package com.landray.kmss.tib.sys.sap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapServerSetting;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapServerSettingExt;


/**
 * tibSysSap服务器扩展配置 Form
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapServerSettingExtForm extends ExtendForm {

	/**
	 * 扩展参数名
	 */
	protected String fdExtName = null;
	
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
	protected String fdExtValue = null;
	
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
		this.fdExtValue = fdExtValue.trim();
	}
	
	/**
	 * 所属服务器的ID
	 */
	protected String fdServerId = null;
	
	/**
	 * @return 所属服务器的ID
	 */
	public String getFdServerId() {
		return fdServerId;
	}
	
	/**
	 * @param fdServerId 所属服务器的ID
	 */
	public void setFdServerId(String fdServerId) {
		this.fdServerId = fdServerId;
	}
	
	/**
	 * 所属服务器的名称
	 */
	protected String fdServerName = null;
	
	/**
	 * @return 所属服务器的名称
	 */
	public String getFdServerName() {
		return fdServerName;
	}
	
	/**
	 * @param fdServerName 所属服务器的名称
	 */
	public void setFdServerName(String fdServerName) {
		this.fdServerName = fdServerName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdExtName = null;
		fdExtValue = null;
		fdServerId = null;
		fdServerName = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSapServerSettingExt.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdServerId",
					new FormConvertor_IDToModel("fdServer",
						TibSysSapServerSetting.class));
		}
		return toModelPropertyMap;
	}
}
