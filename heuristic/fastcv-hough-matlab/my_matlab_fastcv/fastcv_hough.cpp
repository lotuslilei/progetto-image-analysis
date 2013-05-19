#include <math.h>
#include <unistd.h>

#include <matrix.h>
#include <mex.h>

#include <vector>

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#define	FILEPATH_MAXLENGTH	512

using namespace cv;
using namespace std;

const char fastcvHoughErrorID[] = "FastCV:fastcv_hough:nrhs";

const char fastcvHoughErrorMessage[] =
	"fastcv_hough needs exactly 6 parameters\n" \
	"lowCannyThreshold, highCannyThreshold, houghThreshold, minLineLength, maxLineGap\n"
;
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	Mat sourceImage, cannyImage, bwImage, houghImage;
	vector<Vec4i> lines;
	char filePath[FILEPATH_MAXLENGTH];

	if(nrhs != 6) {
		mexErrMsgIdAndTxt(fastcvHoughErrorID, fastcvHoughErrorMessage);
	}

	char *currentDirectory = get_current_dir_name();
	int buflen = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;
	char *filename = (char*) mxCalloc(buflen, sizeof(char));
	mxGetString(prhs[0], filename, buflen);

	snprintf(filePath, FILEPATH_MAXLENGTH, "%s/%s", currentDirectory, filename);

	int lowCannyThreshold = mxGetScalar(prhs[1]);
	int highCannyThreshold = mxGetScalar(prhs[2]);
	int houghThreshold =  mxGetScalar(prhs[3]);
	int minLineLength =  mxGetScalar(prhs[4]);
	int maxLineGap = mxGetScalar(prhs[5]);

	sourceImage = imread(filePath, 0);

	free(currentDirectory);
	mxFree(filename);

	Canny(sourceImage, cannyImage, lowCannyThreshold, highCannyThreshold);
	cvtColor(cannyImage, bwImage, CV_GRAY2BGR);

	HoughLinesP(cannyImage, lines, 1, CV_PI/360, houghThreshold, minLineLength,  maxLineGap);

	double *outMatrix;
	int num_lines = lines.size();
	plhs[0] = mxCreateDoubleMatrix(num_lines,4,mxREAL);
	outMatrix = mxGetPr(plhs[0]);

	for(int i = 0; i < num_lines; i++) {
                outMatrix[num_lines*0 + i] = lines[i][0];
                outMatrix[num_lines*1 + i] = lines[i][1];
                outMatrix[num_lines*2 + i] = lines[i][2];
                outMatrix[num_lines*3 + i] = lines[i][3];
        }
}
