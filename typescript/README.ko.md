# Snapkit Image URL Builder - TypeScript

Snapkit 이미지 프록시 URL을 생성하는 TypeScript 라이브러리입니다.

## 설치

```bash
npm install @snapkit/image-url-typescript
# or
pnpm add @snapkit/image-url-typescript
# or
yarn add @snapkit/image-url-typescript
```

## 사용법

### 기본 사용

```typescript
import { buildSnapkitImageURL } from '@snapkit/image-url-typescript';

const imageUrl = buildSnapkitImageURL({
  organizationName: 'my-org',
  url: 'https://cdn.cloudfront.net/image.jpg',
});
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

```typescript
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
// → https://my-org.snapkit.dev/image?url=...&transform=w:300,h:200,fit:cover,format:webp
```

### 고급 변환

```typescript
const imageUrl = buildSnapkitImageURL({
  organizationName: 'my-org',
  url: 'https://cdn.cloudfront.net/image.jpg',
  transform: {
    w: 400,
    h: 300,
    fit: 'cover',
    format: 'webp',
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

| 옵션 | 타입 | 설명 |
|------|------|------|
| `w` | `number` | 이미지 너비 (픽셀) |
| `h` | `number` | 이미지 높이 (픽셀) |
| `fit` | `'contain' \| 'cover' \| 'fill' \| 'inside' \| 'outside'` | 리사이즈 방식 |
| `format` | `'jpeg' \| 'png' \| 'webp' \| 'avif'` | 출력 포맷 |
| `rotation` | `number` | 회전 각도 (degrees) |
| `blur` | `number` | 블러 강도 (0.3-1000) |
| `grayscale` | `boolean` | 흑백 변환 |
| `flip` | `boolean` | 상하 반전 |
| `flop` | `boolean` | 좌우 반전 |
| `extract` | `{ x, y, width, height }` | 영역 추출 |
| `dpr` | `number` | Device Pixel Ratio (1.0-4.0) |

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
