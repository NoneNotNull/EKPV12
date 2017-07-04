package com.landray.kmss.tib.common.log.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.log.model.TibCommonLogManage;


/**
 * 日志管理 Form
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogManageForm extends ExtendForm {

	/**
	 * 操作日志保存时间
	 */
	protected Integer fdLogTime = null;
	
	/**
	 * @return 操作日志保存时间
	 */
	public Integer getFdLogTime() {
		return fdLogTime;
	}
	
	/**
	 * @param fdLogTime 操作日志保存时间
	 */
	public void setFdLogTime(Integer fdLogTime) {
		this.fdLogTime = fdLogTime;
	}
	
	/**
	 * 日志归档时间
	 */
	protected Integer fdLogLastTime = null;
	
	/**
	 * @return 日志归档时间
	 */
	public Integer getFdLogLastTime() {
		return fdLogLastTime;
	}
	
	/**
	 * @param fdLogLastTime 日志归档时间
	 */
	public void setFdLogLastTime(Integer fdLogLastTime) {
		this.fdLogLastTime = fdLogLastTime;
	}
	
	/**
	 * 日志记录级别
	 */
	protected String fdLogType = null;
	
	/**
	 * @return 日志记录级别
	 */
	public String getFdLogType() {
		return fdLogType;
	}
	
	/**
	 * @param fdLogType 日志记录级别
	 */
	public void setFdLogType(String fdLogType) {
		this.fdLogType = fdLogType;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdLogTime = null;
		fdLogLastTime = null;
		fdLogType = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonLogManage.class;
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
