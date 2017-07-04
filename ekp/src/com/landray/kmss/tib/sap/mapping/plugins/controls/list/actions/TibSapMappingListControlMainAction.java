package com.landray.kmss.tib.sap.mapping.plugins.controls.list.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.service.ITibSapMappingListControlMainService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;


/**
 * 主文档 Action
 * 
 * @author 
 * @version 1.0 2013-04-17
 */
public class TibSapMappingListControlMainAction extends ExtendAction {
	protected ITibSapMappingListControlMainService tibSapMappingListControlMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSapMappingListControlMainService == null)
			tibSapMappingListControlMainService = (ITibSapMappingListControlMainService)getBean("tibSapMappingListControlMainService");
		return tibSapMappingListControlMainService;
	}

	@Override
	public ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		return super.list(mapping, form, request, response);
	}
	
	public ActionForward include(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String isMulti = request.getParameter("isMulti");
			String rfcName = request.getParameter("rfcName");
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
			hqlInfo.setRowSize(10);
			changeFindPageHQLInfo(request, hqlInfo);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("isMulti", isMulti);
			request.setAttribute("rfcName", rfcName);
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
			return getActionForward("include", mapping, form, request, response);
		}
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String fdKey = request.getParameter("fdKey");
		String titleNames = request.getParameter("titleNames");
		String fieldNames = request.getParameter("fieldNames");
		String searchKeys = request.getParameter("searchKeys");
		String whereBlock = hqlInfo.getWhereBlock();
		whereBlock = StringUtil.linkString(whereBlock, "and", "tibSapMappingListControlMain.fdKey = :fdKey ");
		hqlInfo.setParameter("fdKey", fdKey);
		// 添加搜索条件
		if (titleNames != null && fieldNames != null && searchKeys != null) {
			String[] titleNameArr = titleNames.split("-split-");
			String[] fieldNameArr = fieldNames.split("-split-");
			String[] searchNameArr = searchKeys.split("-split-");
			for (int i = 0, len = searchNameArr.length; i < len; i++) {
				whereBlock += " and tibSapMappingListControlMain.fdShowData like '%th:''"+ titleNameArr[i] +"'',td:''%"+ searchNameArr[i] +"%'',value:''"+ fieldNameArr[i] +"''%'";
			}
		}
		hqlInfo.setWhereBlock(whereBlock);
		request.setAttribute("searchKeys", searchKeys);
	}
	
	public ActionForward sapSearch(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String isMulti = request.getParameter("isMulti");
			String rfcName = request.getParameter("rfcName");
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
			hqlInfo.setRowSize(10);
			changeFindPageHQLInfo(request, hqlInfo);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("isMulti", isMulti);
			request.setAttribute("rfcName", rfcName);
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
			return getActionForward("include", mapping, form, request, response);
		}
	}

}

