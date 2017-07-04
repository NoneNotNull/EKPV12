package com.landray.kmss.kms.multidoc.service;

import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.sys.authentication.intercept.IAuthenticationValidator;
import com.landray.kmss.sys.authentication.intercept.ValidatorRequestContext;
import com.landray.kmss.util.StringUtil;

public class AuthCategoryExternalValidator implements IAuthenticationValidator {

	IKmsMultidocTemplateService kmsMultidocTemplateService = null;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	public boolean validate(ValidatorRequestContext validatorContext)
			throws Exception {

		String fdTemplateId = validatorContext.getParameter("fdTemplateId");
		String fdModelId = validatorContext.getParameter("fdModelId");
		//如果是从bam中创建过来的文档不进行类别判断过滤
		if(StringUtil.isNotNull(fdModelId)){
			return true;
		}
		if (StringUtil.isNull(fdTemplateId))
			return true;

		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("kmsMultidocTemplate.fdExternalId is not null and " +
				" kmsMultidocTemplate.fdId = :fdTemplateId");
		hqlInfo.setParameter("fdTemplateId", fdTemplateId);
		List list = kmsMultidocTemplateService.findList(hqlInfo);
		if (list != null && !list.isEmpty()) {
			return false;
		}
		return true;
	}

}
