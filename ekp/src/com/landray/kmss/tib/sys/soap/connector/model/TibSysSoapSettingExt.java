package com.landray.kmss.tib.sys.soap.connector.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapSettingExtForm;

/**
 * WEBSERVICE服务配置扩展
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingExt extends BaseModel {

	/**
	 * 扩展配置名字
	 */
	protected String fdWsExtName;
	
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
	protected String fdWsExtValue;
	
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
	 * WEBSERVICE服务配置
	 */
	protected TibSysSoapSetting fdServer;
	
	/**
	 * @return WEBSERVICE服务配置
	 */
	public TibSysSoapSetting getFdServer() {
		return fdServer;
	}
	
	/**
	 * @param fdServer WEBSERVICE服务配置
	 */
	public void setFdServer(TibSysSoapSetting fdServer) {
		this.fdServer = fdServer;
	}
	
	public Class getFormClass() {
		return TibSysSoapSettingExtForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdServer.fdId", "fdServerId");
			toFormPropertyMap.put("fdServer.docSubject", "fdServerName");
		}
		return toFormPropertyMap;
	}
}
