package com.landray.kmss.kms.multidoc.webservice.doc.processor;

import com.landray.kmss.kms.common.model.KmsWebserviceAuth;
import com.landray.kmss.kms.common.webservice.constant.WSConstant;
import com.landray.kmss.kms.common.webservice.form.KmsAuthRequest;
import com.landray.kmss.kms.common.webservice.processor.AbstractMaintainProcessor;
import com.landray.kmss.kms.common.webservice.util.WSAuthorityUtils;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;

public class KmsMultidocDelDocProcessor extends
		AbstractMaintainProcessor<KmsAuthRequest, String> {

	@Override
	protected String processRequest(KmsAuthRequest[] requests) throws Exception {
		String status = null;
		KmsWebserviceAuth authModel = WSAuthorityUtils.getTranslateModel(
				kmsWebserviceAuthService, requests[0],
				KmsMultidocKnowledge.class, this.actualOperateService);
		getActualOperateService().delete(authModel.getFdMainId());
		kmsWebserviceAuthService.delete(authModel);
		status = WSConstant.OPERATION_SUCCESS;
		return status;
	}

}
