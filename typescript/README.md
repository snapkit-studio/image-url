# Snapkit Image URL Builder - TypeScript

[English](README.md) | [한국어](README.ko.md)

Snapkit image proxy URL builder library written in TypeScript.

> **⚠️ Note**: This is a reference implementation, not a published package. Copy the code below into your project.

## Usage

### Basic Usage

First, copy the code from [src/buildSnapkitImageURL.ts](src/buildSnapkitImageURL.ts) into your project:

```typescript
// Use the copied buildSnapkitImageURL function and types

const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
});
// → https://my-org.snapkit.dev/image?url=https%3A%2F%2Fcdn.cloudfront.net%2Fimage.jpg
```

### Image Transform Options

```typescript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 300,
    h: 200,
    fit: "cover",
    format: "webp",
  },
});
// → https://my-org.snapkit.dev/image?url=...&transform=w:300,h:200,fit:cover,format:webp
```

### Advanced Transforms

```typescript
const imageUrl = buildSnapkitImageURL({
  organizationName: "my-org",
  url: "https://cdn.cloudfront.net/image.jpg",
  transform: {
    w: 400,
    h: 300,
    fit: "cover",
    format: "webp",
    rotation: 90,
    blur: 5,
    grayscale: true,
    dpr: 2,
    extract: {
      x: 10,
      y: 20,
      width: 100,
      height: 150,
    },
  },
});
```

## ⚠️ URL Parameter Usage Notes

The `url` parameter is **optional** and should only be used when you need to continue using your existing CDN.

- **Purpose**: Fetching images from external URLs (not S3)
- **Cost**: May increase image response time and CDN costs
- **Recommendation**: Use only when unavoidable

## Transform Options

| Option      | Type                                                      | Description                  |
| ----------- | --------------------------------------------------------- | ---------------------------- |
| `w`         | `number`                                                  | Image width (pixels)         |
| `h`         | `number`                                                  | Image height (pixels)        |
| `fit`       | `'contain' \| 'cover' \| 'fill' \| 'inside' \| 'outside'` | Resize method                |
| `format`    | `'jpeg' \| 'png' \| 'webp' \| 'avif'`                     | Output format                |
| `rotation`  | `number`                                                  | Rotation angle (degrees)     |
| `blur`      | `number`                                                  | Blur intensity (0.3-1000)    |
| `grayscale` | `boolean`                                                 | Convert to grayscale         |
| `flip`      | `boolean`                                                 | Flip vertically              |
| `flop`      | `boolean`                                                 | Flip horizontally            |
| `extract`   | `{ x, y, width, height }`                                 | Extract region               |
| `dpr`       | `number`                                                  | Device Pixel Ratio (1.0-4.0) |

## Development

### Run Tests

```bash
# Unit tests
pnpm test

# Watch mode
pnpm test:watch

# Coverage
pnpm test:coverage
```

### Build

```bash
pnpm build
```

### Type Check

```bash
pnpm type-check
```

## License

MIT
