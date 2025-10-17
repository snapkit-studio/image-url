import XCTest
@testable import SnapkitImageURL

final class SnapkitImageURLTests: XCTestCase {
    var builder: SnapkitImageURL!
    let testURL = "https://cdn.cloudfront.net/image.jpg"

    override func setUp() {
        super.setUp()
        builder = SnapkitImageURL(organizationName: "test-org")
    }

    // MARK: - Basic URL Generation

    func testBasicURLGeneration() {
        let result = builder.build(url: testURL)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("https://test-org.snapkit.dev/image"))
        XCTAssertTrue(result!.absoluteString.contains("url="))
        XCTAssertTrue(result!.absoluteString.contains("cdn.cloudfront.net"))
    }

    func testURLEncoding() {
        let urlWithSpaces = "https://example.com/path with spaces/image.jpg?query=value"
        let result = builder.build(url: urlWithSpaces)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("url="))
    }

    // MARK: - Numeric/String Transform Parameters

    func testWidthParameter() {
        let transform = TransformOptions(w: 300)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("w:300"))
    }

    func testHeightParameter() {
        let transform = TransformOptions(h: 200)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("h:200"))
    }

    func testFitParameter() {
        let transform = TransformOptions(fit: .cover)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("fit:cover"))
    }

    func testFormatParameter() {
        let transform = TransformOptions(format: .webp)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("format:webp"))
    }

    func testRotationParameter() {
        let transform = TransformOptions(rotation: 90)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("rotation:90"))
    }

    func testBlurParameter() {
        let transform = TransformOptions(blur: 5)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("blur:5"))
    }

    func testDPRParameter() {
        let transform = TransformOptions(dpr: 2.0)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("dpr:2"))
    }

    func testQualityParameter() {
        let transform = TransformOptions(quality: 85)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("quality:85"))
    }

    // MARK: - Boolean Transform Parameters

    func testGrayscaleParameter() {
        let transform = TransformOptions(grayscale: true)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("grayscale"))
    }

    func testFlipParameter() {
        let transform = TransformOptions(flip: true)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("flip"))
    }

    func testFlopParameter() {
        let transform = TransformOptions(flop: true)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("flop"))
    }

    func testFalseBooleanParametersAreNotIncluded() {
        let transform = TransformOptions(grayscale: false)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertFalse(result!.absoluteString.contains("grayscale"))
    }

    // MARK: - extract parameter

    func testExtractParameter() {
        let extract = TransformOptions.Extract(x: 10, y: 20, width: 100, height: 200)
        let transform = TransformOptions(extract: extract)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("extract:10-20-100-200"))
    }

    // MARK: - Combined Parameter Tests

    func testMultipleParameterCombination() {
        let transform = TransformOptions(
            w: 300,
            h: 200,
            fit: .cover,
            format: .webp
        )
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("w:300"))
        XCTAssertTrue(result!.absoluteString.contains("h:200"))
        XCTAssertTrue(result!.absoluteString.contains("fit:cover"))
        XCTAssertTrue(result!.absoluteString.contains("format:webp"))
    }

    func testAllTypeParameterCombination() {
        let extract = TransformOptions.Extract(x: 10, y: 20, width: 100, height: 200)
        let transform = TransformOptions(
            w: 300,
            h: 200,
            fit: .cover,
            format: .webp,
            rotation: 90,
            blur: 5,
            grayscale: true,
            flip: true,
            flop: nil,
            extract: extract,
            dpr: 2.0,
            quality: 85
        )
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("w:300"))
        XCTAssertTrue(result!.absoluteString.contains("h:200"))
        XCTAssertTrue(result!.absoluteString.contains("fit:cover"))
        XCTAssertTrue(result!.absoluteString.contains("format:webp"))
        XCTAssertTrue(result!.absoluteString.contains("rotation:90"))
        XCTAssertTrue(result!.absoluteString.contains("blur:5"))
        XCTAssertTrue(result!.absoluteString.contains("grayscale"))
        XCTAssertTrue(result!.absoluteString.contains("flip"))
        XCTAssertTrue(result!.absoluteString.contains("dpr:2"))
        XCTAssertTrue(result!.absoluteString.contains("quality:85"))
        XCTAssertTrue(result!.absoluteString.contains("extract:10-20-100-200"))
    }

    // MARK: - Edge Cases

    func testEmptyTransformObject() {
        let transform = TransformOptions()
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertFalse(result!.absoluteString.contains("transform="))
    }

    func testZeroValuesAreHandled() {
        let transform = TransformOptions(w: 0, rotation: 0)
        let result = builder.build(url: testURL, transform: transform)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("w:0"))
        XCTAssertTrue(result!.absoluteString.contains("rotation:0"))
    }

    func testOrganizationNameWithSpecialCharacters() {
        let builder = SnapkitImageURL(organizationName: "my-org-123")
        let result = builder.build(url: testURL)

        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("https://my-org-123.snapkit.dev/image"))
    }
}
