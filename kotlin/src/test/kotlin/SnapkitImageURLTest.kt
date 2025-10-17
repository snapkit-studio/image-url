package dev.snapkit.imageurl

import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

class SnapkitImageURLTest {
    private lateinit var builder: SnapkitImageURL
    private val testURL = "https://cdn.cloudfront.net/image.jpg"

    @Before
    fun setUp() {
        builder = SnapkitImageURL("test-org")
    }

    // Basic URL generation
    @Test
    fun `generate basic URL`() {
        val result = builder.build(testURL)

        assertTrue(result.contains("https://test-org.snapkit.dev/image"))
        assertTrue(result.contains("url="))
        assertTrue(result.contains("cdn.cloudfront.net"))
    }

    @Test
    fun `URL encoding`() {
        val urlWithSpaces = "https://example.com/path with spaces/image.jpg?query=value"
        val result = builder.build(urlWithSpaces)

        assertTrue(result.contains("url="))
    }

    // Numeric/string transformation parameters
    @Test
    fun `width parameter`() {
        val result = builder.build(testURL, TransformOptions(w = 300))

        assertTrue(result.contains("w%3A300") || result.contains("w:300"))
    }

    @Test
    fun `height parameter`() {
        val result = builder.build(testURL, TransformOptions(h = 200))

        assertTrue(result.contains("h%3A200") || result.contains("h:200"))
    }

    @Test
    fun `fit parameter`() {
        val result = builder.build(testURL, TransformOptions(fit = TransformOptions.Fit.COVER))

        assertTrue(result.contains("fit%3Acover") || result.contains("fit:cover"))
    }

    @Test
    fun `format parameter`() {
        val result = builder.build(testURL, TransformOptions(format = TransformOptions.Format.WEBP))

        assertTrue(result.contains("format%3Awebp") || result.contains("format:webp"))
    }

    @Test
    fun `rotation parameter`() {
        val result = builder.build(testURL, TransformOptions(rotation = 90))

        assertTrue(result.contains("rotation%3A90") || result.contains("rotation:90"))
    }

    @Test
    fun `blur parameter`() {
        val result = builder.build(testURL, TransformOptions(blur = 5))

        assertTrue(result.contains("blur%3A5") || result.contains("blur:5"))
    }

    @Test
    fun `dpr parameter`() {
        val result = builder.build(testURL, TransformOptions(dpr = 2.0))

        assertTrue(result.contains("dpr%3A2") || result.contains("dpr:2"))
    }

    @Test
    fun `quality parameter`() {
        val result = builder.build(testURL, TransformOptions(quality = 85))

        assertTrue(result.contains("quality%3A85") || result.contains("quality:85"))
    }

    // Boolean transformation parameters
    @Test
    fun `grayscale parameter`() {
        val result = builder.build(testURL, TransformOptions(grayscale = true))

        assertTrue(result.contains("grayscale"))
    }

    @Test
    fun `flip parameter`() {
        val result = builder.build(testURL, TransformOptions(flip = true))

        assertTrue(result.contains("flip"))
    }

    @Test
    fun `flop parameter`() {
        val result = builder.build(testURL, TransformOptions(flop = true))

        assertTrue(result.contains("flop"))
    }

    @Test
    fun `false Boolean parameters should not be included`() {
        val result = builder.build(testURL, TransformOptions(grayscale = false))

        assertFalse(result.contains("grayscale"))
    }

    // extract parameter
    @Test
    fun `extract parameter`() {
        val extract = TransformOptions.Extract(10, 20, 100, 200)
        val result = builder.build(testURL, TransformOptions(extract = extract))

        assertTrue(result.contains("extract") && result.contains("10-20-100-200"))
    }

    // Multiple parameter combinations
    @Test
    fun `multiple parameter combinations`() {
        val result = builder.build(
            testURL,
            TransformOptions(
                w = 300,
                h = 200,
                fit = TransformOptions.Fit.COVER,
                format = TransformOptions.Format.WEBP
            )
        )

        assertTrue(result.contains("w:300") || result.contains("w%3A300"))
        assertTrue(result.contains("h:200") || result.contains("h%3A200"))
        assertTrue(result.contains("fit:cover") || result.contains("fit%3Acover"))
        assertTrue(result.contains("format:webp") || result.contains("format%3Awebp"))
    }

    @Test
    fun `all parameter type combinations`() {
        val extract = TransformOptions.Extract(10, 20, 100, 200)
        val result = builder.build(
            testURL,
            TransformOptions(
                w = 300,
                h = 200,
                fit = TransformOptions.Fit.COVER,
                format = TransformOptions.Format.WEBP,
                rotation = 90,
                blur = 5,
                grayscale = true,
                flip = true,
                dpr = 2.0,
                quality = 85,
                extract = extract
            )
        )

        assertTrue(result.contains("w:300") || result.contains("w%3A300"))
        assertTrue(result.contains("h:200") || result.contains("h%3A200"))
        assertTrue(result.contains("grayscale"))
        assertTrue(result.contains("flip"))
        assertTrue(result.contains("quality:85") || result.contains("quality%3A85"))
    }

    // Edge Cases
    @Test
    fun `empty Transform object`() {
        val result = builder.build(testURL, TransformOptions())

        assertFalse(result.contains("transform="))
    }

    @Test
    fun `handle zero values`() {
        val result = builder.build(testURL, TransformOptions(w = 0, rotation = 0))

        assertTrue(result.contains("w:0") || result.contains("w%3A0"))
        assertTrue(result.contains("rotation:0") || result.contains("rotation%3A0"))
    }

    @Test
    fun `organizationName with special characters`() {
        val builder = SnapkitImageURL("my-org-123")
        val result = builder.build(testURL)

        assertTrue(result.contains("https://my-org-123.snapkit.dev/image"))
    }
}
