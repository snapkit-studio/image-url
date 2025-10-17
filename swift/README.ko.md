# Snapkit Image URL Builder - Swift

Swift로 작성된 Snapkit 이미지 프록시 URL 생성 라이브러리입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 전체 구현 코드

### Step 1: 코드 복사

소스 파일을 열지 않고도 바로 복사하여 사용할 수 있도록 전체 코드를 제공합니다:

<details>
<summary><strong>전체 코드 보기 (185줄)</strong></summary>

````swift
import Foundation

/// Image transformation parameters
public struct TransformOptions {
    /// Image width (pixels)
    public var w: Int?
    /// Image height (pixels)
    public var h: Int?
    /// Resize method
    public var fit: Fit?
    /// Output format
    public var format: Format?
    /// Rotation angle (degrees)
    public var rotation: Int?
    /// Blur intensity (0.3-1000)
    public var blur: Int?
    /// Whether to convert to grayscale
    public var grayscale: Bool?
    /// Whether to flip vertically
    public var flip: Bool?
    /// Whether to flip horizontally
    public var flop: Bool?
    /// Region extraction
    public var extract: Extract?
    /// Device Pixel Ratio (1.0-4.0)
    public var dpr: Double?
    /// Image quality (1-100)
    public var quality: Int?

    public init(
        w: Int? = nil,
        h: Int? = nil,
        fit: Fit? = nil,
        format: Format? = nil,
        rotation: Int? = nil,
        blur: Int? = nil,
        grayscale: Bool? = nil,
        flip: Bool? = nil,
        flop: Bool? = nil,
        extract: Extract? = nil,
        dpr: Double? = nil,
        quality: Int? = nil
    ) {
        self.w = w
        self.h = h
        self.fit = fit
        self.format = format
        self.rotation = rotation
        self.blur = blur
        self.grayscale = grayscale
        self.flip = flip
        self.flop = flop
        self.extract = extract
        self.dpr = dpr
        self.quality = quality
    }

    /// Resize method
    public enum Fit: String {
        case contain
        case cover
        case fill
        case inside
        case outside
    }

    /// Output format
    public enum Format: String {
        case jpeg
        case png
        case webp
        case avif
    }

    /// Region extraction
    public struct Extract {
        public let x: Int
        public let y: Int
        public let width: Int
        public let height: Int

        public init(x: Int, y: Int, width: Int, height: Int) {
            self.x = x
            self.y = y
            self.width = width
            self.height = height
        }
    }
}

/// Snapkit image URL builder
public struct SnapkitImageURL {
    private let organizationName: String

    public init(organizationName: String) {
        self.organizationName = organizationName
    }

    /// Generate Snapkit image proxy URL
    ///
    /// - Parameters:
    ///   - url: Original image URL
    ///   - transform: Image transformation options
    /// - Returns: Complete image proxy URL
    ///
    /// # Example
    /// ```swift
    /// let builder = SnapkitImageURL(organizationName: "my-org")
    /// let imageURL = builder.build(
    ///     url: "https://cdn.cloudfront.net/image.jpg",
    ///     transform: TransformOptions(
    ///         w: 300,
    ///         h: 200,
    ///         fit: .cover,
    ///         format: .webp
    ///     )
    /// )
    /// ```
    public func build(url: String, transform: TransformOptions? = nil) -> URL? {
        var components = URLComponents(string: "https://\(organizationName).snapkit.dev/image")

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "url", value: url)
        ]

        if let transform = transform {
            let transformString = buildTransformString(transform)
            if !transformString.isEmpty {
                queryItems.append(URLQueryItem(name: "transform", value: transformString))
            }
        }

        components?.queryItems = queryItems
        return components?.url
    }

    private func buildTransformString(_ options: TransformOptions) -> String {
        var parts: [String] = []

        // Numeric/string value parameters
        if let w = options.w {
            parts.append("w:\(w)")
        }
        if let h = options.h {
            parts.append("h:\(h)")
        }
        if let fit = options.fit {
            parts.append("fit:\(fit.rawValue)")
        }
        if let format = options.format {
            parts.append("format:\(format.rawValue)")
        }
        if let rotation = options.rotation {
            parts.append("rotation:\(rotation)")
        }
        if let blur = options.blur {
            parts.append("blur:\(blur)")
        }
        if let dpr = options.dpr {
            parts.append("dpr:\(dpr)")
        }
        if let quality = options.quality {
            parts.append("quality:\(quality)")
        }

        // Boolean parameters
        if options.grayscale == true {
            parts.append("grayscale")
        }
        if options.flip == true {
            parts.append("flip")
        }
        if options.flop == true {
            parts.append("flop")
        }

        // extract parameter
        if let extract = options.extract {
            parts.append("extract:\(extract.x)-\(extract.y)-\(extract.width)-\(extract.height)")
        }

        return parts.joined(separator: ",")
    }
}
````

</details>

### Step 2: 프로젝트 폴더에 파일 생성 및 붙여넣기

복사한 코드를 프로젝트에 `SnapkitImageURL.swift` 파일로 저장합니다.

## 요구사항

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.9+

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
