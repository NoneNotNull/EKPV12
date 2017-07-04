package com.landray.kmss.km.doc.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryPortalAction;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖
 */
public class KmDocTemplatePortletAction extends SysSimpleCategoryPortalAction {
	protected IKmDocTemplateService kmDocTemplateService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmDocTemplateService == null)
			kmDocTemplateService = (IKmDocTemplateService) getBean("kmDocTemplateService");
		return kmDocTemplateService;
	}

	@Override
	public String getHref() {
		return "/km/doc";
	}
}