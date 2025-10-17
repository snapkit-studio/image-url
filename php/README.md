# Snapkit Image URL Builder - PHP

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder reference implementation written in PHP.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Full Implementation Code

### Step 1: Copy the code

The complete code is provided below so you can copy and use it directly without opening source files:

<details>
<summary><strong>View Full Code</strong></summary>

```php
<?php

namespace Snapkit\ImageURL;

/**
 * Image transformation parameters
 */
class TransformOptions
{
    /** @var int|null Image width (pixels) */
    public ?int $w = null;

    /** @var int|null Image height (pixels) */
    public ?int $h = null;

    /** @var string|null Resize mode (contain, cover, fill, inside, outside) */
    public ?string $fit = null;

    /** @var string|null Output format (jpeg, png, webp, avif) */
    public ?string $format = null;

    /** @var int|null Rotation angle (degrees) */
    public ?int $rotation = null;

    /** @var int|null Blur intensity (0.3-1000) */
    public ?int $blur = null;

    /** @var bool|null Whether to convert to grayscale */
    public ?bool $grayscale = null;

    /** @var bool|null Whether to flip vertically */
    public ?bool $flip = null;

    /** @var bool|null Whether to flip horizontally */
    public ?bool $flop = null;

    /** @var Extract|null Area extraction */
    public ?Extract $extract = null;

    /** @var float|null Device Pixel Ratio (1.0-4.0) */
    public ?float $dpr = null;

    /** @var int|null Image quality (1-100) */
    public ?int $quality = null;

    public function __construct(array $options = [])
    {
        foreach ($options as $key => $value) {
            if (property_exists($this, $key)) {
                $this->$key = $value;
            }
        }
    }
}

/**
 * Area extraction
 */
class Extract
{
    public int $x;
    public int $y;
    public int $width;
    public int $height;

    public function __construct(int $x, int $y, int $width, int $height)
    {
        $this->x = $x;
        $this->y = $y;
        $this->width = $width;
        $this->height = $height;
    }
}

/**
 * Snapkit image URL builder
 *
 * @example
 * ```php
 * $builder = new SnapkitImageURL('my-org');
 * $imageUrl = $builder->build(
 *     'https://cdn.cloudfront.net/image.jpg',
 *     new TransformOptions([
 *         'w' => 300,
 *         'h' => 200,
 *         'fit' => 'cover',
 *         'format' => 'webp'
 *     ])
 * );
 * ```
 */
class SnapkitImageURL
{
    private string $organizationName;

    public function __construct(string $organizationName)
    {
        $this->organizationName = $organizationName;
    }

    /**
     * Generate Snapkit image proxy URL
     *
     * @param string $url Original image URL
     * @param TransformOptions|null $transform Image transformation options
     * @return string Complete image proxy URL
     */
    public function build(string $url, ?TransformOptions $transform = null): string
    {
        $baseUrl = "https://{$this->organizationName}.snapkit.dev/image";

        $queryParams = [
            'url' => $url,
        ];

        if ($transform !== null) {
            $transformString = $this->buildTransformString($transform);
            if (!empty($transformString)) {
                $queryParams['transform'] = $transformString;
            }
        }

        return $baseUrl . '?' . http_build_query($queryParams);
    }

    private function buildTransformString(TransformOptions $options): string
    {
        $parts = [];

        // Numeric/string value parameters
        if ($options->w !== null) {
            $parts[] = "w:{$options->w}";
        }
        if ($options->h !== null) {
            $parts[] = "h:{$options->h}";
        }
        if ($options->fit !== null) {
            $parts[] = "fit:{$options->fit}";
        }
        if ($options->format !== null) {
            $parts[] = "format:{$options->format}";
        }
        if ($options->rotation !== null) {
            $parts[] = "rotation:{$options->rotation}";
        }
        if ($options->blur !== null) {
            $parts[] = "blur:{$options->blur}";
        }
        if ($options->dpr !== null) {
            $parts[] = "dpr:{$options->dpr}";
        }
        if ($options->quality !== null) {
            $parts[] = "quality:{$options->quality}";
        }

        // Boolean parameters
        if ($options->grayscale === true) {
            $parts[] = 'grayscale';
        }
        if ($options->flip === true) {
            $parts[] = 'flip';
        }
        if ($options->flop === true) {
            $parts[] = 'flop';
        }

        // extract parameter
        if ($options->extract !== null) {
            $e = $options->extract;
            $parts[] = "extract:{$e->x}-{$e->y}-{$e->width}-{$e->height}";
        }

        return implode(',', $parts);
    }
}
```

</details>

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
