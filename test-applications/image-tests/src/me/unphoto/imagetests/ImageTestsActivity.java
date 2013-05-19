package me.unphoto.imagetests;

import java.io.FileNotFoundException;
import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class ImageTestsActivity extends Activity {
	private ImageProcessing proc;
	private TextView logArea;
	private Button loadImageButton;
	private static final int LOAD_IMAGE = 1;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		proc = new ImageProcessing();
		logArea = (TextView) findViewById(R.id.logTextView);

		loadImageButton = (Button) findViewById(R.id.loadImageButton);
		loadImageButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(Intent.ACTION_PICK, Images.Media.EXTERNAL_CONTENT_URI);
				intent.setType("image/*");
				startActivityForResult(intent, LOAD_IMAGE);
			}
		});
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
		super.onActivityResult(requestCode, resultCode, intent);

		switch (requestCode) {
		case LOAD_IMAGE:
			if (resultCode == RESULT_OK) {
				Uri imageUri = intent.getData();
				String imagePath = getPath(imageUri);
				new AsyncFilter(imagePath).execute(ProcessingFilter.values());
			}
		}
	}

	private class AsyncFilter extends AsyncTask<ProcessingFilter, String, Boolean> {

		private String fileName;

		public AsyncFilter(String fileName) {
			this.fileName = fileName;
		}

		@Override
		protected void onPreExecute() {
			logArea.append("Loading and converting image...\n\n");
		}

		@Override
		protected Boolean doInBackground(ProcessingFilter... params) {

			Bitmap image;

			try {
				image = ImageConverter.JPEGToBitmap(fileName);
			} catch (FileNotFoundException e) {
				return false;
			}

			byte[] yuvImage = ImageConverter.BitmapToNV21(image);
			int width = image.getWidth();
			int height = image.getHeight();

			for (ProcessingFilter filter : params) {
				try {
					applyFilterAndSave(yuvImage, Configurations.applicationFolder, width, height, filter);
				} catch (IOException e) {
					return false;
				}
				publishProgress(filter.getFilterName());
			}
			return true;
		}

		@Override
		protected void onProgressUpdate(String... progress) {
			logArea.append("Executed filter: " + progress[0] + "\n");
		}

		@Override
		protected void onPostExecute(Boolean result) {
			if (result) {
				logArea.append("\nAll done!!!\n");
			} else {
				logArea.append("\nSomething went wrong :(\n");
			}
		}

	}

	private String getPath(Uri uri) {
		String[] projection = { MediaStore.Images.Media.DATA };
		Cursor cursor = managedQuery(uri, projection, null, null, null);
		int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
		cursor.moveToFirst();
		return cursor.getString(column_index);
	}

	private void applyFilterAndSave(byte[] image, String path, int width, int height, ProcessingFilter filter) throws IOException {

		String fileName = path + filter.getFilterName() + ".jpeg";

		byte[] result = proc.applyFilter(image, width, height, filter);
		ImageConverter.saveN21ToFile(result, width, height, fileName);
	}
}
