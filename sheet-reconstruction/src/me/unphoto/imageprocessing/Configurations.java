package me.unphoto.imageprocessing;

import java.io.File;

import android.os.Environment;

public class Configurations {

	static {
		String path = Environment.getExternalStorageDirectory().getPath()
				+ File.separator + Environment.DIRECTORY_PICTURES
				+ File.separator + "FastCV"
				+ File.separator;

		File imagesFolder = new File(path);
		imagesFolder.mkdirs();

		applicationFolder = path;

		outputRectifiedImage = path + "RectifiedImage.jpg";
	}

	public static final String applicationFolder;
	public static final String outputRectifiedImage;
}
