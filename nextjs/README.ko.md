# Snapkit Image URL Builder - Next.js

Next.js Image Component용 Snapkit Custom Loader입니다.

## 설치

```bash
npm install @snapkit/image-url-nextjs
# or
pnpm add @snapkit/image-url-nextjs
# or
yarn add @snapkit/image-url-nextjs
```

## 사용법

### 방법 1: 환경 변수 사용 (권장)

#### 1. 환경 변수 설정

```bash
# .env.local
NEXT_PUBLIC_SNAPKIT_ORG=my-org
```

#### 2. Next.js 설정

```js
// next.config.js
module.exports = {
  images: {
    loader: 'custom',
    loaderFile: './lib/snapkit-loader.ts',
  },
};
```

#### 3. Loader 파일 생성

```ts
// lib/snapkit-loader.ts
import snapkitLoader from '@snapkit/image-url-nextjs';

export default snapkitLoader;
```

#### 4. Component에서 사용

```tsx
import Image from 'next/image';

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

### 방법 2: Custom Loader Factory 사용

#### 1. Loader 생성

```ts
// lib/snapkit-loader.ts
import { createSnapkitLoader } from '@snapkit/image-url-nextjs';

export default createSnapkitLoader({
  organizationName: 'my-org',
  transform: {
    format: 'webp',
    fit: 'cover',
  },
});
```

#### 2. Next.js 설정

```js
// next.config.js
module.exports = {
  images: {
    loader: 'custom',
    loaderFile: './lib/snapkit-loader.ts',
  },
};
```

#### 3. Component에서 사용

```tsx
import Image from 'next/image';

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

### 방법 3: Component별 Loader 사용

```tsx
import Image from 'next/image';
import { createSnapkitLoader } from '@snapkit/image-url-nextjs';

const snapkitLoader = createSnapkitLoader({
  organizationName: 'my-org',
  transform: {
    format: 'webp',
    fit: 'cover',
  },
});

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

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

| 옵션 | 타입 | 설명 |
|------|------|------|
| `h` | `number` | 이미지 높이 (width는 Next.js에서 자동 제공) |
| `fit` | `'contain' \| 'cover' \| 'fill' \| 'inside' \| 'outside'` | 리사이즈 방식 |
| `format` | `'jpeg' \| 'png' \| 'webp' \| 'avif'` | 출력 포맷 (기본: webp) |
| `rotation` | `number` | 회전 각도 (degrees) |
| `blur` | `number` | 블러 강도 (0.3-1000) |
| `grayscale` | `boolean` | 흑백 변환 |
| `flip` | `boolean` | 상하 반전 |
| `flop` | `boolean` | 좌우 반전 |
| `extract` | `{ x, y, width, height }` | 영역 추출 |
| `dpr` | `number` | Device Pixel Ratio (1.0-4.0) |

## 고급 사용

### 반응형 이미지

```tsx
import Image from 'next/image';

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
import Image from 'next/image';

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

## 참고

- [Next.js Image Component](https://nextjs.org/docs/api-reference/next/image)
- [Next.js Custom Loader](https://nextjs.org/docs/api-reference/next/image#loader)

## 라이선스

MIT
