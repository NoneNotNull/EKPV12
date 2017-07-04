package com.landray.kmss.kms.multidoc.service.spring;

import com.landray.kmss.common.service.BaseTemplateTreeService;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;

/**
 * @author 王晖
 * 
 * 模板树菜单
 */
public class KmsMultidocTemplateTreeService extends BaseTemplateTreeService {
	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	protected IBaseService getServiceImp() {
		return kmsMultidocTemplateService;
	}

}
