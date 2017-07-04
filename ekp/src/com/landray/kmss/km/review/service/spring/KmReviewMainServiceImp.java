package com.landray.kmss.km.review.service.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysNotifyConstant;
import com.landray.kmss.km.review.Constant;
import com.landray.kmss.km.review.dao.IKmReviewMainDao;
import com.landray.kmss.km.review.forms.KmReviewMainForm;
import com.landray.kmss.km.review.model.KmReviewConfigNotify;
import com.landray.kmss.km.review.model.KmReviewDocKeyword;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.model.KmReviewSnContext;
import com.landray.kmss.km.review.model.KmReviewTemplate;
import com.landray.kmss.km.review.model.KmReviewTemplateKeyword;
import com.landray.kmss.km.review.service.IKmReviewGenerateSnService;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.km.review.service.IKmReviewTemplateService;
import com.landray.kmss.km.review.util.KmReviewTitleUtil;
import com.landray.kmss.sys.agenda.interfaces.ISysAgendaMainCoreService;
import com.landray.kmss.sys.agenda.interfaces.SysAgendaMainContextFormula;
import com.landray.kmss.sys.agenda.util.SysAgendaTypeEnum;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataServiceImp;
import com.landray.kmss.sys.notify.interfaces.ISysNotifyMainCoreService;
import com.landray.kmss.sys.notify.interfaces.NotifyContext;
import com.landray.kmss.sys.number.interfaces.ISysNumberFlowService;
import com.landray.kmss.sys.workflow.interfaces.Event_SysFlowDiscard;
import com.landray.kmss.sys.workflow.interfaces.Event_SysFlowFinish;
import com.landray.kmss.sys.xform.interfaces.XFormUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批文档基本信息业务接口实现
 */
