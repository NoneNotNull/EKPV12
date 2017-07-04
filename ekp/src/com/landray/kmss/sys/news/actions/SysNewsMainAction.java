package com.landray.kmss.sys.news.actions;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.Hibernate;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.actions.SimpleCategoryNodeAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.service.ICoreOuterService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService;
import com.landray.kmss.sys.attachment.service.ISysAttachmentService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.news.forms.SysNewsMainForm;
import com.landray.kmss.sys.news.forms.SysNewsTemplateForm;
import com.landray.kmss.sys.news.model.SysNewsMain;
import com.landray.kmss.sys.news.model.SysNewsTemplate;
import com.landray.kmss.sys.news.model.SysNewsTemplateKeyword;
import com.landray.kmss.sys.news.service.ISysNewsMainService;
import com.landray.kmss.sys.news.service.ISysNewsPublishMainService;
import com.landray.kmss.sys.news.service.ISysNewsTemplateService;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌
 */
public class SysNewsMainAction extends SimpleCategoryNodeAction {
	protected ISysNewsPublishMainService sysNewsPublishMainService;

	protected ISysNewsMainService sysNewsMainService;

	protected ISysNewsTemplateService sysNewsTemplateService;

	private ICoreOuterService dispatchCoreService;

	protected ISysAttachmentService sysAttachmentService;

	protected ISysAttachmentService getSysAttachmentServiceImp(
			HttpServletRequest request) {
		if (sysAttachmentService == null)
			sysAttachmentService = (ISysAttachmentService) getBean("sysAttachmentService");
		return sysAttachmentService;
	}
	
	protected ISysAttMainCoreInnerService sysAttMainService;

	protected ISysAttMainCoreInnerService getSysAttMainCoreInnerServiceImp(
			HttpServletRequest request) {
		if (sysAttMainService == null)
			sysAttMainService = (ISysAttMainCoreInnerService) getBean("sysAttMainService");
		return sysAttMainService;
	}


	protected String getParentProperty() {
		return "fdTemplate";
	}

	protected IBaseService getSysNewsPublishMainService(
			HttpServletRequest request) {
		if (sysNewsPublishMainService == null)
			sysNewsPublishMainService = (ISysNewsPublishMainService) getBean("sysNewsPublishMainService");
		return sysNewsPublishMainService;
	}

