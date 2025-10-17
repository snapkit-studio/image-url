# Snapkit Image URL Builder

[English](README.md) | [한국어](README.ko.md)

Build Snapkit image proxy URLs for multiple languages and frameworks.

> **⚠️ Note**: These are reference implementations, not published packages. Copy the example code from each language directory into your project.

## Supported Languages & Frameworks

| Language/Framework        | Platform                  | Package Manager       | Documentation                |
| ------------------------- | ------------------------- | --------------------- | ---------------------------- |
| [TypeScript](#typescript) | Node.js, Browser          | npm, pnpm, yarn       | [Docs](typescript/README.md) |
| [JavaScript](#javascript) | Node.js, Browser          | npm, pnpm, yarn       | [Docs](javascript/README.md) |
| [Next.js](#nextjs)        | React (SSR)               | npm, pnpm, yarn       | [Docs](nextjs/README.md)     |
| [Swift](#swift)           | iOS, macOS, tvOS, watchOS | Swift Package Manager | [Docs](swift/README.md)      |
| [Kotlin](#kotlin)         | Android                   | Gradle                | [Docs](kotlin/README.md)     |
| [Dart](#dart)             | Flutter                   | pub                   | [Docs](dart/README.md)       |
| [PHP](#php)               | Web                       | Composer              | [Docs](php/README.md)        |

## Quick Start Examples

### TypeScript

Copy the `buildSnapkitImageURL` function from [typescript/src/buildSnapkitImageURL.ts](typescript/src/buildSnapkitImageURL.ts) and use it:

```typescript
// Copy the function from typescript/src/buildSnapkitImageURL.ts
// Then use it in your code:

const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
```

### JavaScript

Copy the `buildSnapkitImageURL` function from [javascript/src/buildSnapkitImageURL.js](javascript/src/buildSnapkitImageURL.js) and use it:

```javascript
// Copy the function from javascript/src/buildSnapkitImageURL.js
// Then use it in your code:

const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
```

### Next.js

See the [Next.js documentation](nextjs/README.md) for complete implementation. Copy the helper functions and create a custom loader:

```typescript
// 1. Copy buildSnapkitImageURL function to lib/snapkit-image-url.ts
// 2. Create lib/snapkit-loader.ts with the loader implementation
// 3. Configure next.config.js

// next.config.js
module.exports = {
  images: {
    loader: "custom",
    loaderFile: "./lib/snapkit-loader.ts",
  },
};

// Component
import Image from "next/image";

<Image
  src="https://cdn.cloudfront.net/image.jpg"
  width={300}
  height={200}
  alt="Example"
/>;
```

### Swift

Copy the Swift implementation from [swift/Sources/](swift/Sources/) and use it:

```swift
// Copy the implementation files from swift/Sources/
// Then use it in your code:

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

Copy the Kotlin implementation from [kotlin/src/](kotlin/src/) and use it:

```kotlin
// Copy the implementation files from kotlin/src/
// Then use it in your code:

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

Copy the Dart implementation from [dart/lib/](dart/lib/) and use it:

```dart
// Copy the implementation files from dart/lib/
// Then use it in your code:

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

Copy the PHP implementation from [php/src/](php/src/) and use it:

```php
<?php
// Copy the implementation files from php/src/
// Then use it in your code:

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

| Option      | Type      | Description                                                  |
| ----------- | --------- | ------------------------------------------------------------ |
| `w`         | `number`  | Image width in pixels                                        |
| `h`         | `number`  | Image height in pixels                                       |
| `fit`       | `string`  | Resize mode: `contain`, `cover`, `fill`, `inside`, `outside` |
| `format`    | `string`  | Output format: `jpeg`, `png`, `webp`, `avif`                 |
| `rotation`  | `number`  | Rotation angle in degrees                                    |
| `blur`      | `number`  | Blur intensity (0.3-1000)                                    |
| `grayscale` | `boolean` | Convert to grayscale                                         |
| `flip`      | `boolean` | Flip vertically                                              |
| `flop`      | `boolean` | Flip horizontally                                            |
| `extract`   | `object`  | Extract region `{x, y, width, height}`                       |
| `dpr`       | `number`  | Device Pixel Ratio (1.0-4.0)                                 |

## Usage

**These are reference implementations**. Copy the code examples from the language-specific directories into your project:

- **TypeScript/JavaScript**: Copy code from [typescript/](typescript/) or [javascript/](javascript/)
- **Next.js**: Copy code from [nextjs/](nextjs/)
- **Swift**: Copy code from [swift/](swift/)
- **Kotlin**: Copy code from [kotlin/](kotlin/)
- **Dart**: Copy code from [dart/](dart/)
- **PHP**: Copy code from [php/](php/)

See individual documentation for detailed implementation instructions.

## Testing

Each implementation includes comprehensive unit tests:

```bash
# TypeScript/JavaScript/Next.js
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
- [Swift Documentation](swift/README.md)
- [Kotlin Documentation](kotlin/README.md)
- [Dart Documentation](dart/README.md)
- [PHP Documentation](php/README.md)
