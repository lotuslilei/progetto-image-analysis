package me.unphoto.cameratests;

import java.io.IOException;

import android.content.Context;
import android.hardware.Camera;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class SurfaceCameraPreview extends SurfaceView implements SurfaceHolder.Callback {
	private SurfaceHolder surfaceHolder;
	private Camera camera;
	private final String TAG = "CameraPreview";

	public SurfaceCameraPreview(Context context, Camera camera) {
		super(context);
		this.camera = camera;

		surfaceHolder = getHolder();
		surfaceHolder.addCallback(this);
		surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		try {
			camera.setPreviewDisplay(holder);
			camera.startPreview();
		} catch (IOException e) {
			Log.d(TAG, "Error setting camera preview: " + e.getMessage());
		}
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {

		if (surfaceHolder.getSurface() == null) {
			return;
		}

		try {
			camera.stopPreview();
		} catch (Exception e) {
		}

		try {
			camera.setPreviewDisplay(surfaceHolder);
			camera.startPreview();
		} catch (Exception e) {
			Log.d(TAG, "Error starting camera preview: " + e.getMessage());
		}
	}
}