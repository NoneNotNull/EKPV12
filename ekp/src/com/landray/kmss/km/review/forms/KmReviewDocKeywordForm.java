package com.landray.kmss.km.review.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.forms.BaseForm;
import com.landray.kmss.km.review.model.KmReviewDocKeyword;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌
 */
public class KmReviewDocKeywordForm extends BaseForm 

{
	/**
	 * 
	 */
	private static final long serialVersionUID = -8513992662006989840L;

	/*
	 * 对象ID
	 */
	private String fdObjectId = null;

	/*
	 * 关键字
	 */
	private String docKeyword = null;



	/**
	 * @return 返回 对象ID
	 */
	public String getFdObjectId() {
		return fdObjectId;
	}

	/**
	 * @param fdObjectId
	 *            要设置的 对象ID
	 */
	public void setFdObjectId(String fdObjectId) {
		this.fdObjectId = fdObjectId;
	}
	
	

	public String getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(String docKeyword) {
		this.docKeyword = docKeyword;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see org.apache.struts.action.ActionForm#reset(org.apache.struts.action.ActionMapping,
	 *      javax.servlet.http.HttpServletRequest)
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdObjectId = null;
		docKeyword = null;
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmReviewDocKeyword.class;
	}

}