@SuppressWarnings("unchecked")
public class KmReviewMainServiceImp extends ExtendDataServiceImp implements
		IKmReviewMainService, ApplicationListener {

	public IKmReviewTemplateService kmReviewTemplateService;

	public ISysNotifyMainCoreService sysNotifyMainCoreService;

	public ISysCategoryMainService sysCategoryMainService;

	private IKmReviewGenerateSnService kmReviewGenerateSnService;

	public void setKmReviewGenerateSnService(
			IKmReviewGenerateSnService kmReviewGenerateSnService) {
		this.kmReviewGenerateSnService = kmReviewGenerateSnService;
	}

	private ISysNumberFlowService sysNumberFlowService;

	public void setSysNumberFlowService(
			ISysNumberFlowService sysNumberFlowService) {
		this.sysNumberFlowService = sysNumberFlowService;
	}

	/**
	 * 修改流程文档权限
	 * 
	 * @param documentId
	 *            文档ID
	 * @param form
	 * @throws Exception
	 */
	public void updateDocumentPermission(IExtendForm form,
			RequestContext requestContext) throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		if (model == null)
			throw new NoRecordException();
		this.update(model);

	}

	/**
	 * 转移流程文档
	 * 
	 * @param fdId
	 *            文档ID
	 * @param categoryId
	 *            目标模板ID
	 * @throws Exception
	 */
	public void updateDocumentCategory(String fdId, String templateId)
			throws Exception {
		KmReviewMain main = (KmReviewMain) findByPrimaryKey(fdId);
		KmReviewTemplate template = (KmReviewTemplate) kmReviewTemplateService
				.findByPrimaryKey(templateId);
		main.setFdTemplate(template);
		update(main);
	}

	/**
	 * 新建流程文档
	 */
	@Override
	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		KmReviewMainForm main = (KmReviewMainForm) form;
		if (!Constant.STATUS_DRAFT.equals(main.getDocStatus())) {
			// 修改为调用新服务取得流水编号 modify by limh 2010年11月5日
			// main.setFdNumber(generateFlowNumber(main.getFdTemplateId(),
			// null));

			String fdNumber = "";
			if (com.landray.kmss.sys.number.util.NumberResourceUtil
					.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")) {
				IBaseModel model = initModelSetting(requestContext);
				model = convertFormToModel(main, model, requestContext);
				fdNumber = sysNumberFlowService.generateFlowNumber(model);
			} else {
				KmReviewSnContext context = new KmReviewSnContext();
				String templateId = main.getFdTemplateId();
				KmReviewTemplate template = (KmReviewTemplate) kmReviewTemplateService
						.findByPrimaryKey(templateId);
				context.setFdPrefix(template.getFdNumberPrefix());
				context.setFdModelName(KmReviewMain.class.getName());
				context.setFdTemplate(template);
				synchronized (this) {
					fdNumber = kmReviewGenerateSnService
							.getSerialNumber(context);
				}
			}

			main.setFdNumber(fdNumber);
		}
		String fdId = super.add(form, requestContext);
		return fdId;
	}

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		// 根据标题规则生成标题
		KmReviewTitleUtil.genTitle(modelObj);

		String fdId = super.add(modelObj);
		KmReviewMain mainModel = (KmReviewMain) modelObj;
		if ("flowSubmitAfter".equals(mainModel.getSyncDataToCalendarTime())) {
			// 日程机制新增同步(针对表单公式定义器模块)
			updateSyncDataToCalendarFormula(mainModel);
		}
		return fdId;
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		KmReviewMain main = (KmReviewMain) modelObj;
		if (!Constant.STATUS_DRAFT.equals(main.getDocStatus())
				&& StringUtil.isNull(main.getFdNumber())) {
			// 修改为调用新服务取得流水编号 modify by limh 2010年11月5日
			// main.setFdNumber(generateFlowNumber(null, main.getFdTemplate()));
			String fdNumber = "";
			if (com.landray.kmss.sys.number.util.NumberResourceUtil
					.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")) {
				fdNumber = sysNumberFlowService.generateFlowNumber(main);
			} else {
				KmReviewSnContext context = new KmReviewSnContext();
				KmReviewTemplate template = main.getFdTemplate();
				context.setFdPrefix(template.getFdNumberPrefix());
				context.setFdModelName(KmReviewMain.class.getName());
				context.setFdTemplate(template);
				synchronized (this) {
					fdNumber = kmReviewGenerateSnService
							.getSerialNumber(context);
				}
			}
			main.setFdNumber(fdNumber);
		}
		// 根据标题规则生成标题
		KmReviewTitleUtil.genTitle(modelObj);

		super.update(modelObj);
		if ("flowSubmitAfter".equals(main.getSyncDataToCalendarTime())) {
			// 日程机制新增同步(针对表单公式定义器模块)
			updateSyncDataToCalendarFormula(main);
		} else {
			// 修改了同步时机,删除日程
			deleteSyncDataToCalendarFormula(main);
		}
	}

	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		KmReviewMain main = (KmReviewMain) modelObj;
		// 删除流程时删除日程
		if ("flowSubmitAfter".equals(main.getSyncDataToCalendarTime())
				|| "flowPublishAfter".equals(main.getSyncDataToCalendarTime())) {
			deleteSyncDataToCalendarFormula(main);
		}
		super.delete(modelObj);
	}

	public int updateDucmentTemplate(String ids, String templateId)
			throws Exception {
		return ((IKmReviewMainDao) this.getBaseDao()).updateDocumentTemplate(
				ids, templateId);
	}

	public void onApplicationEvent(ApplicationEvent event) {
		if (event == null)
			return;
		Object obj = event.getSource();
		if (!(obj instanceof KmReviewMain))
			return;
		if (event instanceof Event_SysFlowFinish) {
			KmReviewMain main = (KmReviewMain) obj;
			main.setDocPublishTime(new Date());
			try {
				// getBaseDao().update(main);
				// 为支持bam2修改的代码块 begin 2013-08-22
				this.update(main);
				// 为支持bam2修改的代码块 end 2013-08-22
				List feedbackList = main.getFdFeedback();
				if (feedbackList.size() > 0) {
					KmReviewConfigNotify configNotify = new KmReviewConfigNotify();
					configNotify.getFdNotifyType();
					if (StringUtil.isNull(configNotify.getFdNotifyType()))
						return;
					HashMap map = new HashMap();
					map.put("km-review:kmReviewMain.docSubject", main
							.getDocSubject());
					NotifyContext notifyContext = sysNotifyMainCoreService
							.getContext("km-review:kmReview.feedback.notify");
					notifyContext.setKey("passreadKey");
					notifyContext
							.setFlag(SysNotifyConstant.NOTIFY_TODOTYPE_ONCE);
					notifyContext.setNotifyTarget(feedbackList);
					notifyContext.setNotifyType(configNotify.getFdNotifyType());
					sysNotifyMainCoreService.send(main, notifyContext, map);

				}
				if ("flowPublishAfter".equals(main.getSyncDataToCalendarTime())) {
					// 日程机制新增同步(针对表单公式定义器模块)
					updateSyncDataToCalendarFormula(main);
				}
			} catch (Exception e) {
				throw new KmssRuntimeException(e);
			}

		} else if (event instanceof Event_SysFlowDiscard) {
			KmReviewMain main = (KmReviewMain) obj;
			// 废弃时删除日程
			if ("flowSubmitAfter".equals(main.getSyncDataToCalendarTime())) {
				try {
					deleteSyncDataToCalendarFormula(main);
				} catch (Exception e) {
					throw new KmssRuntimeException(e);
				}
			}
		}
	}

	public void updateFeedbackPeople(KmReviewMain main, List notifyTarget)
			throws Exception {
		super.update(main);
		if (main.getFdNotifyType() == null)
			return;
		HashMap map = new HashMap();
		map.put("km-review:kmReviewMain.docSubject", main.getDocSubject());
		NotifyContext notifyContext = sysNotifyMainCoreService
				.getContext("km-review:kmReview.feedback.notify");
		notifyContext.setKey("passreadKey");
		notifyContext.setFlag(SysNotifyConstant.NOTIFY_TODOTYPE_ONCE);
		notifyContext.setNotifyTarget(notifyTarget);
		notifyContext.setNotifyType(main.getFdNotifyType());
		sysNotifyMainCoreService.send(main, notifyContext, map);
	}

	public IKmReviewTemplateService getKmReviewTemplateService() {
		return kmReviewTemplateService;
	}

	public void setKmReviewTemplateService(
			IKmReviewTemplateService kmReviewTemplateService) {
		this.kmReviewTemplateService = kmReviewTemplateService;
	}

	public ISysCategoryMainService getSysCategoryMainService() {
		return sysCategoryMainService;
	}

	public void setSysCategoryMainService(
			ISysCategoryMainService sysCategoryMainService) {
		this.sysCategoryMainService = sysCategoryMainService;
	}

	public void setSysNotifyMainCoreService(
			ISysNotifyMainCoreService sysNotifyMainCoreService) {
		this.sysNotifyMainCoreService = sysNotifyMainCoreService;
	}

	@Override
	protected IBaseModel initBizModelSetting(RequestContext requestContext)
			throws Exception {
		String templateId = requestContext.getParameter("fdTemplateId");
		if (!StringUtil.isNotNull(templateId)) {
			return null;
		}
		KmReviewMain model = new KmReviewMain();
		KmReviewTemplate template = (KmReviewTemplate) getKmReviewTemplateService()
				.findByPrimaryKey(templateId);
		// 加载机制数据
		// getKmReviewTemplateService().convertModelToForm(null, template,
		// requestContext);
		model.setFdTemplate(template);
		model.setDocContent(template.getDocContent());
		model.setFdFeedback(new ArrayList(template.getFdFeedback()));
		model.setFdFeedbackModify(template.getFdFeedbackModify() ? "1" : "0");
		List<KmReviewTemplateKeyword> templateList = template.getDocKeyword();
		List modelKeywordList = new ArrayList();
		for (KmReviewTemplateKeyword tkey : templateList) {
			KmReviewDocKeyword tKeyword = new KmReviewDocKeyword();
			tKeyword.setDocKeyword(tkey.getDocKeyword());
			modelKeywordList.add(tKeyword);
		}
		model.setDocKeyword(modelKeywordList);
		model.setFdLableReaders(new ArrayList(template.getFdLabelReaders()));
		model.setFdPosts(new ArrayList(template.getFdPosts()));
		model.setDocProperties(new ArrayList(template.getDocProperties()));
		model.setDocCreator(UserUtil.getUser());
		model.setDocCreateTime(new Date());
		// 增加是否使用表单模式的判断
		if (Boolean.FALSE.equals(template.getFdUseForm())) {
			model.setDocContent(template.getDocContent());
		}
		model.setFdUseForm(template.getFdUseForm());
		model.setFdDepartment(UserUtil.getUser().getFdParent());
		// model.setExtendFilePath(XFormUtil.getFileName(template
		// .getSysFormTemplateModels(), "reviewMainDoc"));
		// 修改为新的接口

		if (Boolean.TRUE.equals(template.getFdUseForm())) {
			model.setExtendFilePath(XFormUtil.getFileName(template,
					"reviewMainDoc"));
		}
		return model;
	}

	@Override
	protected void initCoreServiceFormSetting(IExtendForm form,
			IBaseModel model, RequestContext requestContext) throws Exception {
		KmReviewMain kmReviewMain = (KmReviewMain) model;
		dispatchCoreService.initFormSetting(form, "reviewMainDoc", kmReviewMain
				.getFdTemplate(), "reviewMainDoc", requestContext);
	}

	// ********** 以下的代码为日程机制需要的代码，从业务模板同步数据到时间管理模块 开始**********
	private ISysAgendaMainCoreService sysAgendaMainCoreService = null;

	public void setSysAgendaMainCoreService(
			ISysAgendaMainCoreService sysAgendaMainCoreService) {
		this.sysAgendaMainCoreService = sysAgendaMainCoreService;
	}

	// 新增同步(针对表单公式定义器模块)
	public void addSyncDataToCalendarFormula(IBaseModel model) throws Exception {
		KmReviewMain mainModel = (KmReviewMain) model;
		SysAgendaMainContextFormula sysAgendaMainContextFormula = initSysAgendaMainContextFormula(mainModel);
		sysAgendaMainCoreService.addSyncDataToCalendar(
				sysAgendaMainContextFormula, mainModel);
	}

	// 更新同步数据接口(针对表单公式定义器模块)
	public void updateSyncDataToCalendarFormula(IBaseModel model)
			throws Exception {
		KmReviewMain mainModel = (KmReviewMain) model;
		SysAgendaMainContextFormula sysAgendaMainContextFormula = initSysAgendaMainContextFormula(mainModel);
		sysAgendaMainCoreService.updateDataSyncDataToCalendar(
				sysAgendaMainContextFormula, mainModel);
	}

	// 删除同步数据接口(针对表单公式定义器模块)
	public void deleteSyncDataToCalendarFormula(IBaseModel model)
			throws Exception {
		KmReviewMain mainModel = (KmReviewMain) model;
		sysAgendaMainCoreService.deleteSyncDataToCalendar(mainModel);
	}

	// 初始化数据（针对表单公式定义器模块）
	private SysAgendaMainContextFormula initSysAgendaMainContextFormula(
			IBaseModel mainModel) {
		SysAgendaMainContextFormula sysAgendaMainContextFormula = new SysAgendaMainContextFormula();
		sysAgendaMainContextFormula
				.setDocUrl("/km/review/km_review_main/kmReviewMain.do?method=view&fdId="
						+ mainModel.getFdId());
		sysAgendaMainContextFormula
				.setCalType(SysAgendaTypeEnum.fdCalendarType.EVENT.getKey());
		sysAgendaMainContextFormula.setLunar(false);
		return sysAgendaMainContextFormula;
	}
	// ********** 以下的代码为日程机制需要的代码，从业务模板同步数据到时间管理模块 结束 **********
}
