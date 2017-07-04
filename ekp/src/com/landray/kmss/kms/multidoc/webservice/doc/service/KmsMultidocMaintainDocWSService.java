package com.landray.kmss.kms.multidoc.webservice.doc.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.kms.common.webservice.constant.WSConstant;
import com.landray.kmss.kms.common.webservice.exception.KmsFaultException;
import com.landray.kmss.kms.common.webservice.exception.ValidationException;
import com.landray.kmss.kms.common.webservice.form.KmsAuthRequest;
import com.landray.kmss.kms.common.webservice.form.doc.KmsMaintianDocResponse;
import com.landray.kmss.kms.common.webservice.processor.IKmsWebserviceProcessor;
import com.landray.kmss.kms.common.webservice.util.FaultUtils;
import com.landray.kmss.kms.multidoc.webservice.doc.form.KmsMaintainMultidocDocRequest;

public class KmsMultidocMaintainDocWSService implements
		IKmsMultidocMaintainDocWSService {
	private static Log logger = LogFactory
			.getLog(KmsMultidocMaintainDocWSService.class);
	private IKmsWebserviceProcessor<KmsMaintainMultidocDocRequest, KmsMaintianDocResponse> kmsMultidocAddDocProcessor;
	private IKmsWebserviceProcessor<KmsMaintainMultidocDocRequest, KmsMaintianDocResponse> kmsMultidocUpdateDocProcessor;
	private IKmsWebserviceProcessor<KmsAuthRequest, String> kmsMultidocDelDocProcessor;

	public KmsMaintianDocResponse addDoc(KmsMaintainMultidocDocRequest request)
			throws KmsFaultException {
		KmsMaintianDocResponse response = null;
		Throwable exception = null;
		try {
			response = kmsMultidocAddDocProcessor.processMessage(Boolean.TRUE,
					request);
		} catch (ValidationException e) {
			logger
					.warn("KmsMultidocMaintainDocWSService execute add occur wran:"
							+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			logger.error(
					"KmsMultidocMaintainDocWSService execute add occur an error:"
							+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		} finally {
			setResponseResultField(response, exception);
		}
		return response;
	}

	public KmsMaintianDocResponse updateDoc(
			KmsMaintainMultidocDocRequest request) throws KmsFaultException {
		KmsMaintianDocResponse response = null;
		Throwable exception = null;
		try {
			response = kmsMultidocUpdateDocProcessor.processMessage(
					Boolean.FALSE, request);
		} catch (ValidationException e) {
			exception = e;
			logger
					.warn("KmsMultidocMaintainDocWSService execute update occur wran:"
							+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			exception = ex;
			logger.error(
					"KmsMultidocMaintainDocWSService execute update occur an error:"
							+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		} finally {
			setResponseResultField(response, exception);
		}
		return response;
	}

	public String delDoc(KmsAuthRequest request) throws KmsFaultException {
		String status = WSConstant.OPERATION_FAIL;
		try {
			status = kmsMultidocDelDocProcessor.processMessage(null,
					request);
		} catch (ValidationException e) {
			logger
					.warn("KmsMultidocMaintainDocWSService execute delete occur wran:"
							+ e.getMessage());
			FaultUtils.throwValidationException(e.getErrorCode(), e
					.getMessage());
		} catch (Throwable ex) {
			logger.error(
					"KmsMultidocMaintainDocWSService execute delete occur error:"
							+ ex.getMessage(), ex);
			FaultUtils.throwApplicationError();
		}
		return status;
	}

	private void setResponseResultField(KmsMaintianDocResponse response,
			Throwable exception) {
		if (response == null || (response != null && exception != null)) {
			response = new KmsMaintianDocResponse();
			response.setResult(WSConstant.OPERATION_FAIL);
		}
	}

	public void setKmsMultidocAddDocProcessor(
			IKmsWebserviceProcessor<KmsMaintainMultidocDocRequest, KmsMaintianDocResponse> kmsMultidocAddDocProcessor) {
		this.kmsMultidocAddDocProcessor = kmsMultidocAddDocProcessor;
	}

	public void setKmsMultidocUpdateDocProcessor(
			IKmsWebserviceProcessor<KmsMaintainMultidocDocRequest, KmsMaintianDocResponse> kmsMultidocUpdateDocProcessor) {
		this.kmsMultidocUpdateDocProcessor = kmsMultidocUpdateDocProcessor;
	}

	public void setKmsMultidocDelDocProcessor(
			IKmsWebserviceProcessor<KmsAuthRequest, String> kmsMultidocDelDocProcessor) {
		this.kmsMultidocDelDocProcessor = kmsMultidocDelDocProcessor;
	}

}
