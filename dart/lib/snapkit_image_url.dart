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
