# Snapkit Image URL Builder - TypeScript

TypeScript로 작성된 Snapkit 이미지 프록시 URL 생성 참고용 구현입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 전체 구현 코드

### Step 1: 코드 복사

소스 파일을 열지 않고도 바로 복사하여 사용할 수 있도록 전체 코드를 제공합니다:

<details>
<summary><strong>전체 코드 보기</strong></summary>

```typescript
/**
 * Snapkit image proxy URL builder function
 * @module buildSnapkitImageURL
 */

/**
 * Image transformation parameter type definition
 */
export interface TransformOptions {
  /** Image width (pixels) */
  w?: number;
  /** Image height (pixels) */
  h?: number;
  /** Resize mode */
  fit?: "contain" | "cover" | "fill" | "inside" | "outside";
  /** Output format */
  format?: "jpeg" | "png" | "webp" | "avif";
  /** Rotation angle (degrees) */
  rotation?: number;
  /** Blur strength (0.3-1000) */
  blur?: number;
  /** Whether to convert to grayscale */
  grayscale?: boolean;
  /** Whether to flip vertically */
  flip?: boolean;
  /** Whether to flip horizontally */
  flop?: boolean;
  /** Region extraction (x, y, width, height) */
  extract?: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  /** Device Pixel Ratio (1.0-4.0) */
  dpr?: number;
  /** Image quality (1-100) */
  quality?: number;
}

/**
 * buildSnapkitImageURL function parameters
 */
export interface BuildSnapkitImageURLParams {
  /** Organization name (used as Snapkit subdomain) */
  organizationName: string;
  /** Original image URL (CloudFront, etc.) */
  url: string;
  /** Image transformation options */
  transform?: TransformOptions;
}

/**
 * Convert TransformOptions to query string
 * @param options - Transformation options object
 * @returns Query string (e.g., "w:100,h:100,fit:cover")
 */
function buildTransformString(options: TransformOptions): string {
  const parts: string[] = [];

  // Numeric/string value parameters
  if (options.w !== undefined) parts.push(`w:${options.w}`);
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined)
    parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  // Boolean parameters (key only, no value)
  if (options.grayscale) parts.push("grayscale");
  if (options.flip) parts.push("flip");
  if (options.flop) parts.push("flop");

  // extract parameter (x-y-width-height)
  if (options.extract) {
    const { x, y, width, height } = options.extract;
    parts.push(`extract:${x}-${y}-${width}-${height}`);
  }

  return parts.join(",");
}

/**
 * Build Snapkit image proxy URL
 *
 * @param params - URL generation parameters
 * @returns Complete image proxy URL
 *
 * @example
 * ```typescript
 * const imageUrl = buildSnapkitImageURL({
 *   organizationName: 'my-org',
 *   url: 'https://cdn.cloudfront.net/image.jpg',
 *   transform: {
 *     w: 300,
 *     h: 200,
 *     fit: 'cover',
 *     format: 'webp'
 *   }
 * });
 * // → "https://my-org.snapkit.dev/image?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp"
 * ```
 */
export function buildSnapkitImageURL(
  params: BuildSnapkitImageURLParams,
): string {
  const { organizationName, url, transform } = params;

  // Compose base URL
  const baseUrl = `https://${organizationName}.snapkit.dev/image`;

  // Compose query parameters with URLSearchParams
  const searchParams = new URLSearchParams();
  searchParams.set("url", url);

  // Add transform options if present
  if (transform) {
    const transformString = buildTransformString(transform);
    if (transformString) {
      searchParams.set("transform", transformString);
    }
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
```

</details>

### Step 2: 프로젝트 폴더에 파일 생성 및 붙여넣기

복사한 코드를 프로젝트에 `buildSnapkitImageURL.ts` 파일로 저장합니다.

## 사용법

### 기본 사용

먼저 [src/buildSnapkitImageURL.ts](src/buildSnapkitImageURL.ts) 파일의 코드를 프로젝트에 복사한 후 사용하세요:

```typescript
// buildSnapkitImageURL 함수와 타입을 복사한 후 사용

const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
});
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

```typescript
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
// → https://my-org.snapkit.dev/image?url=...&transform=w:300,h:200,fit:cover,format:webp
```

### 고급 변환

```typescript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 400,
    h: 300,
    fit: "cover",
    format: "webp",
    rotation: 90,
    blur: 5,
    grayscale: true,
    dpr: 2,
    extract: {
      x: 10,
      y: 20,
      width: 100,
      height: 150,
    },
  },
});
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
| `format`    | `'jpeg' \| 'png' \| 'webp' \| 'avif'`                     | 출력 포맷                    |
| `rotation`  | `number`                                                  | 회전 각도 (degrees)          |
| `blur`      | `number`                                                  | 블러 강도 (0.3-1000)         |
| `grayscale` | `boolean`                                                 | 흑백 변환                    |
| `flip`      | `boolean`                                                 | 상하 반전                    |
| `flop`      | `boolean`                                                 | 좌우 반전                    |
| `extract`   | `{ x, y, width, height }`                                 | 영역 추출                    |
| `dpr`       | `number`                                                  | Device Pixel Ratio (1.0-4.0) |

## 개발

### 테스트 실행

```bash
# 단위 테스트
pnpm test

# Watch 모드
pnpm test:watch

# 커버리지
pnpm test:coverage
```

### 빌드

```bash
pnpm build
```

### 타입 체크

```bash
pnpm type-check
```

## 라이선스

MIT
