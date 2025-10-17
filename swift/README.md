# Snapkit Image URL Builder - Swift

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder library written in Swift.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

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
