package com.landray.kmss.kms.multidoc.webservice.category.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.kms.common.webservice.constant.WSConstant;
import com.landray.kmss.kms.common.webservice.exception.KmsFaultException;
import com.landray.kmss.kms.common.webservice.exception.ValidationException;
import com.landray.kmss.kms.common.webservice.form.category.KmsMaintainCategoryResponse;
import com.landray.kmss.kms.common.webservice.processor.IKmsWebserviceProcessor;
import com.landray.kmss.kms.common.webservice.util.FaultUtils;
import com.landray.kmss.kms.multidoc.webservice.category.form.KmsMultidocMaintainCategoryRequest;

public class KmsMultidocMaintainCategoryWSService implements
		IKmsMultidocMaintainCategoryWSService {
	private static Log logger = LogFactory
			.getLog(KmsMultidocMaintainCategoryWSService.class);
	private IKmsWebserviceProcessor<KmsMultidocMaintainCategoryRequest, KmsMaintainCategoryResponse> kmsMultidocAddCategoryProcessor;
	private IKmsWebserviceProcessor<KmsMultidocMaintainCategoryRequest, String> kmsMultidocUpdateCategoryProcessor;
	private IKmsWebserviceProcessor<KmsMultidocMaintainCategoryRequest, String> kmsMultidocDelCategoryProcessor;

	public KmsMaintainCategoryResponse addCategories(
			KmsMultidocMaintainCategoryRequest... requests)
			throws KmsFaultException {
		KmsMaintainCategoryResponse response = null;
		try {
			response = kmsMultidocAddCategoryProcessor.processMessage(
					Boolean.TRUE, requests);
		} catch (ValidationException e) {
			logger
					.warn("KmsMultidocMaintainCategoryWSService execute add occur wran:"
							+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			logger.error(
					"KmsMultidocMaintainCategoryWSService execute add occur error:"
							+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		} finally {
			if (response == null) {
				response = new KmsMaintainCategoryResponse();
				response.setResult(WSConstant.OPERATION_FAIL);
			}
		}
		return response;
	}

	public String updateCategory(KmsMultidocMaintainCategoryRequest request)
			throws KmsFaultException {
		String resultState = null;
		try {
			resultState = kmsMultidocUpdateCategoryProcessor.processMessage(
					Boolean.FALSE, request);
		} catch (ValidationException e) {
			logger
					.warn("KmsMultidocMaintainCategoryWSService execute update occur wran:"
							+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			logger.error(
					"KmsMultidocMaintainCategoryWSService  execute update occur error:"
							+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		}
		return resultState;
	}

	public String delCategory(KmsMultidocMaintainCategoryRequest request)
			throws KmsFaultException {
		String resultState = WSConstant.OPERATION_FAIL;
		try {
			resultState = kmsMultidocDelCategoryProcessor.processMessage(
					null, request);
		} catch (ValidationException e) {
			logger
					.warn("KmsMultidocMaintainCategoryWSService execute delete occur wran:"
							+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			logger.error(
					"KmsMultidocMaintainCategoryWSService execute delete occur error:"
							+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		}
		return resultState;
	}

	public void setKmsMultidocAddCategoryProcessor(
			IKmsWebserviceProcessor<KmsMultidocMaintainCategoryRequest, KmsMaintainCategoryResponse> kmsMultidocAddCategoryProcessor) {
		this.kmsMultidocAddCategoryProcessor = kmsMultidocAddCategoryProcessor;
	}

	public void setKmsMultidocUpdateCategoryProcessor(
			IKmsWebserviceProcessor<KmsMultidocMaintainCategoryRequest, String> kmsMultidocUpdateCategoryProcessor) {
		this.kmsMultidocUpdateCategoryProcessor = kmsMultidocUpdateCategoryProcessor;
	}

	public void setKmsMultidocDelCategoryProcessor(
			IKmsWebserviceProcessor<KmsMultidocMaintainCategoryRequest, String> kmsMultidocDelCategoryProcessor) {
		this.kmsMultidocDelCategoryProcessor = kmsMultidocDelCategoryProcessor;
	}

}
