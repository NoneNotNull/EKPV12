package com.landray.kmss.tib.sys.core.provider.vo;

public class TibSysFuncVo {

	private String funcId;
	private String displayName;
	private String containKey;

	public TibSysFuncVo() {
		super();
	}

	public TibSysFuncVo(String funcId, String displayName, String containKey) {
		super();
		this.funcId = funcId;
		this.displayName = displayName;
		this.containKey = containKey;
	}

	public String getFuncId() {
		return funcId;
	}

	public void setFuncId(String funcId) {
		this.funcId = funcId;
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
