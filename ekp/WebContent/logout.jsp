<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="org.acegisecurity.ui.rememberme.TokenBasedRememberMeServices" %>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<%@ page import="com.landray.kmss.util.StringUtil" %>
<%@ page import="com.landray.kmss.framework.plugin.core.config.IExtension" %>
<%@ page import="com.landray.kmss.framework.service.plugin.Plugin" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.landray.kmss.sys.log.service.ISysLogLogoutService" %>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<%
	String value = ResourceUtil.getKmssConfigString("kmss.isLogLoginEnabled");
	if (StringUtil.isNotNull(value) && value.equals("true") && !UserUtil.getKMSSUser(request).isAnonymous()) {
		ISysLogLogoutService sysLogLogoutService = (ISysLogLogoutService) WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext()).getBean("sysLogLogoutService");
		sysLogLogoutService.saveLogoutInfo(request.getRemoteAddr(),UserUtil.getKMSSUser(request).getPerson());
	}
	session.setAttribute("manualLogout","true");
	session.invalidate();
	Cookie terminate = new Cookie(TokenBasedRememberMeServices.ACEGI_SECURITY_HASHED_REMEMBER_ME_COOKIE_KEY, null);
	terminate.setMaxAge(0);
	response.addCookie(terminate);
	String logoutUrl = request.getParameter("logoutUrl");
	if(StringUtil.isNull(logoutUrl)){
		IExtension extensioin = Plugin.getExtension(
				"com.landray.kmss.sys.authentication", "*", "redirectURL");
		if (extensioin != null) {
			logoutUrl = Plugin.getParamValueString(extensioin,
					"logoutUrl");
		}
		if(StringUtil.isNull(logoutUrl)){
			logoutUrl = request.getContextPath() + "/";
		}else{
			String homeUrl = ResourceUtil.getKmssConfigString("kmss.urlPrefix");
			logoutUrl = StringUtil.replace(logoutUrl, "${url}", homeUrl);
		}
	}
	response.sendRedirect(logoutUrl);
%>