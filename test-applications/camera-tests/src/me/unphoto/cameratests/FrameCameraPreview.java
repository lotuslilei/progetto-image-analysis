package me.unphoto.cameratests;

import java.io.IOException;
import java.nio.ByteBuffer;

import android.app.Activity;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.widget.Toast;

public class FrameCameraPreview implements Camera.PreviewCallback {

	private Activity activity;
	String toastMessage;

	static {
		System.loadLibrary("CameraTestsNative");
	}

	public FrameCameraPreview(Activity activity) {
		this.activity = activity;
	}

	@Override
	public void onPreviewFrame(byte[] data, Camera camera) {
		Size size = camera.getParameters().getPreviewSize();
		byte[] out = new byte[data.length];

		ByteBuffer dataBuffer = ByteBuffer.wrap(data);
		ByteBuffer outBuffer = ByteBuffer.wrap(out);

		edgeDetection(dataBuffer.array(), outBuffer.array(), size.width,
				size.height);

		String imagePath = Configurations.applicationFolder + "camera.jpeg";

		try {
			ImageConverter.saveN21ToFile(out, size.width, size.height, imagePath);
			toastMessage = "Image saved";
		} catch (IOException e) {
			toastMessage = "Error :(";
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(activity.getApplicationContext(), toastMessage, Toast.LENGTH_SHORT).show();
			}
		});
	}

	private native void edgeDetection(byte[] src, byte[] dst, int width, int height);
}
