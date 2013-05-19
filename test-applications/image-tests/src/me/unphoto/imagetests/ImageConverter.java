package me.unphoto.imagetests;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;

/**
 * Utility class that provides method for image format conversion.
 *
 * NV21 format (equivalent to YUV420sp) is the format that the majority of
 * FastCV's functions requires as input format for images.
 */
public class ImageConverter {

	/**
	 * Loads an image from the filesystem into a Bitmap object.
	 *
	 * @param fileName absolute path of the image
	 * @return Bitmap of the JPEG image
	 * @throws FileNotFoundException when the image doesn't exists
	 */
	public static Bitmap JPEGToBitmap(String fileName) throws FileNotFoundException {

		Bitmap bitmap = BitmapFactory.decodeFile(fileName);

		if (bitmap == null) {
			throw new FileNotFoundException("Unable to find image: " + fileName);
		}

		return bitmap;
	}

	/**
	 * Converts a bitmap into a raw image in NV21 format.
	 *
	 * @param image Bitmap image
	 * @return image in NV21 format
	 */
	public static byte[] BitmapToNV21(Bitmap image) {

		int width = image.getWidth();
		int height = image.getHeight();
		int[] argb = new int[width * height];
		byte[] yuv = new byte[width * height * 3 / 2];

		image.getPixels(argb, 0, width, 0, 0, width, height);
		encodeYUV420p(yuv, argb, width, height);

		return yuv;
	}

	/**
	 * Converts a raw image in RGB888 format into another image in NV21 format.
	 *
	 * @param yuv420p raw output image in NV21 format
	 * @param argb raw input image in RGB888 format
	 * @param width width of the image in pixels
	 * @param height height of the image in pixels
	 */
	private static void encodeYUV420p(byte[] yuv420p, int[] argb, int width, int height) {

		final int frameSize = width * height;

		int yIndex = 0;
		int uvIndex = frameSize;

		int R, G, B, Y, U, V;
		int index = 0;
		for (int j = 0; j < height; j++) {
			for (int i = 0; i < width; i++) {

				// a = (argb[index] & 0xff000000) >> 24;
				R = (argb[index] & 0xff0000) >> 16;
				G = (argb[index] & 0xff00) >> 8;
				B = (argb[index] & 0xff) >> 0;

				Y = ((66 * R + 129 * G + 25 * B + 128) >> 8) + 16;
				U = ((-38 * R - 74 * G + 112 * B + 128) >> 8) + 128;
				V = ((112 * R - 94 * G - 18 * B + 128) >> 8) + 128;

				yuv420p[yIndex++] = (byte) ((Y < 0) ? 0 : ((Y > 255) ? 255 : Y));
				if (j % 2 == 0 && index % 2 == 0) {
					yuv420p[uvIndex++] = (byte) ((V < 0) ? 0 : ((V > 255) ? 255 : V));
					yuv420p[uvIndex++] = (byte) ((U < 0) ? 0 : ((U > 255) ? 255 : U));
				}

				index++;
			}
		}
	}

	/**
	 * Saves an image in format NV21 into a file in JPEG format.
	 *
	 * @param image image in format NV21
	 * @param width width of the image in pixels
	 * @param height height of the image in pixels
	 * @param fileName filename where to save the image
	 * @throws IOException 
	 */
	public static void saveN21ToFile(byte image[], int width, int height, String fileName) throws IOException {

		ByteArrayOutputStream out = new ByteArrayOutputStream();
		YuvImage yuvImage = new YuvImage(image, ImageFormat.NV21, width, height, null);
		Rect rectImage = new Rect(0, 0, width, height);
		yuvImage.compressToJpeg(rectImage, 100, out);
		byte[] imageBytes = out.toByteArray();
		FileOutputStream fileOut = new FileOutputStream(new File(fileName));
		fileOut.write(imageBytes);
		fileOut.close();
	}

}
