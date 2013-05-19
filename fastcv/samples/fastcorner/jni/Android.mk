LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_PRELINK_MODULE:= false

LOCAL_CFLAGS := -Wno-write-strings -DUSE_OPENGL_ES_2_0
LOCAL_LDLIBS := -llog -lGLESv2 -lfastcv -L ../../../fastcv/lib
LOCAL_MODULE := libfastcvsample

LOCAL_SRC_FILES := \
    FastCVSample.cpp \
    FPSCounter.cpp \
    CameraRendererRGB565GL2.cpp \
    CameraUtil.cpp \
    FastCVSampleRenderer.cpp

LOCAL_STATIC_LIBRARIES := libfastcv
LOCAL_SHARED_LIBRARIES := liblog libGLESv2
LOCAL_C_INCLUDES += vendor/qcom-proprietary/blur/tests/fastcvsample/jni ../../../fastcv/inc

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_STATIC_JAVA_LIBRARIES :=
LOCAL_JNI_SHARED_LIBRARIES := libfastcvsample
LOCAL_SRC_FILES := $(call all-subdir-java-files)
LOCAL_PACKAGE_NAME := FastCVSample

include $(BUILD_PACKAGE)
