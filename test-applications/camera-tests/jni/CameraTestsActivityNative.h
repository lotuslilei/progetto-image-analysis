#ifndef CAMERATESTSACTIVITYNATIVE_H
#define CAMERATESTSACTIVITYNATIVE_H

#include <jni.h>

#define LOG_TAG    "CameraTestsActivityNative.cpp"

#define DPRINTF(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#define IPRINTF(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define EPRINTF(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

extern "C" {

JNIEXPORT void JNICALL Java_me_unphoto_cameratests_FrameCameraPreview_edgeDetection
(
	JNIEnv* env,
	jobject obj,
	jbooleanArray src,
	jbooleanArray dst,
	jint width,
	jint height
);

};

#endif
