#include "Rectification.h"
#include "Calculus.h"
#include "Hough.h"
#include "Utils.h"

#include <cmath>
#include <vector>
#include <iostream>
#include <algorithm>

void getPerspectiveTransformf32(const float32_t src1[8],
		const float32_t src2[8], float32_t projectionMatrix[9])
{
	float matrix[64];
	float constantTerms[8];
	float solution[8];

	for (int i = 0; i < 8; i += 2) {
		matrix[i*8 + 0] = 0;
		matrix[i*8 + 1] = 0;
		matrix[i*8 + 2] = 0;
		matrix[i*8 + 3] = -src1[i];
		matrix[i*8 + 4] = -src1[i+1];
		matrix[i*8 + 5] = -1;
		matrix[i*8 + 6] = src1[i]*src2[i+1];
		matrix[i*8 + 7] = src1[i+1]*src2[i+1];
		matrix[(i+1)*8 + 0] = src1[i];
		matrix[(i+1)*8 + 1] = src1[i+1];
		matrix[(i+1)*8 + 2] = 1;
		matrix[(i+1)*8 + 3] = 0;
		matrix[(i+1)*8 + 4] = 0;
		matrix[(i+1)*8 + 5] = 0;
		matrix[(i+1)*8 + 6] = -src1[i]*src2[i];
		matrix[(i+1)*8 + 7] = -src1[i+1]*src2[i];
	}

	for (int i = 0; i < 8; i += 2) {
		constantTerms[i] = -src2[i+1];
		constantTerms[i+1] = src2[i];
	}

	solve32f((float*)matrix, (float*)constantTerms, (float*)projectionMatrix, 8);

	projectionMatrix[8] = 1;
}

bool identifySheetCorners(const uint8_t *image, int width, int height,
		float32_t corners[8])
{
	uint8_t *canny = (uint8_t*) fcvMemAlloc(width*height*sizeof(uint8_t), 16);
	std::vector<Segment> segments;
	int numLines;
	int stride = width;

	int peakThresh = 100;

	int numLinesMin = 4;
	int numLinesMax = 250;

	int lineGap = std::ceil(0.013*(height+width)/2);
	int lineGapInc = std::ceil(0.0022*(height+width)/2);
	int lineGapMax = std::ceil(0.09*(height+width)/2);

	int lineMinLength = std::ceil(0.035*(height+width)/2);

	int lineMinLenInc = std::ceil(0.0022*(height+width)/2);
	int lineMinLenMax = 1;

	int lines = 0;

	fcvFilterCanny3x3u8_v2(image, width, height, width, canny, width, 14, 15);

	while(segments.size() < numLinesMin) {

		numLines = houghp(canny, width, height, 1, M_PI/360, peakThresh, lineMinLength, lineGap, segments, 100);

		if(lineGap >= lineGapMax && lineMinLength <= lineMinLenMax) {
			break;
		}

		if(lineGap+lineGapInc >= lineGapMax) {
			lineGap = lineGapMax;
		} else {
			lineGap = lineGap + lineGapInc;
		}

		if(lineMinLength - lineMinLenInc <= lineMinLenMax) {
			lineMinLength = lineMinLenMax;
		} else {
			lineMinLength = lineMinLength - lineMinLenInc;
		}
	}

	fcvMemFree(canny);

	if(segments.size() < numLines) {
		return false;
	}

	std::sort(segments.begin(), segments.end());
	std::reverse(segments.begin(), segments.end());

	float distToll = ceil(0.013*(height+width)/2);
	joinLines(segments, distToll);

	segments.erase(
			std::remove(segments.begin(), segments.end(), Segment::getInvalidLine()),
			segments.end()
	);
	std::sort(segments.begin(), segments.end());
	std::reverse(segments.begin(), segments.end());

	std::vector<CandidateSegments> candSeg;

	float thetaToll = 25;
	float thetaTollInc = 5;
	float thetaTollMax = 35;

	distToll = std::ceil(0.018*(height+width)/2);
	float distTollInc = std::ceil(0.0044*(height+width)/2);
	float distTollMax = std::ceil(0.9*(height+width)/2);

	numLinesMin = 2;

	while(candSeg.size() < numLinesMin) {

		if(distToll >= distTollMax && thetaToll >= thetaTollMax) {
			break;
		}

		for(int h =0; h < segments.size(); h++) {

			int from = h+1;

			if(from <= segments.size() && segments[h].isValid()) {
				for(int k = 0; k < segments.size(); k++) {
					if(	segments[h].getID() != segments[k].getID() &&
						segments[k].isValid()) {
						if(	areOrthogonal(getAngle(segments[h]), getAngle(segments[k]), thetaToll) &&
							areClose(segments[h], segments[k], distToll)) {
							candSeg.push_back(CandidateSegments(segments[h], segments[k]));
							segments[k].setValid(false);
							break;
						}
					}
				}
			}
		}

		thetaToll = thetaToll + thetaTollInc;
		distToll = distToll + distTollInc;
	}

	if(candSeg.size() < numLinesMin) {
		return false;
	}

	thetaToll = thetaToll - thetaTollInc;

	point_t points[4];
	getPointsOrt(candSeg, points, thetaToll);

	if(!insideImage(points, height, width)) {
		return false;
	}

	corners[0] = points[0].x;
	corners[1] = points[0].y;
	corners[2] = points[1].x;
	corners[3] = points[1].y;
	corners[4] = points[2].x;
	corners[5] = points[2].y;
	corners[6] = points[3].x;
	corners[7] = points[3].y;

	return true;
}
