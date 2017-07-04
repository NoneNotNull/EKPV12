package com.landray.kmss.sys.news.service.spring;

import com.landray.kmss.common.service.BaseTemplateTreeService;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.news.service.ISysNewsTemplateService;

public class SysNewsTemplateTreeService extends BaseTemplateTreeService {

	private ISysNewsTemplateService sysNewsTemplateService;

	public ISysNewsTemplateService getSysNewsTemplateService() {
		return sysNewsTemplateService;
	}

	public void setSysNewsTemplateService(
			ISysNewsTemplateService sysNewsTemplateService) {
		this.sysNewsTemplateService = sysNewsTemplateService;
	}

	protected IBaseService getServiceImp() {
		return sysNewsTemplateService;
	}

}
