#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>

#include <vector>

#include "Hough.h"
#include "Segment.h"

static inline unsigned randInt(uint64_t* rng);

int houghp(	uint8_t* image, int width, int height, float rho, float theta,
		int threshold, int lineLength, int lineGap,
		std::vector<Segment> &segments, int maxSegments)
{
	int32_t *accum;
	uint8_t *mask;
	std::vector<point_t> seq;
	float *trigtab;

	uint64_t rng = 0xFFFFFFFFFFFFFFFF;

	int stride = width;
	int numangle, numrho;
	float irho = 1 / rho;
	float ang;
	int r, n, count;
	point_t pt;

	int addedLines = 0;

	numangle = M_PI / theta;
	numrho = lrint(((width + height) * 2 + 1) / rho);

	trigtab = (float *) std::malloc(numangle*2*sizeof(float));
	accum = (int32_t *) std::malloc(numangle*numrho*sizeof(int32_t));
	mask = (uint8_t *) std::malloc(height*width*sizeof(uint8_t));

	std::memset(accum, 0, numangle*numrho*sizeof(uint32_t));

	for (ang = 0, n = 0; n < numangle; ang += theta, n++) {
		trigtab[n * 2] = (float) (cos(ang) * irho);
		trigtab[n * 2 + 1] = (float) (sin(ang) * irho);
	}

	// stage 1. collect non-zero image points
	for (pt.y = 0, count = 0; pt.y < height; pt.y++) {
		const uint8_t* data = image + pt.y * stride;
		uint8_t* mdata = mask + pt.y * width;

		for (pt.x = 0; pt.x < width; pt.x++) {
			if (data[pt.x]) {
				mdata[pt.x] = (uint8_t) 1;
				seq.push_back(pt);
			} else {
				mdata[pt.x] = 0;
			}
		}
	}

	count = seq.size();

	// stage 2. process all the points in random order
	for (; count > 0; count--) {
		// choose random point out of the remaining ones
		int idx = randInt(&rng) % count;
		int max_val = threshold - 1, max_n = 0;
		point_t* point = &seq[idx];
		point_t line_end[2] = { { 0, 0 }, { 0, 0 } };
		float a, b;
		int32_t* adata = accum;
		int i, j, k, x0, y0, dx0, dy0, xflag;
		int good_line;
		const int shift = 16;

		i = point->y;
		j = point->x;

		// "remove" it by overriding it with the last element
		*point = seq[count - 1];

		// check if it has been excluded already (i.e. belongs to some other line)
		if (!mask[i * width + j])
			continue;

		// update accumulator, find the most probable line
		for (n = 0; n < numangle; n++, adata += numrho) {
			r = lrint(j * trigtab[n * 2] + i * trigtab[n * 2 + 1]);
			r += (numrho - 1) / 2;
			int val = ++adata[r];
			if (max_val < val) {
				max_val = val;
				max_n = n;
			}
		}

		// if it is too "weak" candidate, continue with another point
		if (max_val < threshold)
			continue;

		// from the current point walk in each direction
		// along the found line and extract the line segment
		a = -trigtab[max_n * 2 + 1];
		b = trigtab[max_n * 2];
		x0 = j;
		y0 = i;
		if (fabs(a) > fabs(b)) {
			xflag = 1;
			dx0 = a > 0 ? 1 : -1;
			dy0 = lrint(b * (1 << shift) / fabs(a));
			y0 = (y0 << shift) + (1 << (shift - 1));
		} else {
			xflag = 0;
			dy0 = b > 0 ? 1 : -1;
			dx0 = lrint(a * (1 << shift) / fabs(b));
			x0 = (x0 << shift) + (1 << (shift - 1));
		}

		for (k = 0; k < 2; k++) {
			int gap = 0, x = x0, y = y0, dx = dx0, dy = dy0;

			if (k > 0)
				dx = -dx, dy = -dy;

			// walk along the line using fixed-point arithmetics,
			// stop at the image border or in case of too big gap
			for (;; x += dx, y += dy) {
				uint8_t* mdata;
				int i1, j1;

				if (xflag) {
					j1 = x;
					i1 = y >> shift;
				} else {
					j1 = x >> shift;
					i1 = y;
				}

				if (j1 < 0 || j1 >= width || i1 < 0 || i1 >= height)
					break;

				mdata = mask + i1 * width + j1;

				// for each non-zero point:
				//    update line end,
				//    clear the mask element
				//    reset the gap
				if (*mdata) {
					gap = 0;
					line_end[k].y = i1;
					line_end[k].x = j1;
				} else if (++gap > lineGap)
					break;
			}
		}

		good_line = std::abs(line_end[1].x - line_end[0].x) >= lineLength ||
					std::abs(line_end[1].y - line_end[0].y) >= lineLength;

		for (k = 0; k < 2; k++) {
			int x = x0, y = y0, dx = dx0, dy = dy0;

			if (k > 0)
				dx = -dx, dy = -dy;

			// walk along the line using fixed-point arithmetics,
			// stop at the image border or in case of too big gap
			for (;; x += dx, y += dy) {
				uint8_t* mdata;
				int i1, j1;

				if (xflag) {
					j1 = x;
					i1 = y >> shift;
				} else {
					j1 = x >> shift;
					i1 = y;
				}

				mdata = mask + i1 * width + j1;

				// for each non-zero point:
				//    update line end,
				//    clear the mask element
				//    reset the gap
				if (*mdata) {
					if (good_line) {
						adata = accum;
						for (n = 0; n < numangle; n++, adata += numrho) {
							r = lrint(
									j1 * trigtab[n * 2]
											+ i1 * trigtab[n * 2 + 1]);
							r += (numrho - 1) / 2;
							adata[r]--;
						}
					}
					*mdata = 0;
				}

				if (i1 == line_end[k].y && j1 == line_end[k].x)
					break;
			}
		}

		if (good_line) {
			Segment seg(line_end[0].x, line_end[0].y, line_end[1].x, line_end[1].y);
			seg.setID(addedLines);
			segments.push_back(seg);
			addedLines++;

			if (addedLines >= maxSegments) {
				std::free(accum);
				std::free(mask);
				std::free(trigtab);

				return addedLines;
			}
		}
	}

	std::free(accum);
	std::free(mask);
	std::free(trigtab);

	return addedLines;
}

static inline unsigned randInt(uint64_t* rng)
{
	uint64_t temp = *rng;
	temp = (uint64_t) (unsigned) temp * 4164903690U + (temp >> 32);
	*rng = temp;
	return (unsigned) temp;
}
