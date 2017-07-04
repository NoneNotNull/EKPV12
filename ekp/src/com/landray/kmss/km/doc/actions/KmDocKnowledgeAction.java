package com.landray.kmss.km.doc.actions;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.forms.KmDocKnowledgeForm;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.service.IKmDocKnowledgePreService;
import com.landray.kmss.km.doc.service.IKmDocKnowledgeService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.km.doc.util.Constants;
import com.landray.kmss.km.doc.util.KmDocKnowlegeUtil;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.doc.actions.SysDocBaseInfoAction;
import com.landray.kmss.sys.edition.service.ISysEditionMainService;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.organization.service.ISysOrgPersonService;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖
 */
public class KmDocKnowledgeAction extends SysDocBaseInfoAction {
	protected IKmDocKnowledgeService kmDocKnowledgeService;

	protected IKmDocTemplateService kmDocTemplateService;

	protected IKmDocKnowledgePreService kmDocKnowledgePreService;

	protected IKmDocKnowledgePreService getKmDocKnowledgePreService(
			HttpServletRequest request) {
		if (kmDocKnowledgePreService == null)
			kmDocKnowledgePreService = (IKmDocKnowledgePreService) getBean("kmDocKnowledgePreService");
		return kmDocKnowledgePreService;
	}

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmDocKnowledgeService == null)
			kmDocKnowledgeService = (IKmDocKnowledgeService) getBean("kmDocKnowledgeService");
		return kmDocKnowledgeService;
	}

	protected String getParentProperty() {
		return "kmDocTemplate";
	}

	protected IBaseService getTreeServiceImp() {
		if (kmDocTemplateService == null)
			kmDocTemplateService = (IKmDocTemplateService) getBean("kmDocTemplateService");
		return kmDocTemplateService;
	}

	public ISysSimpleCategoryService getSysSimpleCategoryService() {
		return (ISysSimpleCategoryService) getTreeServiceImp();
	}

	@Override
	protected String getSearchPageWhereBlock(HttpServletRequest request)
			throws Exception {
		return "kmDocKnowledge.docIsNewVersion='1' and kmDocKnowledge.docStatus like '3%'";
	}

	protected String getSearchPageOrderBy(HttpServletRequest request,
			String curOrderBy) throws Exception {
		if (StringUtil.isNull(curOrderBy)) {
			curOrderBy = "kmDocKnowledge.docCreateTime desc";
		}
		return curOrderBy;
	}

	public ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return mapping.findForward("edit");
	}

	public ActionForward docList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String fdImportInfo = request.getParameter("fdImportInfo");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock(" kmDocKnowledge.fdImportInfo=:fdImportInfo");
			hqlInfo.setParameter("fdImportInfo", fdImportInfo);
			List list = getServiceImp(request).findList(hqlInfo);
			request.setAttribute("queryList", list);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("docList", mapping, form, request, response);
		}
	}

	/**
	 * 根据模板来创建文档
	 */
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmDocKnowledgeForm kmDocKnowledgeForm = (KmDocKnowledgeForm) form;
		kmDocKnowledgeForm.reset(mapping, request);

		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}

		String templateId = request.getParameter("fdTemplateId");
		if (StringUtil.isNotNull(templateId)) {
			KmDocTemplate kmDocTemplate = ((IKmDocKnowledgeService) getServiceImp(request))
					.getKmDocTemplate(templateId);
			if (kmDocTemplate != null) {
				kmDocKnowledgeForm.setFdDocTemplateId(templateId);
				kmDocKnowledgeForm.setFdDocTemplateName(SimpleCategoryUtil
						.getCategoryPathName(kmDocTemplate));
				KMSSUser user = UserUtil.getKMSSUser();
				kmDocKnowledgeForm.setDocCreatorId(user.getUserId());
				kmDocKnowledgeForm.setDocCreatorName(user.getUserName());
				kmDocKnowledgeForm.setDocAuthorId(user.getUserId());
				kmDocKnowledgeForm.setDocAuthorName(user.getUserName());
				if (UserUtil.getUser().getFdParent() != null) {
					kmDocKnowledgeForm.setDocCreatorDeptId(UserUtil.getUser()
							.getFdParent().getFdId());
				}
				if (kmDocTemplate.getDocExpire() != null) {
					kmDocKnowledgeForm.setDocExpire(String
							.valueOf(kmDocTemplate.getDocExpire()));
				}
				if (kmDocTemplate.getDocExpire() != null)
					kmDocKnowledgeForm.setDocExpire(kmDocTemplate
							.getDocExpire().toString());
				else
					kmDocKnowledgeForm.setDocExpire(Constants.DEF_EXPIRE);
				kmDocKnowledgeForm.setDocContent(kmDocTemplate.getDocContent());
				if (UserUtil.getUser().getFdParent() != null) {
					kmDocKnowledgeForm.setDocDeptId(UserUtil.getUser()
							.getFdParent().getFdId().toString());
					kmDocKnowledgeForm.setDocDeptName(UserUtil.getUser()
							.getFdParent().getFdName());
				}
				if (kmDocTemplate.getDocKeyword() != null) {
					kmDocKnowledgeForm.setDocKeywordNames(ArrayUtil
							.joinProperty(kmDocTemplate.getDocKeyword(),
									"docKeyword", ";")[0]);
				}
				if (kmDocTemplate.getDocPosts() != null) {
					String[] posts = ArrayUtil.joinProperty(kmDocTemplate
							.getDocPosts(), "fdId:fdName", ";");
					kmDocKnowledgeForm.setDocPostsIds(posts[0]);
					kmDocKnowledgeForm.setDocPostsNames(posts[1]);
				}
				if (kmDocTemplate.getDocProperties() != null) {
					String[] properties = ArrayUtil.joinProperty(kmDocTemplate
							.getDocProperties(), "fdId:fdName", ";");
					kmDocKnowledgeForm.setDocPropertiesIds(properties[0]);
					kmDocKnowledgeForm.setDocPropertiesNames(properties[1]);
				}
			}
			getDispatchCoreService().initFormSetting(kmDocKnowledgeForm,
					"mainDoc", kmDocTemplate, "mainDoc",
					new RequestContext(request));
		}
		return kmDocKnowledgeForm;
	}

	// list页面搜索查询条件
	protected void changeSearchInfoFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String whereBlock = hqlInfo.getWhereBlock();
		String docSubject = request.getParameter("docSubject");// 文档标题
		String docCreatorId = request.getParameter("docCreatorId");// 录入人
		String docCreatorName = request.getParameter("docCreatorName");
		String fdDocTemplateId = request.getParameter("fdDocTemplateId");// 类别名称
		String fdDocTemplateName = request.getParameter("fdDocTemplateName");
		String docStartdate = request.getParameter("docStartdate");// 创建时间（起始）
		String docFinishdate = request.getParameter("docFinishdate");// 创建时间（截止）
		String docStatus = request.getParameter("docStatus");// 文档状态
		// String docContent = request.getParameter("docContent");//内容
		// String docAuthorId = request.getParameter("docAuthorId");//文件作者
		// String docAuthorName = request.getParameter("docAuthorName");

		if (StringUtil.isNotNull(docSubject)) {
			request.setAttribute("docSubject", docSubject);
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docSubject like '%" + docSubject + "%'");
		}
		if (StringUtil.isNotNull(docCreatorId)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docCreator.fdId = :docCreatorId");
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
		if (StringUtil.isNotNull(docStartdate)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docCreateTime >= '" + docStartdate + "'");
			request.setAttribute("docStartdate", docStartdate);
		}
		if (StringUtil.isNotNull(docFinishdate)) {
			String endTimeNextDay = getCreatTimeNextDay(docFinishdate);
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docCreateTime <= '" + endTimeNextDay + "'");
			request.setAttribute("docFinishdate", docFinishdate);
		}
		if (StringUtil.isNotNull(fdDocTemplateId)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.kmDocTemplate.fdId = :fdDocTemplateId");
			hqlInfo.setParameter("fdDocTemplateId", fdDocTemplateId);
			IKmDocTemplateService kmDocTemplateService = (IKmDocTemplateService) SpringBeanUtil
					.getBean("kmDocTemplateService");
			try {
				KmDocTemplate template = (KmDocTemplate) kmDocTemplateService
						.findByPrimaryKey(fdDocTemplateId);
				if (fdDocTemplateId != null && !fdDocTemplateId.equals("")) {
					request.setAttribute("fdDocTemplateId", template.getFdId());
					request.setAttribute("fdDocTemplateName", template
							.getFdName());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (StringUtil.isNotNull(docStatus) && !"0".equals(docStatus)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docStatus = :docStatus");
			hqlInfo.setParameter("docStatus", docStatus);
			request.setAttribute("docStatus", docStatus);
		}
		// if (StringUtil.isNotNull(docAuthorId)) {
		// whereBlock = StringUtil.linkString(whereBlock, " and ",
		// "kmDocKnowledge.docAuthor.fdId = :docAuthorId");
		// hqlInfo.setParameter("docAuthorId", docAuthorId);
		// ISysOrgPersonService sysOrgPersonService = (ISysOrgPersonService)
		// SpringBeanUtil
		// .getBean("sysOrgPersonService");
		// try {
		// SysOrgPerson person = (SysOrgPerson) sysOrgPersonService
		// .findByPrimaryKey(docAuthorId);
		// if (docAuthorId != null && !docAuthorId.equals("")) {
		// request.setAttribute("docAuthorId", docAuthorId);
		// request.setAttribute("docAuthorName", person.getFdName());
		// }
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
		// }
		// if (StringUtil.isNotNull(docContent)) {
		// request.setAttribute("docContent", docContent);
		// whereBlock = StringUtil.linkString(whereBlock, " and ",
		// "kmDocKnowledge.docContent like '%" + docContent + "%'");
		// }
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

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String whereBlock = hqlInfo.getWhereBlock();
		String ownerId = request.getParameter("ownerId");
		if (!StringUtil.isNull(ownerId)) {
			whereBlock = "(kmDocKnowledge.docCreator.fdId = :ownerId or kmDocKnowledge.docAuthor.fdId = :ownerId)";
			hqlInfo.setParameter("ownerId", ownerId);
			request.setAttribute("ownerId", ownerId);
		}

		String departmentId = request.getParameter("departmentId");
		if (!StringUtil.isNull(departmentId)) {
			whereBlock = "(kmDocKnowledge.docDept.fdId = :departmentId)";
			hqlInfo.setParameter("departmentId", departmentId);
			request.setAttribute("departmentId", departmentId);
		}

		String propertyId = request.getParameter("propertyId");
		if (!StringUtil.isNull(propertyId)) {
			whereBlock = "(kmDocKnowledge.docProperties.fdId = :propertyId)";
			hqlInfo.setParameter("propertyId", propertyId);
		}

		String para = request.getParameter("mydoc");
		String m_where = "kmDocKnowledge.docIsNewVersion=1";
		if (!StringUtil.isNull(para))
			m_where += " and kmDocKnowledge.docCreator.fdId='"
					+ UserUtil.getUser().getFdId() + "'";

		para = request.getParameter("pink");
		if (!StringUtil.isNull(para))
			m_where += " and kmDocKnowledge.docIsIntroduced=1";

		para = request.getParameter("status");
		String d_where = null;
		if (StringUtil.isNull(para)) {
			d_where = "kmDocKnowledge.docStatus like '3%'";
		} else if (!para.equals("all")) {
			d_where = "kmDocKnowledge.docStatus=:status";
			hqlInfo.setParameter("status", para);
		}
		d_where = StringUtil.linkString(StringUtil.isNull(m_where) ? null : "("
				+ m_where + ")", " and ", d_where);

		whereBlock = StringUtil.linkString(StringUtil.isNull(whereBlock) ? null
				: "(" + whereBlock + ")", " and ", d_where);
		hqlInfo.setWhereBlock(whereBlock);
		String myFlow = request.getParameter("myflow");
		String myDoc = request.getParameter("mydoc");

		// 我的文档或者流程，不作过滤
		if (StringUtil.isNotNull(myFlow) || StringUtil.isNotNull(myDoc)) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
		}

		if ("1".equals(myFlow)) {

			SysFlowUtil.buildLimitBlockForMyApproved("kmDocKnowledge", hqlInfo);

		}
		if ("0".equals(myFlow)) {

			SysFlowUtil.buildLimitBlockForMyApproval("kmDocKnowledge", hqlInfo);
		}
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		KmDocKnowledgeForm kmDocKnowledgeForm = (KmDocKnowledgeForm) form;
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String fdId = getServiceImp(request).add((IExtendForm) form,
					new RequestContext(request));
			if (kmDocKnowledgeForm.getDocStatus().equals(
					SysDocConstant.DOC_STATUS_DRAFT))
				KmssReturnPage.getInstance(request).addMessages(messages)
						.addButton("button.back",
								"kmDocKnowledge.do?method=edit&fdId=" + fdId,
								false).save(request);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return getActionForward("edit", mapping, form, request, response);
		} else {

			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
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
			KmDocKnowledgeForm kmDocKnowledgeForm = (KmDocKnowledgeForm) form;
			if (SysDocConstant.DOC_STATUS_DRAFT.equals(kmDocKnowledgeForm
					.getDocStatus())) {
				returnPage.addButton("button.back",
						"kmDocKnowledge.do?method=edit&fdId="
								+ kmDocKnowledgeForm.getFdId(), false);
			}
			returnPage.addButton(KmssReturnPage.BUTTON_CLOSE);
			return getActionForward("success", mapping, form, request, response);
		}
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
		KmDocKnowledgeForm kmDocKnowledgeForm = (KmDocKnowledgeForm) form;
		kmDocKnowledgeForm.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
		return update(mapping, form, request, response);
	}

	/**
	 * 转移模板
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
		String templateId = ((KmDocKnowledgeForm) form).getFdDocTemplateId();
		String ids = request.getParameter("values");
		try {
			((IKmDocKnowledgeService) getServiceImp(request))
					.updateDucmentTemplate(ids, templateId);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
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
			// 插入搜索条件查询语句
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
				"list", null);
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
			String s_IsShowAll = request.getParameter("isShowAll");
			String excepteIds = request.getParameter("excepteIds");
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
			// 插入搜索条件查询语句
			changeSearchInfoFindPageHQLInfo(request, hqlInfo);
			String whereBlock = hqlInfo.getWhereBlock();
			if (!StringUtil.isNull(parentId)) {
				if (StringUtil.isNull(whereBlock))
					whereBlock = "";
				else
					whereBlock = "(" + whereBlock + ") and ";
				String tableName = ModelUtil.getModelTableName(getServiceImp(
						request).getModelName());
				if (isShowAll) {
					IBaseTreeModel treeModel = (IBaseTreeModel) getSysSimpleCategoryService()
							.findByPrimaryKey(parentId);

					if (StringUtil.isNull(treeModel.getFdHierarchyId())) {
						whereBlock += tableName + "." + getParentProperty()
								+ ".fdId=:_treeFdId";
						hqlInfo.setParameter("_treeFdId", treeModel.getFdId());
					} else {
						// whereBlock += "substring(" + tableName + "."
						// + getParentProperty() + ".fdHierarchyId,1,"
						// + treeModel.getFdHierarchyId().length()
						// + ")= :treeHierarchyId";
						whereBlock += tableName + "." + getParentProperty()
								+ ".fdHierarchyId like :_treeHierarchyId";
						hqlInfo.setParameter("_treeHierarchyId", treeModel
								.getFdHierarchyId()
								+ "%");
					}
				} else {
					whereBlock += tableName + "." + getParentProperty()
							+ ".fdId=:_treeParentId";
					hqlInfo.setParameter("_treeParentId", parentId);
				}
				if (StringUtil.isNotNull(excepteIds)) {
					whereBlock += " and "
							+ HQLUtil.buildLogicIN(tableName + ".fdId not",
									ArrayUtil.convertArrayToList(excepteIds
											.split("\\s*[;,]\\s*")));
				}
				if (("manageList").equals(forwordPage)) {
					whereBlock += " and " + tableName
							+ ".docStatus <> :_treeDocStatus";
					hqlInfo.setParameter("_treeDocStatus",
							SysDocConstant.DOC_STATUS_DRAFT);
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

	/**
	 * 打开列表页面。<br>
	 * 该操作一般以HTTP的GET方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回listOut页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward listOut(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
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
			int rowsize = 0;
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";

			String whereBlock = null;
			HQLInfo hqlInfo = new HQLInfo();
			String ownerId = request.getParameter("ownerId");
			if (!StringUtil.isNull(ownerId)) {
				whereBlock = "(kmDocKnowledge.docCreator.fdId = :ownerId  or kmDocKnowledge.docAuthor.fdId = :ownerId)";
				request.setAttribute("ownerId", ownerId);
				hqlInfo.setParameter("ownerId", ownerId);
			}

			String departmentId = request.getParameter("departmentId");
			if (!StringUtil.isNull(departmentId)) {
				whereBlock = "(kmDocKnowledge.docDept.fdId = :departmentId )";
				request.setAttribute("departmentId", departmentId);
				hqlInfo.setParameter("departmentId", departmentId);
			}

			String propertyId = request.getParameter("propertyId");
			if (!StringUtil.isNull(propertyId)) {
				whereBlock = "(kmDocKnowledge.docProperties.fdId = :propertyId)";
			}

			String para = request.getParameter("mydoc");
			String m_where = "kmDocKnowledge.docIsNewVersion=1";
			if (!StringUtil.isNull(para))
				m_where += " and kmDocKnowledge.docCreator.fdId='"
						+ UserUtil.getUser().getFdId() + "'";

			para = request.getParameter("pink");
			if (!StringUtil.isNull(para))
				m_where += " and kmDocKnowledge.docIsIntroduced=1";

			para = request.getParameter("status");
			String d_where = null;
			if (StringUtil.isNull(para)) {
				d_where = "kmDocKnowledge.docStatus like '3%'";
			} else if (!para.equals("all")) {
				d_where = "kmDocKnowledge.docStatus=:status";
				hqlInfo.setParameter("status", para);
			}
			d_where = StringUtil.linkString(StringUtil.isNull(m_where) ? null
					: "(" + m_where + ")", " and ", d_where);
			whereBlock = StringUtil.linkString(
					StringUtil.isNull(whereBlock) ? null : "(" + whereBlock
							+ ")", " and ", d_where);
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy(getFindPageOrderBy(request, orderby));
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listOut", mapping, form, request, response);
		}
	}

	/**
	 * 发布文档可跳转到 info_view
	 * 
	 * @author 傅游翔
	 */
	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		Boolean isHasNewVersion = new Boolean(false);
		try {
			loadActionForm(mapping, form, request, response);
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
						.equals(((KmDocKnowledgeForm) form).getDocStatus())) {
					return getActionForward("stylepage", mapping, form,
							request, response);
				} else {
					return getActionForward("view", mapping, form, request,
							response);
				}
			}
		}
	}

	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		String categoryPathName = "";
		String id = request.getParameter("fdId");
		String topEdition = request.getParameter("topEdition");
		Boolean isHasNewVersion = new Boolean(false);
		if (!StringUtil.isNull(id)) {
			KmDocKnowledge model = (KmDocKnowledge) getServiceImp(request)
					.findByPrimaryKey(id, null, true);
			if (model != null) {
				// 当一个文档有多个版本时，用户配置了旧版本的链接同时配置了topEdition参数，则默认链接到最新版本
				if ("true".equals(topEdition)) {
					// 当前打开的不是最新版本时，则查询改文档的历史版本，从历史版本中取最新版本返回
					if (false == model.getDocIsNewVersion()) {
						ISysEditionMainService sysEditionMainService = (ISysEditionMainService) SpringBeanUtil
								.getBean("sysEditionMainService");
						RequestContext requestContext = new RequestContext(
								request);
						requestContext.setParameter("fdModelId", model
								.getFdId());
						requestContext.setParameter("fdModelName",
								"com.landray.kmss.km.doc.model.KmDocKnowledge");
						List<KmDocKnowledge> historylist = sysEditionMainService
								.getEditionHistoryList(requestContext);
						for (KmDocKnowledge hisDoc : historylist) {
							if (hisDoc.getDocIsNewVersion()) {
								categoryPathName = KmDocKnowlegeUtil.getSPath(
										hisDoc.getKmDocTemplate(), "");
								rtnForm = getServiceImp(request)
										.convertModelToForm((IExtendForm) form,
												hisDoc,
												new RequestContext(request));
								((KmDocKnowledgeForm) rtnForm)
										.setFdDocTemplateName(categoryPathName);
							}
						}
					} else {
						categoryPathName = KmDocKnowlegeUtil.getSPath(model
								.getKmDocTemplate(), "");
						rtnForm = getServiceImp(request).convertModelToForm(
								(IExtendForm) form, model,
								new RequestContext(request));
						((KmDocKnowledgeForm) rtnForm)
								.setFdDocTemplateName(categoryPathName);
					}

				} else {
					// 判断是否有新版本，以便view页面提示(该文档已有新版本)
					if (model.getDocOriginDoc() != null
							&& (model.getDocStatus().startsWith("3"))) {
						isHasNewVersion = true;
					}
					categoryPathName = KmDocKnowlegeUtil.getSPath(model
							.getKmDocTemplate(), "");
					rtnForm = getServiceImp(request).convertModelToForm(
							(IExtendForm) form, model,
							new RequestContext(request));
					((KmDocKnowledgeForm) rtnForm)
							.setFdDocTemplateName(categoryPathName);

				}
			}
		}
		if (rtnForm == null) {
			throw new NoRecordException();
		}
		request.setAttribute("isHasNewVersion", isHasNewVersion);
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	
	public ActionForward preview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			 String arrayString = getKmDocKnowledgePreService(request).getKmDocKnowledgePre();
			if(StringUtil.isNull(arrayString)){
				arrayString = getKmDocKnowledgePreService(request).updateKnowledgePre();
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

}