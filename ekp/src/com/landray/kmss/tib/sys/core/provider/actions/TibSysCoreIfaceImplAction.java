package com.landray.kmss.tib.sys.core.provider.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceImplForm;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceImplService;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;

/**
 * 接口实现 Action
 * 
 * @author 
 * @version 1.0 2013-08-08
 */
public class TibSysCoreIfaceImplAction extends ExtendAction {
	protected ITibSysCoreIfaceImplService tibSysCoreIfaceImplService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysCoreIfaceImplService == null)
			tibSysCoreIfaceImplService = (ITibSysCoreIfaceImplService)getBean("tibSysCoreIfaceImplService");
		return tibSysCoreIfaceImplService;
	}
	
	/**
	 * 判断接口xml是否修改过，然后处理
	 */
	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		boolean flag = false;
		try {
			loadActionForm(mapping, form, request, response);
			TibSysCoreIfaceImplForm ifaceImplForm = (TibSysCoreIfaceImplForm)form;
			if (ifaceImplForm.getFdIfaceXmlStatus().equals("1")) {
				flag = true;
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-view", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			if (flag) {
				ActionMessages message = new ActionMessages();
				message.add("success", new ActionMessage(ResourceUtil.getString(
						"tib-sys-core-provider:tibSysCoreIfaceImpl.ifaceXmlStatus.change", request.getLocale()), 
						false));
				saveMessages(request, message);
			}
			return getActionForward("view", mapping, form, request, response);
		}
	}
	
	/**
	 * 判断接口xml是否修改过，然后处理
	 */
	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		boolean flag = false;
		try {
			loadActionForm(mapping, form, request, response);
			TibSysCoreIfaceImplForm ifaceImplForm = (TibSysCoreIfaceImplForm)form;
			if (ifaceImplForm.getFdIfaceXmlStatus().equals("1")) {
				flag = true;
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			if (flag) {
				ActionMessages message = new ActionMessages();
				message.add("success", new ActionMessage(ResourceUtil.getString(
						"tib-sys-core-provider:tibSysCoreIfaceImpl.ifaceXmlStatus.change", request.getLocale()), 
						false));
				saveMessages(request, message);
			}
			return getActionForward("edit", mapping, form, request, response);
		}
	}
}

