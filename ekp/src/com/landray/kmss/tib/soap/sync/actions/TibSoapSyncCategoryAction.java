package com.landray.kmss.tib.soap.sync.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncCategoryService;


/**
 * 配置/分类信息 Action
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public class TibSoapSyncCategoryAction extends ExtendAction {
	protected ITibSoapSyncCategoryService tibSoapSyncCategoryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSoapSyncCategoryService == null)
			tibSoapSyncCategoryService = (ITibSoapSyncCategoryService)getBean("tibSoapSyncCategoryService");
		return tibSoapSyncCategoryService;
	}

	@Override
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionForward forward = super.deleteall(mapping, form, request, response);
		if ("failure".equals(forward.getName())) {
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("tree", mapping, form, request, response);
		}
		
	}

}

