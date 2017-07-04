package com.landray.kmss.common.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

public abstract class BaseCoreInnerForm extends ExtendForm {
	/*
	 * 域模型ID
	 */
	private String fdModelId = null;

	public String getFdModelId() {
		return fdModelId;
	}

	public void setFdModelId(String fdModelId) {
		this.fdModelId = fdModelId;
	}

	/*
	 * 域模型类名
	 */
	private String fdModelName = null;

	public String getFdModelName() {
		return fdModelName;
	}

	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}

	/*
	 * 机制键值
	 */
	private String fdKey = null;

	public String getFdKey() {
		return fdKey;
	}

	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdModelId = null;
		fdModelName = null;
		fdKey = null;
		super.reset(mapping, request);
	}
}
