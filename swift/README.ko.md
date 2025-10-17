# Snapkit Image URL Builder - Swift

Swift로 작성된 Snapkit 이미지 프록시 URL 생성 라이브러리입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 요구사항

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.9+

또는 Xcode에서:

1. File > Add Packages...
2. Repository URL 입력: `https://github.com/snapkit-studio/snapkit-image-url-swift.git`

## 사용법

### 기본 사용

```swift
import SnapkitImageURL

let builder = SnapkitImageURL(organizationName: "my-org")
let imageURL = builder.build(url: "https://cdn.cloudfront.net/image.jpg")
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

```swift
let imageURL = builder.build(
    url: "https://cdn.cloudfront.net/image.jpg",
    transform: TransformOptions(
        w: 300,
        h: 200,
        fit: .cover,
        format: .webp
    )
)
// → https://my-org.snapkit.dev/image?url=...&transform=w:300,h:200,fit:cover,format:webp
```

### 고급 변환

```swift
let extract = TransformOptions.Extract(x: 10, y: 20, width: 100, height: 150)

let imageURL = builder.build(
    url: "https://cdn.cloudfront.net/image.jpg",
    transform: TransformOptions(
        w: 400,
        h: 300,
        fit: .cover,
        format: .webp,
        rotation: 90,
        blur: 5,
        grayscale: true,
        dpr: 2.0,
        extract: extract
    )
)
```

### UIImageView/NSImageView와 함께 사용

```swift
// iOS/tvOS
import UIKit
import SnapkitImageURL

let builder = SnapkitImageURL(organizationName: "my-org")
let imageURL = builder.build(
    url: "https://cdn.cloudfront.net/image.jpg",
    transform: TransformOptions(w: 300, h: 200, fit: .cover, format: .webp)
)

if let url = imageURL {
    // URLSession으로 이미지 로드
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }.resume()
}
```

```swift
// macOS
import AppKit
import SnapkitImageURL

let builder = SnapkitImageURL(organizationName: "my-org")
let imageURL = builder.build(
    url: "https://cdn.cloudfront.net/image.jpg",
    transform: TransformOptions(w: 300, h: 200, fit: .cover, format: .webp)
)

if let url = imageURL {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data, let image = NSImage(data: data) {
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }.resume()
}
```

### SwiftUI와 함께 사용

```swift
import SwiftUI
import SnapkitImageURL

struct ContentView: View {
    @State private var image: UIImage?
    let builder = SnapkitImageURL(organizationName: "my-org")

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear(perform: loadImage)
        }
    }

    private func loadImage() {
        let imageURL = builder.build(
            url: "https://cdn.cloudfront.net/image.jpg",
            transform: TransformOptions(
                w: 300,
                h: 200,
                fit: .cover,
                format: .webp
            )
        )

        guard let url = imageURL else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
```

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

| 옵션        | 타입       | 설명                                                       |
| ----------- | ---------- | ---------------------------------------------------------- |
| `w`         | `Int?`     | 이미지 너비 (픽셀)                                         |
| `h`         | `Int?`     | 이미지 높이 (픽셀)                                         |
| `fit`       | `Fit?`     | 리사이즈 방식 (.contain, .cover, .fill, .inside, .outside) |
| `format`    | `Format?`  | 출력 포맷 (.jpeg, .png, .webp, .avif)                      |
| `rotation`  | `Int?`     | 회전 각도 (degrees)                                        |
| `blur`      | `Int?`     | 블러 강도 (0.3-1000)                                       |
| `grayscale` | `Bool?`    | 흑백 변환                                                  |
| `flip`      | `Bool?`    | 상하 반전                                                  |
| `flop`      | `Bool?`    | 좌우 반전                                                  |
| `extract`   | `Extract?` | 영역 추출                                                  |
| `dpr`       | `Double?`  | Device Pixel Ratio (1.0-4.0)                               |

## 개발

### 테스트 실행

```bash
# 모든 플랫폼에서 테스트
swift test

# 특정 플랫폼
swift test --filter SnapkitImageURLTests
```

### 빌드

```bash
swift build
```

## 라이선스

MIT
