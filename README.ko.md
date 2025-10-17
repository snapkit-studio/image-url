# Snapkit Image URL Builder

[English](README.md) | [한국어](README.ko.md)

여러 언어와 프레임워크를 위한 Snapkit 이미지 프록시 URL 빌더입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현 예제입니다. 각 언어 디렉토리의 예시 코드를 프로젝트에 복사하여 사용하세요.

## 지원 언어 및 프레임워크

| 언어/프레임워크           | 플랫폼                    | 패키지 매니저         | 문서                            |
| ------------------------- | ------------------------- | --------------------- | ------------------------------- |
| [TypeScript](#typescript) | Node.js, 브라우저         | npm, pnpm, yarn       | [문서](typescript/README.ko.md) |
| [JavaScript](#javascript) | Node.js, 브라우저         | npm, pnpm, yarn       | [문서](javascript/README.ko.md) |
| [Next.js](#nextjs)        | React (SSR)               | npm, pnpm, yarn       | [문서](nextjs/README.ko.md)     |
| [Swift](#swift)           | iOS, macOS, tvOS, watchOS | Swift Package Manager | [문서](swift/README.ko.md)      |
| [Kotlin](#kotlin)         | Android                   | Gradle                | [문서](kotlin/README.ko.md)     |
| [Dart](#dart)             | Flutter                   | pub                   | [문서](dart/README.ko.md)       |
| [PHP](#php)               | 웹                        | Composer              | [문서](php/README.ko.md)        |

## 빠른 시작 예제

### TypeScript

[typescript/src/buildSnapkitImageURL.ts](typescript/src/buildSnapkitImageURL.ts)에서 `buildSnapkitImageURL` 함수를 복사하여 사용하세요:

```typescript
// typescript/src/buildSnapkitImageURL.ts에서 함수를 복사
// 그 후 코드에서 사용:

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

[javascript/src/buildSnapkitImageURL.js](javascript/src/buildSnapkitImageURL.js)에서 `buildSnapkitImageURL` 함수를 복사하여 사용하세요:

```javascript
// javascript/src/buildSnapkitImageURL.js에서 함수를 복사
// 그 후 코드에서 사용:

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

전체 구현은 [Next.js 문서](nextjs/README.ko.md)를 참고하세요. Helper 함수를 복사하고 커스텀 loader를 생성하세요:

```typescript
// 1. buildSnapkitImageURL 함수를 lib/snapkit-image-url.ts로 복사
// 2. loader 구현으로 lib/snapkit-loader.ts 생성
// 3. next.config.js 설정

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

[swift/Sources/](swift/Sources/)에서 Swift 구현을 복사하여 사용하세요:

```swift
// swift/Sources/에서 구현 파일들을 복사
// 그 후 코드에서 사용:

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

[kotlin/src/](kotlin/src/)에서 Kotlin 구현을 복사하여 사용하세요:

```kotlin
// kotlin/src/에서 구현 파일들을 복사
// 그 후 코드에서 사용:

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

[dart/lib/](dart/lib/)에서 Dart 구현을 복사하여 사용하세요:

```dart
// dart/lib/에서 구현 파일들을 복사
// 그 후 코드에서 사용:

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

[php/src/](php/src/)에서 PHP 구현을 복사하여 사용하세요:

```php
<?php
// php/src/에서 구현 파일들을 복사
// 그 후 코드에서 사용:

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

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

모든 구현은 다음 transform 옵션을 지원합니다:

| 옵션        | 타입      | 설명                                                           |
| ----------- | --------- | -------------------------------------------------------------- |
| `w`         | `number`  | 이미지 너비 (픽셀)                                             |
| `h`         | `number`  | 이미지 높이 (픽셀)                                             |
| `fit`       | `string`  | 리사이즈 방식: `contain`, `cover`, `fill`, `inside`, `outside` |
| `format`    | `string`  | 출력 포맷: `jpeg`, `png`, `webp`, `avif`                       |
| `rotation`  | `number`  | 회전 각도 (degrees)                                            |
| `blur`      | `number`  | 블러 강도 (0.3-1000)                                           |
| `grayscale` | `boolean` | 흑백 변환                                                      |
| `flip`      | `boolean` | 상하 반전                                                      |
| `flop`      | `boolean` | 좌우 반전                                                      |
| `extract`   | `object`  | 영역 추출 `{x, y, width, height}`                              |
| `dpr`       | `number`  | Device Pixel Ratio (1.0-4.0)                                   |

## 사용법

**참고용 구현 예제입니다**. 각 언어별 디렉토리의 코드 예제를 프로젝트에 복사하여 사용하세요:

- **TypeScript/JavaScript**: [typescript/](typescript/) 또는 [javascript/](javascript/) 코드 복사
- **Next.js**: [nextjs/](nextjs/) 코드 복사
- **Swift**: [swift/](swift/) 코드 복사
- **Kotlin**: [kotlin/](kotlin/) 코드 복사
- **Dart**: [dart/](dart/) 코드 복사
- **PHP**: [php/](php/) 코드 복사

자세한 구현 방법은 각 언어별 문서를 참고하세요.

## 테스트

각 구현은 포괄적인 단위 테스트를 포함합니다:

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

## 기여

기여는 언제나 환영합니다! Pull Request를 자유롭게 제출해주세요.

## 라이선스

MIT

## 문서

상세한 문서, 예제, API 레퍼런스는 개별 언어 문서를 참조하세요:

- [TypeScript 문서](typescript/README.ko.md)
- [JavaScript 문서](javascript/README.ko.md)
- [Next.js 문서](nextjs/README.ko.md)
- [Swift 문서](swift/README.ko.md)
- [Kotlin 문서](kotlin/README.ko.md)
- [Dart 문서](dart/README.ko.md)
- [PHP 문서](php/README.ko.md)
