package com.landray.kmss.km.review.service.spring;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.common.service.ICheckUniqueBean;
import com.landray.kmss.km.review.forms.KmReviewTemplateForm;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.model.KmReviewSnContext;
import com.landray.kmss.km.review.model.KmReviewTemplate;
import com.landray.kmss.km.review.service.IKmReviewGenerateSnService;
import com.landray.kmss.km.review.service.IKmReviewTemplateService;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批流程模板业务接口实现
 */
public class KmReviewTemplateServiceImp extends BaseServiceImp implements
		IKmReviewTemplateService, ICheckUniqueBean {

	private IKmReviewGenerateSnService kmReviewGenerateSnService;

	public void setKmReviewGenerateSnService(
			IKmReviewGenerateSnService kmReviewGenerateSnService) {
		this.kmReviewGenerateSnService = kmReviewGenerateSnService;
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		if (UserUtil.getUser() != null) {
			KmReviewTemplate template = (KmReviewTemplate) modelObj;
			template.setDocAlteror(UserUtil.getUser());
			template.setDocAlterTime(new Date());
		}
		KmReviewTemplate kmReviewTemplate = (KmReviewTemplate) modelObj;
		KmReviewSnContext context = new KmReviewSnContext();
		context.setFdPrefix(kmReviewTemplate.getFdNumberPrefix());
		context.setFdModelName(KmReviewMain.class.getName());
		context.setFdTemplate(modelObj);
		kmReviewGenerateSnService.initalizeSerialNumber(context);
		if (Boolean.TRUE.equals(kmReviewTemplate.getFdUseForm())) {
			kmReviewTemplate.setDocContent(null); // 使用表单时清空RTF
		}
		super.update(modelObj);
	}

	@Override
	public IExtendForm cloneModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception {
		KmReviewTemplateForm newForm = (KmReviewTemplateForm) super
				.cloneModelToForm(form, model, requestContext);
		newForm.setFdName(newForm.getFdName() + "的拷贝");
		return newForm;
	}

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		KmReviewTemplate kmReviewTemplate = (KmReviewTemplate) modelObj;
		KmReviewSnContext context = new KmReviewSnContext();
		context.setFdPrefix(kmReviewTemplate.getFdNumberPrefix());
		context.setFdModelName(KmReviewMain.class.getName());
		context.setFdTemplate(modelObj);
		kmReviewGenerateSnService.initalizeSerialNumber(context);
		if (Boolean.TRUE.equals(kmReviewTemplate.getFdUseForm())) {
			kmReviewTemplate.setDocContent(null); // 使用表单时清空RTF
		}
		return super.add(modelObj);
	}

	public String checkUnique(RequestContext requestInfo) throws Exception {
		String tempId = requestInfo.getParameter("tempId");
		String prefixStr = requestInfo.getParameter("prefixStr");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock(" kmReviewTemplate.fdNumberPrefix=:prefixStr and kmReviewTemplate.fdId<>:tempId");
		hqlInfo.setParameter("prefixStr", prefixStr);
		hqlInfo.setParameter("tempId", tempId);
		List<KmReviewTemplate> list = findList(hqlInfo);
		String result = "";
		for (KmReviewTemplate template : list) {
			result += template.getDocCategory().getFdName() + "/"
					+ template.getFdName() + ";";
		}
		return ";" + result;
	}
}
