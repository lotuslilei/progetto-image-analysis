#ifndef RECTIFICATION_H
#define RECTIFICATION_H

#include <fastcv.h>

void getPerspectiveTransformf32(const float32_t src1[8],
		const float32_t src2[8], float32_t projectionMatrix[9]);

bool identifySheetCorners(const uint8_t *image, int width, int height,
		float32_t corners[8]);

#endif
