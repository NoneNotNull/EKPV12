package com.landray.kmss.tib.jdbc.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.jdbc.forms.TibJdbcRelationForm;

/**
 * 映射关系
 * 
 * @author 
 * @version 1.0 2013-08-13
 */
public class TibJdbcRelation extends BaseModel {

	/**
	 * 用途说明
	 */
	protected String fdUseExplain;
	
	/**
	 * @return 用途说明
	 */
	public String getFdUseExplain() {
		return fdUseExplain;
	}
	
	/**
	 * @param fdUseExplain 用途说明
	 */
	public void setFdUseExplain(String fdUseExplain) {
		this.fdUseExplain = fdUseExplain;
	}
	
	/**
	 * 同步方式
	 */
	protected String fdSyncType;
	
	/**
	 * @return 同步方式
	 */
	public String getFdSyncType() {
		return fdSyncType;
	}
	
	/**
	 * @param fdSyncType 同步方式
	 */
	public void setFdSyncType(String fdSyncType) {
		this.fdSyncType = fdSyncType;
	}
	
	/**
	 * 所属映射
	 */
	protected TibJdbcMappManage tibJdbcMappManage;
	
	/**
	 * @return 所属映射
	 */
	public TibJdbcMappManage getTibJdbcMappManage() {
		return tibJdbcMappManage;
	}
	
	/**
	 * @param tibJdbcMappManage 所属映射
	 */
	public void setTibJdbcMappManage(TibJdbcMappManage tibJdbcMappManage) {
		this.tibJdbcMappManage = tibJdbcMappManage;
	}
	
	/**
	 * 所属任务
	 */
	protected TibJdbcTaskManage tibJdbcTaskManage;
	
	/**
	 * @return 所属任务
	 */
	public TibJdbcTaskManage getTibJdbcTaskManage() {
		return tibJdbcTaskManage;
	}
	
	/**
	 * @param tibJdbcTaskManage 所属任务
	 */
	public void setTibJdbcTaskManage(TibJdbcTaskManage tibJdbcTaskManage) {
		this.tibJdbcTaskManage = tibJdbcTaskManage;
	}
	
	public Class getFormClass() {
		return TibJdbcRelationForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("tibJdbcMappManage.fdId", "tibJdbcMappManageId");
			toFormPropertyMap.put("tibJdbcMappManage.docSubject", "tibJdbcMappManageName");
			toFormPropertyMap.put("tibJdbcTaskManage.fdId", "tibJdbcTaskManageId");
			toFormPropertyMap.put("tibJdbcTaskManage.fdId", "tibJdbcTaskManageName");
		}
		return toFormPropertyMap;
	}
}
