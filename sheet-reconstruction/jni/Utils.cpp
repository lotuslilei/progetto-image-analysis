#include "Utils.h"
#include "Segment.h"

#include <cmath>
#include <algorithm>

void convertRGBtoYUV(uint8_t * yuv420p, int *argb, int width, int height)
{
	int frameSize = width * height;

	int yIndex = 0;
	int uvIndex = frameSize;

	int R, G, B, Y, U, V;
	int index = 0;
	for (int j = 0; j < height; j++) {
		for (int i = 0; i < width; i++) {
			// a = (argb[index] & 0xff000000) >> 24;
			R = (argb[index] & 0xff0000) >> 16;
			G = (argb[index] & 0xff00) >> 8;
			B = (argb[index] & 0xff) >> 0;

			Y = ((66 * R + 129 * G + 25 * B + 128) >> 8) + 16;
			U = ((-38 * R - 74 * G + 112 * B + 128) >> 8) + 128;
			V = ((112 * R - 94 * G - 18 * B + 128) >> 8) + 128;

			yuv420p[yIndex++] = (uint8_t) ((Y < 0) ? 0 : ((Y > 255) ? 255 : Y));
			if (j % 2 == 0 && index % 2 == 0) {
				yuv420p[uvIndex++] = (uint8_t) ((V < 0) ? 0 : ((V > 255) ? 255 : V));
				yuv420p[uvIndex++] = (uint8_t) ((U < 0) ? 0 : ((U > 255) ? 255 : U));
			}

			index++;
		}
	}
}

bool areClose(Segment &l1, Segment &l2, float closeDistToll)
{
	using namespace std;

	float l11_l21 = sqrt(pow((float)(l1.x1-l2.x1), 2) + pow((float)(l1.y1-l2.y1), 2));
	float l11_l22 = sqrt(pow((float)(l1.x1-l2.x2), 2) + pow((float)(l1.y1-l2.y2), 2));
	float l12_l21 = sqrt(pow((float)(l1.x2-l2.x1), 2) + pow((float)(l1.y2-l2.y1), 2));
	float l12_l22 = sqrt(pow((float)(l1.x2-l2.x2), 2) + pow((float)(l1.y2-l2.y2), 2));

	if (l11_l21 <= closeDistToll) {
		return true;
	} else if (l11_l22 <= closeDistToll) {
		return true;
	} else if (l12_l21 <= closeDistToll) {
		return true;
	} else if (l12_l22 <= closeDistToll) {
		return true;
	} else {
		return false;
	}
}

bool areOrthogonal(float alpha, float beta, float thetaToll)
{
	using namespace std;

	if ((abs(abs(alpha)-abs(beta))<=(90+thetaToll) && abs(abs(alpha)-abs(beta))>=(90-thetaToll)) ||
		(abs(abs(180-alpha)-abs(beta))<=(90+thetaToll) && abs(abs(180-alpha)-abs(beta))>=(90-thetaToll)) ||
		(abs(abs(alpha)-abs(180-beta))<=(90+thetaToll) && abs(abs(alpha)-abs(180-beta))>=(90-thetaToll))) {
		return true;
	}

	return false;
}

bool areParallel(float alpha, float beta, float thetaToll)
{
	using namespace std;

	if (	abs(abs(alpha)-abs(beta))<=thetaToll ||
			abs(abs(180-alpha)-abs(beta))<=thetaToll ||
			abs(abs(alpha)-abs(180-beta))<=thetaToll) {
		return true;
	}


	return false;
}

float getAngle(Segment &l)
{
	using namespace std;

	float anglerad = fmod(atan2((float)(abs(l.y2)-abs(l.y1)), (float)(abs(l.x1)-abs(l.x2))), (float)(2*M_PI));

	return (anglerad/M_PI)*180;
}

void getPointsOrt(std::vector<CandidateSegments> segments, point_t points[4], float thetaToll)
{
	point_t p111 = { segments[0].l1.x1, segments[0].l1.y1 };
	point_t p112 = { segments[0].l1.x2, segments[0].l1.y2 };
	point_t p121 = { segments[0].l2.x1, segments[0].l2.y1 };
	point_t p122 = { segments[0].l2.x2, segments[0].l2.y2 };

	point_t p211 = { segments[1].l1.x1, segments[1].l1.y1 };
	point_t p212 = { segments[1].l1.x2, segments[1].l1.y2 };
	point_t p221 = { segments[1].l2.x1, segments[1].l2.y1 };
	point_t p222 = { segments[1].l2.x2, segments[1].l2.y2 };

	points[0] = lineIntersect(p111, p112, p121, p122);
	points[1] = lineIntersect(p211, p212, p221, p222);

	if(areOrthogonal(getAngle(segments[0].l1), getAngle(segments[1].l1), thetaToll)) {
		points[2] = lineIntersect(p111, p112, p211, p212);
		points[3] = lineIntersect(p121, p122, p221, p222);
	} else {
		points[2] = lineIntersect(p111, p112, p221, p222);
		points[3] = lineIntersect(p121, p122, p211, p212);
	}
}

