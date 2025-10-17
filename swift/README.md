# Snapkit Image URL Builder - Swift

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder library written in Swift.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Full Implementation Code

### Step 1: Copy the code

The complete code is provided so you can copy and use it directly without opening source files:

<details>
<summary><strong>View Full Code (185 lines)</strong></summary>

```swift
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
```

</details>

### Step 2: Create and paste file in your project

Save the copied code as `SnapkitImageURL.swift` file in your project.

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.9+

Or in Xcode:

1. File > Add Packages...
2. Enter Repository URL: `https://github.com/snapkit-studio/snapkit-image-url-swift.git`

## Usage

### Basic Usage

```swift
import SnapkitImageURL

let builder = SnapkitImageURL(organizationName: "my-org")
let imageURL = builder.build(url: "https://cdn.cloudfront.net/image.jpg")
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### Image Transform Options

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

### Advanced Transforms

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

### Using with UIImageView/NSImageView

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
    // Load image with URLSession
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

### Using with SwiftUI

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

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform Options

| Option      | Type       | Description                                     |
| ----------- | ---------- | ----------------------------------------------- |
| `w`         | `Int?`     | Image width (pixels)                            |
| `h`         | `Int?`     | Image height (pixels)                           |
| `fit`       | `Fit?`     | Resize method (.contain, .cover, .fill, .inside, .outside) |
| `format`    | `Format?`  | Output format (.jpeg, .png, .webp, .avif)       |
| `rotation`  | `Int?`     | Rotation angle (degrees)                        |
| `blur`      | `Int?`     | Blur intensity (0.3-1000)                       |
| `grayscale` | `Bool?`    | Convert to grayscale                            |
| `flip`      | `Bool?`    | Flip vertically                                 |
| `flop`      | `Bool?`    | Flip horizontally                               |
| `extract`   | `Extract?` | Extract region                                  |
| `dpr`       | `Double?`  | Device Pixel Ratio (1.0-4.0)                    |

## Development

### Run Tests

```bash
# Test on all platforms
swift test

# Specific platform
swift test --filter SnapkitImageURLTests
```

### Build

```bash
swift build
```

## License

MIT
