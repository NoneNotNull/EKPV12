package com.landray.kmss.tib.sys.core.mapping.model;

import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;


public class TibSysCoreMappingBaseSettingModel  extends BaseModel  {
	
	private static final long serialVersionUID = 1L;

	static {
		ModelConvertor_Common.addCacheClass(TibSysCoreMappingBaseSettingModel.class);
	}
	
	private String fdType;
	
	protected String docStatus;
	protected String docSubject;

	public Class getFormClass() {
		return null;
	}
	
	private static ModelToFormPropertyMap toFormPropertyMap;
	

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

	
	
	
	
}
