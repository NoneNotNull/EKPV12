
package com.landray.kmss.sys.news.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.news.service.ISysNewsPublishCategoryService;


/**
 * 创建日期 2009-八月-02
 * @author 周超
 */
public class SysNewsPublishCategoryAction extends ExtendAction

{
	protected ISysNewsPublishCategoryService sysNewsPublishCategoryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(sysNewsPublishCategoryService == null)
			sysNewsPublishCategoryService = (ISysNewsPublishCategoryService)getBean("sysNewsPublishCategoryService");
		return sysNewsPublishCategoryService;
	}
}

