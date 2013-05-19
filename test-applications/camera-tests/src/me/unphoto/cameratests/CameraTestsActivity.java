package me.unphoto.cameratests;

import android.app.Activity;
import android.hardware.Camera;
import android.os.Bundle;
import android.view.Display;
import android.view.Surface;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;

public class CameraTestsActivity extends Activity {
	private Camera camera;
	private FrameCameraPreview frameCameraPreview;
	private Button captureButton;
	private static int[] orientations;

	static {
		orientations = new int[4];
		orientations[Surface.ROTATION_0] = 90;
		orientations[Surface.ROTATION_90] = 0;
		orientations[Surface.ROTATION_180] = 270;
		orientations[Surface.ROTATION_270] = 180;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		frameCameraPreview = new FrameCameraPreview(this);
		camera = Camera.open();

		if (camera == null) {
			return;
		}

		Display display = ((WindowManager) getSystemService(WINDOW_SERVICE))
				.getDefaultDisplay();

		camera.setDisplayOrientation(orientations[display.getRotation()]);

		SurfaceCameraPreview preview = new SurfaceCameraPreview(this, camera);
		FrameLayout frame = (FrameLayout) findViewById(R.id.camera_preview);
		frame.addView(preview);

		captureButton = (Button) findViewById(R.id.button_capture);
		captureButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				camera.setOneShotPreviewCallback(frameCameraPreview);
			}
		});
	}

	@Override
	protected void onPause() {
		if (camera != null) {
			camera.release();
			camera = null;
		}
		super.onPause();
	}

}
