package com.landray.kmss.kms.multidoc.model;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖 知识文档关键字
 */
public class KmsMultidocKnowledgeKeyword extends BaseModel {

	public KmsMultidocKnowledgeKeyword() {
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
	 * 知识文档信息
	 */
	protected KmsMultidocKnowledge kmsMultidocKnowledge = null;

	public KmsMultidocKnowledge getKmsMultidocKnowledge() {
		return kmsMultidocKnowledge;
	}

	public void setKmsMultidocKnowledge(
			KmsMultidocKnowledge kmsMultidocKnowledge) {
		this.kmsMultidocKnowledge = kmsMultidocKnowledge;
	}

	public Class getFormClass() {
		return null;
	}

	public String getDocSubject() {
		return null;
	}
}
