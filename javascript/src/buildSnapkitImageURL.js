/**
 * Snapkit image proxy URL builder function
 * @module buildSnapkitImageURL
 */

/**
 * Convert TransformOptions to query string
 * @param {Object} options - Transform options object
 * @param {number} [options.w] - Image width (pixels)
 * @param {number} [options.h] - Image height (pixels)
 * @param {'contain'|'cover'|'fill'|'inside'|'outside'} [options.fit] - Resize method
 * @param {'jpeg'|'png'|'webp'|'avif'} [options.format] - Output format
 * @param {number} [options.rotation] - Rotation angle (degrees)
 * @param {number} [options.blur] - Blur intensity (0.3-1000)
 * @param {boolean} [options.grayscale] - Whether to convert to grayscale
 * @param {boolean} [options.flip] - Whether to flip vertically
 * @param {boolean} [options.flop] - Whether to flip horizontally
 * @param {Object} [options.extract] - Area extraction
 * @param {number} options.extract.x - X coordinate
 * @param {number} options.extract.y - Y coordinate
 * @param {number} options.extract.width - Width
 * @param {number} options.extract.height - Height
 * @param {number} [options.dpr] - Device Pixel Ratio (1.0-4.0)
 * @param {number} [options.quality] - Image quality (1-100)
 * @returns {string} Query string (e.g., "w:100,h:100,fit:cover")
 */
function buildTransformString(options) {
  const parts = [];

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
 *
 * @param {Object} params - URL generation parameters
 * @param {string} params.organizationName - Organization name (used as Snapkit subdomain)
 * @param {string} params.url - Original image URL (CloudFront, etc.)
 * @param {Object} [params.transform] - Image transformation options
 * @returns {string} Complete image proxy URL
 *
 * @example
 * const imageUrl = buildSnapkitImageURL({
 *   organizationName: 'my-org',
 *   url: 'https://cdn.cloudfront.net/image.jpg',
 *   transform: {
 *     w: 300,
 *     h: 200,
 *     fit: 'cover',
 *     format: 'webp'
 *   }
 * });
 * // → "https://my-org.snapkit.dev/image?url=https%3A%2F%2F...&transform=w:300,h:200,fit:cover,format:webp"
 */
export function buildSnapkitImageURL(params) {
  const { organizationName, url, transform } = params;

  // Construct base URL
  const baseUrl = `https://${organizationName}.snapkit.dev/image`;

  // Build query parameters using URLSearchParams
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
