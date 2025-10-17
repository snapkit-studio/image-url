<?php

namespace Snapkit\ImageURL\Tests;

use PHPUnit\Framework\TestCase;
use Snapkit\ImageURL\SnapkitImageURL;
use Snapkit\ImageURL\TransformOptions;
use Snapkit\ImageURL\Extract;

class SnapkitImageURLTest extends TestCase
{
    private SnapkitImageURL $builder;
    private string $testURL = 'https://cdn.cloudfront.net/image.jpg';

    protected function setUp(): void
    {
        $this->builder = new SnapkitImageURL('test-org');
    }

    // Basic URL generation
    public function testBasicURLGeneration(): void
    {
        $result = $this->builder->build($this->testURL);

        $this->assertStringContainsString('https://test-org.snapkit.dev/image', $result);
        $this->assertStringContainsString('url=', $result);
        $this->assertStringContainsString('cdn.cloudfront.net', $result);
    }

    public function testURLEncoding(): void
    {
        $urlWithSpaces = 'https://example.com/path with spaces/image.jpg?query=value';
        $result = $this->builder->build($urlWithSpaces);

        $this->assertStringContainsString('url=', $result);
    }

    // Numeric/string transformation parameters
    public function testWidthParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['w' => 300])
        );

        $this->assertTrue(
            str_contains($result, 'w%3A300') || str_contains($result, 'w:300')
        );
    }

    public function testHeightParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['h' => 200])
        );

        $this->assertTrue(
            str_contains($result, 'h%3A200') || str_contains($result, 'h:200')
        );
    }

    public function testFitParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['fit' => 'cover'])
        );

        $this->assertTrue(
            str_contains($result, 'fit%3Acover') || str_contains($result, 'fit:cover')
        );
    }

    public function testFormatParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['format' => 'webp'])
        );

        $this->assertTrue(
            str_contains($result, 'format%3Awebp') || str_contains($result, 'format:webp')
        );
    }

    public function testRotationParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['rotation' => 90])
        );

        $this->assertTrue(
            str_contains($result, 'rotation%3A90') || str_contains($result, 'rotation:90')
        );
    }

    public function testBlurParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['blur' => 5])
        );

        $this->assertTrue(
            str_contains($result, 'blur%3A5') || str_contains($result, 'blur:5')
        );
    }

    public function testDPRParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['dpr' => 2.0])
        );

        $this->assertTrue(
            str_contains($result, 'dpr%3A2') || str_contains($result, 'dpr:2')
        );
    }

    public function testQualityParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['quality' => 85])
        );

        $this->assertTrue(
            str_contains($result, 'quality%3A85') || str_contains($result, 'quality:85')
        );
    }

    // Boolean transformation parameters
    public function testGrayscaleParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['grayscale' => true])
        );

        $this->assertStringContainsString('grayscale', $result);
    }

    public function testFlipParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['flip' => true])
        );

        $this->assertStringContainsString('flip', $result);
    }

    public function testFlopParameter(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['flop' => true])
        );

        $this->assertStringContainsString('flop', $result);
    }

    public function testFalseBooleanParameterNotIncluded(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['grayscale' => false])
        );

        $this->assertStringNotContainsString('grayscale', $result);
    }

    // extract parameter
    public function testExtractParameter(): void
    {
        $extract = new Extract(10, 20, 100, 200);
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['extract' => $extract])
        );

        $this->assertStringContainsString('extract', $result);
        $this->assertStringContainsString('10-20-100-200', $result);
    }

    // Composite parameter combinations
    public function testMultipleParameterCombination(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions([
                'w' => 300,
                'h' => 200,
                'fit' => 'cover',
                'format' => 'webp',
            ])
        );

        $this->assertTrue(str_contains($result, 'w:300') || str_contains($result, 'w%3A300'));
        $this->assertTrue(str_contains($result, 'h:200') || str_contains($result, 'h%3A200'));
        $this->assertTrue(str_contains($result, 'fit:cover') || str_contains($result, 'fit%3Acover'));
        $this->assertTrue(str_contains($result, 'format:webp') || str_contains($result, 'format%3Awebp'));
    }

    public function testAllTypeParameterCombination(): void
    {
        $extract = new Extract(10, 20, 100, 200);
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions([
                'w' => 300,
                'h' => 200,
                'fit' => 'cover',
                'format' => 'webp',
                'rotation' => 90,
                'blur' => 5,
                'grayscale' => true,
                'flip' => true,
                'dpr' => 2.0,
                'quality' => 85,
                'extract' => $extract,
            ])
        );

        $this->assertTrue(str_contains($result, 'w:300') || str_contains($result, 'w%3A300'));
        $this->assertTrue(str_contains($result, 'h:200') || str_contains($result, 'h%3A200'));
        $this->assertStringContainsString('grayscale', $result);
        $this->assertStringContainsString('flip', $result);
        $this->assertTrue(str_contains($result, 'quality:85') || str_contains($result, 'quality%3A85'));
    }

    // Edge Cases
    public function testEmptyTransformObject(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions()
        );

        $this->assertStringNotContainsString('transform=', $result);
    }

    public function testZeroValueHandling(): void
    {
        $result = $this->builder->build(
            $this->testURL,
            new TransformOptions(['w' => 0, 'rotation' => 0])
        );

        $this->assertTrue(str_contains($result, 'w:0') || str_contains($result, 'w%3A0'));
        $this->assertTrue(str_contains($result, 'rotation:0') || str_contains($result, 'rotation%3A0'));
    }

    public function testOrganizationNameWithSpecialCharacters(): void
    {
        $builder = new SnapkitImageURL('my-org-123');
        $result = $builder->build($this->testURL);

        $this->assertStringContainsString('https://my-org-123.snapkit.dev/image', $result);
    }
}
