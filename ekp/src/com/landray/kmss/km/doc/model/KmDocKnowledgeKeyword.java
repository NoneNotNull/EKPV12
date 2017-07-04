package com.landray.kmss.km.doc.model;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖 知识文档关键字
 */
public class KmDocKnowledgeKeyword extends BaseModel {

	public KmDocKnowledgeKeyword() {
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
	protected KmDocKnowledge kmDocKnowledge = null;

	public KmDocKnowledge getKmDocKnowledge() {
		return kmDocKnowledge;
	}

	public void setKmDocKnowledge(KmDocKnowledge kmDocKnowledge) {
		this.kmDocKnowledge = kmDocKnowledge;
	}

	public Class getFormClass() {
		return null;
	}
}
