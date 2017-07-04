package com.landray.kmss.common.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 * Action拦截器接口
 * 
 * @author 叶中奇
 */
public interface IActionInterceptor {
	/**
	 * 执行拦截器，类是过滤器的写法，请执行chain.execute(mapping, form, request,
	 * response);使整个Action能继续运行
	 * 
	 * @param chain
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	ActionForward execute(IActionChain chain, ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception;
}
