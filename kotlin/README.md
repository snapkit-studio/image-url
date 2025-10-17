# Snapkit Image URL Builder - Kotlin

[English](README.md) | [한국어](README.ko.md)

Kotlin으로 작성된 Snapkit 이미지 프록시 URL 생성 라이브러리입니다.

> **⚠️ 안내**: 배포된 패키지가 아닌 참고용 구현입니다. 아래 코드를 프로젝트에 복사하여 사용하세요.

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

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform 옵션

| 옵션 | 타입 | 설명 |
|------|------|------|
| `w` | `Int?` | 이미지 너비 (픽셀) |
| `h` | `Int?` | 이미지 높이 (픽셀) |
| `fit` | `Fit?` | 리사이즈 방식 (CONTAIN, COVER, FILL, INSIDE, OUTSIDE) |
| `format` | `Format?` | 출력 포맷 (JPEG, PNG, WEBP, AVIF) |
| `rotation` | `Int?` | 회전 각도 (degrees) |
| `blur` | `Int?` | 블러 강도 (0.3-1000) |
| `grayscale` | `Boolean?` | 흑백 변환 |
| `flip` | `Boolean?` | 상하 반전 |
| `flop` | `Boolean?` | 좌우 반전 |
| `extract` | `Extract?` | 영역 추출 |
| `dpr` | `Double?` | Device Pixel Ratio (1.0-4.0) |

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
