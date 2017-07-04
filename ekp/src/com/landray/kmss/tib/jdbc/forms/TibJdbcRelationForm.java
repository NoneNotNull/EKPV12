package com.landray.kmss.tib.jdbc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappManage;
import com.landray.kmss.tib.jdbc.model.TibJdbcRelation;
import com.landray.kmss.tib.jdbc.model.TibJdbcTaskManage;


/**
 * 映射关系 Form
 * 
 * @author 
 * @version 1.0 2013-08-13
 */
public class TibJdbcRelationForm extends ExtendForm {

	/**
	 * 用途说明
	 */
	protected String fdUseExplain = null;
	
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
	protected String fdSyncType = null;
	
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
	 * 所属映射的ID
	 */
	protected String tibJdbcMappManageId = null;
	
	/**
	 * @return 所属映射的ID
	 */
	public String getTibJdbcMappManageId() {
		return tibJdbcMappManageId;
	}
	
	/**
	 * @param tibJdbcMappManageId 所属映射的ID
	 */
	public void setTibJdbcMappManageId(String tibJdbcMappManageId) {
		this.tibJdbcMappManageId = tibJdbcMappManageId;
	}
	
	/**
	 * 所属映射的名称
	 */
	protected String tibJdbcMappManageName = null;
	
	/**
	 * @return 所属映射的名称
	 */
	public String getTibJdbcMappManageName() {
		return tibJdbcMappManageName;
	}
	
	/**
	 * @param tibJdbcMappManageName 所属映射的名称
	 */
	public void setTibJdbcMappManageName(String tibJdbcMappManageName) {
		this.tibJdbcMappManageName = tibJdbcMappManageName;
	}
	
	/**
	 * 所属任务的ID
	 */
	protected String tibJdbcTaskManageId = null;
	
	/**
	 * @return 所属任务的ID
	 */
	public String getTibJdbcTaskManageId() {
		return tibJdbcTaskManageId;
	}
	
	/**
	 * @param tibJdbcTaskManageId 所属任务的ID
	 */
	public void setTibJdbcTaskManageId(String tibJdbcTaskManageId) {
		this.tibJdbcTaskManageId = tibJdbcTaskManageId;
	}
	
	/**
	 * 所属任务的名称
	 */
	protected String tibJdbcTaskManageName = null;
	
	/**
	 * @return 所属任务的名称
	 */
	public String getTibJdbcTaskManageName() {
		return tibJdbcTaskManageName;
	}
	
	/**
	 * @param tibJdbcTaskManageName 所属任务的名称
	 */
	public void setTibJdbcTaskManageName(String tibJdbcTaskManageName) {
		this.tibJdbcTaskManageName = tibJdbcTaskManageName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdUseExplain = null;
		fdSyncType = null;
		tibJdbcMappManageId = null;
		tibJdbcMappManageName = null;
		tibJdbcTaskManageId = null;
		tibJdbcTaskManageName = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibJdbcRelation.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("tibJdbcMappManageId",
					new FormConvertor_IDToModel("tibJdbcMappManage",
						TibJdbcMappManage.class));
			toModelPropertyMap.put("tibJdbcTaskManageId",
					new FormConvertor_IDToModel("tibJdbcTaskManage",
						TibJdbcTaskManage.class));
		}
		return toModelPropertyMap;
	}
}
