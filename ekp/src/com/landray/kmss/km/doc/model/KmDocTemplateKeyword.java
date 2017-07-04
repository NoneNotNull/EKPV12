package com.landray.kmss.km.doc.model;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖 模板关键字
 */
public class KmDocTemplateKeyword extends BaseModel {
	public KmDocTemplateKeyword() {
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
	protected KmDocTemplate kmDocTemplate = null;

	public KmDocTemplate getKmDocTemplate() {
		return kmDocTemplate;
	}

	public void setKmDocTemplate(KmDocTemplate kmDocTemplate) {
		this.kmDocTemplate = kmDocTemplate;
	}

	public Class getFormClass() {
		return null;
	}
}
