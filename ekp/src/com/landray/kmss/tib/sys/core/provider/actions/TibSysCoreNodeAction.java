package com.landray.kmss.tib.sys.core.provider.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;

import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreNodeService;


/**
 * 节点信息 Action
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreNodeAction extends ExtendAction {
	protected ITibSysCoreNodeService tibSysCoreNodeService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysCoreNodeService == null)
			tibSysCoreNodeService = (ITibSysCoreNodeService)getBean("tibSysCoreNodeService");
		return tibSysCoreNodeService;
	}
}

