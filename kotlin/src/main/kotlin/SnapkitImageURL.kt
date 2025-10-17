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
