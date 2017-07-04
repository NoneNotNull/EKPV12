package com.landray.kmss.tib.common.log.model;

import java.util.Date;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.log.forms.TibCommonLogOptForm;

/**
 * TIB_COMMON中间件操作日志
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
@SuppressWarnings("serial")
public class TibCommonLogOpt extends BaseModel implements InterceptFieldEnabled {

	/**
	 * 操作人
	 */
	protected String fdPerson;
	
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
	protected Date fdAlertTime;
	
	/**
	 * @return 操作时间
	 */
	public Date getFdAlertTime() {
		return fdAlertTime;
	}
	
	/**
	 * @param fdAlertTime 操作时间
	 */
	public void setFdAlertTime(Date fdAlertTime) {
		this.fdAlertTime = fdAlertTime;
	}
	
	/**
	 * 请求url
	 */
	protected String fdUrl;
	
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
	protected String fdContent;
	
	/**
	 * @return 操作内容
	 */
	public String getFdContent() {
		return (String) readLazyField("fdContent", fdContent);
	}
	
	/**
	 * @param fdContent 操作内容
	 */
	public void setFdContent(String fdContent) {
		this.fdContent = (String) writeLazyField("fdContent",
				this.fdContent, fdContent);
	}

	public Class getFormClass() {
		return TibCommonLogOptForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
		}
		return toFormPropertyMap;
	}
}
