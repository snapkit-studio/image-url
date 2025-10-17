# Snapkit Image URL Builder

[English](README.md) | [한국어](README.ko.md)

Build Snapkit image proxy URLs for multiple languages and frameworks.

## Supported Languages & Frameworks

| Language/Framework | Platform | Package Manager | Documentation |
|-------------------|----------|-----------------|---------------|
| [TypeScript](#typescript) | Node.js, Browser | npm, pnpm, yarn | [Docs](typescript/README.md) |
| [JavaScript](#javascript) | Node.js, Browser | npm, pnpm, yarn | [Docs](javascript/README.md) |
| [Next.js](#nextjs) | React (SSR) | npm, pnpm, yarn | [Docs](nextjs/README.md) |
| [Nuxt](#nuxt) | Vue (SSR) | npm, pnpm, yarn | [Docs](nuxt/README.md) |
| [Swift](#swift) | iOS, macOS, tvOS, watchOS | Swift Package Manager | [Docs](swift/README.md) |
| [Kotlin](#kotlin) | Android | Gradle | [Docs](kotlin/README.md) |
| [Dart](#dart) | Flutter | pub | [Docs](dart/README.md) |
| [PHP](#php) | Web | Composer | [Docs](php/README.md) |

## Quick Start Examples

### TypeScript

```typescript
import { buildSnapkitImageURL } from '@snapkit/image-url-typescript';

const imageUrl = buildSnapkitImageURL({
  organizationName: 'my-org',
  url: 'https://cdn.cloudfront.net/image.jpg',
  transform: {
    w: 300,
    h: 200,
    fit: 'cover',
    format: 'webp',
  },
});
```

### JavaScript

```javascript
import { buildSnapkitImageURL } from '@snapkit/image-url-javascript';

const imageUrl = buildSnapkitImageURL({
  organizationName: 'my-org',
  url: 'https://cdn.cloudfront.net/image.jpg',
  transform: {
    w: 300,
    h: 200,
    fit: 'cover',
    format: 'webp',
  },
});
```

### Next.js

```typescript
// lib/snapkit-loader.ts
import { createSnapkitLoader } from '@snapkit/image-url-nextjs';

export default createSnapkitLoader({
  organizationName: 'my-org',
  transform: {
    format: 'webp',
    fit: 'cover',
  },
});

// next.config.js
module.exports = {
  images: {
    loader: 'custom',
    loaderFile: './lib/snapkit-loader.ts',
  },
};

// Component
import Image from 'next/image';

<Image
  src="https://cdn.cloudfront.net/image.jpg"
  width={300}
  height={200}
  alt="Example"
/>
```

### Nuxt

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['@nuxt/image'],
  image: {
    providers: {
      snapkit: {
        name: 'snapkit',
        provider: '~/providers/snapkit',
        options: {
          organizationName: 'my-org',
        },
      },
    },
  },
});

// Component
<template>
  <NuxtImg
    provider="snapkit"
    src="https://cdn.cloudfront.net/image.jpg"
    width="300"
    height="200"
    fit="cover"
    format="webp"
  />
</template>
```

### Swift

```swift
import SnapkitImageURL

let builder = SnapkitImageURL(organizationName: "my-org")
let imageURL = builder.build(
    url: "https://cdn.cloudfront.net/image.jpg",
    transform: TransformOptions(
        w: 300,
        h: 200,
        fit: .cover,
        format: .webp
    )
)
```

### Kotlin

```kotlin
import dev.snapkit.imageurl.SnapkitImageURL
import dev.snapkit.imageurl.TransformOptions

val builder = SnapkitImageURL("my-org")
val imageUrl = builder.build(
    url = "https://cdn.cloudfront.net/image.jpg",
    transform = TransformOptions(
        w = 300,
        h = 200,
        fit = TransformOptions.Fit.COVER,
        format = TransformOptions.Format.WEBP
    )
)
```

### Dart

```dart
import 'package:snapkit_image_url/snapkit_image_url.dart';

final builder = SnapkitImageURL('my-org');
final imageUrl = builder.build(
  url: 'https://cdn.cloudfront.net/image.jpg',
  transform: TransformOptions(
    w: 300,
    h: 200,
    fit: Fit.cover,
    format: Format.webp,
  ),
);
```

### PHP

```php
<?php

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
```

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform Options

All implementations support the following transform options:

| Option | Type | Description |
|--------|------|-------------|
| `w` | `number` | Image width in pixels |
| `h` | `number` | Image height in pixels |
| `fit` | `string` | Resize mode: `contain`, `cover`, `fill`, `inside`, `outside` |
| `format` | `string` | Output format: `jpeg`, `png`, `webp`, `avif` |
| `rotation` | `number` | Rotation angle in degrees |
| `blur` | `number` | Blur intensity (0.3-1000) |
| `grayscale` | `boolean` | Convert to grayscale |
| `flip` | `boolean` | Flip vertically |
| `flop` | `boolean` | Flip horizontally |
| `extract` | `object` | Extract region `{x, y, width, height}` |
| `dpr` | `number` | Device Pixel Ratio (1.0-4.0) |

## Features

- ✅ **Type-safe**: Full TypeScript/Swift/Kotlin/Dart type definitions
- ✅ **Framework integration**: Native loaders for Next.js and Nuxt
- ✅ **URL encoding**: Automatic URL encoding for all parameters
- ✅ **Comprehensive testing**: 19+ unit tests for each implementation
- ✅ **Production ready**: Used in production environments
- ✅ **Multi-platform**: Web, Mobile (iOS/Android), and Desktop (macOS)

## Installation

See individual documentation for installation instructions:

- **TypeScript/JavaScript**: `pnpm add @snapkit/image-url-{typescript|javascript}`
- **Next.js**: `pnpm add @snapkit/image-url-nextjs`
- **Nuxt**: `pnpm add @snapkit/image-url-nuxt`
- **Swift**: Add via Swift Package Manager
- **Kotlin**: Add via Gradle
- **Dart**: Add to `pubspec.yaml`
- **PHP**: `composer require snapkit/image-url-php`

## Testing

Each implementation includes comprehensive unit tests:

```bash
# TypeScript/JavaScript/Next.js/Nuxt
pnpm test

# Swift
swift test

# Kotlin
./gradlew test

# Dart
dart test

# PHP
composer test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Documentation

For detailed documentation, examples, and API reference, see the individual language documentation:

- [TypeScript Documentation](typescript/README.md)
- [JavaScript Documentation](javascript/README.md)
- [Next.js Documentation](nextjs/README.md)
- [Nuxt Documentation](nuxt/README.md)
- [Swift Documentation](swift/README.md)
- [Kotlin Documentation](kotlin/README.md)
- [Dart Documentation](dart/README.md)
- [PHP Documentation](php/README.md)
