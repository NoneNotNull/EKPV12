package com.landray.kmss.util.chart;

public class ChartItem {
	private String columnKey; // 项目列标签
	private String rowKey = ""; // 项目行标签
	private double value; // 项目值
	public String getColumnKey() {
		if (columnKey == null) columnKey = "";
		return columnKey;
	}
	public void setColumnKey(String columnKey) {
		this.columnKey = columnKey;
	}
	public String getRowKey() {
		return rowKey;
	}
	public void setRowKey(String rowKey) {
		this.rowKey = rowKey;
	}
	public double getValue() {
		return value;
	}
	public void setValue(double value) {
		this.value = value;
	}
	
}
