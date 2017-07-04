package com.landray.kmss.util.chart;

import java.awt.Font;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

public interface ChartOutput
{
	Font CHART_TITLE_FONT = new Font(null, Font.PLAIN, 20);
	Font CHART_LABEL_FONT = new Font(null, Font.PLAIN, 12);
	Font AXIS_TITLE_FONT = new Font(null, Font.PLAIN, 16);
	Font AXIS_LABEL_FONT = new Font(null, Font.PLAIN, 12);

	/**
	 * 简单型曲线图
	 */
	int TYPE_LINE = 1;
	/**
	 * 简单型柱状图
	 */
	int TYPE_BAR = 2;
	/**
	 * 简单型饼图
	 */
	int TYPE_PIE = 3;
	/** 面积图 */
	int TYPE_AREA = 4;

	public void output(OutputStream stream, List dataList, ChartConfig config)
			throws IOException;

	public void output(HttpServletResponse response, List dataList, ChartConfig config)
			throws IOException;
}
