package com.landray.kmss.tib.sys.core.provider.vo;

public class TibSysCateVo {

	private String cateId;
	private String displayName;
	private String containKey;

	public TibSysCateVo() {
		super();
	}

	public TibSysCateVo(String cateId, String displayName, String containKey) {
		super();
		this.cateId = cateId;
		this.displayName = displayName;
		this.containKey = containKey;
	}

	public String getCateId() {
		return cateId;
	}

	public void setCateId(String cateId) {
		this.cateId = cateId;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getContainKey() {
		return containKey;
	}

	public void setContainKey(String containKey) {
		this.containKey = containKey;
	}

}
