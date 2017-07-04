package com.landray.kmss.tib.common.log.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainBackupService;


/**
 * TIB_COMMON日志管理归档 Action
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogMainBackupAction extends ExtendAction {
	protected ITibCommonLogMainBackupService tibCommonLogMainBackupService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibCommonLogMainBackupService == null)
			tibCommonLogMainBackupService = (ITibCommonLogMainBackupService)getBean("tibCommonLogMainBackupService");
		return tibCommonLogMainBackupService;
	}
}

