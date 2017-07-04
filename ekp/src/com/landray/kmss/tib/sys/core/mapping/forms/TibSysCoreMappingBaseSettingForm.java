package com.landray.kmss.tib.sys.core.mapping.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;


@SuppressWarnings("serial")
public abstract class TibSysCoreMappingBaseSettingForm  extends ExtendForm  {
	
	protected String fdType;
	
	protected String docStatus;
	protected String docSubject;
	public String getFdType() {
		return fdType;
	}
	public void setFdType(String fdType) {
		this.fdType = fdType;
	}
	public String getDocStatus() {
		return docStatus;
	}
	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
	}
	public String getDocSubject() {
		return docSubject;
	}
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
		}
		return toModelPropertyMap;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		this.fdType=null;
		this.docSubject=null;
		super.reset(mapping, request);
	}
	
	
}
