# Snapkit Image URL Builder - Next.js

[English](README.md) | [한국어](README.ko.md)

Example implementation of SnapKit image transformation functions for use with Next.js Image Component's loader prop.

## Quick Start

Copy the following code into your Next.js project to enable SnapKit image transformations.

### Step 1: Copy Helper Functions

Create a file with the SnapKit URL builder functions:

```ts
// lib/snapkit-image-url.ts

/**
 * Image transformation parameter type definition
 */
export interface TransformOptions {
  /** Image width (pixels) */
  w?: number;
  /** Image height (pixels) */
  h?: number;
  /** Resize mode */
  fit?: "contain" | "cover" | "fill" | "inside" | "outside";
  /** Output format */
  format?: "jpeg" | "png" | "webp" | "avif";
  /** Rotation angle (degrees) */
  rotation?: number;
  /** Blur strength (0.3-1000) */
  blur?: number;
  /** Whether to convert to grayscale */
  grayscale?: boolean;
  /** Whether to flip vertically */
  flip?: boolean;
  /** Whether to flip horizontally */
  flop?: boolean;
  /** Region extraction (x, y, width, height) */
  extract?: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  /** Device Pixel Ratio (1.0-4.0) */
  dpr?: number;
  /** Image quality (1-100) */
  quality?: number;
}

/**
 * buildSnapkitImageURL function parameters
 */
export interface BuildSnapkitImageURLParams {
  /** Organization name (used as Snapkit subdomain) */
  organizationName: string;
  /** Original image URL (CloudFront, etc.) */
  url: string;
  /** Image transformation options */
  transform?: TransformOptions;
}

/**
 * Convert TransformOptions to query string
 */
function buildTransformString(options: TransformOptions): string {
  const parts: string[] = [];

  // Numeric/string value parameters
  if (options.w !== undefined) parts.push(`w:${options.w}`);
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined)
    parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  // Boolean parameters (key only, no value)
  if (options.grayscale) parts.push("grayscale");
  if (options.flip) parts.push("flip");
  if (options.flop) parts.push("flop");

  // extract parameter (x-y-width-height)
  if (options.extract) {
    const { x, y, width, height } = options.extract;
    parts.push(`extract:${x}-${y}-${width}-${height}`);
  }

  return parts.join(",");
}

/**
 * Build Snapkit image proxy URL
 */
export function buildSnapkitImageURL(
  params: BuildSnapkitImageURLParams,
): string {
  const { organizationName, url, transform } = params;

  // Compose base URL
  const baseUrl = `https://${organizationName}.snapkit.dev/image`;

  // Compose query parameters with URLSearchParams
  const searchParams = new URLSearchParams();
  searchParams.set("url", url);

  // Add transform options if present
  if (transform) {
    const transformString = buildTransformString(transform);
    if (transformString) {
      searchParams.set("transform", transformString);
    }
  }

  return `${baseUrl}?${searchParams.toString()}`;
}
```

### Step 2: Create Next.js Loader

Create a loader function for Next.js Image Component:

```ts
// lib/snapkit-loader.ts
import { buildSnapkitImageURL } from "./snapkit-image-url";

export default function snapkitLoader({
  src,
  width,
  quality,
}: {
  src: string;
  width: number;
  quality?: number;
}): string {
  return buildSnapkitImageURL({
    organizationName: process.env.NEXT_PUBLIC_SNAPKIT_ORG || "my-org",
    url: src,
    transform: {
      w: width,
      quality,
      format: "webp",
    },
  });
}
```

## Usage

### Method 1: Global Loader Configuration (Recommended)

Configure the loader globally in your Next.js config:

```js
// next.config.js
module.exports = {
  images: {
    loader: "custom",
    loaderFile: "./lib/snapkit-loader.ts",
  },
};
```

Then use the Image component normally:

```tsx
import Image from "next/image";

export function MyComponent() {
  return (
    <Image
      src="https://cdn.cloudfront.net/image.jpg"
      width={300}
      height={200}
      alt="Example"
    />
  );
}
```

### Method 2: Component-Specific Loader

Pass the loader directly to individual Image components:

```tsx
import Image from "next/image";
import snapkitLoader from "@/lib/snapkit-loader";

export function MyComponent() {
  return (
    <Image
      loader={snapkitLoader}
      src="https://cdn.cloudfront.net/image.jpg"
      width={300}
      height={200}
      alt="Example"
    />
  );
}
```

### Method 3: Custom Loader with Specific Options

Create custom loaders for different use cases:

```tsx
import Image from "next/image";
import { buildSnapkitImageURL } from "@/lib/snapkit-image-url";

const highQualityLoader = ({ src, width }: { src: string; width: number }) => {
  return buildSnapkitImageURL({
    organizationName: "my-org",
    url: src,
    transform: {
      w: width,
      format: "avif",
      quality: 90,
      fit: "cover",
    },
  });
};

export function HeroImage() {
  return (
    <Image
      loader={highQualityLoader}
      src="https://cdn.cloudfront.net/hero.jpg"
      width={1200}
      height={600}
      priority
      alt="Hero"
    />
  );
}
```

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform Options

| Option      | Type                                                      | Description                   |
| ----------- | --------------------------------------------------------- | ----------------------------- |
| `w`         | `number`                                                  | Image width (pixels)          |
| `h`         | `number`                                                  | Image height (pixels)         |
| `fit`       | `'contain' \| 'cover' \| 'fill' \| 'inside' \| 'outside'` | Resize mode                   |
| `format`    | `'jpeg' \| 'png' \| 'webp' \| 'avif'`                     | Output format (default: webp) |
| `rotation`  | `number`                                                  | Rotation angle (degrees)      |
| `blur`      | `number`                                                  | Blur intensity (0.3-1000)     |
| `grayscale` | `boolean`                                                 | Convert to grayscale          |
| `flip`      | `boolean`                                                 | Flip vertically               |
| `flop`      | `boolean`                                                 | Flip horizontally             |
| `extract`   | `{ x, y, width, height }`                                 | Extract region                |
| `dpr`       | `number`                                                  | Device Pixel Ratio (1.0-4.0)  |
| `quality`   | `number`                                                  | Image quality (1-100)         |

## Advanced Usage

### Responsive Images

```tsx
import Image from "next/image";

export function ResponsiveImage() {
  return (
    <Image
      src="https://cdn.cloudfront.net/image.jpg"
      width={800}
      height={600}
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      alt="Responsive"
    />
  );
}
```

### Priority Images

```tsx
import Image from "next/image";

export function HeroImage() {
  return (
    <Image
      src="https://cdn.cloudfront.net/hero.jpg"
      width={1200}
      height={600}
      priority
      alt="Hero"
    />
  );
}
```

## Environment Variables

Set your organization name in environment variables:

```bash
# .env.local
NEXT_PUBLIC_SNAPKIT_ORG=my-org
```

## References

- [Next.js Image Component](https://nextjs.org/docs/api-reference/next/image)
- [Next.js Custom Loader](https://nextjs.org/docs/api-reference/next/image#loader)
