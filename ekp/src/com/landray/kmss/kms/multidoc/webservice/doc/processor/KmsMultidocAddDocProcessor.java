package com.landray.kmss.kms.multidoc.webservice.doc.processor;

import java.util.HashMap;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.common.webservice.constant.WSConstant;
import com.landray.kmss.kms.common.webservice.exception.ValidationException;
import com.landray.kmss.kms.common.webservice.form.doc.KmsMaintianDocResponse;
import com.landray.kmss.kms.common.webservice.processor.property.ExtendPropertyProcessor;
import com.landray.kmss.kms.common.webservice.util.WSUtils;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.multidoc.forms.KmsMultidocKnowledgeForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.webservice.doc.form.KmsMaintainMultidocDocRequest;
import com.landray.kmss.sys.metadata.service.ISysMetadataService;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm;
import com.landray.kmss.sys.workflow.webservice.DefaultStartParameter;
import com.landray.kmss.sys.workflow.webservice.WorkFlowParameterInitializer;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmsMultidocAddDocProcessor extends
		AbstractMaintainMultidocDocProcessor {
	@Override
	protected KmsMaintianDocResponse processAddOrUpdateOperate(
			KmsMaintainMultidocDocRequest req) throws Exception {
		String categoryId = getCategoryId(req);
		req.setFdDocTemplateId(categoryId);
		RequestContext requestContext = buildRequestContext(categoryId);
		IKmsMultidocKnowledgeService service = (IKmsMultidocKnowledgeService) getActualOperateService();
		IExtendForm form = initFormSetting(req, requestContext, service);
		initWorkFlow(form, req);
		ExtendPropertyProcessor processor = getExtendPropertyProcessor();
		// 插入动态属性值
		addExtendProperty(processor, req, form);
		// 保存文档
		String modelId = service.add(form, requestContext);
		WSUtils.saveKmsWebserviceAuth(modelId, KmsMultidocKnowledge.class, req,
				kmsWebserviceAuthService);
		// 插入标签(在service中已经判空，不需要在判断为是否为空)
		//service.addTagMain(modelId, req.getTags());
		// 保存附件
		saveAttachmentFile(req, form, modelId);
		KmsMaintianDocResponse response = buildKmsMaintianDocResponse(processor);
		return response;
	}

	/**
	 * 设置分类
	 * 
	 * @param form
	 * @throws Exception
	 */
	private String getCategoryId(KmsMaintainMultidocDocRequest req)
			throws Exception {

		if (StringUtil.isNull(req.getFdDocTemplateId())) {
			// 如果没有指定分类则创建一个名为“未分类”的类别名称
			String unclassifiedId = WSUtils.getUnclassifiedId(
					"kmsKnowledgeCategory", kmsKnowledgeCategoryService);
			if (StringUtil.isNull(unclassifiedId)) {
				KmsKnowledgeCategory template = new KmsKnowledgeCategory();
				template.setFdId(IDGenerator.generateID());
				template.setFdNumberPrefix("unclassified");
				template.setFdName(WSConstant.UNCLASSIFIY_NAME);
				String id = kmsKnowledgeCategoryService.add(template);
				return id;
			} else {
				return unclassifiedId;
			}
		} else if (isFromInnerSystem(req)) {
			return req.getFdDocTemplateId();
		} else {
			String templateId = this.kmsWebserviceAuthService
					.getFdMainIdByRelateIdAndModelName(
							req.getFdDocTemplateId(), KmsKnowledgeCategory.class
									.getName());
			return templateId;
		}
	}

	private RequestContext buildRequestContext(String categoryId)
			throws Exception {
		RequestContext requestContext = new RequestContext();
		requestContext.setParameter("fdTemplateId", categoryId);
		Map<String, Object> values = new HashMap<String, Object>();
		requestContext.setAttribute(ISysMetadataService.INIT_MODELDATA_KEY,
				values);
		values.put("docCreator", UserUtil.getUser());
		return requestContext;
	}

	private IExtendForm initFormSetting(KmsMaintainMultidocDocRequest req,
			RequestContext requestContext, IKmsMultidocKnowledgeService service)
			throws Exception {
		KmsMultidocKnowledgeForm form = new KmsMultidocKnowledgeForm();
		service.initFormSetting(form, requestContext);
		WSUtils.copyDataToForm(form, req, this.sysWsOrgService, null);
		return form;
	}

	private void initWorkFlow(IExtendForm form,
			KmsMaintainMultidocDocRequest req) throws Exception {
		DefaultStartParameter defaultStartParameter = buildDefaultStartParameter(req);
		WorkFlowParameterInitializer.initialize((ISysWfMainForm) form,
				defaultStartParameter);
	}

	private DefaultStartParameter buildDefaultStartParameter(
			KmsMaintainMultidocDocRequest request) {
		DefaultStartParameter param = new DefaultStartParameter();
		param.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
		param.setDrafterId(UserUtil.getUser().getFdId());
		return param;
	}

	private void addExtendProperty(ExtendPropertyProcessor processor,
			KmsMaintainMultidocDocRequest req, IExtendForm form)
			throws Exception {
		Map<String, Object> extendInfoMap = processor.extractPropertyForAdd(req
				.getPropertyEntities(), req.getFdDocTemplateId(),
				"kmsKnowledgeCategory", this.isFromInnerSystem(req));
		KmsMultidocKnowledgeForm kForm = (KmsMultidocKnowledgeForm) form;
		// 新增扩展属性
		kForm.getExtendDataFormInfo().getFormData().putAll(extendInfoMap);
	}

	@Override
	protected void validateRequests(KmsMaintainMultidocDocRequest[] requests)
			throws ValidationException {
		KmsMaintainMultidocDocRequest req = (KmsMaintainMultidocDocRequest) requests[0];
		Map<String, String> requiredFieldMap = new HashMap<String, String>();
		requiredFieldMap.put("docSubject", req.getDocSubject());
		WSUtils.checkRequiredField(requiredFieldMap);
		super.validateRequests(requests);
	}

}
