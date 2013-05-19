#include "ImageProcessing.h"

#include <stdlib.h>
#include <fastcv.h>
#include <android/log.h>

#define LOG_TAG    "ImageProcessing.cpp"

#define DPRINTF(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#define IPRINTF(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define EPRINTF(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

JNIEXPORT void JNICALL Java_me_unphoto_imagetests_ImageProcessing_applyFilterNative
(
	JNIEnv* env,
	jobject obj,
	jbooleanArray src,
	jbooleanArray dst,
	jint width,
	jint height,
	jint filter
)
{
	jboolean* srcData = NULL;
	jboolean* dstData = NULL;
	jboolean isCopy = 0;

	jint stride = width;
	jint frameSize = width*height;

	srcData = env->GetBooleanArrayElements(src, &isCopy);
	dstData = env->GetBooleanArrayElements(dst, &isCopy);

	switch(filter) {
		case NULLFILTER:
			memcpy((uint8_t *)dstData, (uint8_t *)srcData, width*height);
			break;
		case MEDIAN3x3:
			fcvFilterMedian3x3u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride);
			break;
		case GAUSS3x3:
			fcvFilterGaussian3x3u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride, 1);
			break;
		case GAUSS11x11:
			fcvFilterGaussian11x11u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride, 1);
			break;
		case SOBEL3x3:
			fcvFilterSobel3x3u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride);
			break;
		case CANNY3x3:
			fcvFilterCanny3x3u8((uint8_t *)srcData, width, height, (uint8_t *)dstData, 5, 10);
			break;
		case ERODE3x3:
			fcvFilterErode3x3u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride);
			break;
		case THRESHOLD:
			fcvFilterThresholdu8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride, 100);
			break;
		case DILATE3x3:
			fcvFilterDilate3x3u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t *)dstData, stride);
			break;
	}

	// copy U,V data that are not used by the filters
	memcpy(dstData+frameSize, srcData+frameSize, frameSize/2);

	env->ReleaseBooleanArrayElements(src, srcData, JNI_ABORT);
	env->ReleaseBooleanArrayElements(dst, dstData, JNI_ABORT);
}
