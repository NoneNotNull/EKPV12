package com.landray.kmss.tib.sys.soap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingExtService;


/**
 * WEBSERVICE服务配置扩展 Action
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingExtAction extends ExtendAction {
	protected ITibSysSoapSettingExtService TibSysSoapSettingExtService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(TibSysSoapSettingExtService == null)
			TibSysSoapSettingExtService = (ITibSysSoapSettingExtService)getBean("tibSysSoapSettingExtService");
		return TibSysSoapSettingExtService;
	}
}

