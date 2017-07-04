package com.landray.kmss.tib.common.log.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.log.service.ITibCommonLogOptService;


/**
 * TIB_COMMON中间件操作日志 Action
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogOptAction extends ExtendAction {
	protected ITibCommonLogOptService tibCommonLogOptService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibCommonLogOptService == null)
			tibCommonLogOptService = (ITibCommonLogOptService)getBean("tibCommonLogOptService");
		return tibCommonLogOptService;
	}
}

