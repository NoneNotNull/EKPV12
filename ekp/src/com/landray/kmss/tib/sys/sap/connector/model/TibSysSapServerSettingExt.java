package com.landray.kmss.tib.sys.sap.connector.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapServerSettingExtForm;

/**
 * tibSysSap服务器扩展配置
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapServerSettingExt extends BaseModel {

	/**
	 * 扩展参数名
	 */
	protected String fdExtName;
	
	/**
	 * @return 扩展参数名
	 */
	public String getFdExtName() {
		return fdExtName;
	}
	
	/**
	 * @param fdExtName 扩展参数名
	 */
	public void setFdExtName(String fdExtName) {
		this.fdExtName = fdExtName;
	}
	
	/**
	 * 扩展参数值
	 */
	protected String fdExtValue;
	
	/**
	 * @return 扩展参数值
	 */
	public String getFdExtValue() {
		return fdExtValue;
	}
	
	/**
	 * @param fdExtValue 扩展参数值
	 */
	public void setFdExtValue(String fdExtValue) {
		this.fdExtValue = fdExtValue;
	}
	
	/**
	 * 所属服务器
	 */
	protected TibSysSapServerSetting fdServer;
	
	/**
	 * @return 所属服务器
	 */
	public TibSysSapServerSetting getFdServer() {
		return fdServer;
	}
	
	/**
	 * @param fdServer 所属服务器
	 */
	public void setFdServer(TibSysSapServerSetting fdServer) {
		this.fdServer = fdServer;
	}
	
	public Class getFormClass() {
		return TibSysSapServerSettingExtForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdServer.fdId", "fdServerId");
			toFormPropertyMap.put("fdServer.fdServerCode", "fdServerName");
		}
		return toFormPropertyMap;
	}
}
