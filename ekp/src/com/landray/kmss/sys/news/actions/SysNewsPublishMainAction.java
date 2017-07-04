package com.landray.kmss.sys.news.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.news.service.ISysNewsPublishMainService;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超
 */
public class SysNewsPublishMainAction extends ExtendAction

{
	protected ISysNewsPublishMainService sysNewsPublishMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (sysNewsPublishMainService == null)
			sysNewsPublishMainService = (ISysNewsPublishMainService) getBean("sysNewsPublishMainService");
		return sysNewsPublishMainService;
	} 

}
