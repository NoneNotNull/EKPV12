package com.landray.kmss.kms.multidoc.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.BaseAction;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgePreService;
import com.landray.kmss.util.KmssMessages;

public class KmsMultidocKnowlegePreAction extends BaseAction {

	protected IKmsMultidocKnowledgePreService kmsMultidocKnowledgePreService;

	protected IKmsMultidocKnowledgePreService getServiceImp(
			HttpServletRequest request) {
		if (kmsMultidocKnowledgePreService == null) {
			kmsMultidocKnowledgePreService = (IKmsMultidocKnowledgePreService) getBean("kmsMultidocKnowledgePreService");
		}
		return kmsMultidocKnowledgePreService;
	}

	/*
	 * 显示知识预览-旧版
	 */
	public ActionForward preview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-preview", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			// 当前父分类id
			String currid = request.getParameter("currid");
			String content = getServiceImp(request).updatePre(currid);
			JSONArray jsonArray = JSONArray.fromObject(content);
			request.setAttribute("lui-source", jsonArray);
			TimeCounter.logCurrentTime("Action-preview", true, getClass());
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		if (messages.hasError()) {
			return mapping.findForward("lui-failure");
		} else {
			return mapping.findForward("lui-source");
		}
	}

}
