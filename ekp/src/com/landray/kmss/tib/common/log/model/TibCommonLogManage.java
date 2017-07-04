package com.landray.kmss.tib.common.log.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.log.forms.TibCommonLogManageForm;

/**
 * 日志管理
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogManage extends BaseModel {

	/**
	 * 操作日志保存时间
	 */
	protected Integer fdLogTime;
	
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
	protected Integer fdLogLastTime;
	
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
	protected Integer fdLogType;
	
	/**
	 * @return 日志记录级别
	 */
	public Integer getFdLogType() {
		return fdLogType;
	}
	
	/**
	 * @param fdLogType 日志记录级别
	 */
	public void setFdLogType(Integer fdLogType) {
		this.fdLogType = fdLogType;
	}
	
	public Class getFormClass() {
		return TibCommonLogManageForm.class;
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
