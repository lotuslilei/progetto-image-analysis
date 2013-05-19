#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H

#include <jni.h>

#ifdef __cplusplus
extern "C" {
#endif

#define LOG_TAG    "ImageProcessing"

#define DPRINTF(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#define IPRINTF(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define EPRINTF(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

JNIEXPORT jint JNICALL Java_me_unphoto_imageprocessing_ImageProcessing_testLibrary
	(JNIEnv *);

JNIEXPORT jboolean JNICALL Java_me_unphoto_imageprocessing_ImageProcessing_extractSheet
	(JNIEnv *env, jobject obj, jbooleanArray inImage, jbooleanArray outImage,
	 jint width, jint height);

#ifdef __cplusplus
}
#endif

#endif
