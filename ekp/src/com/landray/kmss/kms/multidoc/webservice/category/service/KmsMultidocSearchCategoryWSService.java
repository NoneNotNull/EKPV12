package com.landray.kmss.kms.multidoc.webservice.category.service;

import java.util.Collections;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.kms.common.webservice.exception.KmsFaultException;
import com.landray.kmss.kms.common.webservice.exception.ValidationException;
import com.landray.kmss.kms.common.webservice.form.category.CategoryEntity;
import com.landray.kmss.kms.common.webservice.form.category.KmsSearchCategoryRequest;
import com.landray.kmss.kms.common.webservice.processor.category.KmsSearchCategoryProcessor;
import com.landray.kmss.kms.common.webservice.util.FaultUtils;
import com.landray.kmss.kms.common.webservice.util.WSUtils;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.webservice2.interfaces.ISysWsOrgService;

public class KmsMultidocSearchCategoryWSService implements
		IKmsMultidocSearchCategoryWSService {
	private static Log logger = LogFactory
			.getLog(KmsMultidocSearchCategoryWSService.class);
	private KmsSearchCategoryProcessor kmsMultidocSearchCategoryProcessor;
	private ISysWsOrgService sysWsOrgService;

	public List<CategoryEntity> searchCategoryList(
			KmsSearchCategoryRequest request) throws KmsFaultException {
		List<CategoryEntity> entryList = Collections.emptyList();
		try {
			SysOrgElement element = WSUtils.getSysOrgElement(sysWsOrgService,
					"userId", request, true);
			entryList = kmsMultidocSearchCategoryProcessor
					.buildCategoryEntryList(request.getParentId(), element
							.getFdId(), "kmsKnowledgeCategory");
		} catch (ValidationException e) {
			logger.warn("KmsMultidocSearchCategoryWSService occur wran:"
					+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			logger.error("KmsMultidocSearchCategoryWSService occur error:"
					+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		}
		return entryList;
	}

	public void setKmsMultidocSearchCategoryProcessor(
			KmsSearchCategoryProcessor kmsMultidocSearchCategoryProcessor) {
		this.kmsMultidocSearchCategoryProcessor = kmsMultidocSearchCategoryProcessor;
	}

	public void setSysWsOrgService(ISysWsOrgService sysWsOrgService) {
		this.sysWsOrgService = sysWsOrgService;
	}

}
