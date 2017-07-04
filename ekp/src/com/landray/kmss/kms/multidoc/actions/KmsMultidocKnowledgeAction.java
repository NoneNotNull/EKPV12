package com.landray.kmss.kms.multidoc.actions;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi2.hssf.usermodel.HSSFCell;
import org.apache.poi2.hssf.usermodel.HSSFRow;
import org.apache.poi2.hssf.usermodel.HSSFSheet;
import org.apache.poi2.hssf.usermodel.HSSFWorkbook;
import org.apache.poi2.poifs.filesystem.POIFSFileSystem;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionRedirect;
import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.common.forms.KmsCommonDataPushForm;
import com.landray.kmss.kms.common.model.KmsCommonDataPush;
import com.landray.kmss.kms.common.service.IKmsCommonDataPushService;
import com.landray.kmss.kms.knowledge.actions.KmsKnowledgeBaseDocAction;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeDocTemplate;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil;
import com.landray.kmss.kms.multidoc.forms.KmsMultidocKnowledgeForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplatePreview;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgePreService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.category.service.ISysCategoryPropertyService;
import com.landray.kmss.sys.doc.actions.SysDocBaseInfoAction;
import com.landray.kmss.sys.filestore.util.SysFileStoreUtil;
import com.landray.kmss.sys.filestore.util.SysFileStoreUtil.FileConverter;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.organization.service.ISysOrgElementService;
import com.landray.kmss.sys.organization.service.ISysOrgPersonService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterMainService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterSettingService;
import com.landray.kmss.sys.property.service.ISysPropertyTreeService;
import com.landray.kmss.sys.relation.service.ISysRelationMainService;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 日期 2011-九月-04
 * 
 * @author
 */
public class KmsMultidocKnowledgeAction extends KmsKnowledgeBaseDocAction {

	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;
	protected ISysRelationMainService sysRelationMainService;
	protected ISysPropertyFilterSettingService sysPropertyFilterSettingService;
	protected ISysPropertyTreeService sysPropertyTreeService;
	protected IKmsMultidocKnowledgePreService kmsMultidocKnowledgePreService;
	protected ISysPropertyFilterMainService sysPropertyFilterMainService;
	protected ISysCategoryPropertyService sysCategoryPropertyService;
	protected ISysOrgElementService sysOrgElementService;
	protected ISysPropertyFilterService sysPropertyFilterService;

	protected ISysPropertyFilterService getSysPropertyFilterService() {
		if (sysPropertyFilterService == null)
			sysPropertyFilterService = (ISysPropertyFilterService) getBean("sysPropertyFilterService");
		return sysPropertyFilterService;
	}

	protected ISysOrgElementService getSysOrgElementService() {
		if (sysOrgElementService == null)
			sysOrgElementService = (ISysOrgElementService) getBean("sysOrgElementService");
		return sysOrgElementService;
	}

	protected ISysCategoryPropertyService getSysCategoryPropertyService() {
		if (sysCategoryPropertyService == null)
			sysCategoryPropertyService = (ISysCategoryPropertyService) getBean("sysCategoryPropertyService");
		return sysCategoryPropertyService;
	}

	protected ISysPropertyFilterMainService getSysPropertyFilterMainService() {
		if (sysPropertyFilterMainService == null)
			sysPropertyFilterMainService = (ISysPropertyFilterMainService) getBean("sysPropertyFilterMainService");
		return sysPropertyFilterMainService;
	}

	protected IKmsMultidocKnowledgePreService getKmsMultidocKnowledgePreService() {
		if (kmsMultidocKnowledgePreService == null)
			kmsMultidocKnowledgePreService = (IKmsMultidocKnowledgePreService) getBean("kmsMultidocKnowledgePreService");
		return kmsMultidocKnowledgePreService;
	}

