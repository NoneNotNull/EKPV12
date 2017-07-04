package com.landray.kmss.common.actions;

import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.struts.LookupDispatchActionSupport;

/**
 * Action基类，不建议直接继承，仅当ExtendAction完全无法满足实际业务需求时才继承该类。<br>
 * 使用范围：Action层代码，作为基类继承。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class BaseAction extends LookupDispatchActionSupport {
	private static ApplicationContext ctx = null;

	protected final Map getKeyMethodMap() {
		return null;
	}

	protected String getLookupMapName(HttpServletRequest request,
			String keyName, ActionMapping mapping) throws ServletException {
		return keyName;
	}

	/**
	 * 根据spring配置的业务对象名称，取得业务对象实例。
	 * 
	 * @param name
	 *            spring配置的业务对象名称
	 * @return spring的业务对象（service）
	 */
	protected Object getBean(String name) {
		return getSpringApplicationContext().getBean(name);
	}

	protected ApplicationContext getSpringApplicationContext() {
		if (ctx == null) {
			ctx = WebApplicationContextUtils
					.getRequiredWebApplicationContext(servlet
							.getServletContext());
		}
		return ctx;
	}
}
