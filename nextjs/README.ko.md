# Snapkit Image URL Builder - Next.js

[English](README.md) | [한국어](README.ko.md)

Next.js Image Component의 loader prop에서 사용할 수 있는 SnapKit 이미지 변환 함수 예제입니다.

## 빠른 시작

아래 코드를 Next.js 프로젝트에 복사하여 SnapKit 이미지 변환 기능을 사용할 수 있습니다.

### 1단계: Helper 함수 복사

SnapKit URL 빌더 함수가 포함된 파일을 생성합니다:

```ts
// lib/snapkit-image-url.ts

/**
 * 이미지 변환 파라미터 타입 정의
 */
export interface TransformOptions {
  /** 이미지 너비 (픽셀) */
  w?: number;
  /** 이미지 높이 (픽셀) */
  h?: number;
  /** 리사이즈 방식 */
  fit?: "contain" | "cover" | "fill" | "inside" | "outside";
  /** 출력 포맷 */
  format?: "jpeg" | "png" | "webp" | "avif";
  /** 회전 각도 (degrees) */
  rotation?: number;
  /** 블러 강도 (0.3-1000) */
  blur?: number;
  /** 흑백 변환 여부 */
  grayscale?: boolean;
  /** 상하 반전 여부 */
  flip?: boolean;
  /** 좌우 반전 여부 */
  flop?: boolean;
  /** 영역 추출 (x, y, width, height) */
  extract?: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  /** Device Pixel Ratio (1.0-4.0) */
  dpr?: number;
  /** 이미지 품질 (1-100) */
  quality?: number;
}

/**
 * buildSnapkitImageURL 함수 파라미터
 */
export interface BuildSnapkitImageURLParams {
  /** 조직 이름 (Snapkit 서브도메인으로 사용) */
  organizationName: string;
  /** 원본 이미지 URL (CloudFront 등) */
  url: string;
  /** 이미지 변환 옵션 */
  transform?: TransformOptions;
}

/**
 * TransformOptions를 쿼리 스트링으로 변환
 */
function buildTransformString(options: TransformOptions): string {
  const parts: string[] = [];

  // 숫자/문자열 값 파라미터
  if (options.w !== undefined) parts.push(`w:${options.w}`);
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined)
    parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  // Boolean 파라미터 (키만, 값 없음)
  if (options.grayscale) parts.push("grayscale");
  if (options.flip) parts.push("flip");
  if (options.flop) parts.push("flop");

  // extract 파라미터 (x-y-width-height)
  if (options.extract) {
    const { x, y, width, height } = options.extract;
    parts.push(`extract:${x}-${y}-${width}-${height}`);
  }

  return parts.join(",");
}

/**
 * Snapkit 이미지 프록시 URL 생성
 */
export function buildSnapkitImageURL(
  params: BuildSnapkitImageURLParams,
): string {
  const { organizationName, url, transform } = params;

  // 기본 URL 구성
  const baseUrl = `https://${organizationName}.snapkit.dev/image`;

  // URLSearchParams로 쿼리 파라미터 구성
  const searchParams = new URLSearchParams();
  searchParams.set("url", url);

  // transform 옵션이 있으면 추가
  if (transform) {
    const transformString = buildTransformString(transform);
    if (transformString) {
      searchParams.set("transform", transformString);
    }
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
```

### 2단계: Next.js Loader 생성

Next.js Image Component용 loader 함수를 생성합니다:

```ts
// lib/snapkit-loader.ts
import { buildSnapkitImageURL } from "./snapkit-image-url";

export default function snapkitLoader({
  src,
  width,
  quality,
}: {
  src: string;
  width: number;
  quality?: number;
}): string {
  return buildSnapkitImageURL({
    organizationName: process.env.NEXT_PUBLIC_SNAPKIT_ORG || "my-org",
    url: src,
    transform: {
      w: width,
      quality,
      format: "webp",
    },
  });
}
```

## 사용법

### 방법 1: 전역 Loader 설정 (권장)

Next.js 설정에서 loader를 전역으로 구성합니다:

```js
// next.config.js
module.exports = {
  images: {
    loader: "custom",
    loaderFile: "./lib/snapkit-loader.ts",
  },
};
```

이후 Image 컴포넌트를 일반적으로 사용합니다:

```tsx
import Image from "next/image";

export function MyComponent() {
  return (
    <Image
      src="https://cdn.cloudfront.net/image.jpg"
      width={300}
      height={200}
      alt="Example"
    />
  );
}
```

### 방법 2: 컴포넌트별 Loader 사용

개별 Image 컴포넌트에 loader를 직접 전달합니다:

```tsx
import Image from "next/image";
import snapkitLoader from "@/lib/snapkit-loader";

export function MyComponent() {
  return (
    <Image
      loader={snapkitLoader}
      src="https://cdn.cloudfront.net/image.jpg"
      width={300}
      height={200}
      alt="Example"
    />
  );
}
```

### 방법 3: 특정 옵션을 가진 커스텀 Loader

다양한 사용 사례에 맞는 커스텀 loader를 생성합니다:

```tsx
import Image from "next/image";
import { buildSnapkitImageURL } from "@/lib/snapkit-image-url";

const highQualityLoader = ({ src, width }: { src: string; width: number }) => {
  return buildSnapkitImageURL({
    organizationName: "my-org",
    url: src,
    transform: {
      w: width,
      format: "avif",
      quality: 90,
      fit: "cover",
    },
  });
};

export function HeroImage() {
  return (
    <Image
      loader={highQualityLoader}
      src="https://cdn.cloudfront.net/hero.jpg"
      width={1200}
      height={600}
      priority
      alt="Hero"
    />
  );
}
```

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

| 옵션        | 타입                                                      | 설명                         |
| ----------- | --------------------------------------------------------- | ---------------------------- |
| `w`         | `number`                                                  | 이미지 너비 (픽셀)           |
| `h`         | `number`                                                  | 이미지 높이 (픽셀)           |
| `fit`       | `'contain' \| 'cover' \| 'fill' \| 'inside' \| 'outside'` | 리사이즈 방식                |
| `format`    | `'jpeg' \| 'png' \| 'webp' \| 'avif'`                     | 출력 포맷 (기본: webp)       |
| `rotation`  | `number`                                                  | 회전 각도 (degrees)          |
| `blur`      | `number`                                                  | 블러 강도 (0.3-1000)         |
| `grayscale` | `boolean`                                                 | 흑백 변환                    |
| `flip`      | `boolean`                                                 | 상하 반전                    |
| `flop`      | `boolean`                                                 | 좌우 반전                    |
| `extract`   | `{ x, y, width, height }`                                 | 영역 추출                    |
| `dpr`       | `number`                                                  | Device Pixel Ratio (1.0-4.0) |
| `quality`   | `number`                                                  | 이미지 품질 (1-100)          |

## 고급 사용

### 반응형 이미지

```tsx
import Image from "next/image";

export function ResponsiveImage() {
  return (
    <Image
      src="https://cdn.cloudfront.net/image.jpg"
      width={800}
      height={600}
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      alt="Responsive"
    />
  );
}
```

### 우선순위 이미지

```tsx
import Image from "next/image";

export function HeroImage() {
  return (
    <Image
      src="https://cdn.cloudfront.net/hero.jpg"
      width={1200}
      height={600}
      priority
      alt="Hero"
    />
  );
}
```

## 환경 변수

환경 변수에 조직 이름을 설정합니다:

```bash
# .env.local
NEXT_PUBLIC_SNAPKIT_ORG=my-org
```

## 참고

- [Next.js Image Component](https://nextjs.org/docs/api-reference/next/image)
- [Next.js Custom Loader](https://nextjs.org/docs/api-reference/next/image#loader)
