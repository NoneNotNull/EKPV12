package com.landray.kmss.km.review.actions;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.CategoryNodeAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.service.ICoreOuterService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.review.ConvertUtil;
import com.landray.kmss.km.review.forms.KmReviewMainForm;
import com.landray.kmss.km.review.model.KmReviewConfigNotify;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.model.KmReviewTemplate;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.km.review.service.IKmReviewOverviewService;
import com.landray.kmss.km.review.service.IKmReviewTemplateService;
import com.landray.kmss.sys.agenda.interfaces.ISysAgendaMainCoreService;
import com.landray.kmss.sys.agenda.interfaces.ISysAgendaMainForm;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.category.model.SysCategoryBaseModel;
import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.organization.interfaces.ISysOrgCoreService;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.organization.service.ISysOrgPersonService;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌
 */
public class KmReviewMainAction extends CategoryNodeAction {
	protected IKmReviewMainService kmReviewMainService;

	protected IKmReviewTemplateService kmReviewTemplateService;

	protected ISysOrgCoreService sysOrgCoreService;

	private ICoreOuterService dispatchCoreService;

	protected IKmReviewOverviewService kmReviewOverviewService;

	protected IKmReviewOverviewService getKmReviewOverviewService(
			HttpServletRequest request) {
		if (kmReviewOverviewService == null)
			kmReviewOverviewService = (IKmReviewOverviewService) getBean("kmReviewOverviewService");
		return kmReviewOverviewService;
	}

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmReviewMainService == null)
			kmReviewMainService = (IKmReviewMainService) getBean("kmReviewMainService");
		return kmReviewMainService;
	}

	public IKmReviewTemplateService getKmReviewTemplateService() {
		if (kmReviewTemplateService == null)
			kmReviewTemplateService = (IKmReviewTemplateService) getBean("kmReviewTemplateService");
		return kmReviewTemplateService;
	}

	public ISysOrgCoreService getSysOrgCoreService() {
		if (sysOrgCoreService == null)
			sysOrgCoreService = (ISysOrgCoreService) getBean("sysOrgCoreService");
		return sysOrgCoreService;
	}

	/**
	 * 发布草稿文件
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward publishDraft(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmReviewMainForm mainForm = (KmReviewMainForm) form;
		mainForm.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
		return super.update(mapping, form, request, response);
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmReviewMainForm mainForm = (KmReviewMainForm) form;
		mainForm.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
		return super.save(mapping, form, request, response);
	}

	public ActionForward saveadd(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmReviewMainForm mainForm = (KmReviewMainForm) form;
		mainForm.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
		return super.saveadd(mapping, form, request, response);
	}

	/**
	 * 新建草稿文档
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward saveDraft(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmReviewMainForm mainForm = (KmReviewMainForm) form;
		KmssMessages messages = new KmssMessages();
		mainForm.setDocStatus(SysDocConstant.DOC_STATUS_DRAFT);
		try {
			String fdId = this.getServiceImp(request).add(
					(KmReviewMainForm) form, new RequestContext(request));
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton("button.back",
							"kmReviewMain.do?method=edit&fdId=" + fdId, false)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("success");
		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		return mapping.findForward("failure");

	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		KmReviewMainForm mainForm = (KmReviewMainForm) form;
		try {
			this.getServiceImp(request).update((KmReviewMainForm) form,
					new RequestContext(request));
			if (com.landray.kmss.km.review.Constant.STATUS_DRAFT
					.equals(mainForm.getDocStatus())) {
				KmssReturnPage.getInstance(request).addButton(
						"button.back",
						"kmReviewMain.do?method=edit&fdId="
								+ ((KmReviewMainForm) form).getFdId(), false)
						.save(request);
			}
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("success");
		} catch (Exception e) {
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		return mapping.findForward("failure");
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
	public ActionForward changeTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		String templateId = ((KmReviewMainForm) form).getFdTemplateId();
		String ids = request.getParameter("values");
		try {
			((IKmReviewMainService) getServiceImp(request))
					.updateDucmentTemplate(ids, templateId);
		} catch (Exception e) {
			messages.addError(e);
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			getActionForward("failure", mapping, form, request, response);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		return getActionForward("success", mapping, form, request, response);

	}

	/**
	 * 打开列表页面。<br>
	 * 该操作一般以HTTP的GET方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回list页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward list(ActionMapping mapping, ActionForm form,
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
			// 添加list页面搜索sql语句
			changeSearchInfoFindPageHQLInfo(request, hqlInfo);
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
			return getActionForward("list", mapping, form, request, response);
		}
	}

	// 重写SimpleCategoryNodeAction中的listChildren方法、manageList方法和listChildrenBase方法
	public ActionForward listChildren(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return listChildrenBase(mapping, form, request, response,
				"listChildren", null);
	}

	public ActionForward manageList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return listChildrenBase(mapping, form, request, response, "manageList",
				SysAuthConstant.AUTH_CHECK_NONE);
	}

	private ActionForward listChildrenBase(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, String forwordPage, String checkAuth)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			String parentId = request.getParameter("categoryId");
			String nodeType = request.getParameter("nodeType");
			String excepteIds = request.getParameter("excepteIds");
			if (StringUtil.isNull(nodeType))
				nodeType = "node";
			String s_IsShowAll = request.getParameter("isShowAll");
			boolean isShowAll = true;
			if (StringUtil.isNotNull(s_IsShowAll)
					&& s_IsShowAll.equals("false"))
				isShowAll = false;
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
			if (checkAuth != null)
				hqlInfo.setAuthCheckType(checkAuth);
			changeFindPageHQLInfo(request, hqlInfo);
			// 添加list页面搜索sql语句
			changeSearchInfoFindPageHQLInfo(request, hqlInfo);
			String whereBlock = hqlInfo.getWhereBlock();
			if (!StringUtil.isNull(parentId)) {
				if (StringUtil.isNull(whereBlock))
					whereBlock = "";
				else
					whereBlock = "(" + whereBlock + ") and ";
				String tableName = ModelUtil.getModelTableName(getServiceImp(
						request).getModelName());
				if (nodeType.indexOf("CATEGORY") == -1) {
					if ("propertyNode".equals(nodeType))
						whereBlock += tableName + ".docProperties.fdId='"
								+ parentId + "'";
					else
						whereBlock += tableName + "." + getParentProperty()
								+ ".fdId='" + parentId + "'";
				} else if (isShowAll) {
					IBaseTreeModel treeModel = (IBaseTreeModel) getCategoryMainService()
							.findByPrimaryKey(parentId);
					whereBlock += "substring(" + tableName + "."
							+ getParentProperty()
							+ ".docCategory.fdHierarchyId,1,"
							+ treeModel.getFdHierarchyId().length() + ")='"
							+ treeModel.getFdHierarchyId() + "'";
				} else {
					whereBlock += tableName + "." + getParentProperty()
							+ ".docCategory.fdId='" + parentId + "'";
				}
				if (StringUtil.isNotNull(excepteIds)) {
					whereBlock += " and "
							+ HQLUtil.buildLogicIN(tableName + ".fdId not",
									ArrayUtil.convertArrayToList(excepteIds
											.split("\\s*[;,]\\s*")));
				}
				if (("manageList").equals(forwordPage)) {
					whereBlock += " and " + tableName + ".docStatus <>'"
							+ SysDocConstant.DOC_STATUS_DRAFT + "'";
				}
			}
			hqlInfo.setWhereBlock(whereBlock);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return getActionForward(forwordPage, mapping, form, request,
					response);
		}
	}

	// list页面搜索查询条件
	protected void changeSearchInfoFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String whereBlock = hqlInfo.getWhereBlock();
		String docSubject = request.getParameter("docSubject");// 主题
		String fdNumber = request.getParameter("fdNumber");// 申请单编号
		String docStartdate = request.getParameter("docStartdate");// 创建时间（起始）
		String docFinishdate = request.getParameter("docFinishdate");// 创建时间（截止）
		String docCreatorId = request.getParameter("docCreatorId");// 申请人
		String docCreatorName = request.getParameter("docCreatorName");
		String fdTemplateId = request.getParameter("fdTemplateId");// 模板名称
		String fdTemplateName = request.getParameter("fdTemplateName");

		if (StringUtil.isNotNull(docStartdate)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmReviewMain.docCreateTime >= '" + docStartdate + "'");
			// StringBuffer sbf = new StringBuffer();
			// sbf.append("kmReviewMain.docCreateTime >= '").append(docStartdate)
			// .append("'");
			// whereBlock = StringUtil.linkString(whereBlock, " and ", sbf
			// .toString().trim());
			request.setAttribute("docStartdate", docStartdate);
		}
		if (StringUtil.isNotNull(docFinishdate)) {
			String endTimeNextDay = getCreatTimeNextDay(docFinishdate);
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmReviewMain.docCreateTime <= '" + endTimeNextDay + "'");
			// StringBuffer sbf = new StringBuffer();
			// sbf.append(" kmReviewMain.docCreateTime <= '").append(
			// endTimeNextDay).append("'");
			// whereBlock = StringUtil.linkString(whereBlock, " and ", sbf
			// .toString().trim());
			request.setAttribute("docFinishdate", docFinishdate);
		}
		if (StringUtil.isNotNull(docCreatorId)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmReviewMain.docCreator.fdId = :docCreatorId");
			hqlInfo.setParameter("docCreatorId", docCreatorId);
			ISysOrgPersonService sysOrgPersonService = (ISysOrgPersonService) SpringBeanUtil
					.getBean("sysOrgPersonService");
			try {
				SysOrgPerson person = (SysOrgPerson) sysOrgPersonService
						.findByPrimaryKey(docCreatorId);
				if (docCreatorId != null && !docCreatorId.equals("")) {
					request.setAttribute("docCreatorId", docCreatorId);
					request.setAttribute("docCreatorName", person.getFdName());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (StringUtil.isNotNull(fdTemplateId)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmReviewMain.fdTemplate.fdId = :fdTemplateId");
			hqlInfo.setParameter("fdTemplateId", fdTemplateId);
			try {
				KmReviewTemplate template = (KmReviewTemplate) getKmReviewTemplateService()
						.findByPrimaryKey(fdTemplateId);
				if (fdTemplateId != null && !fdTemplateId.equals("")) {
					request.setAttribute("fdTemplateId", fdTemplateId);
					request
							.setAttribute("fdTemplateName", template
									.getFdName());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (StringUtil.isNotNull(docSubject)) {
			request.setAttribute("docSubject", docSubject);
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmReviewMain.docSubject like '%" + docSubject + "%'");
		}
		if (StringUtil.isNotNull(fdNumber)) {
			request.setAttribute("fdNumber", fdNumber);
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmReviewMain.fdNumber like '%" + fdNumber + "%'");
		}
		hqlInfo.setWhereBlock(whereBlock);
	}

	/**
	 * 返回查询条件中结束时间的下一天 author wanghj
	 * 
	 * @param endTime
	 * @return
	 */
	public String getCreatTimeNextDay(String endTime) {
		Date date = DateUtil
				.convertStringToDate(endTime, DateUtil.PATTERN_DATE);
		Calendar cla = Calendar.getInstance();
		cla.setTime(date);
		cla.add(Calendar.DAY_OF_MONTH, 1);
		String endTimeNextDay = DateUtil.convertDateToString(cla.getTime(),
				DateUtil.PATTERN_DATE);
		return endTimeNextDay;
	}

	/**
	 * 按状态和分类查询文档
	 */
	protected String changeFindPageWhereBlock(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String type = request.getParameter("type");
		String departmentId = request.getParameter("departmentId");
		String status = request.getParameter("status");
		String fdTemplateId = request.getParameter("fdTemplateId");
		if (null != status) {
			String owner = request.getParameter("mydoc");
			StringBuilder hql = new StringBuilder();
			if ("all".equals(status)) {
				request.setAttribute("docStatus", "true");
				request.setAttribute("publishTime", "true");
				if (!"true".equals(owner)) {
					hql.append("kmReviewMain.docStatus<>'").append(
							SysDocConstant.DOC_STATUS_DRAFT).append("'");
				} else {
					hql.append("1=1");
				}
			} else {
				hql.append("kmReviewMain.docStatus=:status");
				hqlInfo.setParameter("status", status);
			}
			if ("true".equals(owner)) {
				hql.append(" AND kmReviewMain.docCreator.fdId=:userid");
				hqlInfo.setParameter("userid", UserUtil.getUser().getFdId());
			}
			if (StringUtil.isNotNull(fdTemplateId)) {
				hql.append(" and kmReviewMain.fdTemplate.fdId=:fdTemplateId");
				hqlInfo.setParameter("fdTemplateId", fdTemplateId);
			}
			return hql.toString();
		}
		if ("category".equals(type)) {
			return "kmReviewMain.docStatus<>'"
					+ SysDocConstant.DOC_STATUS_DRAFT + "'";
		}
		if ("department".equals(type)) {
			hqlInfo.setParameter("departmentId", "%" + departmentId + "%");
			return "kmReviewMain.docStatus<>'"
					+ SysDocConstant.DOC_STATUS_DRAFT
					+ "' AND kmReviewMain.docCreator.fdHierarchyId LIKE :departmentId";
		}
		if (StringUtil.isNotNull(fdTemplateId)
				&& "true".equals(request.getParameter("mydoc"))) {
			StringBuilder hql = new StringBuilder();
			hql.append("kmReviewMain.docStatus<>'").append(
					SysDocConstant.DOC_STATUS_DRAFT).append("'");
			hql.append(" AND kmReviewMain.docCreator.fdId=:userid");
			hql.append(" and kmReviewMain.fdTemplate.fdId=:fdTemplateId");
			hqlInfo.setParameter("userid", UserUtil.getUser().getFdId());
			hqlInfo.setParameter("fdTemplateId", fdTemplateId);
			return hql.toString();
		}
		return null;
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		hqlInfo.setWhereBlock(changeFindPageWhereBlock(request, hqlInfo));
		String myFlow = request.getParameter("type");
		if ("executed".equals(myFlow)) {
			SysFlowUtil.buildLimitBlockForMyApproved("kmReviewMain", hqlInfo);
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
		}
		if ("unExecuted".equals(myFlow)) {
			SysFlowUtil.buildLimitBlockForMyApproval("kmReviewMain", hqlInfo);
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
		}
		String status = request.getParameter("status");
		String fdTemplateId = request.getParameter("fdTemplateId");
		if ("true".equals(request.getParameter("mydoc"))
				&& (status != null || StringUtil.isNotNull(fdTemplateId))) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
		}
	}

	public ActionForward findOwnerList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HQLInfo hqlInfo = getHQLInfo(request);
		hqlInfo.setModelName(" KmReviewMain ");
		hqlInfo
				.setWhereBlock("kmReviewMain.docCreator.fdId=:userId or flowHisAuditor.fdId=:userId or kmReviewMain.authAllReaders.fdId=:userId ");
		hqlInfo
				.setJoinBlock(" left join kmReviewMain.sysFlowModel.hbmHisAuditorList flowHisAuditor ");
		hqlInfo.setParameter("userId", UserUtil.getUser().getFdId());
		Page page = new Page();
		page.setRowsize(hqlInfo.getRowSize());
		page.setPageno(hqlInfo.getPageNo());
		page.excecute();
		List list = this.getServiceImp(request).findList(hqlInfo);
		page.setList(list);
		page.setTotalrows(list.size());
		request.setAttribute("queryPage", page);
		request.setAttribute("publishTime", "true");
		return mapping.findForward("list");
	}

	private HQLInfo getHQLInfo(HttpServletRequest request) {
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
		hqlInfo.setDistinctType(1);
		hqlInfo.setOrderBy(orderby);
		hqlInfo.setPageNo(pageno);
		hqlInfo.setRowSize(rowsize);
		return hqlInfo;
	}

	public ActionForward add(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-add", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String templateId = request.getParameter("fdTemplateId");
			KmReviewTemplate template = (KmReviewTemplate) getKmReviewTemplateService()
					.findByPrimaryKey(templateId);
			// 设置场所
			if (form instanceof ISysAuthAreaForm) {
				ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
				KMSSUser user = UserUtil.getKMSSUser();
				sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
				sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
			}

			// 外部流程
			if (null != template) {
				if (null != template.getFdIsExternal()
						&& template.getFdIsExternal()) {
					response.sendRedirect(template.getFdExternalUrl());
					return null;
				}
			}

			ActionForm newForm = createNewForm(mapping, form, request, response);
			if (newForm != form)
				request.setAttribute(getFormName(newForm, request), newForm);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-add", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("edit", mapping, form, request, response);
		}
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		super.createNewForm(mapping, form, request, response);
		// 初始化数据
		((IKmReviewMainService) getServiceImp(request)).initFormSetting(
				(IExtendForm) form, new RequestContext(request));

		KmReviewMainForm newForm = (KmReviewMainForm) form;
		// 流程复制
		String fdReviewId = request.getParameter("fdReviewId");
		if (StringUtil.isNotNull(fdReviewId)) {
			IExtendForm copyForm = null;
			KmReviewMain kmReviewMain = (KmReviewMain) getServiceImp(request)
					.findByPrimaryKey(fdReviewId);
			if (kmReviewMain != null) {
				copyForm = getServiceImp(request).cloneModelToForm(newForm,
						kmReviewMain, new RequestContext(request));
			}
			newForm = (KmReviewMainForm) copyForm;
			// 初始化
			newForm.setFdNumber(null);
			newForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
					DateUtil.TYPE_DATETIME, request.getLocale()));
			newForm.setDocCreatorId(UserUtil.getUser().getFdId());
			newForm.setDocCreatorName(UserUtil.getUserName(request));
			newForm.setDocStatus(SysDocConstant.DOC_STATUS_DRAFT);
		}

		// 从模块分类中获取日程机制同步时机，初始化到主文档
		String templateId = newForm.getFdTemplateId();
		if (StringUtil.isNotNull(templateId)) {
			KmReviewTemplate template = (KmReviewTemplate) getKmReviewTemplateService()
					.findByPrimaryKey(templateId);
			newForm.setFdTemplateName(getTemplatePath(template));
			if (form instanceof ISysAgendaMainForm) {
				newForm.setSyncDataToCalendarTime(template
						.getSyncDataToCalendarTime());
			}
		}
		String fdWorkId = request.getParameter("fdWorkId");
		String fdModelId = request.getParameter("fdModelId");
		String fdModelName = request.getParameter("fdModelName");
		String fdPhaseId = request.getParameter("fdPhaseId");
		if (StringUtil.isNotNull(fdWorkId)) {
			newForm.setFdWorkId(fdWorkId);
			newForm.setFdModelId(fdModelId);
			newForm.setFdModelName(fdModelName);
			newForm.setFdPhaseId(fdPhaseId);
			return newForm;
		} else {
			return newForm;
		}
	}

	private String getTemplatePath(KmReviewTemplate kmReviewTemplate) {
		String templatePath = "";
		if (kmReviewTemplate != null) {
			SysCategoryMain sysCategoryMain = kmReviewTemplate.getDocCategory();
			SysCategoryBaseModel sysCategoryBaseModel = (SysCategoryBaseModel) sysCategoryMain
					.getFdParent();
			if (sysCategoryBaseModel != null) {
				do {
					templatePath = sysCategoryBaseModel.getFdName() + "/"
							+ templatePath;
					sysCategoryBaseModel = (SysCategoryBaseModel) sysCategoryBaseModel
							.getFdParent();
				} while (sysCategoryBaseModel != null);
				templatePath = templatePath + sysCategoryMain.getFdName() + "/"
						+ kmReviewTemplate.getFdName();
			} else {
				templatePath = sysCategoryMain.getFdName() + "/"
						+ kmReviewTemplate.getFdName();
			}

		}
		return templatePath;
	}

	/**
	 * 打印流程文档
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward print(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		view(mapping, form, request, response);
		String base = "";
		String info = "";
		String note = "";
		KmReviewConfigNotify kmReviewConfigNotify = new KmReviewConfigNotify();
		base = kmReviewConfigNotify.getBase();
		info = kmReviewConfigNotify.getInfo();
		note = kmReviewConfigNotify.getNote();
		request.setAttribute("base", base);
		request.setAttribute("info", info);
		request.setAttribute("note", note);
		return mapping.findForward("print");
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
			if (model != null)
				rtnForm = getServiceImp(request).convertModelToForm(
						(IExtendForm) form, model, new RequestContext(request));
		}
		if (rtnForm == null) {
			throw new NoRecordException();
		} else {
			KmReviewMainForm kmReviewMainForm = (KmReviewMainForm) rtnForm;
			String templateId = kmReviewMainForm.getFdTemplateId();
			if (StringUtil.isNotNull(templateId)) {
				KmReviewTemplate template = (KmReviewTemplate) getKmReviewTemplateService()
						.findByPrimaryKey(templateId);
				// 获取路径模板的分类路径
				if (template != null) {
					((KmReviewMainForm) form)
							.setFdTemplateName(getTemplatePath(template));
					// 如果同步时机为空，将模板的同步时机赋予主文档
					if (StringUtil.isNull(kmReviewMainForm
							.getSyncDataToCalendarTime())) {
						((KmReviewMainForm) form)
								.setSyncDataToCalendarTime(template
										.getSyncDataToCalendarTime());
					}

				}
			}
		}
		request
				.setAttribute("pdaViewSubmitAction",
						"/km/review/km_review_main/kmReviewMain.do?method=publishDraft");
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	/**
	 * 修改反馈人
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward changeFeedback(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String feedbackIds = ((KmReviewMainForm) form).getFdFeedbackIds();
			String mainId = request.getParameter("fdId");
			KmReviewMain main = (KmReviewMain) getServiceImp(request)
					.findByPrimaryKey(mainId);
			List feedbackList = main.getFdFeedback();
			List notifyList = new ArrayList();
			String[] ids = feedbackIds.split(";");
			for (int i = 0; i < ids.length; i++) {
				SysOrgElement feedbackMan = (SysOrgElement) getSysOrgCoreService()
						.findByPrimaryKey(ids[i]);
				if (!feedbackList.contains(feedbackMan)) {
					feedbackList.add(feedbackMan);
					notifyList.add(feedbackMan);
				}
			}
			main.setFdNotifyType(((KmReviewMainForm) form).getFdNotifyType());
			main.setFdFeedbackExecuted(new Long(1));
			kmReviewMainService.updateFeedbackPeople(main, notifyList);
		} catch (Exception e) {
			messages.addError(e);
			e.printStackTrace();
			return mapping.findForward("failure");
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		return mapping.findForward("success");

	}

	/**
	 * 编辑权限
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward editRight(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String mainId = request.getParameter("fdId");
		List list, returnList;
		if (StringUtil.isNotNull(mainId)) {
			KmReviewMain main = (KmReviewMain) getServiceImp(request)
					.findByPrimaryKey(mainId);
			list = main.getAuthReaders();
			returnList = ConvertUtil.convertIdsAndNames(list,
					SysOrgElement.class);
			if (returnList.size() > 0)
				request.setAttribute("oldAuthReaders", returnList.get(1));
			list = main.getFdFeedback();
			returnList = ConvertUtil.convertIdsAndNames(list,
					SysOrgElement.class);
			if (returnList.size() > 0)
				request.setAttribute("oldFdFeedback", returnList.get(1));
			list = main.getFdLableReaders();
			returnList = ConvertUtil.convertIdsAndNames(list,
					SysOrgElement.class);
			if (returnList.size() > 0)
				request.setAttribute("oldFdLableReaders", returnList.get(1));
		}
		super.view(mapping, form, request, response);
		return mapping.findForward("editRight");
	}

	/**
	 * 保存权限
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward updateRight(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		SysOrgElement user;
		KmReviewMainForm mainForm = (KmReviewMainForm) form;
		String mainId = mainForm.getFdId();
		KmssMessages messages = new KmssMessages();
		try {
			KmReviewMain mainModel = (KmReviewMain) getServiceImp(request)
					.findByPrimaryKey(mainId);
			List authReaders = new ArrayList();
			if (StringUtil.isNull(mainForm.getAuthReaderIds()))
				mainModel.setAuthReaders(authReaders);
			else {
				String ids[] = mainForm.getAuthReaderIds().split(";");
				for (int i = 0; i < ids.length; i++) {
					user = (SysOrgElement) getSysOrgCoreService()
							.findByPrimaryKey(ids[i]);
					authReaders.add(user);
				}
				mainModel.setAuthReaders(authReaders);
			}
			List fdFeedback = new ArrayList();
			if (StringUtil.isNull(mainForm.getFdFeedbackIds()))
				mainModel.setFdFeedback(fdFeedback);
			else {
				String ids[] = mainForm.getFdFeedbackIds().split(";");
				for (int i = 0; i < ids.length; i++) {
					user = (SysOrgElement) getSysOrgCoreService()
							.findByPrimaryKey(ids[i]);
					fdFeedback.add(user);
				}
				mainModel.setFdFeedback(fdFeedback);
			}
			List fdLableReaders = new ArrayList();
			if (StringUtil.isNull(mainForm.getFdLableReaderIds()))
				mainModel.setFdLableReaders(fdLableReaders);
			else {
				String ids[] = mainForm.getFdLableReaderIds().split(";");
				for (int i = 0; i < ids.length; i++) {
					user = (SysOrgElement) getSysOrgCoreService()
							.findByPrimaryKey(ids[i]);
					fdLableReaders.add(user);
				}
				mainModel.setFdLableReaders(fdLableReaders);
			}
			getServiceImp(request).update(mainModel);
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
			return mapping.findForward("failure");
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		return mapping.findForward("success");
	}

	@Override
	protected String getFindPageOrderBy(HttpServletRequest request,
			String curOrderBy) throws Exception {
		String orderBy = request.getParameter("orderby");
		String ordertype = request.getParameter("ordertype");
		boolean isReserve = false;
		if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
			isReserve = true;
		}
		String orderById = ",kmReviewMain.fdId";
		if (StringUtil.isNotNull(orderBy)) {
			String orderbyDesc = orderBy + " desc" + orderById + " desc";
			String orderbyAll = isReserve ? orderbyDesc : orderBy + orderById;
			return orderbyAll;
		}
		return " kmReviewMain.docCreateTime desc" + orderById + " desc ";

	}

	public ActionForward addRelationDoc(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return mapping.findForward("add");
	}

	protected String getParentProperty() {
		return "fdTemplate";
	}

	protected ICoreOuterService getDispatchCoreService() {
		if (dispatchCoreService == null) {
			dispatchCoreService = (ICoreOuterService) getBean("dispatchCoreService");
		}
		return dispatchCoreService;
	}

	public ActionForward audit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return update(mapping, form, request, response);
	}

	public ActionForward previewReview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {

		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("previewReview", mapping, form, request,
					response);
		}
	}

	public ActionForward preview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String arrayString = getKmReviewOverviewService(request)
					.getReviewPre();
			if (StringUtil.isNull(arrayString)) {
				arrayString = getKmReviewOverviewService(request)
						.updateReview();
			}
			JSONArray array = new JSONArray();
			array = array.fromObject(arrayString);
			request.setAttribute("lui-source", array);

		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-index", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}

	// ********** 以下的代码为日程机制需要的代码，删除从业务模板同步数据到时间管理模块 开始**********
	private ISysAgendaMainCoreService sysAgendaMainCoreService;

	public ISysAgendaMainCoreService getSysAgendaMainCoreService() {
		if (sysAgendaMainCoreService == null)
			sysAgendaMainCoreService = (ISysAgendaMainCoreService) getBean("sysAgendaMainCoreService");
		return sysAgendaMainCoreService;
	}

	/**
	 * 在list列表中批量删除选定的多条记录。<br>
	 * 表单中，复选框的域名必须为“List_Selected”，其值为记录id。<br>
	 * 该操作一般以HTTP的POST方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回success页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");

			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(ids,
						request, "method=delete&fdId=${id}");
				int noAuthIdNum = ids.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					getServiceImp(request).delete(authIds);
				for (String id : ids) {
					KmReviewMain mainModel = (KmReviewMain) getServiceImp(
							request).findByPrimaryKey(id);
					getSysAgendaMainCoreService().deleteSyncDataToCalendar(
							mainModel);
				}
			} else if (ids != null) {
				getServiceImp(request).delete(ids);
				for (String id : ids) {
					KmReviewMain mainModel = (KmReviewMain) getServiceImp(
							request).findByPrimaryKey(id);
					getSysAgendaMainCoreService().deleteSyncDataToCalendar(
							mainModel);
				}
			}

		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	// ********** 以下的代码为日程机制需要的代码，删除从业务模板同步数据到时间管理模块 开始**********

	/**
	 * 
	 * 检验是否有模板使用权限
	 * 
	 */
	public ActionForward checkAuth(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		String hasAuth = "false";
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String fdTempid = request.getParameter("fdTempid");
			if (StringUtil.isNotNull(fdTempid)) {
				if (UserUtil.checkAuthentication(
						"/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId="
								+ fdTempid, "post")) {
					hasAuth = "true";
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-save", false, getClass());
		JSONObject json = new JSONObject();
		json.put("value", hasAuth);
		response.getWriter().append(json.toString());
		response.getWriter().flush();
		response.getWriter().close();
		return null;

	}

	public ActionForward showKeydataUsed(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();

		String whereBlock = "";
		String keydataIdStr = "";
		String keydataId = request.getParameter("keydataId");
		if (StringUtil.isNotNull(keydataId)) {
			keydataIdStr = " and kmKeydataUsed.keydataId = '" + keydataId + "'";
		}
		// 从kmKeydataUsed表中查找使用了‘keydataId’数据的对应主文档ID（这里指流程管理主文档ID），“kmReviewMainForm”指的是模块的form名称
		whereBlock += "kmReviewMain.fdId in (select kmKeydataUsed.modelId from com.landray.kmss.km.keydata.base.model.KmKeydataUsed kmKeydataUsed"
				+ " where kmKeydataUsed.formName='kmReviewMainForm'"
				+ keydataIdStr + ")";

		// 以下部分可直接参考list中的逻辑代码
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
			// 添加list页面搜索sql语句
			// changeSearchInfoFindPageHQLInfo(request, hqlInfo);
			hqlInfo.setWhereBlock(whereBlock);
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
			return getActionForward("list", mapping, form, request, response);
		}
	}
}
