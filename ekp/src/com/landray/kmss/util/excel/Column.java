package com.landray.kmss.util.excel;



public class Column {
	private String title; // 列标题
	private String titleKey; // 列标题资源Key值
	private String bundle; // 列标题资源bundle
	private KmssFormat format; // 对应的Format对象
	private boolean redFont; // 是否标红
	
	public String getBundle() {
		return bundle;
	}
	
	public void setBundle(String bundle) {
		this.bundle = bundle;
	}
	
	public KmssFormat getFormat() {
		return format;
	}
	
	public void setFormat(KmssFormat format) {
		this.format = format;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitleKey() {
		return titleKey;
	}
	
	public void setTitleKey(String titleKey) {
		this.titleKey = titleKey;
	}

	public boolean isRedFont() {
		return redFont;
	}

	public void setRedFont(boolean redFont) {
		this.redFont = redFont;
	}
}
