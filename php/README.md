# Snapkit Image URL Builder - PHP

[English](README.md) | [한국어](README.ko.md)

PHP library for building Snapkit image proxy URLs.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Full Implementation Code

### Step 1: Copy the code

The complete PHP implementation can be found in the [src/SnapkitImageURL.php](src/SnapkitImageURL.php) file.

### Step 2: Create and paste file in your project

Save the copied code as `SnapkitImageURL.php` file in your project.

## Requirements

- PHP 8.1+

## Installation

### Composer

```bash
composer require snapkit/image-url-php
```

## Usage

### Basic Usage

```php
<?php

use Snapkit\ImageURL\SnapkitImageURL;

$builder = new SnapkitImageURL('my-org');
$imageUrl = $builder->build('https://cdn.cloudfront.net/image.jpg');
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### Image Transform Options

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

### Advanced Transforms

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

### Using with Laravel

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

// Using in Controller
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

// Using in Blade template
<img src="{{ $imageUrl }}" alt="{{ $product->name }}">
```

### Using with WordPress

```php
// functions.php or plugin file

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

// Usage example
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

## Transform Options

| Option      | Type            | Description                                                    |
| ----------- | --------------- | -------------------------------------------------------------- |
| `w`         | `int\|null`     | Image width (pixels)                                           |
| `h`         | `int\|null`     | Image height (pixels)                                          |
| `fit`       | `string\|null`  | Resize method ('contain', 'cover', 'fill', 'inside', 'outside') |
| `format`    | `string\|null`  | Output format ('jpeg', 'png', 'webp', 'avif')                  |
| `rotation`  | `int\|null`     | Rotation angle (degrees)                                       |
| `blur`      | `int\|null`     | Blur intensity (0.3-1000)                                      |
| `grayscale` | `bool\|null`    | Convert to grayscale                                           |
| `flip`      | `bool\|null`    | Flip vertically                                                |
| `flop`      | `bool\|null`    | Flip horizontally                                              |
| `extract`   | `Extract\|null` | Extract region                                                 |
| `dpr`       | `float\|null`   | Device Pixel Ratio (1.0-4.0)                                   |

## Development

### Run Tests

```bash
composer test
```

### Install Dependencies

```bash
composer install
```

## License

MIT
