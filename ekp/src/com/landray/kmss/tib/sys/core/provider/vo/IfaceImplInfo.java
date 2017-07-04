package com.landray.kmss.tib.sys.core.provider.vo;

public class IfaceImplInfo {
	private String fdName;    		// 实现名称
	private String fdOrderBy; 		// 实现执行顺序
	private String fdKey;			// Key值(仅在定制实现中存在不同)
	private String fdRefFuncType;	// 实现关联类型
	private String fdRefFuncName;	// 关联函数名称
	
	public String getFdName() {
		return fdName;
	}
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	public String getFdOrderBy() {
		return fdOrderBy;
	}
	public void setFdOrderBy(String fdOrderBy) {
		this.fdOrderBy = fdOrderBy;
	}
	public String getFdKey() {
		return fdKey;
	}
	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}
	public String getFdRefFuncType() {
		return fdRefFuncType;
	}
	public void setFdRefFuncType(String fdRefFuncType) {
		this.fdRefFuncType = fdRefFuncType;
	}
	public String getFdRefFuncName() {
		return fdRefFuncName;
	}
	public void setFdRefFuncName(String fdRefFuncName) {
		this.fdRefFuncName = fdRefFuncName;
	}
}
