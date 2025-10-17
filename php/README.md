# Snapkit Image URL Builder - PHP

[English](README.md) | [한국어](README.ko.md)

Snapkit 이미지 프록시 URL을 생성하는 PHP 라이브러리입니다.

## 요구사항

- PHP 8.1+

## 설치

### Composer

```bash
composer require snapkit/image-url-php
```

## 사용법

### 기본 사용

```php
<?php

use Snapkit\ImageURL\SnapkitImageURL;

$builder = new SnapkitImageURL('my-org');
$imageUrl = $builder->build('https://cdn.cloudfront.net/image.jpg');
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

```php
use Snapkit\ImageURL\SnapkitImageURL;
use Snapkit\ImageURL\TransformOptions;

$builder = new SnapkitImageURL('my-org');
$imageUrl = $builder->build(
    'https://cdn.cloudfront.net/image.jpg',
    new TransformOptions([
        'w' => 300,
        'h' => 200,
        'fit' => 'cover',
        'format' => 'webp',
    ])
);
// → https://my-org.snapkit.dev/image?url=...&transform=w:300,h:200,fit:cover,format:webp
```

### 고급 변환

```php
use Snapkit\ImageURL\SnapkitImageURL;
use Snapkit\ImageURL\TransformOptions;
use Snapkit\ImageURL\Extract;

$extract = new Extract(10, 20, 100, 150);

$builder = new SnapkitImageURL('my-org');
$imageUrl = $builder->build(
    'https://cdn.cloudfront.net/image.jpg',
    new TransformOptions([
        'w' => 400,
        'h' => 300,
        'fit' => 'cover',
        'format' => 'webp',
        'rotation' => 90,
        'blur' => 5,
        'grayscale' => true,
        'dpr' => 2.0,
        'extract' => $extract,
    ])
);
```

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

### Laravel에서 사용

```php
// app/Services/ImageService.php
namespace App\Services;

use Snapkit\ImageURL\SnapkitImageURL;
use Snapkit\ImageURL\TransformOptions;

class ImageService
{
    private SnapkitImageURL $builder;

    public function __construct()
    {
        $this->builder = new SnapkitImageURL(config('snapkit.organization'));
    }

    public function getImageUrl(string $url, array $transform = []): string
    {
        $options = !empty($transform) ? new TransformOptions($transform) : null;
        return $this->builder->build($url, $options);
    }
}

// config/snapkit.php
return [
    'organization' => env('SNAPKIT_ORG', 'my-org'),
];

// .env
SNAPKIT_ORG=my-org

// Controller에서 사용
use App\Services\ImageService;

class ProductController extends Controller
{
    public function show(Product $product, ImageService $imageService)
    {
        $imageUrl = $imageService->getImageUrl(
            $product->image_url,
            [
                'w' => 600,
                'h' => 400,
                'fit' => 'cover',
                'format' => 'webp',
            ]
        );

        return view('products.show', compact('product', 'imageUrl'));
    }
}

// Blade 템플릿에서 사용
<img src="{{ $imageUrl }}" alt="{{ $product->name }}">
```

### WordPress에서 사용

```php
// functions.php 또는 플러그인 파일

require_once __DIR__ . '/vendor/autoload.php';

use Snapkit\ImageURL\SnapkitImageURL;
use Snapkit\ImageURL\TransformOptions;

function get_snapkit_image_url($url, $options = [])
{
    static $builder = null;

    if ($builder === null) {
        $org = get_option('snapkit_organization', 'my-org');
        $builder = new SnapkitImageURL($org);
    }

    $transform = !empty($options) ? new TransformOptions($options) : null;
    return $builder->build($url, $transform);
}

// 사용 예시
$imageUrl = get_snapkit_image_url(
    get_the_post_thumbnail_url(),
    [
        'w' => 800,
        'h' => 600,
        'fit' => 'cover',
        'format' => 'webp',
    ]
);

echo '<img src="' . esc_url($imageUrl) . '" alt="' . esc_attr(get_the_title()) . '">';
```

## Transform 옵션

| 옵션        | 타입            | 설명                                                            |
| ----------- | --------------- | --------------------------------------------------------------- |
| `w`         | `int\|null`     | 이미지 너비 (픽셀)                                              |
| `h`         | `int\|null`     | 이미지 높이 (픽셀)                                              |
| `fit`       | `string\|null`  | 리사이즈 방식 ('contain', 'cover', 'fill', 'inside', 'outside') |
| `format`    | `string\|null`  | 출력 포맷 ('jpeg', 'png', 'webp', 'avif')                       |
| `rotation`  | `int\|null`     | 회전 각도 (degrees)                                             |
| `blur`      | `int\|null`     | 블러 강도 (0.3-1000)                                            |
| `grayscale` | `bool\|null`    | 흑백 변환                                                       |
| `flip`      | `bool\|null`    | 상하 반전                                                       |
| `flop`      | `bool\|null`    | 좌우 반전                                                       |
| `extract`   | `Extract\|null` | 영역 추출                                                       |
| `dpr`       | `float\|null`   | Device Pixel Ratio (1.0-4.0)                                    |

## 개발

### 테스트 실행

```bash
composer test
```

### 의존성 설치

```bash
composer install
```

## 라이선스

MIT
