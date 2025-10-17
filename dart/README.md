# Snapkit Image URL Builder - Dart

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder library written in Dart.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Requirements

- Dart 3.0+
- Flutter 3.0+ (when using with Flutter projects)

Installation:

```bash
dart pub get
# Or for Flutter projects
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:snapkit_image_url/snapkit_image_url.dart';

final builder = SnapkitImageURL('my-org');
final imageUrl = builder.build(url: 'https://cdn.cloudfront.net/image.jpg');
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### Image Transform Options

```dart
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

### Advanced Transforms

```dart
final extract = Extract(x: 10, y: 20, width: 100, height: 150);

final imageUrl = builder.build(
  url: 'https://cdn.cloudfront.net/image.jpg',
  transform: TransformOptions(
    w: 400,
    h: 300,
    fit: Fit.cover,
    format: Format.webp,
    rotation: 90,
    blur: 5,
    grayscale: true,
    dpr: 2.0,
    extract: extract,
  ),
);
```

### Using with Flutter Image Widget

```dart
import 'package:flutter/material.dart';
import 'package:snapkit_image_url/snapkit_image_url.dart';

class MyWidget extends StatelessWidget {
  final builder = SnapkitImageURL('my-org');

  @override
  Widget build(BuildContext context) {
    final imageUrl = builder.build(
      url: 'https://cdn.cloudfront.net/image.jpg',
      transform: TransformOptions(
        w: 300,
        h: 200,
        fit: Fit.cover,
        format: Format.webp,
      ),
    );

    return Image.network(
      imageUrl,
      width: 300,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
```

### Using with cached_network_image

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:snapkit_image_url/snapkit_image_url.dart';

class MyWidget extends StatelessWidget {
  final builder = SnapkitImageURL('my-org');

  @override
  Widget build(BuildContext context) {
    final imageUrl = builder.build(
      url: 'https://cdn.cloudfront.net/image.jpg',
      transform: TransformOptions(
        w: 300,
        h: 200,
        fit: Fit.cover,
        format: Format.webp,
      ),
    );

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
```

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform Options

| Option      | Type       | Description                                       |
| ----------- | ---------- | ------------------------------------------------- |
| `w`         | `int?`     | Image width (pixels)                              |
| `h`         | `int?`     | Image height (pixels)                             |
| `fit`       | `Fit?`     | Resize method (contain, cover, fill, inside, outside) |
| `format`    | `Format?`  | Output format (jpeg, png, webp, avif)             |
| `rotation`  | `int?`     | Rotation angle (degrees)                          |
| `blur`      | `int?`     | Blur intensity (0.3-1000)                         |
| `grayscale` | `bool?`    | Convert to grayscale                              |
| `flip`      | `bool?`    | Flip vertically                                   |
| `flop`      | `bool?`    | Flip horizontally                                 |
| `extract`   | `Extract?` | Extract region                                    |
| `dpr`       | `double?`  | Device Pixel Ratio (1.0-4.0)                      |

## Development

### Run Tests

```bash
dart test
```

## License

MIT
