package com.landray.kmss.tib.sys.core.provider.vo;

public class IfaceInfo {
	private String fdName;		// 接口名称
	private String fdKey;		// 接口关键字
	private String fdType;		// 接口类型，1：定制组件（此类组件由初始化导入，不可修改接口
	private String fdInXml;		// 接口传入模板
	private String fdNote;		// 接口说明
	private String fdIfaceTags;	// 接口分类（接口关联标签，多个用半角分号隔开）
	private String fdInfoExt;	// 接口扩展信息(json格式)
	private boolean fdIfaceControl;     	// 是否允许前台控制
	private String fdControlPattern;     	// 调度模式
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
	public String getFdInXml() {
		return fdInXml;
	}
	public void setFdInXml(String fdInXml) {
		this.fdInXml = fdInXml;
	}
	public String getFdNote() {
		return fdNote;
	}
	public void setFdNote(String fdNote) {
		this.fdNote = fdNote;
	}
	public String getFdIfaceTags() {
		return fdIfaceTags;
	}
	public void setFdIfaceTags(String fdIfaceTags) {
		this.fdIfaceTags = fdIfaceTags;
	}
	public String getFdInfoExt() {
		return fdInfoExt;
	}
	public void setFdInfoExt(String fdInfoExt) {
		this.fdInfoExt = fdInfoExt;
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
	public IfaceInfo(String fdName, String fdKey, String fdType, 
			String fdInXml, String fdNote, String fdIfaceTags, String fdInfoExt, 
			boolean fdIfaceControl, String fdControlPattern) {
		super();
		this.fdName = fdName;
		this.fdKey = fdKey;
		this.fdType = fdType;
		this.fdInXml = fdInXml;
		this.fdNote = fdNote;
		this.fdIfaceTags = fdIfaceTags;
		this.fdInfoExt = fdInfoExt;
		this.fdIfaceControl = fdIfaceControl;
		this.fdControlPattern = fdControlPattern;
	}
	public IfaceInfo(String fdName, String fdKey, String fdType,
			String fdNote, String fdIfaceTags, String fdInfoExt, String fdControlPattern) {
		super();
		this.fdName = fdName;
		this.fdKey = fdKey;
		this.fdType = fdType;
		this.fdNote = fdNote;
		this.fdIfaceTags = fdIfaceTags;
		this.fdInfoExt = fdInfoExt;
		this.fdControlPattern = fdControlPattern;
	}
	public IfaceInfo() {
		super();
	}
	
}
