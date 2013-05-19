#include "ImageProcessing.h"
#include "Rectification.h"

#include <fastcv.h>
#include <string.h>

JNIEXPORT jint JNICALL Java_me_unphoto_imageprocessing_ImageProcessing_testLibrary
  (JNIEnv *env)
{
	return 42;
}

JNIEXPORT jboolean JNICALL Java_me_unphoto_imageprocessing_ImageProcessing_extractSheet
	(JNIEnv *env, jobject obj, jbooleanArray inImage, jbooleanArray outImage,
	 jint width, jint height)
{
	// reads arrays using JNI functions
	jboolean isCopy = 0;
	jboolean *srcData = env->GetBooleanArrayElements(inImage, &isCopy);
	jboolean *dstData = env->GetBooleanArrayElements(outImage, &isCopy);

	// copy of srcData and dstData pointer if they are not 128-bit aligned
	jboolean *backupSrcData = srcData;
	jboolean *backupDstData = dstData;

	float32_t corners[8];
	float32_t *projectionMatrix = (float32_t*) fcvMemAlloc(9*sizeof(float32_t), 16);
	float32_t sheetPoints[] = {0.0f, 0.0f, width, height,  width, 0.0f, 0.0f, height};

	int32_t stride = width;
	int32_t frameSize = width*height;

	bool inAligned = ((int)srcData & 0xF) == 0;
	bool outAligned = ((int)dstData & 0xF) == 0;

	bool sheetIdentified;

	// if srcData or dstData are not 128-bit aligned create a copy that is
	// aligned so it can be used by FastCV functions
	if(!inAligned) {
		srcData = (jboolean*) fcvMemAlloc(width*height*3/2*sizeof(jboolean), 16);
		memcpy(srcData, backupSrcData, width*height*3/2);
	}

	if(!outAligned) {
		dstData = (jboolean*) fcvMemAlloc(width*height*3/2*sizeof(jboolean), 16);
		memcpy(dstData, backupDstData, width*height*3/2);
	}

	// identify corners, compute the projection matrix, warp perspective
	sheetIdentified = identifySheetCorners((uint8_t*)srcData, width, height, corners);

	if(sheetIdentified) {
		getPerspectiveTransformf32(sheetPoints, corners, projectionMatrix);
		fcvWarpPerspectiveu8_v2(srcData, width, height, stride, dstData, width, height, stride, projectionMatrix);
		memset(dstData+frameSize, 128, frameSize/2);
	}

	if(!inAligned) {
		memcpy(backupSrcData, srcData, width*height*3/2);
		fcvMemFree(srcData);
		srcData = backupSrcData;
	}

	if(!outAligned) {
		memcpy(backupDstData, dstData, width*height*3/2);
		fcvMemFree(dstData);
		dstData = backupDstData;
	}

	// release all the allocated resources
	fcvMemFree(projectionMatrix);
	env->ReleaseBooleanArrayElements(inImage, srcData, JNI_ABORT);
	env->ReleaseBooleanArrayElements(outImage, dstData, JNI_ABORT);

	return sheetIdentified;
}
