/**
 * 
 */
package com.landray.kmss.km.review.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.DataAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 二级页面主页对应action
 * 
 * @author 傅游翔
 * 
 */
public class KmReviewIndexAction extends DataAction {

	private IKmReviewMainService kmReviewMainService;

	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmReviewMainService == null) {
			kmReviewMainService = (IKmReviewMainService) getBean("kmReviewMainService");
		}
		return kmReviewMainService;
	}

	@Override
	protected String getParentProperty() {
		return "fdTemplate";
	}

	private ISysCategoryMainService categoryMainService;

	@Override
	protected IBaseService getCategoryServiceImp(HttpServletRequest request) {
		if (categoryMainService == null)
			categoryMainService = (ISysCategoryMainService) getBean("sysCategoryMainService");
		return categoryMainService;
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

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		hqlInfo.setOrderBy(getFindPageOrderBy(request, hqlInfo.getOrderBy()));
		StringBuilder hql = new StringBuilder(" 1=1 ");
		CriteriaValue cv = new CriteriaValue(request);
		String categoryId = cv.poll("fdTemplate");
		if (StringUtil.isNotNull(categoryId)) {
			// 默认 show all
			SysCategoryMain category = (SysCategoryMain) getCategoryServiceImp(
					request).findByPrimaryKey(categoryId, null, true);
			if (category != null) {
				hql
						.append(" and kmReviewMain.fdTemplate.docCategory.fdHierarchyId like :category");
				hqlInfo.setParameter("category", category.getFdHierarchyId()
						+ "%");
			} else {
				hql.append(" and kmReviewMain.fdTemplate.fdId = :template");
				hqlInfo.setParameter("template", categoryId);
			}
		}
		String docProperties = cv.poll("docProperties");
		if (StringUtil.isNotNull(docProperties)) {
			hql.append(" and kmReviewMain.docProperties.fdId = :docProperties");
			hqlInfo.setParameter("docProperties", docProperties);
		}
		CriteriaUtil.buildHql(cv, hqlInfo, KmReviewMain.class);
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			hql.append(" and ").append(hqlInfo.getWhereBlock());
		}
		hqlInfo.setWhereBlock(hql.toString());
		buildHomeZoneHql(cv, hqlInfo, request);
	}

	private void buildHomeZoneHql(CriteriaValue cv, HQLInfo hqlInfo,
			HttpServletRequest request) {
		String whereStr = hqlInfo.getWhereBlock();
		StringBuilder where = new StringBuilder(
				StringUtil.isNull(whereStr) ? "1=1 " : whereStr);
		String self = cv.poll("selfdoc");
		String tadoc = cv.poll("tadoc");
		boolean isSelfDoc = StringUtil.isNotNull(self);
		String mydoc = isSelfDoc ? self : tadoc;
		String userId = isSelfDoc ? UserUtil.getUser().getFdId() : request
				.getParameter("userid");

		if (StringUtil.isNull(userId) || StringUtil.isNull(mydoc)) {
			return;
		}

		if (StringUtil.isNotNull(mydoc)) {
			// 我启动的流程
			mydoc = mydoc.trim().toLowerCase();
			if ("create".equals(mydoc)) {
				where.append(" and kmReviewMain.docCreator.fdId=:docCreator");
				hqlInfo.setParameter("docCreator", userId);
				hqlInfo.setWhereBlock(where.toString());
			} else if ("approved".equals(mydoc) && isSelfDoc) {
				SysFlowUtil.buildLimitBlockForMyApproved("kmReviewMain",
						hqlInfo);
			} else if ("approval".equals(mydoc) && isSelfDoc) {
				SysFlowUtil.buildLimitBlockForMyApproval("kmReviewMain",
						hqlInfo);
			}
		}
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
			String whereBlockOri = hqlInfo.getWhereBlock();
			if (StringUtil.isNotNull(whereBlockOri)) {
				whereBlock = whereBlockOri + " and (" + whereBlock + ")";
			}
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
