import 'package:snapkit_image_url/snapkit_image_url.dart';
import 'package:test/test.dart';

void main() {
  late SnapkitImageURL builder;
  const testURL = 'https://cdn.cloudfront.net/image.jpg';

  setUp(() {
    builder = SnapkitImageURL('test-org');
  });

  group('Basic URL generation', () {
    test('Generate basic URL', () {
      final result = builder.build(url: testURL);

      expect(result, contains('https://test-org.snapkit.dev/image'));
      expect(result, contains('url='));
      expect(result, contains('cdn.cloudfront.net'));
    });

    test('URL encoding', () {
      const urlWithSpaces =
          'https://example.com/path with spaces/image.jpg?query=value';
      final result = builder.build(url: urlWithSpaces);

      expect(result, contains('url='));
    });
  });

  group('Numeric/string transform parameters', () {
    test('Width parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(w: 300),
      );

      expect(result, contains('w:300') || result.contains('w%3A300'));
    });

    test('Height parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(h: 200),
      );

      expect(result, contains('h:200') || result.contains('h%3A200'));
    });

    test('Fit parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(fit: Fit.cover),
      );

      expect(result, contains('fit:cover') || result.contains('fit%3Acover'));
    });

    test('Format parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(format: Format.webp),
      );

      expect(
          result, contains('format:webp') || result.contains('format%3Awebp'));
    });

    test('Rotation parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(rotation: 90),
      );

      expect(result,
          contains('rotation:90') || result.contains('rotation%3A90'));
    });

    test('Blur parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(blur: 5),
      );

      expect(result, contains('blur:5') || result.contains('blur%3A5'));
    });

    test('DPR parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(dpr: 2.0),
      );

      expect(result, contains('dpr:2') || result.contains('dpr%3A2'));
    });

    test('Quality parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(quality: 80),
      );

      expect(result, contains('quality:80') || result.contains('quality%3A80'));
    });
  });

  group('Boolean transform parameters', () {
    test('Grayscale parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(grayscale: true),
      );

      expect(result, contains('grayscale'));
    });

    test('Flip parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(flip: true),
      );

      expect(result, contains('flip'));
    });

    test('Flop parameter', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(flop: true),
      );

      expect(result, contains('flop'));
    });

    test('Boolean parameters with false value should not be included', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(grayscale: false),
      );

      expect(result, isNot(contains('grayscale')));
    });
  });

  group('Extract parameter', () {
    test('Extract parameter', () {
      const extract = Extract(x: 10, y: 20, width: 100, height: 200);
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(extract: extract),
      );

      expect(result, contains('extract'));
      expect(result, contains('10-20-100-200'));
    });
  });

  group('Combined parameters', () {
    test('Multiple parameters combination', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(
          w: 300,
          h: 200,
          fit: Fit.cover,
          format: Format.webp,
        ),
      );

      expect(result, contains('w:300') || result.contains('w%3A300'));
      expect(result, contains('h:200') || result.contains('h%3A200'));
      expect(result, contains('fit:cover') || result.contains('fit%3Acover'));
      expect(
          result, contains('format:webp') || result.contains('format%3Awebp'));
    });

    test('All types of parameters combination', () {
      const extract = Extract(x: 10, y: 20, width: 100, height: 200);
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(
          w: 300,
          h: 200,
          fit: Fit.cover,
          format: Format.webp,
          rotation: 90,
          blur: 5,
          grayscale: true,
          flip: true,
          dpr: 2.0,
          quality: 85,
          extract: extract,
        ),
      );

      expect(result, contains('w:300') || result.contains('w%3A300'));
      expect(result, contains('h:200') || result.contains('h%3A200'));
      expect(result, contains('grayscale'));
      expect(result, contains('flip'));
      expect(result, contains('quality:85') || result.contains('quality%3A85'));
    });
  });

  group('Edge Cases', () {
    test('Empty Transform object', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(),
      );

      expect(result, isNot(contains('transform=')));
    });

    test('Handle zero values', () {
      final result = builder.build(
        url: testURL,
        transform: const TransformOptions(w: 0, rotation: 0),
      );

      expect(result, contains('w:0') || result.contains('w%3A0'));
      expect(result,
          contains('rotation:0') || result.contains('rotation%3A0'));
    });

    test('OrganizationName with special characters', () {
      final builder = SnapkitImageURL('my-org-123');
      final result = builder.build(url: testURL);

      expect(result, contains('https://my-org-123.snapkit.dev/image'));
    });
  });
}
