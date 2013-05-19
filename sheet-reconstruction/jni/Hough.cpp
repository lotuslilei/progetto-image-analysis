#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <algorithm>

#include <vector>

#include "Hough.h"

static inline void houghSortDescent32s(int *array, size_t total, const int* aux);

int hough(	uint8_t* image, int width, int height, float rho, float theta,
		int threshold, line *lines, int linesMax)
{
	int numangle, numrho;
	int total = 0;
	float ang;
	int r, n;
	int i, j;
	float irho = 1 / rho;
	double scale;
	int step = width;

	numangle = lrint(M_PI / theta);
	numrho = lrint(((width + height) * 2 + 1) / rho);

	int *accum = (int*) std::malloc(sizeof(int) * (numangle+2) * (numrho+2));
	int *sort_buf = (int*) std::malloc(sizeof(int) * numangle * numrho);
	float *tabSin = (float*) std::malloc(sizeof(float) * numangle);
	float *tabCos = (float*) std::malloc(sizeof(float) * numangle);

	std::memset(accum, 0, sizeof(int) * (numangle+2) * (numrho+2));

	for (ang = 0, n = 0; n < numangle; ang += theta, n++) {
		tabSin[n] = (float) (sin(ang) * irho);
		tabCos[n] = (float) (cos(ang) * irho);
	}

	// stage 1. fill accumulator
	for (i = 0; i < height; i++)
		for (j = 0; j < width; j++) {
			if (image[i * step + j] != 0)
				for (n = 0; n < numangle; n++) {
					r = lrint(j*tabCos[n] + i*tabSin[n]);
					r += (numrho - 1) / 2;
					accum[(n + 1) * (numrho + 2) + r + 1]++;
				}
		}

	// stage 2. find local maximums
	for (r = 0; r < numrho; r++) {
		for (n = 0; n < numangle; n++) {
			int base = (n + 1) * (numrho + 2) + r + 1;
			if (accum[base] > threshold && accum[base] > accum[base - 1]
					&& accum[base] >= accum[base + 1]
					&& accum[base] > accum[base - numrho - 2]
					&& accum[base] >= accum[base + numrho + 2])
				sort_buf[total++] = base;
		}
	}

	// stage 3. sort the detected lines by accumulator value
	houghSortDescent32s(sort_buf, total, accum);

	// stage 4. store the first min(total,linesMax) lines to the output buffer
	linesMax = std::min(linesMax, total);

	scale = 1. / (numrho + 2);
	for (i = 0; i < linesMax; i++) {

		int idx = sort_buf[i];
		int n = floor(idx * scale) - 1;
		int r = idx - (n + 1) * (numrho + 2) - 1;
		lines[i].rho = (r - (numrho - 1)*0.5f) * rho;
		lines[i].angle = n * theta;
	}

	free(accum);
	free(sort_buf);
	free(tabSin);
	free(tabCos);

	return linesMax;
}

static inline void houghSortDescent32s(int *array, size_t total, const int* aux)
{
	int isort_thresh = 7;
	int sp = 0;
	struct {
		int *lb;
		int *ub;
	} stack[48];

	if (total <= 1)
		return;

	stack[0].lb = array;
	stack[0].ub = array + (total - 1);

	while (sp >= 0) {
		int* left = stack[sp].lb;
		int* right = stack[sp--].ub;
		for (;;) {
			int i, n = (int) (right - left) + 1, m;
			int* ptr;
			int* ptr2;
			if (n <= isort_thresh) {
				insert_sort: for (ptr = left + 1; ptr <= right; ptr++) {
					for (ptr2 = ptr; ptr2 > left && (aux[ptr2[0]] > aux[ptr2[-1]]); ptr2--)
						std::swap(ptr2[0], ptr2[-1]);
				}
				break;
			} else {
				int* left0;
				int* left1;
				int* right0;
				int* right1;
				int* pivot;
				int* a;
				int* b;
				int* c;
				int swap_cnt = 0;
				left0 = left;
				right0 = right;
				pivot = left + (n / 2);
				if (n > 40) {
					int d = n / 8;
					a = left, b = left + d, c = left + 2 * d;
					left = (aux[*a] > aux[*b]) ?
							((aux[*b] > aux[*c]) ?
									b : ((aux[*a] > aux[*c]) ? c : a)) :
							((aux[*c] > aux[*b]) ?
									b : ((aux[*a] > aux[*c]) ? a : c));
					a = pivot - d, b = pivot, c = pivot + d;
					pivot = (aux[*a] > aux[*b]) ?
							((aux[*b] > aux[*c]) ?
									b : ((aux[*a] > aux[*c]) ? c : a)) :
							((aux[*c] > aux[*b]) ?
									b : ((aux[*a] > aux[*c]) ? a : c));
					a = right - 2 * d, b = right - d, c = right;
					right = (aux[*a] > aux[*b]) ?
							((aux[*b] > aux[*c]) ?
									b : ((aux[*a] > aux[*c]) ? c : a)) :
							((aux[*c] > aux[*b]) ?
									b : ((aux[*a] > aux[*c]) ? a : c));
				}
				a = left, b = pivot, c = right;
				pivot =
						(aux[*a] > aux[*b]) ?
								((aux[*b] > aux[*c]) ?
										b : ((aux[*a] > aux[*c]) ? c : a)) :
								((aux[*c] > aux[*b]) ?
										b : ((aux[*a] > aux[*c]) ? a : c));
				if (pivot != left0) {
					std::swap(*pivot, *left0);
					pivot = left0;
				}
				left = left1 = left0 + 1;
				right = right1 = right0;
				for (;;) {
					while (left <= right && !(aux[*pivot] > aux[*left])) {
						if (!(aux[*left] > aux[*pivot])) {
							if (left > left1)
								std::swap(*left1, *left);
							swap_cnt = 1;
							left1++;
						}
						left++;
					}
					while (left <= right && !(aux[*right] > aux[*pivot])) {
						if (!(aux[*pivot] > aux[*right])) {
							if (right < right1)
								std::swap(*right1, *right);
							swap_cnt = 1;
							right1--;
						}
						right--;
					}
					if (left > right)
						break;
					std::swap(*left, *right);
					swap_cnt = 1;
					left++;
					right--;
				}
				if (swap_cnt == 0) {
					left = left0, right = right0;
					goto insert_sort;
				}
				n = std::min((int) (left1 - left0), (int) (left - left1));
				for (i = 0; i < n; i++)
					std::swap(left0[i], left[i - n]);
				n = std::min((int) (right0 - right1), (int) (right1 - right));
				for (i = 0; i < n; i++)
					std::swap(left[i], right0[i - n + 1]);
				n = (int) (left - left1);
				m = (int) (right1 - right);
				if (n > 1) {
					if (m > 1) {
						if (n > m) {
							stack[++sp].lb = left0;
							stack[sp].ub = left0 + n - 1;
							left = right0 - m + 1, right = right0;
						} else {
							stack[++sp].lb = right0 - m + 1;
							stack[sp].ub = right0;
							left = left0, right = left0 + n - 1;
						}
					} else
						left = left0, right = left0 + n - 1;
				} else if (m > 1)
					left = right0 - m + 1, right = right0;
				else
					break;
			}
		}
	}
}
