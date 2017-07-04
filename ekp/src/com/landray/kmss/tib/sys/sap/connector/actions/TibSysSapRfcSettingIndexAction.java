/**
 * 
 */
package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * @author qiujh
 * @version 1.0 2013-12-11
 */
public class TibSysSapRfcSettingIndexAction extends ExtendAction {
	protected ITibSysSapRfcSettingService tibSysSapRfcSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapRfcSettingService == null)
			tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) getBean("tibSysSapRfcSettingService");
		return tibSysSapRfcSettingService;
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
			if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
				hqlInfo.setWhereBlock(hqlInfo.getWhereBlock()
						+ " and docOriginDoc=null");
			} else {
				hqlInfo.setWhereBlock("docOriginDoc=null");
			}
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			e.printStackTrace();
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
	
	protected void changeFindPageHQLInfo(HttpServletRequest request, HQLInfo hqlInfo)
			throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		if (StringUtil.isNotNull(categoryId)) {
			hqlInfo.setWhereBlock(" tibSysSapRfcSetting.docCategory.fdHierarchyId like :docCategoryFdHierarchyId");
			hqlInfo.setParameter("docCategoryFdHierarchyId", "%" + categoryId + "%");
		}
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSysSapRfcSetting.class);
	}
	
}
