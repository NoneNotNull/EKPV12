package com.landray.kmss.kms.multidoc.webservice.category.processor;

import java.util.HashMap;
import java.util.Map;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.kms.common.webservice.exception.ValidationException;
import com.landray.kmss.kms.common.webservice.form.category.KmsMaintainCategoryRequest;
import com.landray.kmss.kms.common.webservice.processor.category.AbstractAddCategoryProcessor;
import com.landray.kmss.kms.common.webservice.util.WSUtils;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeCategoryForm;
import com.landray.kmss.kms.multidoc.webservice.category.form.KmsMultidocMaintainCategoryRequest;

public class KmsMultidocAddCategoryProcessor extends
		AbstractAddCategoryProcessor {
	@Override
	protected HQLInfo buildSearchCategoryNamesHQL() {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("kmsKnowledgeCategory.fdName");
		return hqlInfo;
	}

	@Override
	protected ExtendForm createFormInstance() {
		return new KmsKnowledgeCategoryForm();
	}

	@Override
	protected void validateRequests(KmsMaintainCategoryRequest[] requests)
			throws ValidationException {
		Map<String, String> requiredFieldMap = null;
		for (KmsMaintainCategoryRequest request : requests) {
			KmsMultidocMaintainCategoryRequest req = (KmsMultidocMaintainCategoryRequest) request;
			requiredFieldMap = new HashMap<String, String>();
			requiredFieldMap.put("fdName", req.getFdName());
			requiredFieldMap.put("fdNumberPrefix", req.getFdNumberPrefix());
			WSUtils.checkRequiredField(requiredFieldMap);
		}
	}

}
