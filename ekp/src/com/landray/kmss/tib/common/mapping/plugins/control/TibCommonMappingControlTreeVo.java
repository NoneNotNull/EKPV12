/**
 * 
 */
package com.landray.kmss.tib.common.mapping.plugins.control;

/**
 * @author qiujh
 * @version 1.0 2014-7-2
 */
public class TibCommonMappingControlTreeVo {

	private String selectId;
	private String displayName;
	private String moduleKey;

	public TibCommonMappingControlTreeVo() {
		super();
	}

	public TibCommonMappingControlTreeVo(String selectId, String displayName, String moduleKey) {
		super();
		this.selectId = selectId;
		this.displayName = displayName;
		this.moduleKey = moduleKey;
	}

	public String getSelectId() {
		return selectId;
	}

	public void setSelectId(String selectId) {
		this.selectId = selectId;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getModuleKey() {
		return moduleKey;
	}

	public void setModuleKey(String moduleKey) {
		this.moduleKey = moduleKey;
	}

}