	protected ISysPropertyTreeService getSysPropertyTreeService() {
		if (sysPropertyTreeService == null)
			sysPropertyTreeService = (ISysPropertyTreeService) getBean("sysPropertyTreeService");
		return sysPropertyTreeService;
	}

	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmsMultidocKnowledgeService == null)
			kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) getBean("kmsMultidocKnowledgeService");
		return kmsMultidocKnowledgeService;
	}

	protected ISysPropertyFilterSettingService getSysPropertyFilterSettingService() {
		if (sysPropertyFilterSettingService == null)
			sysPropertyFilterSettingService = (ISysPropertyFilterSettingService) getBean("sysPropertyFilterSettingService");
		return sysPropertyFilterSettingService;
	}

	protected ISysRelationMainService getSysRelationMainServiceService() {
		if (sysRelationMainService == null)
			sysRelationMainService = (ISysRelationMainService) getBean("sysRelationMainService");
		return sysRelationMainService;
	}

	private IKmsCommonDataPushService kmsCommonDataPushService;

	protected IBaseService getKmsDataPushService(HttpServletRequest request) {
		if (kmsCommonDataPushService == null)
			kmsCommonDataPushService = (IKmsCommonDataPushService) getBean("kmsCommonDataPushService");
		return kmsCommonDataPushService;
	}

	protected void changeSearchPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeSearchPageHQLInfo(request, hqlInfo);
		this.buildStatusWhereBlock(request, hqlInfo);
	}

	protected String getSearchPageOrderBy(HttpServletRequest request,
			String curOrderBy) throws Exception {
		if (StringUtil.isNull(curOrderBy)) {
			curOrderBy = "kmsMultidocKnowledge.docCreateTime desc";
		}
		return curOrderBy;
	}

	protected void getFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String para = request.getParameter("ownerId");
		if (!StringUtil.isNull(para)) {
			String block = "(kmsMultidocKnowledge.docCreator.fdId = :docCreatorId or kmsMultidocKnowledge.docAuthor.fdId = :docCreatorId)";
			hqlInfo.setWhereBlock(StringUtil.linkString(
					hqlInfo.getWhereBlock(), " and ", block));
			hqlInfo.setParameter("docCreatorId", para);
			request.setAttribute("ownerId", para);
		}

		para = request.getParameter("departmentId");
		if (!StringUtil.isNull(para)) {
			String block = "(kmsMultidocKnowledge.docDept.fdId = :docDeptId)";
			hqlInfo.setWhereBlock(StringUtil.linkString(
					hqlInfo.getWhereBlock(), " and ", block));
			hqlInfo.setParameter("docDeptId", para);
			request.setAttribute("deparatmentId", para);
		}

		// 最新版本
		String m_where = "kmsMultidocKnowledge.docIsNewVersion=1";
		// 我的文档
		para = request.getParameter("mydoc");
		if (!StringUtil.isNull(para)) {
			m_where += " and "
					+ "kmsMultidocKnowledge.docCreator.fdId=:docCreatorId";
			hqlInfo.setParameter("docCreatorId", UserUtil.getUser().getFdId());
		}

		// 置顶
		para = request.getParameter("pink");
		if (!StringUtil.isNull(para)) {
			m_where += " and kmsMultidocKnowledge.docIsIntroduced=1";
		}

		// 设条件
		hqlInfo.setWhereBlock(StringUtil.linkString(hqlInfo.getWhereBlock(),
				" and ", m_where));
		// 我的流程
		para = request.getParameter("myflow");
		if (!StringUtil.isNull(para)) {
			if ("1".equals(para)) {
				SysFlowUtil.buildLimitBlockForMyApproved(
						"kmsMultidocKnowledge", hqlInfo);

			}
			if ("0".equals(para)) {
				SysFlowUtil.buildLimitBlockForMyApproval(
						"kmsMultidocKnowledge", hqlInfo);
			}
		}

		// 文档状态
		buildStatusWhereBlock(request, hqlInfo);

	}

	/**
	 * 文档状态
	 * 
	 * @param request
	 * @param hqlInfo
	 */
	protected void buildStatusWhereBlock(HttpServletRequest request,
			HQLInfo hqlInfo) {

		String statusBlock = "";
		String para = request.getParameter("status");
		if (StringUtil.isNull(para)) {
			statusBlock = "kmsMultidocKnowledge.docStatus like '3%'";
		} else if (!para.equals("all")) {
			statusBlock = "kmsMultidocKnowledge.docStatus=:docStatus";
			hqlInfo.setParameter("docStatus", para);
		}
		String whereBlock = hqlInfo.getWhereBlock();
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			whereBlock = "(" + whereBlock + ")";
		}
		hqlInfo.setWhereBlock(StringUtil.linkString(whereBlock, " and ",
				statusBlock));
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
			hqlInfo.setWhereBlock("kmsMultidocKnowledge.fdImportInfo=:fdImportInfo");
			hqlInfo.setParameter("fdImportInfo", fdImportInfo);
			List<?> list = getServiceImp(request).findList(hqlInfo);
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
		super.createNewForm(mapping, form, request, response);
		IExtendForm extendForm = (IExtendForm) form;

		IKmsMultidocKnowledgeService service = (IKmsMultidocKnowledgeService) getServiceImp(request);
		service.initFormSetting(extendForm, new RequestContext(request));

		initForm(request, form);
		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}
		KmsCommonDataPushForm kmsCommonDataPushForm = (KmsCommonDataPushForm) request
				.getAttribute("kmsCommonDataPushForm");
		if (null != kmsCommonDataPushForm) {
			KmsMultidocKnowledgeForm kmsMultidocKnowledgeForm = (KmsMultidocKnowledgeForm) form;
			kmsMultidocKnowledgeForm.setDocSubject(kmsCommonDataPushForm
					.getDocSubject());
			kmsMultidocKnowledgeForm.setDocContent(kmsCommonDataPushForm
					.getDocContent());
			kmsMultidocKnowledgeForm.setDocSourceId(kmsCommonDataPushForm
					.getFdId());
		}
		Date docCreateTime = DateUtil.convertStringToDate(
				((KmsMultidocKnowledgeForm) form).getDocCreateTime(),
				DateUtil.PATTERN_DATE);
		request.setAttribute("docCreateTime", docCreateTime);
		return form;
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 我的文档或者流程，不作过滤
		String myFlow = request.getParameter("myflow");
		String myDoc = request.getParameter("mydoc");
		if (StringUtil.isNotNull(myFlow) || StringUtil.isNotNull(myDoc)) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.NO);
		}

		this.getFindPageHQLInfo(request, hqlInfo);

		hqlInfo.setModelName("com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
		// 是否进行筛选---pda使用
		String[] filterIds = request.getParameterValues("filterSetting");
		if (filterIds != null && filterIds.length > 0) {
			JSONArray jsonArray = new JSONArray();
			for (String filterId : filterIds) {
				JSONObject jsonObject = JSONObject.fromObject(filterId);
				jsonArray.element(jsonObject);
			}
			if (jsonArray.size() > 0) {
				JSONArray jsonArr = jsonArray;

				request.setAttribute("filterIds", jsonArr.toString());
			}
		} else
			request.setAttribute("filterIds", "");
		String parentId = request.getParameter("categoryId");

		// 带筛选过滤条件，有分类模板
		if (StringUtil.isNotNull(parentId)) {
			// 查找本类下，包含之类的文档
			KmsKnowledgeCategory knowledgeCategory = (KmsKnowledgeCategory) getCategoryServiceImp()
					.findByPrimaryKey(parentId);
			if (knowledgeCategory.getSysPropertyTemplate() != null) {
				// 查找出所有子类的模板ID,
				List<?> temps = getCategoryServiceImp().getAllChildCategory(
						knowledgeCategory);
				// idLists为该分类下所有子类的模板Id列表
				List<String> idLists = new ArrayList<String>();
				for (int i = 0; i < temps.size(); i++) {
					KmsKnowledgeCategory category = (KmsKnowledgeCategory) temps
							.get(i);
					if (category.getSysPropertyTemplate() != null) {
						idLists.add(category.getSysPropertyTemplate().getFdId());
					}
				}
				getSysPropertyFilterService().filterHQLInfo(
						knowledgeCategory.getSysPropertyTemplate(),
						new RequestContext(request), hqlInfo, idLists);
			}
		}
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		KmsMultidocKnowledgeForm kmsMultidocKnowledgeForm = (KmsMultidocKnowledgeForm) form;

		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String fdId = getServiceImp(request).add((IExtendForm) form,
					new RequestContext(request));
			if (StringUtil.isNotNull(kmsMultidocKnowledgeForm.getDocSourceId())) {
				KmsCommonDataPush kmsDataPush = (KmsCommonDataPush) getKmsDataPushService(
						request).findByPrimaryKey(
						kmsMultidocKnowledgeForm.getDocSourceId(),
						KmsCommonDataPush.class, true);
				if (kmsDataPush != null) {
					kmsDataPush.setStatus("1");
					getKmsDataPushService(request).update(kmsDataPush);
				}
			}
			if (kmsMultidocKnowledgeForm.getDocStatus().equals(
					SysDocConstant.DOC_STATUS_DRAFT))
				KmssReturnPage
						.getInstance(request)
						.addMessages(messages)
						.addButton(
								"button.back",
								"kmsMultidocKnowledge.do?method=edit&fdId="
										+ fdId, false).save(request);
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.save(request);
			return getActionForward("failure", mapping, form, request, response);
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
			KmsMultidocKnowledgeForm kmsMultidocKnowledgeForm = (KmsMultidocKnowledgeForm) form;
			if (SysDocConstant.DOC_STATUS_DRAFT.equals(kmsMultidocKnowledgeForm
					.getDocStatus())) {
				returnPage.addButton("button.back",
						"kmsMultidocKnowledge.do?method=edit&fdId="
								+ kmsMultidocKnowledgeForm.getFdId(), false);
			}
			returnPage.addButton(KmssReturnPage.BUTTON_CLOSE);
			return getActionForward("success", mapping, form, request, response);
		}

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
		String templateId = ((KmsMultidocKnowledgeForm) form)
				.getDocCategoryId();
		String ids = request.getParameter("values");
		try {
			((IKmsMultidocKnowledgeService) getServiceImp(request))
					.updateDucmentTemplate(ids, templateId);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		}
		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
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

			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			hqlInfo.setOrderBy(getFindPageOrderBy(request, orderby));
			getFindPageHQLInfo(request, hqlInfo);
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
	 */
	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			loadActionForm(mapping, form, request, response);
			// loadSysAttSwf(mapping, form, request, response);
		} catch (Exception e) {
			messages.addError(e);

		}
		setFileConverter(request);

		String more = request.getParameter("more");
		TimeCounter.logCurrentTime("Action-view", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			Boolean newEdition = (Boolean) request.getAttribute("newEdition");
			if (newEdition != null && newEdition) {// 有新版本则直接跳转到新版本
				ActionForward actionForward = (ActionForward) request
						.getAttribute("actionForward");
				return actionForward;
			} else {
				if (StringUtil.isNotNull(more)) {
					return getActionForward("view", mapping, form, request,
							response);
				} else {
					if (SysDocConstant.DOC_STATUS_PUBLISH
							.equals(((KmsMultidocKnowledgeForm) form)
									.getDocStatus())) {
						return getActionForward("stylepage", mapping, form,
								request, response);
					} else {
						return getActionForward("stylepage", mapping, form,
								request, response);
					}
				}
			}
		}
	}

	/**
	 * 设置可用播放器
	 * 
	 * @param request
	 */
	private void setFileConverter(HttpServletRequest request) {
		List<FileConverter> fileConverters = SysFileStoreUtil
				.getConvertConfigs();
		for (FileConverter convert : fileConverters) {
			if (convert.getConverterKey().equals("VideoCompress")) {
				request.setAttribute("videoEnabled", true);
			}
			if (convert.getConverterKey().equals("aspose_office2html")) {
				request.setAttribute("htmlEnabled", true);
			}
		}
	}


	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		KmsMultidocKnowledgeForm rtnForm = null;
		String fdId = request.getParameter("fdId");
		String type = request.getParameter("viewPattern");// 由历史版本列表进行的点击阅读链接
		String[] ids = fdId.split(",");
		String id = "";
		Boolean isHasNewVersion = new Boolean(false);
		if (ids.length > 0)
			id = ids[0];
		if (!StringUtil.isNull(id)) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(id,
					null, true);
			if (model != null) {

				// 判断是否有新版本
				if (((KmsMultidocKnowledge) model).getDocOriginDoc() != null
						&& (((KmsMultidocKnowledge) model).getDocStatus()
								.startsWith("3"))) {
					if (!"edition".equals(type)) {// 非版本机制中的查阅，不查看旧版本，直接跳到最新版本
						ActionForward actionForward = new ActionForward();
						actionForward.setRedirect(true);
						actionForward
								.setPath("/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
										+ ((KmsMultidocKnowledge) model)
												.getDocOriginDoc().getFdId());
						request.setAttribute("newEdition", true);
						request.setAttribute("actionForward", actionForward);
					}

					isHasNewVersion = true;
				}

				rtnForm = (KmsMultidocKnowledgeForm) getServiceImp(request)
						.convertModelToForm((IExtendForm) form, model,
								new RequestContext(request));
				rtnForm.setDocCategoryName(SimpleCategoryUtil
						.getCategoryPathName(((KmsMultidocKnowledge) model)
								.getDocCategory()));

				// 只保留日期，去掉时间
				KmsMultidocKnowledge knowledge = (KmsMultidocKnowledge) model;
				String publishTime = DateUtil.convertDateToString(
						knowledge.getDocPublishTime(), DateUtil.PATTERN_DATE);
				String alterTime = DateUtil.convertDateToString(
						knowledge.getDocAlterTime(), DateUtil.PATTERN_DATE);
				String createTime = DateUtil.convertDateToString(
						knowledge.getDocCreateTime(), DateUtil.PATTERN_DATE);
				request.setAttribute("publishTime", publishTime);
				request.setAttribute("alterTime", alterTime);
				request.setAttribute("createTime", createTime);
			}
		}
		if (rtnForm == null) {
			throw new NoRecordException();
		}
		String _ids = rtnForm.getDocSecondCategoriesIds();
		String _names = rtnForm.getDocSecondCategoriesNames();
		if (_ids != null) {
			String[] secondCategoriesIds = _ids.split(";");
			request.setAttribute("secondCategoriesIds", secondCategoriesIds);
		}
		if (_names != null) {
			String[] secondCategoriesNames = _names.split(";");
			request.setAttribute("secondCategoriesNames", secondCategoriesNames);
		}
		request.setAttribute("isHasNewVersion", isHasNewVersion);
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	public ActionForward previewDoc(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			List<KmsMultidocKnowledge> latestDocList = getKmsMultidocKnowledgePreService()
					.getLatestDoc();
			List<KmsMultidocKnowledge> hotDocList = getKmsMultidocKnowledgePreService()
					.getHotDoc();
			List<KmsMultidocTemplatePreview> kmsMultidocTemplatePreviewList = getKmsMultidocKnowledgePreService()
					.getMainContent();
			request.setAttribute("kmsMultidocTemplatePreviewList",
					kmsMultidocTemplatePreviewList);
			request.setAttribute("latestDocList", latestDocList);
			request.setAttribute("hotDocList", hotDocList);

		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("previewDoc", mapping, form, request,
					response);
		}
	}

	// 模块关联展示列表 by chenyy
	public ActionForward listModulerelationDoc(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		TimeCounter.logCurrentTime("Action-listModulerelationDoc", true,
				getClass());
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
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			String sysModulerelationTargetId = request
					.getParameter("sysModulerelationTargetId");

			if (StringUtil.isNotNull(sysModulerelationTargetId)) {
				String whereBlock = "kmsMultidocKnowledge.fdId in (select sysModulerelationRecord.fdTargetModelId from SysModulerelationRecord as sysModulerelationRecord where sysModulerelationRecord.sysModulerelationTargetId=:sysModulerelationTargetId)";
				hqlInfo.setParameter("sysModulerelationTargetId",
						sysModulerelationTargetId);
				hqlInfo.setWhereBlock(whereBlock);
			}
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);

			request.setAttribute("sourceModelName",
					request.getParameter("sourceModelName"));
			request.setAttribute("sourceModelId",
					request.getParameter("sourceModelId"));
			request.setAttribute("fdKey", request.getParameter("fdKey"));
			request.setAttribute("targetTemplateId",
					request.getParameter("targetTemplateId"));
			request.setAttribute("targetTemplateName",
					request.getParameter("targetTemplateName"));
			request.setAttribute("sysModulerelationTargetId",
					sysModulerelationTargetId);

		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-listModulerelationDoc", false,
				getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listModulerelationDoc", mapping, form,
					request, response);
		}
	}

	public ActionForward setTop(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-setTop", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String fdId = request.getParameter("fdId");
			if (StringUtil.isNotNull(fdId)) {
				KmsMultidocKnowledge model = (KmsMultidocKnowledge) getServiceImp(
						request).findByPrimaryKey(fdId);
				if (model != null) {
					model.setDocIsIndexTop(Boolean.TRUE);
					getServiceImp(request).update(model);
				}
			}

		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-setTop", false, getClass());

		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError()) {
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("success", mapping, form, request, response);
		}
	}

	// 初始化form基本信息
	private ActionForm initForm(HttpServletRequest request, ActionForm form)
			throws Exception {
		SysOrgPerson u = UserUtil.getUser();
		KmsMultidocKnowledgeForm newForm = (KmsMultidocKnowledgeForm) form;
		String fdTemplateId = request.getParameter("fdTemplateId");
		if (StringUtil.isNull(fdTemplateId))
			return newForm;
		KmsKnowledgeCategory knowledgeCategory = (KmsKnowledgeCategory) getCategoryServiceImp()
				.findByPrimaryKey(fdTemplateId);
		newForm.setDocAuthorName(u.getFdName());
		newForm.setDocAuthorId(u.getFdId());
		newForm.setDocCategoryName(SimpleCategoryUtil
				.getCategoryPathName(knowledgeCategory));
		KmsKnowledgeDocTemplate content = knowledgeCategory.getDocTemplate();
		newForm.setDocContent(content == null ? "" : content.getDocContent());
		newForm.setDocPostsIds(ArrayUtil.joinProperty(u.getFdPosts(), "fdId",
				";")[0]);
		newForm.setDocPostsNames(ArrayUtil.joinProperty(u.getFdPosts(),
				"fdName", ";")[0]);
		return newForm;
	}

	public ActionForward newEdition(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String originId = request.getParameter("originId");
			if (StringUtil.isNull(originId))
				throw new NoRecordException();
			KmsMultidocKnowledgeForm baseInfoForm = (KmsMultidocKnowledgeForm) form;
			KmsMultidocKnowledge docBaseInfo = (KmsMultidocKnowledge) getServiceImp(
					request).findByPrimaryKey(originId);
			baseInfoForm = (KmsMultidocKnowledgeForm) getServiceImp(request)
					.cloneModelToForm(baseInfoForm, docBaseInfo,
							new RequestContext(request));
			baseInfoForm.setMethod("add");
			baseInfoForm.setMethod_GET("add");
			baseInfoForm.setDocStatus(SysDocConstant.DOC_STATUS_DRAFT);
			// baseInfoForm.getExtendDataFormInfo().setExtendFilePath(docBaseInfo.getExtendFilePath())
			// int i = 1;
			String version = request.getParameter("version");
			if (StringUtil.isNotNull(version)) {
				baseInfoForm.setDocMainVersion(Long.valueOf(version.substring(
						0, version.indexOf('.'))));
				baseInfoForm.setDocAuxiVersion(Long.valueOf(version.substring(
						version.indexOf('.') + 1, version.length())));
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return mapping.findForward("edit");
		}
	}

	protected String getLookupMapName(HttpServletRequest request,
			String keyName, ActionMapping mapping) throws ServletException {
		if (this.getClass().equals(SysDocBaseInfoAction.class)) {
			if (keyName != null && keyName.equals("search")) {
				return keyName;
			} else {
				return null;
			}
		}
		return keyName;
	}

	public ActionForward importDoc(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return getActionForward("importDoc", mapping, form, request, response);
	}

	public ActionForward saveExcel(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-saveExcel", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			KmsMultidocKnowledgeForm kmsMultidocKnowledgeForm = (KmsMultidocKnowledgeForm) form;
			FormFile file = kmsMultidocKnowledgeForm.getFile();
			if (file.getFileSize() == 0) {
				messages.addError(new KmssMessage(
						"kms-multidoc:kmsMultidocKnowledge.noData"));
			} else {
				POIFSFileSystem fs = new POIFSFileSystem(file.getInputStream());
				HSSFWorkbook wb = new HSSFWorkbook(fs);
				HSSFSheet sheet = wb.getSheetAt(0);

				for (int i = 1; i <= sheet.getLastRowNum(); i++) {
					KmsMultidocKnowledge docKnowledge = new KmsMultidocKnowledge();
					boolean flag = true;
					HSSFRow row = sheet.getRow(i);

					// /HSSFCell orderCell = row.getCell(0);
					HSSFCell subjectCell = row.getCell(0);
					HSSFCell templateCell = row.getCell(1);
					HSSFCell creatorCell = row.getCell(2);
					HSSFCell createTimeCell = row.getCell(3);
					HSSFCell autherCell = row.getCell(4);
					HSSFCell keyWordCell = row.getCell(5);
					HSSFCell contentCell = row.getCell(6);
					HSSFCell attCell = row.getCell(7);

					String subject = "";
					KmsKnowledgeCategory knowledgeCategory = null;

					if ((subjectCell == null) || (templateCell == null)) {
						flag = false;
						messages.addError(new KmssMessage(
								"kms-multidoc:kmsMultidocTemplate.noNameOrNoFrex"));
					} else {
						knowledgeCategory = getTemplateById(changeToString(templateCell));
						if (knowledgeCategory == null) {
							flag = false;
							messages.addError(new KmssMessage(
									"kms-multidoc:kmsMultidocTemplate.noNameOrNoFrex"));
						} else {
							flag = true;
							subject = changeToString(subjectCell);
							docKnowledge.setDocSubject(subject);
							docKnowledge.setDocCategory(knowledgeCategory);
						}

					}

					if (contentCell != null) {
						String content = changeToString(contentCell);
						docKnowledge.setFdDescription(content);
					}

					if (creatorCell != null) {
						String creator = changeToString(creatorCell);
						SysOrgPerson orgPerson = getOrgPerson(docKnowledge,
								creator, request, messages);
						docKnowledge.setDocCreator(orgPerson);
						docKnowledge.setDocDept(orgPerson.getFdParent());
					}

					if (createTimeCell != null) {
						Date dateCellValue = createTimeCell.getDateCellValue();

						docKnowledge.setDocCreateTime(dateCellValue);
					}

					if (autherCell != null) {
						String auther = changeToString(autherCell);
						docKnowledge.setDocAuthor(getOrgPerson(docKnowledge,
								auther, request, messages));
					}
					if (keyWordCell != null) {
						String keyWord = changeToString(keyWordCell);
						((IKmsMultidocKnowledgeService) getServiceImp(request))
								.setTagMain(docKnowledge.getFdId(), keyWord);
					}
					if (flag) {
						if (attCell != null) {
							String att = changeToString(attCell);
							((IKmsMultidocKnowledgeService) getServiceImp(request))
									.setAttachment(att, docKnowledge);
						}

					}

					((IKmsMultidocKnowledgeService) getServiceImp(request))
							.addDocByImportExcel(docKnowledge);
					// getSysTagMainCoreService().update(docKnowledge);

				}
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(0)
				.save(request);
		TimeCounter.logCurrentTime("Action-saveExcel", false, getClass());
		if (messages.hasError()) {
			return getActionForward("failure", mapping, form, request, response);
		}
		return getActionForward("success", mapping, form, request, response);
	}



	private String changeToString(HSSFCell cell) throws Exception {
		String returnv = null;
		if (cell == null)
			return returnv;
		int type = cell.getCellType();
		switch (type) {
		case HSSFCell.CELL_TYPE_NUMERIC: {
			cell.setCellType(Cell.CELL_TYPE_STRING);
			returnv = cell.getRichStringCellValue().getString();
			break;
		}
		case HSSFCell.CELL_TYPE_STRING:
			returnv = cell.getRichStringCellValue().getString();
			break;
		default:
			break;
		}
		return returnv;
	}

	public SysOrgPerson getOrgPerson(KmsMultidocKnowledge docKnowledge,
			String cell, HttpServletRequest request, KmssMessages messages)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("sysOrgPerson.fdLoginName ='" + cell + "'");
		List<?> findValue = getSysOrgPersonService(request).findValue(hqlInfo);
		if ((findValue == null) || (findValue.isEmpty())) {
			KmssMessage kmssMessage = new KmssMessage(
					docKnowledge.getDocSubject() + "文档中没有 " + cell + " 此用户名");
			throw new KmssRuntimeException(kmssMessage);
		}
		return (SysOrgPerson) findValue.get(0);
	}

	protected ISysOrgPersonService sysOrgPersonService;

	protected ISysOrgPersonService getSysOrgPersonService(
			HttpServletRequest request) {
		if (this.sysOrgPersonService == null)
			this.sysOrgPersonService = ((ISysOrgPersonService) getBean("sysOrgPersonService"));
		return this.sysOrgPersonService;
	}

	public KmsKnowledgeCategory getTemplateById(String id) throws Exception {
		return kmsMultidocKnowledgeService.getKnowledgeCategory(id);
	}


	public ActionForward add(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-add", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
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
			KmsCommonDataPushForm kmsCommonDataPushForm = (KmsCommonDataPushForm) request
					.getAttribute("kmsCommonDataPushForm");
			if (null != kmsCommonDataPushForm) {
				return getActionForward("edit", mapping, form, request,
						response);
			}
			return getActionForward("add", mapping, form, request, response);
		}
	}

	// 调用地方未知，暂时注释
	// 将200*200的附件图转成高质量的2250*1695图
	// public void upgrade(ActionMapping mapping, ActionForm form,
	// HttpServletRequest request, HttpServletResponse response)
	// throws Exception {
	// List fileType = Arrays.asList(new Object[] { "pic" });
	// List<String> fileTypeList = new ArrayList<String>();
	// String allFileType = "";
	// allFileType = KmsKnowledgeUtil.getFileTypeHql(fileType, fileTypeList,
	// allFileType);// 获得所有完整格式
	//
	// HQLInfo hqlInfo = new HQLInfo();
	// String whereBlock =
	// " fdModelName=:fdModelName and fdKey=:fdKey and fdContentType "
	// + allFileType;
	// hqlInfo.setWhereBlock(whereBlock);
	// hqlInfo.setParameter("fdModelName",
	// "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
	// hqlInfo.setParameter("fdKey", "attachment");
	//
	// List<?> list = getSysAttMainCoreInnerService().findList(hqlInfo);
	// for (Object o : list) {
	//
	// SysAttMain sysAttMain = (SysAttMain) o;
	// String fileId = sysAttMain.getFdFileId();
	// sysAttUploadService = (ISysAttUploadService) SpringBeanUtil
	// .getBean("sysAttUploadService");
	// SysAttFile attFile = sysAttUploadService.getFileById(fileId);
	// String picPath = formatPath(attFile.getFdFilePath());
	// // 删除旧的数据
	// File dir = new File(picPath + "_" + "s2");
	// if (dir.exists()) {
	// FileUtil.deleteFile(dir);
	// }
	// if (new File(picPath).exists()) {
	// ThumbnailUtil.resizeByFix(Integer.valueOf("2250").intValue(),
	// Integer.valueOf("1695").intValue(), picPath + "_"
	// + "s2", FileUtil.getInputStream(new File(
	// picPath)));
	// }
	//
	// }
	// }

	// private String formatPath(String absPath) {
	// String cfgPath = sysAttUploadService.getDefaultCatalog();
	// if (StringUtil.isNotNull(cfgPath)) {
	// cfgPath = cfgPath.replace("\\", "/");
	// }
	// if (cfgPath.endsWith("/"))
	// cfgPath = cfgPath.substring(0, cfgPath.length() - 1);
	// return cfgPath + absPath;
	// }
	//
	// protected ISysAttUploadService sysAttUploadService;

	/**
	 * 将文档放入回收站
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward recycle(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-recycle", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!"GET".equals(request.getMethod()))
				throw new UnexpectedRequestException();
			else {
				String id = request.getParameter("fdId");
				if (StringUtil.isNotNull(id)) {
					// 根据id进行回收
					((IKmsKnowledgeBaseService) getServiceImp(request))
							.updateRecycle(id);
				}
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-recycle", false, getClass());
		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);

	}

	/**
	 * 将文档恢复
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward recover(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-recover", true, getClass());
		KmssMessages messages = new KmssMessages();
		Boolean flag = true;
		try {
			if (!"POST".equals(request.getMethod()))
				throw new UnexpectedRequestException();
			else {
				String id = request.getParameter("fdId");
				String reason = request.getParameter("description");
				if (StringUtil.isNotNull(id)) {
					// 根据id进行回收
					((IKmsKnowledgeBaseService) getServiceImp(request))
							.updateRecover(id, reason);
				}
			}
		} catch (Exception e) {
			flag = false;
			messages.addError(e);
		}
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		request.setAttribute("lui-source", json);
		TimeCounter.logCurrentTime("Action-recover", false, getClass());
		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError())
			return getActionForward("lui-failure", mapping, form, request,
					response);
		else
			return getActionForward("lui-source", mapping, form, request,
					response);
	}

	@SuppressWarnings("unchecked")
	public ActionForward docThumb(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-docThumb", true, getClass());
		KmssMessages messages = new KmssMessages();
		String imgAttUrl = "";
		String fdId = request.getParameter("fdId");
		String modelName = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";
		try {
			if (StringUtil.isNotNull(fdId)) {
				SysAttMain imgAttMain = null;
				ISysAttMainCoreInnerService sysAttMainCoreInnerService = (ISysAttMainCoreInnerService) SpringBeanUtil
						.getBean("sysAttMainService");
				List<SysAttMain> attMainList = sysAttMainCoreInnerService
						.findByModelKey(modelName, fdId, "spic");
				// 如果上传了封面图片
				if (attMainList.size() > 0) {
					imgAttMain = attMainList.get(0);
					imgAttUrl = "/sys/attachment/sys_att_main/sysAttMain.do?method=view&filekey=image2thumbnail_s1&fdId="
							+ imgAttMain.getFdId();
				} else {
					List<SysAttMain> attachments = sysAttMainCoreInnerService
							.findByModelKey(modelName, fdId, "attachment");
					// 如果有上传附件
					if (attachments.size() > 0) {
						SysAttMain attmain = attachments.get(0);
						imgAttUrl = KmsKnowledgeUtil
								.getThumbUrlByAttMain(attmain);
					}
				}
			}
			if (StringUtil.isNull(imgAttUrl)) {
				String style = "default";
				String img = "default.png";
				imgAttUrl = "/resource/style/" + style + "/attachment/" + img;
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-docThumb", false, getClass());
		ActionRedirect redirect = new ActionRedirect(imgAttUrl);
		return redirect;
	}

	public ActionForward viewOfLearn(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			loadActionForm(mapping, form, request, response);
			// loadSysAttSwf(mapping, form, request, response);
		} catch (Exception e) {
			messages.addError(e);

		}
		setFileConverter(request);

		TimeCounter.logCurrentTime("Action-view", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			Boolean newEdition = (Boolean) request.getAttribute("newEdition");
			if (newEdition != null && newEdition) {// 有新版本则直接跳转到新版本
				ActionForward actionForward = (ActionForward) request
						.getAttribute("actionForward");
				String fdUrl = actionForward.getPath();
				fdUrl = fdUrl.replace("method=view", "method=viewOfLearn");
				actionForward.setPath(fdUrl);
				return actionForward;
			} else {
				if (SysDocConstant.DOC_STATUS_PUBLISH
						.equals(((KmsMultidocKnowledgeForm) form)
								.getDocStatus())) {
					return getActionForward("viewOfLearn", mapping, form,
							request, response);
				} else {
					return getActionForward("viewOfLearn", mapping, form,
							request, response);
				}
			}
		}
	}
	
	public ActionForward viewOfLearnOnMobile(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String fdStatus=request.getParameter("fdStatus");
			String fdContentId=request.getParameter("fdContentId");
			request.setAttribute("fdCatelogContentId", fdContentId);
			if("learnt".equals(fdStatus)){
				request.setAttribute("fdStatus", "1");
			}else{
				request.setAttribute("fdStatus", "0");
			}
			loadActionForm(mapping, form, request, response);
			// loadSysAttSwf(mapping, form, request, response);
		} catch (Exception e) {
			messages.addError(e);

		}
		setFileConverter(request);

		TimeCounter.logCurrentTime("Action-view", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			Boolean newEdition = (Boolean) request.getAttribute("newEdition");
			if (newEdition != null && newEdition) {// 有新版本则直接跳转到新版本
				ActionForward actionForward = (ActionForward) request
						.getAttribute("actionForward");
				String fdUrl = actionForward.getPath();
				fdUrl = fdUrl.replace("method=view", "method=viewOfLearnOnMobile");
				actionForward.setPath(fdUrl);
				return actionForward;
			} else {
				if (SysDocConstant.DOC_STATUS_PUBLISH
						.equals(((KmsMultidocKnowledgeForm) form)
								.getDocStatus())) {
					return getActionForward("viewOfLearnOnMobile", mapping, form,
							request, response);
				} else {
					return getActionForward("viewOfLearnOnMobile", mapping, form,
							request, response);
				}
			}
		}
	}
}
