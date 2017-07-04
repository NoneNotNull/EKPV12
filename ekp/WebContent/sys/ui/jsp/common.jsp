<%@page import="com.landray.kmss.web.filter.ResourceCacheFilter"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/sunbor.tld" prefix="sunbor"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
if(request.getAttribute("LUI_ContextPath")==null){
	String LUI_ContextPath = request.getContextPath();
	request.setAttribute("LUI_ContextPath", LUI_ContextPath);
	request.setAttribute("LUI_CurrentTheme",SysUiPluginUtil.getThemeById("default"));
	request.setAttribute("LUI_Cache",ResourceCacheFilter.cache);
	request.setAttribute("KMSS_Parameter_Style", "default");
	request.setAttribute("KMSS_Parameter_ContextPath", LUI_ContextPath+"/");
	request.setAttribute("KMSS_Parameter_ResPath", LUI_ContextPath+"/resource/");
	request.setAttribute("KMSS_Parameter_StylePath", LUI_ContextPath+"/resource/style/default/");
	request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil.getKMSSUser(request).getUserId());
	request.setAttribute("KMSS_Parameter_Lang", UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-'));
}
%>