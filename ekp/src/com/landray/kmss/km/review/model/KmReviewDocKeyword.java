package com.landray.kmss.km.review.model;


import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.km.review.forms.KmReviewDocKeywordForm;

/**
 * 创建日期 2007-Aug-30
 * @author 舒斌
 * 审批流程文档关键字
 */
public class KmReviewDocKeyword  extends BaseModel {


	/**
	 * 
	 */
	private static final long serialVersionUID = 7498751267518682141L;



	/*
	 * 关键字
	 */
	protected java.lang.String docKeyword;
	
	
	
	/*
	 * 审批文档基本信息
	 */		
	protected KmReviewMain	kmReviewMain = null;
	
	public KmReviewDocKeyword() {
		super();
	}
	
	
	public java.lang.String getDocKeyword() {
		return docKeyword;
	}


	public void setDocKeyword(java.lang.String docKeyword) {
		this.docKeyword = docKeyword;
	}


	/**
	 * @return 返回 审批文档基本信息
	 */	
	public KmReviewMain getKmReviewMain() {
		return kmReviewMain;
	}
	/**
	 * @param kmReviewMain 要设置的 审批文档基本信息
	 */
	public void setKmReviewMain(KmReviewMain kmReviewMain) {
		this.kmReviewMain = kmReviewMain;
	}
	public Class getFormClass() {
		return KmReviewDocKeywordForm.class;
	}


}
