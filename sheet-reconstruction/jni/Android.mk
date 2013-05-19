LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PRELINK_MODULE:= false

LOCAL_CFLAGS := -Wno-write-strings
LOCAL_LDLIBS := -llog -lfastcv -L ../../fastcv/lib

LOCAL_MODULE    := ImageProcessingNative
LOCAL_SRC_FILES := ImageProcessing.cpp Hough.cpp HoughP.cpp Utils.cpp Rectification.cpp Calculus.cpp Segment.cpp

LOCAL_STATIC_LIBRARIES := libfastcv
LOCAL_C_INCLUDES +=  ../../fastcv/inc

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_STATIC_JAVA_LIBRARIES :=
LOCAL_JNI_SHARED_LIBRARIES := ImageProcessingNative
LOCAL_SRC_FILES := $(call all-subdir-java-files)
LOCAL_PACKAGE_NAME := ImageProcessingNative

include $(BUILD_PACKAGE)
