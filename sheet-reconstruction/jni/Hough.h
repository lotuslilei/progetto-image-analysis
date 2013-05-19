#ifndef HOUGH_H
#define HOUGH_H

#include "Segment.h"

#include <stdint.h>
#include <vector>

typedef struct point {
	int x;
	int y;
}point_t;

typedef struct line {
	float rho;
	float angle;
}line_t;

int hough(	uint8_t* image, int width, int height, float rho, float theta,
		int threshold, line_t *lines, int linesMax);

int houghp(	uint8_t* image, int width, int height, float rho, float theta,
		int threshold, int lineLength, int lineGap,
		std::vector<Segment> &segments, int maxSegments);

#endif

