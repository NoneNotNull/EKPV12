package com.landray.kmss.tib.sys.core.test;

public class ApplicationVo {
	
	private String bundle;
	private String path;
	private String jsTitle;
	
	public ApplicationVo(String bundle, String path, String jsTitle) {
		super();
		this.bundle = bundle;
		this.path = path;
		this.jsTitle = jsTitle;
	}
	public String getBundle() {
		return bundle;
	}
	public void setBundle(String bundle) {
		this.bundle = bundle;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getJsTitle() {
		return jsTitle;
	}
	public void setJsTitle(String jsTitle) {
		this.jsTitle = jsTitle;
	}
	
	

}
