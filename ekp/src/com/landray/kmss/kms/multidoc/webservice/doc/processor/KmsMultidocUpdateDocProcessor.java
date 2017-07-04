package com.landray.kmss.kms.multidoc.webservice.doc.processor;

import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.kms.common.model.KmsWebserviceAuth;
import com.landray.kmss.kms.common.webservice.form.doc.KmsMaintianDocResponse;
import com.landray.kmss.kms.common.webservice.processor.property.ExtendPropertyProcessor;
import com.landray.kmss.kms.common.webservice.util.WSAuthorityUtils;
import com.landray.kmss.kms.common.webservice.util.WSUtils;
import com.landray.kmss.kms.multidoc.forms.KmsMultidocKnowledgeForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.webservice.doc.form.KmsMaintainMultidocDocRequest;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;

public class KmsMultidocUpdateDocProcessor extends
		AbstractMaintainMultidocDocProcessor {
	@Override
	protected KmsMaintianDocResponse processAddOrUpdateOperate(
			KmsMaintainMultidocDocRequest req) throws Exception {
		KmsMultidocKnowledgeForm form = new KmsMultidocKnowledgeForm();
		KmsWebserviceAuth model = WSAuthorityUtils.getTranslateModel(
				kmsWebserviceAuthService, req, form.getModelClass(),
				this.actualOperateService);
		form.setFdId(model.getFdMainId());
		ExtendPropertyProcessor processor = getExtendPropertyProcessor();
		// 插入动态属性值
		updateExtendProperty(processor, req, form, model.getFdMainId());
		WSUtils.copyDataToForm(form, req, sysWsOrgService,
				kmsWebserviceAuthService);
		IExtendForm targetForm = new KmsMultidocKnowledgeForm();
		WSUtils.convertModelDataTOForm(actualOperateService, model
				.getFdMainId(), targetForm);
		WSUtils.copyData(targetForm, form);
		getActualOperateService().update(targetForm, new RequestContext());
		saveAttachmentFile(req, form, model.getFdMainId());
		KmsMaintianDocResponse response = buildKmsMaintianDocResponse(processor);
		return response;
	}

	private void updateExtendProperty(ExtendPropertyProcessor processor,
			KmsMaintainMultidocDocRequest req, IExtendForm form, String fdId)
			throws Exception {
		KmsMultidocKnowledge knowledge = (KmsMultidocKnowledge) actualOperateService
				.findByPrimaryKey(fdId);
		if (knowledge == null) {
			return;
		}
		SysPropertyTemplate template = knowledge.getKmsMultidocTemplate()
				.getSysPropertyTemplate();
		Map<String, Object> extendInfoMap = processor.extractPropertyForUpdate(
				req.getPropertyEntities(), template,this.isFromInnerSystem(req));
		KmsMultidocKnowledgeForm kForm = (KmsMultidocKnowledgeForm) form;
		// 更新扩展属性
		kForm.getExtendDataFormInfo().getFormData().putAll(extendInfoMap);
	}

}
