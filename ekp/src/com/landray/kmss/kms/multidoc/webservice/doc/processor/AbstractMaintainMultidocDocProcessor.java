package com.landray.kmss.kms.multidoc.webservice.doc.processor;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.kms.common.webservice.constant.ErrorMessage;
import com.landray.kmss.kms.common.webservice.constant.WSConstant;
import com.landray.kmss.kms.common.webservice.exception.ValidationException;
import com.landray.kmss.kms.common.webservice.form.WranEntity;
import com.landray.kmss.kms.common.webservice.form.doc.KmsMaintianDocResponse;
import com.landray.kmss.kms.common.webservice.processor.AbstractMaintainProcessor;
import com.landray.kmss.kms.common.webservice.processor.attachment.AttachmentProcessor;
import com.landray.kmss.kms.common.webservice.processor.property.ExtendPropertyProcessor;
import com.landray.kmss.kms.common.webservice.util.WSUtils;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.multidoc.webservice.doc.form.KmsMaintainMultidocDocRequest;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.StringUtil;

public abstract class AbstractMaintainMultidocDocProcessor
		extends
		AbstractMaintainProcessor<KmsMaintainMultidocDocRequest, KmsMaintianDocResponse> {
	private static final String AUTHOR_TYPE_INNER = "0";
	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;
	protected AttachmentProcessor attachmentProcessor = new AttachmentProcessor();

	protected abstract KmsMaintianDocResponse processAddOrUpdateOperate(
			KmsMaintainMultidocDocRequest req) throws Exception;

	@Override
	protected KmsMaintianDocResponse processRequest(
			KmsMaintainMultidocDocRequest[] requests) throws Exception {
		KmsMaintainMultidocDocRequest req = (KmsMaintainMultidocDocRequest) requests[0];
		translateInnerAuthor(req);
		return processAddOrUpdateOperate(req);
	}

	/**
	 * 转换內部作者信息
	 * 
	 * @param req
	 * @throws Exception
	 */
	private void translateInnerAuthor(KmsMaintainMultidocDocRequest req)
			throws Exception {
		if (this.isFromInnerSystem(req)) {
			return;
		}
		if (StringUtil.isNotNull(req.getDocAuthorId())
				&& (AUTHOR_TYPE_INNER.equals(req.getDocAuthorType()))) {
			List<SysOrgElement> elements = WSUtils.getSysOrgElementList(
					sysWsOrgService, "docAuthorId", req, false);
			if (!elements.isEmpty()) {
				SysOrgElement element = elements.get(0);
				req.setDocAuthorId(element.getFdId());
			}
		}
	}

	protected ExtendPropertyProcessor getExtendPropertyProcessor() {
		ExtendPropertyProcessor processor = new ExtendPropertyProcessor();
		processor.setBaseService(kmsKnowledgeCategoryService);
		return processor;
	}

	protected KmsMaintianDocResponse buildKmsMaintianDocResponse(
			ExtendPropertyProcessor processor) {
		KmsMaintianDocResponse response = new KmsMaintianDocResponse();
		response.setResult(WSConstant.OPERATION_SUCCESS);
		List<WranEntity> wranEntities = new ArrayList<WranEntity>();
		WranEntity wranEntity = buildWranEntity(processor);
		if (wranEntity != null) {
			wranEntities.add(wranEntity);
		}
		response.setWranEntites(wranEntities);
		return response;
	}

	private WranEntity buildWranEntity(ExtendPropertyProcessor processor) {
		WranEntity wranEntity = null;
		if (processor.getWranMessage().length() > 0) {
			wranEntity = new WranEntity();
			wranEntity
					.setWranSubject(ErrorMessage.DISCARD_VALUE_SUBJECT_ERROR_MSG);
			wranEntity.setWranInfo(processor.getWranMessage());
		}
		return wranEntity;
	}

	protected void saveAttachmentFile(KmsMaintainMultidocDocRequest req,
			IExtendForm form, String modelId) throws Exception {
		attachmentProcessor.saveAttachments(req.getAttachmentForms(), modelId,
				form.getModelClass().getName(), this.actualOperateService);
	}

	@Override
	protected void validateRequests(KmsMaintainMultidocDocRequest[] requests)
			throws ValidationException {
		KmsMaintainMultidocDocRequest req = (KmsMaintainMultidocDocRequest) requests[0];
		attachmentProcessor.checkAttachmentSize(req.getAttachmentForms());
	}

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}

	
}
