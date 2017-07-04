package com.landray.kmss.km.review.model;


import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.km.review.forms.KmReviewTemplateKeywordForm;

/**
 * 创建日期 2007-Aug-30
 * @author 舒斌
 * 审批流程模板关键字
 */
public class KmReviewTemplateKeyword  extends BaseModel {


	/**
	 * 
	 */
	private static final long serialVersionUID = -4093811201740562683L;



	/*
	 * 关键字
	 */
	protected java.lang.String docKeyword;
	
	
	
	/*
	 * 审批流程模板
	 */		
	protected KmReviewTemplate	kmReviewTemplate = null;
	
	public KmReviewTemplateKeyword() {
		super();
	}
	
	

	
	public java.lang.String getDocKeyword() {
		return docKeyword;
	}




	public void setDocKeyword(java.lang.String docKeyword) {
		this.docKeyword = docKeyword;
	}




	/**
	 * @return 返回 审批流程模板
	 */	
	public KmReviewTemplate getKmReviewTemplate() {
		return kmReviewTemplate;
	}
	/**
	 * @param kmReviewTemplate 要设置的 审批流程模板
	 */
	public void setKmReviewTemplate(KmReviewTemplate kmReviewTemplate) {
		this.kmReviewTemplate = kmReviewTemplate;
	}
	public Class getFormClass() {
		return KmReviewTemplateKeywordForm.class;
	}

}
