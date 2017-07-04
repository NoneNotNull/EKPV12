package com.landray.kmss.util.chart;

import java.awt.Font;

public class ChartConfig {
	private int width; // 图表宽度（像素值）
	private int high; // 图表高度（像素值）
	private boolean createLegend; // 是否创建图例
	private int chartType; // 图表类型
	private String chartTitle; // 图表标题
	private String rowTitle; // 横座标标题
	private String columnTitle; // 纵座标标题
	private Font chartTitleFont = new Font(null, Font.BOLD, 20); // 图表标题字体 java.awt.Font类型
	private Font chartLabelFont = new Font(null, Font.PLAIN, 12); // 图表标签字体 java.awt.Font类型
	private Font axisTitleFont = new Font(null, Font.PLAIN, 14); // 座标轴标题字体 java.awt.Font类型
	private Font axisLabelFont = new Font(null, Font.PLAIN, 12); // 座标轴标签字体 java.awt.Font类型
	private boolean isCategoryLabelIncline = false;
	
	public int getChartType() {
		return chartType;
	}
	public void setChartType(int chartType) {
		this.chartType = chartType;
	}
	public boolean isCreateLegend() {
		return createLegend;
	}
	public void setCreateLegend(boolean createLegend) {
		this.createLegend = createLegend;
	}
	public int getHigh() {
		return high;
	}
	public void setHigh(int high) {
		this.high = high;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public String getChartTitle() {
		return chartTitle;
	}
	public void setChartTitle(String chartTitle) {
		this.chartTitle = chartTitle;
	}
	public String getColumnTitle() {
		return columnTitle;
	}
	public void setColumnTitle(String columnTitle) {
		this.columnTitle = columnTitle;
	}
	public String getRowTitle() {
		return rowTitle;
	}
	public void setRowTitle(String rowTitle) {
		this.rowTitle = rowTitle;
	}
	public Font getAxisTitleFont() {
		return axisTitleFont;
	}
	public void setAxisTitleFont(Font axisFont) {
		this.axisTitleFont = axisFont;
	}
	public Font getChartLabelFont() {
		return chartLabelFont;
	}
	public void setChartLabelFont(Font labelFont) {
		this.chartLabelFont = labelFont;
	}
	public Font getChartTitleFont() {
		return chartTitleFont;
	}
	public void setChartTitleFont(Font titleFont) {
		this.chartTitleFont = titleFont;
	}
	public Font getAxisLabelFont() {
		return axisLabelFont;
	}
	public void setAxisLabelFont(Font axisLabelFont) {
		this.axisLabelFont = axisLabelFont;
	}
	public boolean isCategoryLabelIncline() {
		return isCategoryLabelIncline;
	}
	public void setCategoryLabelIncline(boolean isCategoryLabelIncline) {
		this.isCategoryLabelIncline = isCategoryLabelIncline;
	}
	
}
