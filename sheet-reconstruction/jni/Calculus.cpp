#include "Calculus.h"

#include <algorithm>
#include <cmath>

#include <stdint.h>

static int LUDecomp(float *A, size_t astep, int m, float *b, size_t bstep, int n);

bool solve32f(float *src, float *src2, float *dst, int elems)
{
	memcpy(dst, src2, 8*sizeof(float));
	return LUDecomp((float*)src, elems, elems, dst, 1, 1) != 0;
}

static int LUDecomp(float *A, size_t astep, int m, float *b, size_t bstep, int n) {

	int i, j, k, p = 1;

	for (i = 0; i < m; i++) {
		k = i;

		for (j = i + 1; j < m; j++)
			if (std::abs(A[j * astep + i]) > std::abs(A[k * astep + i]))
				k = j;

		if (std::abs(A[k * astep + i]) < __FLT_EPSILON__)
			return 0;

		if (k != i) {
			for (j = i; j < m; j++)
				std::swap(A[i * astep + j], A[k * astep + j]);
			if (b)
				for (j = 0; j < n; j++)
					std::swap(b[i * bstep + j], b[k * bstep + j]);
			p = -p;
		}

		float d = -1 / A[i * astep + i];

		for (j = i + 1; j < m; j++) {
			float alpha = A[j * astep + i] * d;

			for (k = i + 1; k < m; k++)
				A[j * astep + k] += alpha * A[i * astep + k];

			if (b)
				for (k = 0; k < n; k++)
					b[j * bstep + k] += alpha * b[i * bstep + k];
		}

		A[i * astep + i] = -d;
	}

	if (b) {
		for (i = m - 1; i >= 0; i--)
			for (j = 0; j < n; j++) {
				float s = b[i * bstep + j];
				for (k = i + 1; k < m; k++)
					s -= A[i * astep + k] * b[k * bstep + j];
				b[i * bstep + j] = s * A[i * astep + i];
			}
	}

	return p;
}
