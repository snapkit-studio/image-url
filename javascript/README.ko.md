# Snapkit Image URL Builder - JavaScript

JavaScript로 작성된 Snapkit 이미지 프록시 URL 생성 라이브러리입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 사용법

### 기본 사용

먼저 [src/buildSnapkitImageURL.js](src/buildSnapkitImageURL.js) 파일의 코드를 프로젝트에 복사한 후 사용하세요:

```javascript
// buildSnapkitImageURL 함수를 복사한 후 사용

const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
});
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

```javascript
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

```javascript
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

| 옵션        | 타입      | 설명                                                            |
| ----------- | --------- | --------------------------------------------------------------- |
| `w`         | `number`  | 이미지 너비 (픽셀)                                              |
| `h`         | `number`  | 이미지 높이 (픽셀)                                              |
| `fit`       | `string`  | 리사이즈 방식 ('contain', 'cover', 'fill', 'inside', 'outside') |
| `format`    | `string`  | 출력 포맷 ('jpeg', 'png', 'webp', 'avif')                       |
| `rotation`  | `number`  | 회전 각도 (degrees)                                             |
| `blur`      | `number`  | 블러 강도 (0.3-1000)                                            |
| `grayscale` | `boolean` | 흑백 변환                                                       |
| `flip`      | `boolean` | 상하 반전                                                       |
| `flop`      | `boolean` | 좌우 반전                                                       |
| `extract`   | `object`  | 영역 추출 `{ x, y, width, height }`                             |
| `dpr`       | `number`  | Device Pixel Ratio (1.0-4.0)                                    |

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

## 라이선스

MIT
