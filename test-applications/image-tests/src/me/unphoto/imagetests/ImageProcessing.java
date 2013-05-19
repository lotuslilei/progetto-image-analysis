package me.unphoto.imagetests;

import java.nio.ByteBuffer;

public class ImageProcessing {
	
	static {
		System.loadLibrary("ImageProcessingNative");
	};

	/**
	 * Applies a particular filter to the image
	 *
	 * @param src source image
	 * @param width width of the images in pixels
	 * @param height height of the images in pixels
	 * @param filter filter to be applied
	 * @return the filtered image
	 */
	public byte[] applyFilter(byte[] src, int width, int height, ProcessingFilter filter) {
		
		byte[] dst = new byte[src.length];
		ByteBuffer srcBuffer = ByteBuffer.wrap(src);
		ByteBuffer dstBuffer = ByteBuffer.wrap(dst);
		
		applyFilterNative(srcBuffer.array(), dstBuffer.array(), width, height, filter.getCode());

		return dst;
	}

	/**
	 * Performs the specified filter using FastCV API.
	 *
	 * @param src source image
	 * @param dst destination image
	 * @param width width of the images in pixels
	 * @param height height of the images in pixels
	 * @param filter filter to be applied
	 */
	private native void applyFilterNative(byte[] src, byte[] dst, int width, int height, int filter);
}
