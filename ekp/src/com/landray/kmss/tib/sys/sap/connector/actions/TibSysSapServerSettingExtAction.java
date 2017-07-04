package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapServerSettingExtService;


/**
 * tibSysSap服务器扩展配置 Action
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapServerSettingExtAction extends ExtendAction {
	protected ITibSysSapServerSettingExtService tibSysSapServerSettingExtService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysSapServerSettingExtService == null)
			tibSysSapServerSettingExtService = (ITibSysSapServerSettingExtService)getBean("tibSysSapServerSettingExtService");
		return tibSysSapServerSettingExtService;
	}
}

