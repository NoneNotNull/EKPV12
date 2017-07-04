package com.landray.kmss.spi.query;

public class QueryOrder { 

	private String filed;
	private boolean desc;

	public QueryOrder(String filed, boolean desc) {
		this.filed = filed;
		this.desc = desc;
	}

	public String getFiled() {
		return filed;
	}

	public void setFiled(String filed) {
		this.filed = filed;
	}

	public boolean isDesc() {
		return desc;
	}

	public void setDesc(boolean desc) {
		this.desc = desc;
	}
}
