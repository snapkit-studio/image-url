# Snapkit Image URL Builder - Dart

[English](README.md) | [한국어](README.ko.md)

Dart로 작성된 Snapkit 이미지 프록시 URL 생성 라이브러리입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 요구사항

- Dart 3.0+
- Flutter 3.0+ (Flutter 프로젝트에서 사용 시)

설치:

```bash
dart pub get
# 또는 Flutter 프로젝트
flutter pub get
```

## 사용법

### 기본 사용

```dart
import 'package:snapkit_image_url/snapkit_image_url.dart';

final builder = SnapkitImageURL('my-org');
final imageUrl = builder.build(url: 'https://cdn.cloudfront.net/image.jpg');
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

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

### 고급 변환

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

### Flutter Image 위젯과 함께 사용

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

### cached_network_image와 함께 사용

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

## Transform 옵션

| 옵션        | 타입       | 설명                                                  |
| ----------- | ---------- | ----------------------------------------------------- |
| `w`         | `int?`     | 이미지 너비 (픽셀)                                    |
| `h`         | `int?`     | 이미지 높이 (픽셀)                                    |
| `fit`       | `Fit?`     | 리사이즈 방식 (contain, cover, fill, inside, outside) |
| `format`    | `Format?`  | 출력 포맷 (jpeg, png, webp, avif)                     |
| `rotation`  | `int?`     | 회전 각도 (degrees)                                   |
| `blur`      | `int?`     | 블러 강도 (0.3-1000)                                  |
| `grayscale` | `bool?`    | 흑백 변환                                             |
| `flip`      | `bool?`    | 상하 반전                                             |
| `flop`      | `bool?`    | 좌우 반전                                             |
| `extract`   | `Extract?` | 영역 추출                                             |
| `dpr`       | `double?`  | Device Pixel Ratio (1.0-4.0)                          |

## 개발

### 테스트 실행

```bash
dart test
```

## 라이선스

MIT
