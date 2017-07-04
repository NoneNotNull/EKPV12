package com.landray.kmss.tib.common.init.actions;

import java.util.List;
import java.util.Map;

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
import com.landray.kmss.tib.common.init.interfaces.ITibCommonInitExecute;
import com.landray.kmss.tib.common.init.plugins.TibCommonInitPlugin;
import com.landray.kmss.tib.common.init.service.ITibCommonInitService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;


/**
 * 主文档 Action
 * 
 * @author 
 * @version 1.0 2013-06-17
 */
public class TibCommonInitAction extends ExtendAction {
	protected ITibCommonInitService tibCommonInitService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibCommonInitService == null)
			tibCommonInitService = (ITibCommonInitService)getBean("tibCommonInitService");
		return tibCommonInitService;
	}
	
	/**
	 * 显示初始化页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward showInit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			ITibCommonInitService initService = (ITibCommonInitService)getServiceImp(request);
			List<String> jspList = initService.getJspPathList();
			request.setAttribute("jspList", jspList);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("edit", mapping, form, request, response);
		}
	}
	
	/**
	 * 测试连接
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward testConn(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionMessages message = new ActionMessages();
		// 测试连接，失败则返回错误信息
		String isSuccess = "";
		try {
			String moduleType = request.getParameter("moduleType");
			Map<String, String> map = TibCommonInitPlugin.getConfigByKey(moduleType);
			ITibCommonInitExecute initExecute = (ITibCommonInitExecute) 
					SpringBeanUtil.getBean(map.get("springBean"));
			isSuccess = initExecute.testConn(request);
			ITibCommonInitService initService = (ITibCommonInitService)getServiceImp(request);
			List<String> jspList = initService.getJspPathList();
			request.setAttribute("jspList", jspList);
			// 默认选中
			request.setAttribute("moduleType", moduleType);
		} catch (Exception e) {
			isSuccess = "测试连接发生异常："+ e.toString();
			e.printStackTrace();
		}
		
		if (StringUtil.isNull(isSuccess)) {
			message.add("success", new ActionMessage(ResourceUtil.getString(
					"tib-common-init:init.connection.success", request.getLocale()),
					false));
			saveMessages(request, message);
		} else {
			message.add("failure", new ActionMessage(ResourceUtil.getString(
					"tib-common-init:init.connection.failure", request.getLocale())
					+ isSuccess, false));
			saveErrors(request, message);
		}
		return mapping.findForward("edit");
	}
	
	/**
	 * 导入标准数据包
	 */
	public ActionForward importInitStandData(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
					throws Exception {
		ActionMessages message = new ActionMessages();
		String moduleType = request.getParameter("moduleType");
		ITibCommonInitService initService = (ITibCommonInitService)getServiceImp(request);
		List<String> jspList = initService.getJspPathList();
		request.setAttribute("jspList", jspList);
		// 默认选中
		request.setAttribute("moduleType", moduleType);
		try {
			Map<String, String> map = TibCommonInitPlugin.getConfigByKey(moduleType);
			ITibCommonInitExecute initExecute = (ITibCommonInitExecute) 
					SpringBeanUtil.getBean(map.get("springBean"));
			// 进行文件导入
			initExecute.importInitJar(request);
		} catch (Exception e) {
			e.printStackTrace();
			message.add("failure", new ActionMessage(ResourceUtil.getString(
					"tib-common-init:init.import.failure", request.getLocale())
					+ e.toString(), false));
			saveErrors(request, message);
			return mapping.findForward("edit");
		}
		message.add("success", new ActionMessage(ResourceUtil.getString(
				"tib-common-init:init.import.success", request.getLocale()),
				false));
		saveMessages(request, message);
		return mapping.findForward("edit");
	}
}

