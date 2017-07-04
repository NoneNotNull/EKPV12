package com.landray.kmss.common.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

public abstract class SimpleCategoryNodeAction extends ExtendAction {
	public abstract ISysSimpleCategoryService getSysSimpleCategoryService();

	protected abstract String getParentProperty();

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
					whereBlock += buildCategoryHQL(hqlInfo,treeModel,tableName);
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
	 * 拼接分类HQL
	 */
	protected String buildCategoryHQL(HQLInfo hqlInfo, IBaseTreeModel treeModel,
			String tableName) {
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

}