	public ISysSimpleCategoryService getSysSimpleCategoryService() {
		return (ISysSimpleCategoryService) getSysNewsTemplateService();
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String para = request.getParameter("status");
		String m_where = "1=1";
		if (StringUtil.isNull(para)) {
			m_where = "sysNewsMain.docStatus=:docStatus";
			hqlInfo
					.setParameter("docStatus",
							SysDocConstant.DOC_STATUS_PUBLISH);
		} else if (!"all".equals(para)) {
			m_where = "sysNewsMain.docStatus=:docStatus";
			hqlInfo.setParameter("docStatus", para);
		}
		String type = request.getParameter("type");
		if ("pic".equals(type)) {
			m_where += " and sysNewsMain.fdIsPicNews=:fdIsPicNews";
			hqlInfo.setParameter("fdIsPicNews", true);
		}
		para = request.getParameter("mydoc");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.docCreator.fdId=:userId";
			// 我的文档，不需要控制权限
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
			hqlInfo.setParameter("userId", UserUtil.getUser().getFdId());
		} else {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
					SysAuthConstant.AreaCheck.YES);
		}

		para = request.getParameter("modelName");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.fdModelName=:modelName";
			hqlInfo.setParameter("modelName", para);
		}

		para = request.getParameter("modelId");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.fdModelId=:modelId";
			hqlInfo.setParameter("modelId", para);
		}
		// 为bam增加判断，因参数为fdModelId
		para = request.getParameter("fdModelName");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.fdModelName=:fdModelName";
			hqlInfo.setParameter("fdModelName", para);
		}

		para = request.getParameter("fdModelId");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.fdModelId=:fdModelId";
			hqlInfo.setParameter("fdModelId", para);
		}

		para = request.getParameter("top");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.fdIsTop=:fdIsTop";
			hqlInfo.setParameter("fdIsTop", true);
		}

		para = request.getParameter("departmentId");
		if (!StringUtil.isNull(para)) {
			m_where += " and sysNewsMain.fdDepartment.fdId =:deptId";
			hqlInfo.setParameter("deptId", para);
		}
		hqlInfo.setWhereBlock(m_where);

		para = request.getParameter("myflow");
		if (!StringUtil.isNull(para)) {
			// 我的流程，不需要控制权限
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
			if (para.equals("0")) {
				SysFlowUtil
						.buildLimitBlockForMyApproval("sysNewsMain", hqlInfo);
			} else if (para.equals("1")) {
				SysFlowUtil
						.buildLimitBlockForMyApproved("sysNewsMain", hqlInfo);
			}
		}
		String m_order = hqlInfo.getOrderBy();
		if (m_order == null)
			m_order = "";
		else
			m_order = "," + m_order;
		m_order += ",sysNewsMain.fdIsTop desc, sysNewsMain.fdTopTime desc";
		if (m_order.indexOf("docAlterTime") == -1) {
			m_order += ",sysNewsMain.docAlterTime desc";
		}
		if (m_order.indexOf("docPublishTime") == -1) {
			m_order += ",sysNewsMain.docPublishTime desc";
		}
		hqlInfo.setOrderBy(m_order.substring(1));
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		List tempList;
		Long importance;
		StringBuffer buffer = new StringBuffer();
		SysNewsMainForm newsMainForm = (SysNewsMainForm) form;
		String templateId = request.getParameter("fdTemplateId");
		if (StringUtil.isNull(templateId))
			return newsMainForm;
		SysNewsTemplate template = (SysNewsTemplate) getSysNewsTemplateService()
				.findByPrimaryKey(templateId);
		if (template == null) {
			return super.createNewForm(mapping, form, request, response);
		}
		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}

		// 模板名称
		newsMainForm.setFdTemplateName(SimpleCategoryUtil
				.getCategoryPathName(template));
		// 新闻内容
		newsMainForm.setDocContent(template.getDocContent());
		// 所属部门
		String deptId = UserUtil.getUser().getFdParent() == null ? ""
				: UserUtil.getUser().getFdParent().getFdId().toString();
		String deptName = UserUtil.getUser().getFdParent() == null ? ""
				: UserUtil.getUser().getFdParent().getFdName();
		newsMainForm.setFdDepartmentId(deptId);
		newsMainForm.setFdDepartmentName(deptName);
		// 标签机制
		if (UserUtil.getUser().getFdParent() != null) {
			newsMainForm.setDocCreatorDeptId(UserUtil.getUser().getFdParent()
					.getFdId());
		}

		// 关键字
		tempList = template.getDocKeyword();
		for (int i = 0; i < tempList.size(); i++) {
			SysNewsTemplateKeyword keyword = (SysNewsTemplateKeyword) tempList
					.get(i);
			buffer.append(keyword.getDocKeyword()).append(";");
		}
		if (buffer.length() > 1)
			newsMainForm.setDocKeywordNames(buffer.substring(0,
					buffer.length() - 1));

		// 新闻重要度
		importance = template.getFdImportance();
		if (null != importance)
			newsMainForm.setFdImportance(importance.toString());

		// 新闻可阅读者
		tempList = template.getAuthTmpReaders();
		if (null != tempList && tempList.size() > 0) {
			String[] strArr = ArrayUtil.joinProperty(tempList, "fdId:fdName",
					";");
			newsMainForm.setAuthReaderIds(strArr[0]);
			newsMainForm.setAuthReaderNames(strArr[1]);
		}
		// 新闻可编辑者
		tempList = template.getAuthTmpEditors();
		if (null != tempList && tempList.size() > 0) {
			String[] strArr = ArrayUtil.joinProperty(tempList, "fdId:fdName",
					";");
			newsMainForm.setAuthEditorIds(strArr[0]);
			newsMainForm.setAuthEditorNames(strArr[1]);
		}
		newsMainForm.setFdCreatorName(UserUtil.getUser().getFdName());
		newsMainForm.setFdCreatorId((UserUtil.getUser().getFdId().toString()));
		newsMainForm.setFdAuthorId(newsMainForm.getFdCreatorId());
		newsMainForm.setFdAuthorName(newsMainForm.getFdCreatorName());
		newsMainForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
				DateUtil.TYPE_DATETIME, request.getLocale()));
		newsMainForm.setFdContentType(template.getFdContentType()); // 设置编辑方式
		// 将模板加入request中，用于从模板中获取在线编辑的正文和参考附件，目前只是在新建的时候可以看见参考附件
		SysNewsTemplateForm sysNewsTemplateForm = new SysNewsTemplateForm();
		getSysNewsTemplateService().convertModelToForm(sysNewsTemplateForm,
				template, new RequestContext(request));
		request.setAttribute("sysNewsTemplateForm", sysNewsTemplateForm);
		getDispatchCoreService().initFormSetting(newsMainForm, "newsMainDoc",
				template, "newsMainDoc", new RequestContext(request));
		return newsMainForm;
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			getServiceImp(request).add((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-save", false, getClass());

		KmssReturnPage returnPage = KmssReturnPage.getInstance(request);
		returnPage.addMessages(messages).save(request);
		if (messages.hasError()) {
			return getActionForward("edit", mapping, form, request, response);
		} else {
			SysNewsMainForm mainForm = (SysNewsMainForm) form;
			if (SysDocConstant.DOC_STATUS_DRAFT.equals(mainForm.getDocStatus())) {
				returnPage
						.addButton("button.back",
								"sysNewsMain.do?method=edit&fdId="
										+ mainForm.getFdId(), false);
			}
			returnPage.addButton(KmssReturnPage.BUTTON_CLOSE);
			return getActionForward("success", mapping, form, request, response);
		}
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			getServiceImp(request).update((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-update", false, getClass());

		KmssReturnPage returnPage = KmssReturnPage.getInstance(request);
		returnPage.addMessages(messages).save(request);
		if (messages.hasError()) {
			return getActionForward("edit", mapping, form, request, response);
		} else {
			SysNewsMainForm mainForm = (SysNewsMainForm) form;
			if (SysDocConstant.DOC_STATUS_DRAFT.equals(mainForm.getDocStatus())) {
				returnPage
						.addButton("button.back",
								"sysNewsMain.do?method=edit&fdId="
										+ mainForm.getFdId(), false);
			}
			returnPage.addButton(KmssReturnPage.BUTTON_CLOSE);
			return getActionForward("success", mapping, form, request, response);
		}
	}

	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			loadActionForm(mapping, form, request, response);
			List sysAttMains = (getSysAttMainCoreInnerServiceImp(request))
					.findByModelKey(
							"com.landray.kmss.sys.news.model.SysNewsMain",
							((SysNewsMainForm) form).getFdId(), "Attachment");
			boolean hasImage = sysAttMains.size()>0?true:false;
			request.setAttribute("hasImage",hasImage);
		} catch (Exception e) {
			messages.addError(e);
		}
		String more = request.getParameter("more");
		TimeCounter.logCurrentTime("Action-view", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			if (StringUtil.isNotNull(more)) {
				return getActionForward("view", mapping, form, request,
						response);
			} else {
				if (SysDocConstant.DOC_STATUS_PUBLISH
						.equals(((SysNewsMainForm) form).getDocStatus())) {
					return getActionForward("stylepage", mapping, form,
							request, response);
				} else {
					return getActionForward("view", mapping, form, request,
							response);
				}
			}
		}
	}

	/**
	 * 转移流程文档
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward setTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");
			String templateId = request.getParameter("fdTemplateId");
			if (ids != null)
				((ISysNewsMainService) getServiceImp(request)).updateTemplate(
						ids, templateId);
		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);

	}

	/**
	 * 置顶,取消置顶
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward setTop(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");
			Long days = new Long(request.getParameter("fdDays"));
			boolean isTop = Boolean.parseBoolean(request
					.getParameter("fdIsTop"));
			if (ids != null)
				((ISysNewsMainService) getServiceImp(request)).updateTop(ids,
						days, isTop);
		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	/**
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward setPublish(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");
			String ops = request.getParameter("op");
			if (ids != null && StringUtil.isNotNull(ops)) {
				if (log.isDebugEnabled()) {
					log.debug("setPublish op = " + ops);
				}
				boolean op = Boolean.valueOf(ops);
				((ISysNewsMainService) getServiceImp(request)).updatePublish(
						ids, op);
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	protected ICoreOuterService getDispatchCoreService() {
		if (dispatchCoreService == null) {
			dispatchCoreService = (ICoreOuterService) getBean("dispatchCoreService");
		}
		return dispatchCoreService;
	}

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (sysNewsMainService == null)
			sysNewsMainService = (ISysNewsMainService) getBean("sysNewsMainService");
		return sysNewsMainService;
	}

	public ISysNewsTemplateService getSysNewsTemplateService() {
		if (sysNewsTemplateService == null)
			sysNewsTemplateService = (ISysNewsTemplateService) getBean("sysNewsTemplateService");
		return sysNewsTemplateService;
	}

	/**
	 * 根据模板重新设置权限
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward setAuth(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("GET"))
				throw new UnexpectedRequestException();
			String tmpId = request.getParameter("tmpId");
			if (StringUtil.isNotNull(tmpId)) {
				((ISysNewsMainService) getServiceImp(request))
						.updateAuthWithTmp(tmpId);
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		String id = request.getParameter("fdId");
		if (!StringUtil.isNull(id)) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(id,
					null, true);
			if (model != null) {
				rtnForm = getServiceImp(request).convertModelToForm(
						(IExtendForm) form, model, new RequestContext(request));
				((SysNewsMainForm) rtnForm)
						.setFdTemplateName(SimpleCategoryUtil
								.getCategoryPathName(((SysNewsMain) model)
										.getFdTemplate()));

			}
		}
		if (rtnForm == null) {
			throw new NoRecordException();
		}
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	/**
	 * 打开手动发布的跳转到编辑页面。<br>
	 * 
	 * @author 周超
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward editManualPublish(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		KmssMessages messages = new KmssMessages();
		String fdModelNameParam = request.getParameter("fdModelNameParam");
		String fdModelIdParam = request.getParameter("fdModelIdParam");
		String fdKeyParam = request.getParameter("fdKeyParam");
		request.setAttribute("fdModelNameParam", fdModelNameParam);
		request.setAttribute("fdModelIdParam", fdModelIdParam);
		request.setAttribute("fdKeyParam", fdKeyParam);
		try {
			// 查找新闻记录
			if (StringUtil.isNotNull(fdModelNameParam)
					&& StringUtil.isNotNull(fdModelIdParam)) {
				List listPublishRecord = ((ISysNewsMainService) getServiceImp(request))
						.findListPublishRecord(fdModelNameParam, fdModelIdParam);
				request.setAttribute("listPublishRecord", listPublishRecord);
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("editManualPublish", mapping, form,
					request, response);

	}

	/**
	 * view 页面 新闻记录显示
	 * 
	 * @author 周超
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward viewAllPublish(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		String fdModelNameParam = request.getParameter("fdModelNameParam");
		String fdModelIdParam = request.getParameter("fdModelIdParam");
		String fdKeyParam = request.getParameter("fdKeyParam");
		request.setAttribute("fdModelNameParam", fdModelNameParam);
		request.setAttribute("fdModelIdParam", fdModelIdParam);
		request.setAttribute("fdKeyParam", fdKeyParam);
		try {// 查找新闻记录
			if (StringUtil.isNotNull(fdModelNameParam)
					&& StringUtil.isNotNull(fdModelIdParam)) {
				List listPublishRecord = ((ISysNewsMainService) getServiceImp(request))
						.findListPublishRecord(fdModelNameParam, fdModelIdParam);
				request.setAttribute("listPublishRecord", listPublishRecord);
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("viewAllPublish", mapping, form, request,
					response);

	}

	/**
	 * 手动发布。<br>
	 * 该操作一般以HTTP的POST方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回success页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward manualPublishAdd(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			((ISysNewsPublishMainService) getSysNewsPublishMainService(request))
					.addManuaPublish((IExtendForm) form, new RequestContext(
							request));

		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	/**
	 * 图片新闻浏览
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward browse(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-browse", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String isPage = request.getParameter("isPage");
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 0;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			if (StringUtil.isNotNull(isPage) && "false".equals(isPage)) {
				hqlInfo.setRowSize(getServiceImp(request).findList(hqlInfo)
						.size());
			}
			Page page = getServiceImp(request).findPage(hqlInfo);
			// 与list相比 修改的地方 ---- begin
			for (Iterator<?> it = page.getList().iterator(); it.hasNext();) {
				IAttachment attObj = (IAttachment) it.next();
				getSysAttachmentServiceImp(request).addAttachment(attObj,
						attObj);
			}
			// ---- end
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-browse", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("browse", mapping, form, request, response);
		}
	}

	/**
	 * 用于列表视图测试
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward index(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = SysConfigParameters.getRowSize();
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			bulidCriteriaHQLInfo(request, hqlInfo);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("index", mapping, form, request, response);
		}
	}

	/**
	 * 拼装筛选HQLInfo对象--测试使用
	 * 
	 * @param request
	 * @param hqlInfo
	 */
	private void bulidCriteriaHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) {
		String whereBlock = "1=1";
		String simpleCategory = request.getParameter("simpleCategory");
		if (StringUtil.isNotNull(simpleCategory)) {
			whereBlock += " and sysNewsMain.fdTemplate.fdId=:simpleCategory";
			hqlInfo.setParameter("simpleCategory", simpleCategory);
		}
		String docAuthor = request.getParameter("docAuthor");
		if (StringUtil.isNotNull(docAuthor)) {
			whereBlock += " and sysNewsMain.fdAuthor.fdId=:docAuthor";
			hqlInfo.setParameter("docAuthor", docAuthor);
		}
		String docDept = request.getParameter("docDept");
		if (StringUtil.isNotNull(docDept)) {
			whereBlock += " and sysNewsMain.fdDepartment.fdId=:docDept";
			hqlInfo.setParameter("docDept", docDept);
		}
		String[] docPublishTime = request.getParameterValues("docPublishTime");
		if (docPublishTime != null) {
			if (docPublishTime.length == 2) {
				whereBlock += " and sysNewsMain.docPublishTime>=:fromTime and sysNewsMain.docPublishTime<=:toTime";

				hqlInfo.setParameter("fromTime", DateUtil.convertStringToDate(
						docPublishTime[0], DateUtil.TYPE_DATE, request
								.getLocale()), Hibernate.TIMESTAMP);
				hqlInfo.setParameter("toTime", DateUtil.convertStringToDate(
						docPublishTime[1], DateUtil.TYPE_DATE, request
								.getLocale()), Hibernate.TIMESTAMP);
			}

			if (docPublishTime.length == 1) {
				whereBlock += " and sysNewsMain.docPublishTime = :time";

				hqlInfo.setParameter("time", DateUtil.convertStringToDate(
						docPublishTime[0], DateUtil.TYPE_DATE, request
								.getLocale()), Hibernate.TIMESTAMP);
			}
		}
		hqlInfo.setWhereBlock(StringUtil.linkString(hqlInfo.getWhereBlock(),
				" and ", whereBlock));
	}
}
