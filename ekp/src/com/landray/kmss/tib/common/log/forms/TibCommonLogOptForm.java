package com.landray.kmss.tib.common.log.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.log.model.TibCommonLogOpt;


/**
 * TIB_COMMON中间件操作日志 Form
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogOptForm extends ExtendForm {

	/**
	 * 操作人
	 */
	protected String fdPerson = null;
	
	/**
	 * @return 操作人
	 */
	public String getFdPerson() {
		return fdPerson;
	}
	
	/**
	 * @param fdPerson 操作人
	 */
	public void setFdPerson(String fdPerson) {
		this.fdPerson = fdPerson;
	}
	
	/**
	 * 操作时间
	 */
	protected String fdAlertTime = null;
	
	/**
	 * @return 操作时间
	 */
	public String getFdAlertTime() {
		return fdAlertTime;
	}
	
	/**
	 * @param fdAlertTime 操作时间
	 */
	public void setFdAlertTime(String fdAlertTime) {
		this.fdAlertTime = fdAlertTime;
	}
	
	/**
	 * 请求url
	 */
	protected String fdUrl = null;
	
	/**
	 * @return 请求url
	 */
	public String getFdUrl() {
		return fdUrl;
	}
	
	/**
	 * @param fdUrl 请求url
	 */
	public void setFdUrl(String fdUrl) {
		this.fdUrl = fdUrl;
	}
	
	/**
	 * 操作内容
	 */
	protected String fdContent = null;
	
	/**
	 * @return 操作内容
	 */
	public String getFdContent() {
		return fdContent;
	}
	
	/**
	 * @param fdContent 操作内容
	 */
	public void setFdContent(String fdContent) {
		this.fdContent = fdContent;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdPerson = null;
		fdAlertTime = null;
		fdUrl = null;
		fdContent = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonLogOpt.class;
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
