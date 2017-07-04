package com.landray.kmss.kms.multidoc.model;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖 模板关键字
 */
public class KmsMultidocTemplateKeyword extends BaseModel {
	public KmsMultidocTemplateKeyword() {
		super();
	}

	/*
	 * 关键字
	 */
	protected java.lang.String docKeyword;

	public java.lang.String getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(java.lang.String docKeyword) {
		this.docKeyword = docKeyword;
	}

	/*
	 * 模板设置
	 */
	protected KmsMultidocTemplate kmsMultidocTemplate = null;

	public KmsMultidocTemplate getKmsMultidocTemplate() {
		return kmsMultidocTemplate;
	}

	public void setKmsMultidocTemplate(KmsMultidocTemplate kmsMultidocTemplate) {
		this.kmsMultidocTemplate = kmsMultidocTemplate;
	}

	public Class getFormClass() {
		return null;
	}

	public String getDocSubject() {
		return null;
	}
}