float insideImage(point_t points[4], int r, int c)
{
	for (int i = 0; i < 4; i ++) {
		if(points[i].x < 0 || points[i].x > c) {
			return false;
		} else if(points[i].x < 0 || points[i].y > r) {
			return false;
		}
	}

	return true;
}

bool sameLine(Segment s1, Segment s2, float error)
{
	float m = (float)(s1.y2-s1.y1)/(s1.x2-s1.x1);
	float q = s1.y1 - m*s1.x1;

	float d1 = std::abs(m*s2.x1 - s2.y1 + q)/std::sqrt(m*m + 1);
	float d2 = std::abs(m*s1.x2 - s2.y2 + q)/std::sqrt(m*m + 1);

	return d1<=error && d2<=error;}

point_t lineIntersect(point_t p1, point_t p2, point_t p3, point_t p4)
{
	point_t intersection;

	float x1 = p1.x, x2 = p2.x, x3 = p3.x, x4 = p4.x;
	float y1 = p1.y, y2 = p2.y, y3 = p3.y, y4 = p4.y;

	float d = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);

	if (d == 0) {
		intersection.x = 0;
		intersection.y = 0;
	} else {
		intersection.x = ((x1*y2 - y1*x2)*(x3-x4)-(x1-x2)*(x3*y4 - y3*x4))/d;
		intersection.y = ((x1*y2 - y1*x2)*(y3-y4)-(y1-y2)*(x3*y4 - y3*x4))/d;
	}

	return intersection;
}

void getLinesExtremes(Segment &line1, Segment &line2, Segment &newLine)
{
	float lenmax = 0;

	// length of line1
	float len = std::sqrt(std::pow((float)(line1.x1-line1.x2), 2) + std::pow((float)(line1.y1-line1.y2), 2));
	if(len> lenmax) {
		lenmax = len;
		newLine = line1;
	}

	// length of line2
	len = std::sqrt(std::pow((float)(line2.x1-line2.x2), 2) + std::pow((float)(line2.y1-line2.y2), 2));
	if(len > lenmax) {
		lenmax = len;
		newLine = line2;
	}

	len = std::sqrt(std::pow((float)(line1.x1-line2.x1), 2) + std::pow((float)(line1.y1-line2.y1), 2));
	if(len > lenmax) {
		lenmax = len;
		newLine.x1 = line1.x1;
		newLine.y1 = line1.y1;
		newLine.x2 = line2.x1;
		newLine.y2 = line2.y1;
	}

	len = std::sqrt(std::pow((float)(line1.x1-line2.x2), 2) + std::pow((float)(line1.y1-line2.y2), 2));
	if(len > lenmax) {
		lenmax = len;
		newLine.x1 = line1.x1;
		newLine.y1 = line1.y1;
		newLine.x2 = line2.x2;
		newLine.y2 = line2.y2;
	}

	len = std::sqrt(std::pow((float)(line1.x2-line2.x1), 2) + std::pow((float)(line1.y2-line2.y1), 2));
	if(len > lenmax) {
		lenmax = len;
		newLine.x1 = line1.x2;
		newLine.y1 = line1.y2;
		newLine.x2 = line2.x1;
		newLine.y2 = line2.y1;
	}

	len = std::sqrt(std::pow((float)(line1.x2-line2.x2), 2) + std::pow((float)(line1.y2-line2.y2), 2));
	if(len > lenmax) {
		lenmax = len;
		newLine.x1 = line1.x2;
		newLine.y1 = line1.y2;
		newLine.x2 = line2.x2;
		newLine.y2 = line2.y2;
	}
}

void joinLines(std::vector<Segment> &lines, float distToll)
{
	int joinedId = 0;

	for(int l1 = 0; l1 < lines.size(); l1++) {
		int from = l1+1;

		if(from <= lines.size() && lines[l1].isValid()) {
			for(int l2 = from; l2 < lines.size(); l2++) {
				if(lines[l1].getID() != lines[l2].getID() && lines[l2].isValid()) {
					if(sameLine(lines[l1], lines[l2], distToll)) {
						Segment tmp;
						getLinesExtremes(lines[l1], lines[l2], tmp);
						tmp.setID(lines[l1].getID());

						lines[l1] = tmp;
						lines[l2].setValid(false);
					}
				}
			}
		}
	}
}

