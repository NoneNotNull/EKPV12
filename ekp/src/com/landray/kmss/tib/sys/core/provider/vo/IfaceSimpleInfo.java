package com.landray.kmss.tib.sys.core.provider.vo;

public class IfaceSimpleInfo {
	private String fdName;				// 接口名称
	private String fdKey;				// 接口关键字
	private String fdType;				// 接口类型，1：定制组件（此类组件由初始化导入，不可修改接口
	private boolean fdIfaceControl;		// 接口前台控制
	private String fdControlPattern;	// 接口调度模式
	public String getFdName() {
		return fdName;
	}
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	public String getFdKey() {
		return fdKey;
	}
	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}
	public String getFdType() {
		return fdType;
	}
	public void setFdType(String fdType) {
		this.fdType = fdType;
	}
	public boolean isFdIfaceControl() {
		return fdIfaceControl;
	}
	public void setFdIfaceControl(boolean fdIfaceControl) {
		this.fdIfaceControl = fdIfaceControl;
	}
	public String getFdControlPattern() {
		return fdControlPattern;
	}
	public void setFdControlPattern(String fdControlPattern) {
		this.fdControlPattern = fdControlPattern;
	}
	public IfaceSimpleInfo(String fdName, String fdKey, String fdType,
			boolean fdIfaceControl, String fdControlPattern) {
		super();
		this.fdName = fdName;
		this.fdKey = fdKey;
		this.fdType = fdType;
		this.fdIfaceControl = fdIfaceControl;
		this.fdControlPattern = fdControlPattern;
	}

}
