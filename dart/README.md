# Snapkit Image URL Builder - Dart

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder reference implementation written in Dart.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Full Implementation Code

### Step 1: Copy the code

The complete code is provided below so you can copy and use it directly without opening source files:

<details>
<summary><strong>View Full Code</strong></summary>

```dart
/// Snapkit Image URL Builder for Dart/Flutter
library snapkit_image_url;

/// Resize mode
enum Fit {
  contain,
  cover,
  fill,
  inside,
  outside,
}

/// Output format
enum Format {
  jpeg,
  png,
  webp,
  avif,
}

/// Region extraction
class Extract {
  final int x;
  final int y;
  final int width;
  final int height;

  const Extract({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

/// Image transformation parameters
class TransformOptions {
  /// Image width (pixels)
  final int? w;

  /// Image height (pixels)
  final int? h;

  /// Resize mode
  final Fit? fit;

  /// Output format
  final Format? format;

  /// Rotation angle (degrees)
  final int? rotation;

  /// Blur strength (0.3-1000)
  final int? blur;

  /// Grayscale conversion flag
  final bool? grayscale;

  /// Vertical flip flag
  final bool? flip;

  /// Horizontal flip flag
  final bool? flop;

  /// Region extraction
  final Extract? extract;

  /// Device Pixel Ratio (1.0-4.0)
  final double? dpr;

  /// Image quality (1-100)
  final int? quality;

  const TransformOptions({
    this.w,
    this.h,
    this.fit,
    this.format,
    this.rotation,
    this.blur,
    this.grayscale,
    this.flip,
    this.flop,
    this.extract,
    this.dpr,
    this.quality,
  });
}

/// Snapkit image URL builder
///
/// Example:
/// ```dart
/// final builder = SnapkitImageURL('my-org');
/// final imageUrl = builder.build(
///   url: 'https://cdn.cloudfront.net/image.jpg',
///   transform: TransformOptions(
///     w: 300,
///     h: 200,
///     fit: Fit.cover,
///     format: Format.webp,
///   ),
/// );
/// ```
class SnapkitImageURL {
  final String organizationName;

  SnapkitImageURL(this.organizationName);

  /// Generate Snapkit image proxy URL
  ///
  /// [url] Original image URL
  /// [transform] Image transformation options
  String build({
    required String url,
    TransformOptions? transform,
  }) {
    final uri = Uri.parse('https://$organizationName.snapkit.dev/image');

    final queryParameters = <String, String>{
      'url': url,
    };

    if (transform != null) {
      final transformString = _buildTransformString(transform);
      if (transformString.isNotEmpty) {
        queryParameters['transform'] = transformString;
      }
    }

    return uri.replace(queryParameters: queryParameters).toString();
  }

  String _buildTransformString(TransformOptions options) {
    final parts = <String>[];

    // Numeric/string value parameters
    if (options.w != null) parts.add('w:${options.w}');
    if (options.h != null) parts.add('h:${options.h}');
    if (options.fit != null) parts.add('fit:${options.fit!.name}');
    if (options.format != null) parts.add('format:${options.format!.name}');
    if (options.rotation != null) parts.add('rotation:${options.rotation}');
    if (options.blur != null) parts.add('blur:${options.blur}');
    if (options.dpr != null) parts.add('dpr:${options.dpr}');
    if (options.quality != null) parts.add('quality:${options.quality}');

    // Boolean parameters
    if (options.grayscale == true) parts.add('grayscale');
    if (options.flip == true) parts.add('flip');
    if (options.flop == true) parts.add('flop');

    // Extract parameter
    if (options.extract != null) {
      final e = options.extract!;
      parts.add('extract:${e.x}-${e.y}-${e.width}-${e.height}');
    }

    return parts.join(',');
  }
}
```

</details>

### Step 2: Create and paste file in your project

Save the copied code as `snapkit_image_url.dart` file in your project.

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
