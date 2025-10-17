# Snapkit Image URL Builder - Kotlin

Kotlin으로 작성된 Snapkit 이미지 프록시 URL 생성 라이브러리입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

## 전체 구현 코드

### Step 1: 코드 복사

소스 파일을 열지 않고도 바로 복사하여 사용할 수 있도록 전체 코드를 제공합니다:

<details>
<summary><strong>전체 코드 보기 (127줄)</strong></summary>

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

### Step 2: 프로젝트 폴더에 파일 생성 및 붙여넣기

복사한 코드를 프로젝트에 `SnapkitImageURL.kt` 파일로 저장합니다.

## 요구사항

- Android API 21+
- Kotlin 1.9+

### Gradle (Groovy)

```groovy
dependencies {
    implementation 'dev.snapkit:snapkit-image-url-kotlin:1.0.0'
}
```

## 사용법

### 기본 사용

```kotlin
import dev.snapkit.imageurl.SnapkitImageURL

val builder = SnapkitImageURL("my-org")
val imageUrl = builder.build("https://cdn.cloudfront.net/image.jpg")
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### 이미지 변환 옵션

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

### 고급 변환

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

### Android ImageView와 함께 사용 (Coil)

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

### Jetpack Compose와 함께 사용

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

## ⚠️ URL 파라미터 사용 시 주의사항

`url` 파라미터는 **선택 사항**이며, 기존 CDN을 계속 사용하고자 할 때만 사용하세요.

- **목적**: S3가 아닌 외부 URL로부터 이미지를 fetching
- **비용**: 이미지 응답 속도 저하 및 CDN 비용 증가 가능
- **권장**: 불가피한 경우에만 사용

## Transform 옵션

| 옵션        | 타입       | 설명                                                  |
| ----------- | ---------- | ----------------------------------------------------- |
| `w`         | `Int?`     | 이미지 너비 (픽셀)                                    |
| `h`         | `Int?`     | 이미지 높이 (픽셀)                                    |
| `fit`       | `Fit?`     | 리사이즈 방식 (CONTAIN, COVER, FILL, INSIDE, OUTSIDE) |
| `format`    | `Format?`  | 출력 포맷 (JPEG, PNG, WEBP, AVIF)                     |
| `rotation`  | `Int?`     | 회전 각도 (degrees)                                   |
| `blur`      | `Int?`     | 블러 강도 (0.3-1000)                                  |
| `grayscale` | `Boolean?` | 흑백 변환                                             |
| `flip`      | `Boolean?` | 상하 반전                                             |
| `flop`      | `Boolean?` | 좌우 반전                                             |
| `extract`   | `Extract?` | 영역 추출                                             |
| `dpr`       | `Double?`  | Device Pixel Ratio (1.0-4.0)                          |

## 개발

### 테스트 실행

```bash
./gradlew test
```

### 빌드

```bash
./gradlew build
```

## 라이선스

MIT
