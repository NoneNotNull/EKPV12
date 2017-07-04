package com.landray.kmss.common.exception;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.config.ExceptionConfig;

import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;

/**
 * 用于处理struts action产生的错误，其他地方不需要关注。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class ExceptionHandler extends org.apache.struts.action.ExceptionHandler {
	public ActionForward execute(Exception ex, ExceptionConfig ae,
			ActionMapping mapping, ActionForm formInstance,
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException {
		logException(ex);
		KmssMessages messages = new KmssMessages();
		messages.addError(ex);
		KmssReturnPage.getInstance(request).addMessages(messages).setTitle(
				new KmssMessage("errors.unknown")).save(request);
		return mapping.findForward("failure");
	}
}
