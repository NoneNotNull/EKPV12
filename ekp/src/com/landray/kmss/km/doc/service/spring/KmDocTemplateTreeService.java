package com.landray.kmss.km.doc.service.spring;

import com.landray.kmss.common.service.BaseTemplateTreeService;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;

/**
 * @author 王晖
 * 
 * 模板树菜单
 */
public class KmDocTemplateTreeService extends BaseTemplateTreeService {
	private IKmDocTemplateService kmDocTemplateService;

	public void setKmDocTemplateService(
			IKmDocTemplateService kmDocTemplateService) {
		this.kmDocTemplateService = kmDocTemplateService;
	}

	protected IBaseService getServiceImp() {
		return kmDocTemplateService;
	}

}
