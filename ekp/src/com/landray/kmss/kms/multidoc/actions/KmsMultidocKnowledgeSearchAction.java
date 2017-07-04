package com.landray.kmss.kms.multidoc.actions;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgePre;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.util.KmssMessages;

public class KmsMultidocKnowledgeSearchAction extends ExtendAction {

	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;
	
	protected IBaseService getServiceImp(
			HttpServletRequest request) {
		if (kmsMultidocKnowledgeService == null) {
			kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) getBean("kmsMultidocKnowledgeService");
		}
		return kmsMultidocKnowledgeService;
	}

	/*
	 * 组合查询
	 */
	public ActionForward preview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-preview", true, getClass());
		KmssMessages messages = new KmssMessages();
		JSONObject jsonObject = new JSONObject();
		KmsMultidocKnowledgePre docKnowlegePre = null;
		try {
			List<KmsMultidocKnowledgePre> docKnowledgePreList = (List<KmsMultidocKnowledgePre>) getServiceImp(
					request).findList(null, null);
			if (docKnowledgePreList.size() == 0) {
				throw new NoRecordException();
			}
			docKnowlegePre = docKnowledgePreList.get(0);
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		
		TimeCounter.logCurrentTime("Action-preview", true, getClass());
		if (messages.hasError()) {
			jsonObject.accumulate("error", messages);
		}

		if (docKnowlegePre != null) {
			jsonObject.accumulate("fdPreContent", docKnowlegePre
					.getFdPreContent());
		}
		
		// 写入http头部信息，输出json文本
		response.setContentType("application/jsonp");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		out.println(jsonObject.toString(1));
		return null;
	}
	
}
