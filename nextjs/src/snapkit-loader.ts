/**
 * Snapkit Custom Loader for Next.js Image Component
 * @see https://nextjs.org/docs/api-reference/next/image#loader
 */

/**
 * Image transformation parameter type definition
 */
export interface TransformOptions {
  /** Image width (pixels) */
  w?: number;
  /** Image height (pixels) */
  h?: number;
  /** Resize method */
  fit?: "contain" | "cover" | "fill" | "inside" | "outside";
  /** Output format */
  format?: "jpeg" | "png" | "webp" | "avif";
  /** Rotation angle (degrees) */
  rotation?: number;
  /** Blur intensity (0.3-1000) */
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
 * Next.js Image Loader parameters
 */
export interface NextImageLoaderParams {
  src: string;
  width: number;
  quality?: number;
}

/**
 * Snapkit Loader configuration
 */
export interface SnapkitLoaderConfig {
  organizationName: string;
  transform?: Omit<TransformOptions, "w" | "h">;
}

/**
 * Convert TransformOptions to query string
 */
function buildTransformString(
  options: TransformOptions,
  width: number,
): string {
  const parts: string[] = [];

  // Use width provided by Next.js
  parts.push(`w:${width}`);

  // Other options
  if (options.h !== undefined) parts.push(`h:${options.h}`);
  if (options.fit) parts.push(`fit:${options.fit}`);
  if (options.format) parts.push(`format:${options.format}`);
  if (options.rotation !== undefined)
    parts.push(`rotation:${options.rotation}`);
  if (options.blur !== undefined) parts.push(`blur:${options.blur}`);
  if (options.dpr !== undefined) parts.push(`dpr:${options.dpr}`);
  if (options.quality !== undefined) parts.push(`quality:${options.quality}`);

  // Boolean parameters
  if (options.grayscale) parts.push("grayscale");
  if (options.flip) parts.push("flip");
  if (options.flop) parts.push("flop");

  // extract parameter
  if (options.extract) {
    const { x, y, width: w, height } = options.extract;
    parts.push(`extract:${x}-${y}-${w}-${height}`);
  }

  return parts.join(",");
}

/**
 * Snapkit Custom Loader factory function
 *
 * @param config - Snapkit loader configuration
 * @returns Next.js Image Loader function
 *
 * @example
 * ```tsx
 * // next.config.js
 * module.exports = {
 *   images: {
 *     loader: 'custom',
 *     loaderFile: './snapkit-loader.ts',
 *   },
 * };
 *
 * // snapkit-loader.ts
 * import { createSnapkitLoader } from '@snapkit/image-url-nextjs';
 *
 * export default createSnapkitLoader({
 *   organizationName: 'my-org',
 *   transform: {
 *     format: 'webp',
 *     fit: 'cover',
 *   },
 * });
 * ```
 *
 * @example
 * ```tsx
 * // Usage in Component
 * import Image from 'next/image';
 *
 * export function MyComponent() {
 *   return (
 *     <Image
 *       src="https://cdn.cloudfront.net/image.jpg"
 *       width={300}
 *       height={200}
 *       alt="Example"
 *     />
 *   );
 * }
 * ```
 */
export function createSnapkitLoader(config: SnapkitLoaderConfig) {
  return function snapkitLoader({
    src,
    width,
    quality,
  }: NextImageLoaderParams): string {
    const { organizationName, transform = {} } = config;

    // Construct base URL
    const baseUrl = `https://${organizationName}.snapkit.dev/image`;

    // Build query parameters using URLSearchParams
    const searchParams = new URLSearchParams();
    searchParams.set("url", src);

    // Generate transform string
    const transformOptions: TransformOptions = {
      ...transform,
      // Map quality to format (webp generally has the best quality/size ratio)
      format: transform.format || "webp",
      // Use quality from Next.js if not specified in transform
      quality: transform.quality !== undefined ? transform.quality : quality,
    };

    const transformString = buildTransformString(transformOptions, width);
    if (transformString) {
      searchParams.set("transform", transformString);
    }

    return `${baseUrl}?${searchParams.toString()}`;
  };
}

/**
 * Default Snapkit Loader (reads organizationName from environment variables)
 *
 * @example
 * ```tsx
 * // .env.local
 * NEXT_PUBLIC_SNAPKIT_ORG=my-org
 *
 * // next.config.js
 * module.exports = {
 *   images: {
 *     loader: 'custom',
 *     loaderFile: './snapkit-loader.ts',
 *   },
 * };
 * ```
 */
export default function snapkitLoader(params: NextImageLoaderParams): string {
  const organizationName = process.env.NEXT_PUBLIC_SNAPKIT_ORG;

  if (!organizationName) {
    throw new Error("NEXT_PUBLIC_SNAPKIT_ORG environment variable is not set");
  }

  const loader = createSnapkitLoader({ organizationName });
  return loader(params);
}
