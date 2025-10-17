# Snapkit Image URL Builder

[English](README.md) | [한국어](README.ko.md)

여러 언어와 프레임워크를 위한 Snapkit 이미지 프록시 URL 빌더입니다.

## 지원 언어 및 프레임워크

| 언어/프레임워크 | 플랫폼 | 패키지 매니저 | 문서 |
|-------------------|----------|-----------------|---------------|
| [TypeScript](#typescript) | Node.js, 브라우저 | npm, pnpm, yarn | [문서](typescript/README.ko.md) |
| [JavaScript](#javascript) | Node.js, 브라우저 | npm, pnpm, yarn | [문서](javascript/README.ko.md) |
| [Next.js](#nextjs) | React (SSR) | npm, pnpm, yarn | [문서](nextjs/README.ko.md) |
| [Nuxt](#nuxt) | Vue (SSR) | npm, pnpm, yarn | [문서](nuxt/README.ko.md) |
| [Swift](#swift) | iOS, macOS, tvOS, watchOS | Swift Package Manager | [문서](swift/README.ko.md) |
| [Kotlin](#kotlin) | Android | Gradle | [문서](kotlin/README.ko.md) |
| [Dart](#dart) | Flutter | pub | [문서](dart/README.ko.md) |
| [PHP](#php) | 웹 | Composer | [문서](php/README.ko.md) |

## 빠른 시작 예제

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

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

모든 구현은 다음 transform 옵션을 지원합니다:

| 옵션 | 타입 | 설명 |
|--------|------|-------------|
| `w` | `number` | 이미지 너비 (픽셀) |
| `h` | `number` | 이미지 높이 (픽셀) |
| `fit` | `string` | 리사이즈 방식: `contain`, `cover`, `fill`, `inside`, `outside` |
| `format` | `string` | 출력 포맷: `jpeg`, `png`, `webp`, `avif` |
| `rotation` | `number` | 회전 각도 (degrees) |
| `blur` | `number` | 블러 강도 (0.3-1000) |
| `grayscale` | `boolean` | 흑백 변환 |
| `flip` | `boolean` | 상하 반전 |
| `flop` | `boolean` | 좌우 반전 |
| `extract` | `object` | 영역 추출 `{x, y, width, height}` |
| `dpr` | `number` | Device Pixel Ratio (1.0-4.0) |

## 기능

- ✅ **타입 안전성**: TypeScript/Swift/Kotlin/Dart 완전한 타입 정의
- ✅ **프레임워크 통합**: Next.js와 Nuxt를 위한 네이티브 로더
- ✅ **URL 인코딩**: 모든 파라미터에 대한 자동 URL 인코딩
- ✅ **포괄적인 테스트**: 각 구현별 19개 이상의 단위 테스트
- ✅ **프로덕션 준비**: 프로덕션 환경에서 사용 중
- ✅ **멀티 플랫폼**: 웹, 모바일(iOS/Android), 데스크톱(macOS)

## 설치

개별 문서에서 설치 방법을 확인하세요:

- **TypeScript/JavaScript**: `pnpm add @snapkit/image-url-{typescript|javascript}`
- **Next.js**: `pnpm add @snapkit/image-url-nextjs`
- **Nuxt**: `pnpm add @snapkit/image-url-nuxt`
- **Swift**: Swift Package Manager로 추가
- **Kotlin**: Gradle로 추가
- **Dart**: `pubspec.yaml`에 추가
- **PHP**: `composer require snapkit/image-url-php`

## 테스트

각 구현은 포괄적인 단위 테스트를 포함합니다:

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

## 기여

기여는 언제나 환영합니다! Pull Request를 자유롭게 제출해주세요.

## 라이선스

MIT

## 문서

상세한 문서, 예제, API 레퍼런스는 개별 언어 문서를 참조하세요:

- [TypeScript 문서](typescript/README.ko.md)
- [JavaScript 문서](javascript/README.ko.md)
- [Next.js 문서](nextjs/README.ko.md)
- [Nuxt 문서](nuxt/README.ko.md)
- [Swift 문서](swift/README.ko.md)
- [Kotlin 문서](kotlin/README.ko.md)
- [Dart 문서](dart/README.ko.md)
- [PHP 문서](php/README.ko.md)
