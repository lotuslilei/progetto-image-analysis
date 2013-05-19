#include "CameraTestsActivityNative.h"

#include <stdlib.h>
#include <fastcv.h>

JNIEXPORT void JNICALL Java_me_unphoto_cameratests_FrameCameraPreview_edgeDetection
(
	JNIEnv* env,
	jobject obj,
	jbooleanArray src,
	jbooleanArray dst,
	jint width,
	jint height
)
{
	jboolean* srcData = NULL;
	jboolean* dstData = NULL;
	jboolean isCopy = 0;

	jint stride = width;
	jint frameSize = width*height;

	srcData = env->GetBooleanArrayElements(src, &isCopy);
	dstData = env->GetBooleanArrayElements(dst, &isCopy);

	fcvFilterSobel3x3u8_v2((uint8_t *)srcData, width, height, stride, (uint8_t*)dstData, stride);
	memcpy(dstData+frameSize, srcData+frameSize, frameSize/2);

	env->ReleaseBooleanArrayElements(src, srcData, JNI_ABORT);
	env->ReleaseBooleanArrayElements(dst, dstData, JNI_ABORT);
}
