package com.landray.kmss.km.review.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.km.review.model.KmReviewSn;
import com.landray.kmss.sys.right.interfaces.BaseAuthForm;


/**
 * 主文档 Form
 * 
 * @author 
 * @version 1.0 2010-11-04
 */
public class KmReviewSnForm extends BaseAuthForm {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 339616167429467853L;
	/**
	 * 流水号
	 */
	protected String fdSn = null;
	
	/**
	 * @return 流水号
	 */
	public String getFdSn() {
		return fdSn;
	}
	
	/**
	 * @param fdSn 流水号
	 */
	public void setFdSn(String fdSn) {
		this.fdSn = fdSn;
	}
	
	/**
	 * 日期
	 */
	protected String fdDate = null;
	
	/**
	 * @return 日期
	 */
	public String getFdDate() {
		return fdDate;
	}
	
	/**
	 * @param fdDate 日期
	 */
	public void setFdDate(String fdDate) {
		this.fdDate = fdDate;
	}
	
	/**
	 * 模块名
	 */
	protected String fdModelName = null;
	
	/**
	 * @return 模块名
	 */
	public String getFdModelName() {
		return fdModelName;
	}
	
	/**
	 * @param fdModelName 模块名
	 */
	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}
	
	/**
	 * 模板ID
	 */
	protected String fdTemplateId = null;
	
	/**
	 * @return 模板ID
	 */
	public String getFdTemplateId() {
		return fdTemplateId;
	}
	
	/**
	 * @param fdTemplateId 模板ID
	 */
	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdSn = null;
		fdDate = null;
		fdModelName = null;
		fdTemplateId = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmReviewSn.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
		}
		return toModelPropertyMap;
	}
}
