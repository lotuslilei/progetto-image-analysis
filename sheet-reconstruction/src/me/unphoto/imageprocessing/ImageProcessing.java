package me.unphoto.imageprocessing;

public class ImageProcessing {

	public static final int TEST_ANSWER = 42;

	static {
		System.loadLibrary("ImageProcessingNative");
	};

	/**
	 * Stupid test function to see whether the native library works or not
	 * @return 42 if the library is correctly working
	 */
	public static native int testLibrary();

	/**
	 * Extract the rectified image of an A4 sheet from an image
	 * @param inImage input image (NV21 format)
	 * @param outImage rectified image of the sheet (NV21 format)
	 * @param width width of the input and output image
	 * @param height height of the input and output image
	 * @return true if the sheet has been identified, false otherwise
	 */
	public static native boolean extractSheet(byte[] inImage, byte[] outImage, int width, int height);
}
