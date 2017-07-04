package com.landray.kmss.tib.common.log.actions;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.log.service.ITibCommonLogManageService;


/**
 * 日志管理 Action
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogManageAction extends ExtendAction {
	protected ITibCommonLogManageService tibCommonLogManageService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibCommonLogManageService == null)
			tibCommonLogManageService = (ITibCommonLogManageService)getBean("tibCommonLogManageService");
		return tibCommonLogManageService;
	}

	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		List<?> id = getServiceImp(request).findValue("fdId", null, null);
		if (id.size() != 0) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(
					(String) id.get(0), null, true);
			if (model != null)
				rtnForm = getServiceImp(request).convertModelToForm(
						(IExtendForm) form, model, new RequestContext(request));
			request.setAttribute(getFormName(rtnForm, request), rtnForm);
		} else {
			add(mapping, form, request, response);
		}

	}
	
}

