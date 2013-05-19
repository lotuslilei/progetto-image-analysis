#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H

#include <jni.h>

#define	NULLFILTER	-1
#define	MEDIAN3x3	0
#define	GAUSS3x3	1
#define	GAUSS11x11	2
#define	SOBEL3x3	3
#define	CANNY3x3	4
#define	ERODE3x3	5
#define	THRESHOLD	6
#define	DILATE3x3	7

extern "C" {

JNIEXPORT void JNICALL Java_me_unphoto_imagetests_ImageProcessing_applyFilterNative
(
	JNIEnv* env,
	jobject obj,
	jbooleanArray src,
	jbooleanArray dst,
	jint width,
	jint height,
	jint filter
);

};

#endif
