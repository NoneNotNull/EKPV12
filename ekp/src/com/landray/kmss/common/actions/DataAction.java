package com.landray.kmss.common.actions;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

public abstract class DataAction extends BaseAction {
	private Log logger = LogFactory.getLog(this.getClass());

	protected abstract IBaseService getServiceImp(HttpServletRequest request);

	protected abstract String getParentProperty();

	protected abstract IBaseService getCategoryServiceImp(
			HttpServletRequest request);

	public ActionForward listChildren(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Class<?> clz = getCategoryServiceImp(request).getClass();
		if (ISysSimpleCategoryService.class.isAssignableFrom(clz))
			return listSimpleChildrenBase(mapping, form, request, response,
					"listChildren", null);
		else if (ISysCategoryMainService.class.isAssignableFrom(clz))
			return listCategoryChildrenBase(mapping, form, request, response,
					"listChildren", null);
		return null;

	}

	private ActionForward listCategoryChildrenBase(ActionMapping mapping,
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
					IBaseTreeModel treeModel = (IBaseTreeModel) getCategoryServiceImp(
							request).findByPrimaryKey(parentId);
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

	private ActionForward listSimpleChildrenBase(ActionMapping mapping,
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
			String nodeType = request.getParameter("nodeType");
			boolean isShowAll = true;

			if (StringUtil.isNull(nodeType))
				nodeType = "node";
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
			String modelName = getServiceImp(request).getModelName();
			if (checkAuth != null)
				hqlInfo.setAuthCheckType(checkAuth);
			changeFindPageHQLInfo(request, hqlInfo);
			String whereBlock = hqlInfo.getWhereBlock();
			if (!StringUtil.isNull(parentId)) {
				if (StringUtil.isNull(whereBlock))
					whereBlock = "";
				else
					whereBlock = "(" + whereBlock + ") and ";
				String tableName = ModelUtil.getModelTableName(modelName);
				if (isShowAll) {
					IBaseTreeModel treeModel = (IBaseTreeModel) getCategoryServiceImp(
							request).findByPrimaryKey(parentId);
					whereBlock += this.buildCategoryHQL(hqlInfo, treeModel,
							tableName);
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

	protected String buildCategoryHQL(HQLInfo hqlInfo,
			IBaseTreeModel treeModel, String tableName) {
		String whereBlock;
		if (StringUtil.isNull(treeModel.getFdHierarchyId())) {
			whereBlock = tableName + "." + getParentProperty()
					+ ".fdId=:_treeFdId";
			hqlInfo.setParameter("_treeFdId", treeModel.getFdId());
		} else {
			whereBlock = tableName + "." + getParentProperty()
					+ ".fdHierarchyId like :_treeHierarchyId";
			hqlInfo.setParameter("_treeHierarchyId", treeModel
					.getFdHierarchyId()
					+ "%");
		}
		return whereBlock;
	}

	protected ActionForward getActionForward(String defaultForward,
			ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		String para = request.getParameter("forward");
		if (!StringUtil.isNull(para) && !"failure".equals(para))
			defaultForward = para;
		return mapping.findForward(defaultForward);
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		hqlInfo.setWhereBlock(getFindPageWhereBlock(request));
		hqlInfo.setOrderBy(getFindPageOrderBy(request, hqlInfo.getOrderBy()));
	}

	protected String getFindPageWhereBlock(HttpServletRequest request)
			throws Exception {
		return null;
	}

	protected String getFindPageOrderBy(HttpServletRequest request,
			String curOrderBy) throws Exception {
		if (curOrderBy == null) {
			String className = getServiceImp(request).getModelName();
			if (StringUtil.isNull(className))
				return null;
			SysDictModel model = SysDataDict.getInstance().getModel(className);
			if (model == null)
				return null;
			String modelName = ModelUtil.getModelTableName(className);
			logger.debug("modelNme=" + modelName);
			Map propertyMap = model.getPropertyMap();
			curOrderBy = "";
			if (propertyMap.get("fdOrder") != null) {
				curOrderBy += modelName + ".fdOrder";
				if (propertyMap.get("fdName") != null)
					curOrderBy += "," + modelName + ".fdName";
			} else if (propertyMap.get("fdId") != null)
				curOrderBy += modelName + ".fdId desc";
			logger.debug("curOrderBy=" + curOrderBy);
		}
		return curOrderBy;
	}

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
