package me.unphoto.imagetests;

public enum ProcessingFilter {
	NULLFILTER(-1, "sameimage"),
	MEDIAN3x3(0, "median3x3"),
	GAUSS3x3(1, "gauss3x3"),
	GAUSS11x11(2, "gauss11x11"),
	SOBEL3x3(3, "sobel3x3"),
	CANNY3x3(4, "canny3x3"),
	ERODE3x3(5, "erode3x3"),
	THRESHOLD(6, "threshold"),
	DILATE3x3(7, "dilate3x3");

	/**
	 * Code of the filter, used by the native code to identify the filter.
	 */
	private int code;

	private String filterName;

	private ProcessingFilter(int code, String filterName) {
		this.code = code;
		this.filterName = filterName;
	}

	public int getCode() {
		return code;
	}

	public String getFilterName() {
		return filterName;
	}
}
