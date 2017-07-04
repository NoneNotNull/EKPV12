package com.landray.kmss.tib.common.mapping.plugins;

/**
 * @author zhangwt 用于存储分页信息
 */
public class TibCommonPageInfo {
	public TibCommonPageInfo() {

	}

	private int pageno;
	private int rowsize;
	private String ordertype;
	private String orderby;

	public int getPageno() {
		return pageno;
	}

	public void setPageno(int pageno) {
		this.pageno = pageno;
	}

	public int getRowsize() {
		return rowsize;
	}

	public void setRowsize(int rowsize) {
		this.rowsize = rowsize;
	}

	public String getOrdertype() {
		return ordertype;
	}

	public void setOrdertype(String ordertype) {
		this.ordertype = ordertype;
	}

	public String getOrderby() {
		return orderby;
	}

	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}
}
