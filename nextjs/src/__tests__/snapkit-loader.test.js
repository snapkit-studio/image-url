import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { createSnapkitLoader } from "../snapkit-loader.js";
import snapkitLoader from "../snapkit-loader.js";

describe("createSnapkitLoader", () => {
  const baseParams = {
    src: "https://cdn.cloudfront.net/image.jpg",
    width: 300,
  };

  describe("Basic behavior", () => {
    it("should create a basic loader", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
      });

      const result = loader(baseParams);

      expect(result).toContain("https://test-org.snapkit.dev/image");
      expect(result).toContain(
        "url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg",
      );
      expect(result).toContain("w%3A300");
      expect(result).toContain("format%3Awebp"); // default format
    });

    it("should include width parameter in transform", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
      });

      const result = loader({ ...baseParams, width: 500 });

      expect(result).toContain("w%3A500");
    });
  });

  describe("Transform options", () => {
    it("should apply format option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          format: "avif",
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("format%3Aavif");
    });

    it("should apply fit option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          fit: "cover",
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("fit%3Acover");
    });

    it("should apply height (h) option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          h: 200,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("h%3A200");
    });

    it("should apply rotation option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          rotation: 90,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("rotation%3A90");
    });

    it("should apply blur option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          blur: 5,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("blur%3A5");
    });

    it("should apply dpr option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          dpr: 2,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("dpr%3A2");
    });

    it("should apply quality option from transform", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          quality: 90,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("quality%3A90");
    });

    it("should apply quality option from Next.js parameter", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
      });

      const result = loader({ ...baseParams, quality: 75 });

      expect(result).toContain("quality%3A75");
    });

    it("should prioritize transform quality over Next.js quality", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          quality: 90,
        },
      });

      const result = loader({ ...baseParams, quality: 75 });

      expect(result).toContain("quality%3A90");
      expect(result).not.toContain("quality%3A75");
    });
  });

  describe("Boolean Transform options", () => {
    it("should apply grayscale option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          grayscale: true,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("grayscale");
    });

    it("should apply flip option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          flip: true,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("flip");
    });

    it("should apply flop option", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          flop: true,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("flop");
    });
  });

  describe("extract option", () => {
    it("should apply extract option in correct format", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          extract: { x: 10, y: 20, width: 100, height: 200 },
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("extract%3A10-20-100-200");
    });
  });

  describe("Combined options", () => {
    it("should combine multiple options", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
        transform: {
          h: 200,
          fit: "cover",
          format: "webp",
          rotation: 90,
          blur: 5,
          grayscale: true,
          dpr: 2,
          quality: 85,
        },
      });

      const result = loader(baseParams);

      expect(result).toContain("w%3A300");
      expect(result).toContain("h%3A200");
      expect(result).toContain("fit%3Acover");
      expect(result).toContain("format%3Awebp");
      expect(result).toContain("rotation%3A90");
      expect(result).toContain("blur%3A5");
      expect(result).toContain("grayscale");
      expect(result).toContain("dpr%3A2");
      expect(result).toContain("quality%3A85");
    });
  });

  describe("URL encoding", () => {
    it("should encode src URL correctly", () => {
      const loader = createSnapkitLoader({
        organizationName: "test-org",
      });

      const result = loader({
        src: "https://example.com/path with spaces/image.jpg?query=value",
        width: 300,
      });

      expect(result).toContain(
        "url=https%3A%2F%2Fexample.com%2Fpath+with+spaces%2Fimage.jpg%3Fquery%3Dvalue",
      );
    });
  });
});

describe("snapkitLoader (default export)", () => {
  const originalEnv = process.env.NEXT_PUBLIC_SNAPKIT_ORG;

  beforeEach(() => {
    process.env.NEXT_PUBLIC_SNAPKIT_ORG = "env-org";
  });

  afterEach(() => {
    process.env.NEXT_PUBLIC_SNAPKIT_ORG = originalEnv;
  });

  it("should read organizationName from environment variable", () => {
    const result = snapkitLoader({
      src: "https://cdn.cloudfront.net/image.jpg",
      width: 300,
    });

    expect(result).toContain("https://env-org.snapkit.dev/image");
  });

  it("should throw error when environment variable is not set", () => {
    delete process.env.NEXT_PUBLIC_SNAPKIT_ORG;

    expect(() =>
      snapkitLoader({
        src: "https://cdn.cloudfront.net/image.jpg",
        width: 300,
      }),
    ).toThrow("NEXT_PUBLIC_SNAPKIT_ORG environment variable is not set");
  });
});
