<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<%@page import="com.landray.kmss.web.filter.ResourceCacheFilter"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	
<script>
<%
	String KMSS_Parameter_Style = "default";
	request.setAttribute("KMSS_Parameter_Style", KMSS_Parameter_Style);
	String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
	request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
	String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath+"resource/";
	request.setAttribute("KMSS_Parameter_ResPath", KMSS_Parameter_ResPath);
	String KMSS_Parameter_StylePath = KMSS_Parameter_ResPath + "style/"+KMSS_Parameter_Style+"/";
	request.setAttribute("KMSS_Parameter_StylePath", KMSS_Parameter_StylePath);
	request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil.getKMSSUser(request).getUserId());
	request.setAttribute("LUI_Cache",ResourceCacheFilter.cache);
%>
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	Lang:"<%= ResourceUtil.getLocaleStringByUser(request) %>",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}",
	Cache:${ LUI_Cache }
};
</script>
<script type="text/javascript" src='<c:url value="/resource/js/common.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resource/js/jquery.js"/>'></script>