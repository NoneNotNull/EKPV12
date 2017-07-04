package com.landray.kmss.tib.sys.soap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettingExt;


/**
 * WEBSERVICE服务配置扩展 Form
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingExtForm extends ExtendForm {

	/**
	 * 扩展配置名字
	 */
	protected String fdWsExtName = null;
	
	/**
	 * @return 扩展配置名字
	 */
	public String getFdWsExtName() {
		return fdWsExtName;
	}
	
	/**
	 * @param fdWsExtName 扩展配置名字
	 */
	public void setFdWsExtName(String fdWsExtName) {
		this.fdWsExtName = fdWsExtName;
	}
	
	/**
	 * 扩展配置内容
	 */
	protected String fdWsExtValue = null;
	
	/**
	 * @return 扩展配置内容
	 */
	public String getFdWsExtValue() {
		return fdWsExtValue;
	}
	
	/**
	 * @param fdWsExtValue 扩展配置内容
	 */
	public void setFdWsExtValue(String fdWsExtValue) {
		this.fdWsExtValue = fdWsExtValue;
	}
	
	/**
	 * WEBSERVICE服务配置的ID
	 */
	protected String fdServerId = null;
	
	/**
	 * @return WEBSERVICE服务配置的ID
	 */
	public String getFdServerId() {
		return fdServerId;
	}
	
	/**
	 * @param fdServerId WEBSERVICE服务配置的ID
	 */
	public void setFdServerId(String fdServerId) {
		this.fdServerId = fdServerId;
	}
	
	/**
	 * WEBSERVICE服务配置的名称
	 */
	protected String fdServerName = null;
	
	/**
	 * @return WEBSERVICE服务配置的名称
	 */
	public String getFdServerName() {
		return fdServerName;
	}
	
	/**
	 * @param fdServerName WEBSERVICE服务配置的名称
	 */
	public void setFdServerName(String fdServerName) {
		this.fdServerName = fdServerName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdWsExtName = null;
		fdWsExtValue = null;
		fdServerId = null;
		fdServerName = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSoapSettingExt.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdServerId",
					new FormConvertor_IDToModel("fdServer",
						TibSysSoapSetting.class));
		}
		return toModelPropertyMap;
	}
}
