package me.unphoto.sheetreconstruction;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import me.unphoto.imageprocessing.Configurations;
import me.unphoto.imageprocessing.ImageConverter;
import me.unphoto.imageprocessing.ImageProcessing;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;

public class SheetReconstructionActivity extends Activity {

	private static final int LOAD_IMAGE = 1001;

	private ImageView imageView;
	private TextView logTextView;
	private Button loadImageButton;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_sheet_reconstruction);

		logTextView = (TextView) findViewById(R.id.log_text);

		loadImageButton = (Button) findViewById(R.id.load_image);
		loadImageButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(Intent.ACTION_PICK, Images.Media.EXTERNAL_CONTENT_URI);
				intent.setType("image/*");
				startActivityForResult(intent, LOAD_IMAGE);
			}
		});

		imageView = (ImageView) findViewById(R.id.image);

		if(ImageProcessing.testLibrary() != ImageProcessing.TEST_ANSWER) {
			logTextView.append("Error loading native library");
			loadImageButton.setEnabled(false);
		}
	}

	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
		super.onActivityResult(requestCode, resultCode, intent);

		switch (requestCode) {
		case LOAD_IMAGE:
			if (resultCode == RESULT_OK) {
				Uri imageUri = intent.getData();
				String imagePath = getRealPathFromURI(imageUri);
				imageView.setImageURI(imageUri);
				new AsyncSheetReconstruction().execute(imagePath);
			}
		}
	}

	private String getRealPathFromURI(Uri contentUri) {
		String[] proj = { MediaStore.Images.Media.DATA };
		Cursor cursor = managedQuery(contentUri, proj, null, null, null);
		int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
		cursor.moveToFirst();
		return cursor.getString(column_index);
	}

	private class AsyncSheetReconstruction extends AsyncTask<String, String, Boolean> {

		@Override
		protected void onPreExecute() {
			logTextView.setText("");
			logTextView.append("Loading and converting image...\n\n");
		}

		@Override
		protected Boolean doInBackground(String... params) {

			Bitmap image;

			try {
				image = ImageConverter.JPEGToBitmap(params[0]);
			} catch (FileNotFoundException e) {
				publishProgress("Can't load image :(\n");
				return false;
			}

			byte[] yuvImage = ImageConverter.BitmapToNV21(image);
			byte[] outImage = new byte[yuvImage.length];
			int width = image.getWidth();
			int height = image.getHeight();

			if(!ImageProcessing.extractSheet(yuvImage, outImage, width, height)) {
				publishProgress("Unable to identify sheet\n");
				return false;
			}
			
			publishProgress("Corner extracted\n");
			publishProgress("Image rectified\n");

			try {
				ImageConverter.saveN21ToFile(outImage, width, height, Configurations.outputRectifiedImage);
			} catch (IOException e) {
				publishProgress("Error while saving image :(\n");
				return false;
			}

			return true;
		}

		@Override
		protected void onProgressUpdate(String... message) {
			logTextView.append(message[0]);
		}

		@Override
		protected void onPostExecute(Boolean result) {
			if (result) {
				logTextView.append("All done!!!\n");
				imageView.setImageURI(Uri.fromFile(new File(Configurations.outputRectifiedImage)));
			}
		}
	}
}
