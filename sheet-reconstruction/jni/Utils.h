#ifndef UTILS_H_
#define UTILS_H_

#include <stdint.h>
#include <vector>

#include "Hough.h"

void convertRGBtoYUV(uint8_t *yuv420p, int *argb, int width, int height);

bool areClose(Segment &l1, Segment &l2, float closeDistToll);

bool areOrthogonal(float alpha, float beta, float thetaToll);

bool areParallel(float alpha, float beta, float thetaToll);

float getAngle(Segment &l);

void getPointsOrt(std::vector<CandidateSegments> segments, point_t points[4], float thetaToll);

float insideImage(point_t points[4], int r, int c);

bool sameLine(Segment s1, Segment s2, float error);

point_t lineIntersect(point_t a, point_t b, point_t c, point_t d);

void getLinesExtremes(Segment &line1, Segment &line2, Segment &newLine);

void cleanLines(std::vector<Segment> lines);

void joinLines(std::vector<Segment> &lines, float distToll);

#endif
