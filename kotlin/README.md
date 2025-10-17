# Snapkit Image URL Builder - Kotlin

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder reference implementation written in Kotlin.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Full Implementation Code

### Step 1: Copy the code

The complete code is provided below so you can copy and use it directly without opening source files:

<details>
<summary><strong>View Full Code</strong></summary>

```kotlin
package dev.snapkit.imageurl

import android.net.Uri

/**
 * Image transformation parameters
 */
data class TransformOptions(
    /** Image width (pixels) */
    val w: Int? = null,
    /** Image height (pixels) */
    val h: Int? = null,
    /** Resize method */
    val fit: Fit? = null,
    /** Output format */
    val format: Format? = null,
    /** Rotation angle (degrees) */
    val rotation: Int? = null,
    /** Blur strength (0.3-1000) */
    val blur: Int? = null,
    /** Whether to convert to grayscale */
    val grayscale: Boolean? = null,
    /** Whether to flip vertically */
    val flip: Boolean? = null,
    /** Whether to flip horizontally */
    val flop: Boolean? = null,
    /** Region extraction */
    val extract: Extract? = null,
    /** Device Pixel Ratio (1.0-4.0) */
    val dpr: Double? = null,
    /** Image quality (1-100) */
    val quality: Int? = null
) {
    /** Resize method */
    enum class Fit {
        CONTAIN, COVER, FILL, INSIDE, OUTSIDE;

        override fun toString() = name.lowercase()
    }

    /** Output format */
    enum class Format {
        JPEG, PNG, WEBP, AVIF;

        override fun toString() = name.lowercase()
    }

    /** Region extraction */
    data class Extract(
        val x: Int,
        val y: Int,
        val width: Int,
        val height: Int
    )
}

/**
 * Snapkit image URL builder
 *
 * @property organizationName Organization name (used as Snapkit subdomain)
 *
 * @example
 * ```kotlin
 * val builder = SnapkitImageURL("my-org")
 * val imageUrl = builder.build(
 *     url = "https://cdn.cloudfront.net/image.jpg",
 *     transform = TransformOptions(
 *         w = 300,
 *         h = 200,
 *         fit = TransformOptions.Fit.COVER,
 *         format = TransformOptions.Format.WEBP
 *     )
 * )
 * ```
 */
class SnapkitImageURL(private val organizationName: String) {

    /**
     * Generate Snapkit image proxy URL
     *
     * @param url Original image URL
     * @param transform Image transformation options
     * @return Complete image proxy URL
     */
    fun build(url: String, transform: TransformOptions? = null): String {
        val baseUrl = "https://$organizationName.snapkit.dev/image"

        val uriBuilder = Uri.parse(baseUrl).buildUpon()
        uriBuilder.appendQueryParameter("url", url)

        transform?.let {
            val transformString = buildTransformString(it)
            if (transformString.isNotEmpty()) {
                uriBuilder.appendQueryParameter("transform", transformString)
            }
        }

        return uriBuilder.build().toString()
    }

    private fun buildTransformString(options: TransformOptions): String {
        val parts = mutableListOf<String>()

        // Numeric/string value parameters
        options.w?.let { parts.add("w:$it") }
        options.h?.let { parts.add("h:$it") }
        options.fit?.let { parts.add("fit:$it") }
        options.format?.let { parts.add("format:$it") }
        options.rotation?.let { parts.add("rotation:$it") }
        options.blur?.let { parts.add("blur:$it") }
        options.dpr?.let { parts.add("dpr:$it") }
        options.quality?.let { parts.add("quality:$it") }

        // Boolean parameters
        if (options.grayscale == true) parts.add("grayscale")
        if (options.flip == true) parts.add("flip")
        if (options.flop == true) parts.add("flop")

        // extract parameter
        options.extract?.let {
            parts.add("extract:${it.x}-${it.y}-${it.width}-${it.height}")
        }

        return parts.joinToString(",")
    }
}
```

</details>

### Step 2: Create and paste file in your project

Save the copied code as `SnapkitImageURL.kt` file in your project.

## Requirements

- Android API 21+
- Kotlin 1.9+

### Gradle (Groovy)

```groovy
dependencies {
    implementation 'dev.snapkit:snapkit-image-url-kotlin:1.0.0'
}
```

## Usage

### Basic Usage

```kotlin
import dev.snapkit.imageurl.SnapkitImageURL

val builder = SnapkitImageURL("my-org")
val imageUrl = builder.build("https://cdn.cloudfront.net/image.jpg")
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### Image Transform Options

```kotlin
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

### Advanced Transforms

```kotlin
val extract = TransformOptions.Extract(x = 10, y = 20, width = 100, height = 150)

val imageUrl = builder.build(
    url = "https://cdn.cloudfront.net/image.jpg",
    transform = TransformOptions(
        w = 400,
        h = 300,
        fit = TransformOptions.Fit.COVER,
        format = TransformOptions.Format.WEBP,
        rotation = 90,
        blur = 5,
        grayscale = true,
        dpr = 2.0,
        extract = extract
    )
)
```

### Using with Android ImageView (Coil)

```kotlin
import coil.load
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

imageView.load(imageUrl) {
    crossfade(true)
    placeholder(R.drawable.placeholder)
}
```

### Using with Jetpack Compose

```kotlin
import androidx.compose.foundation.Image
import androidx.compose.runtime.*
import coil.compose.rememberAsyncImagePainter
import dev.snapkit.imageurl.SnapkitImageURL
import dev.snapkit.imageurl.TransformOptions

@Composable
fun SnapkitImage() {
    val builder = remember { SnapkitImageURL("my-org") }

    val imageUrl = remember {
        builder.build(
            url = "https://cdn.cloudfront.net/image.jpg",
            transform = TransformOptions(
                w = 300,
                h = 200,
                fit = TransformOptions.Fit.COVER,
                format = TransformOptions.Format.WEBP
            )
        )
    }

    Image(
        painter = rememberAsyncImagePainter(imageUrl),
        contentDescription = "Example Image",
        modifier = Modifier.fillMaxWidth()
    )
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
| `fit`       | `Fit?`     | Resize method (CONTAIN, COVER, FILL, INSIDE, OUTSIDE) |
| `format`    | `Format?`  | Output format (JPEG, PNG, WEBP, AVIF)           |
| `rotation`  | `Int?`     | Rotation angle (degrees)                        |
| `blur`      | `Int?`     | Blur intensity (0.3-1000)                       |
| `grayscale` | `Boolean?` | Convert to grayscale                            |
| `flip`      | `Boolean?` | Flip vertically                                 |
| `flop`      | `Boolean?` | Flip horizontally                               |
| `extract`   | `Extract?` | Extract region                                  |
| `dpr`       | `Double?`  | Device Pixel Ratio (1.0-4.0)                    |

## Development

### Run Tests

```bash
./gradlew test
```

### Build

```bash
./gradlew build
```

## License

MIT
