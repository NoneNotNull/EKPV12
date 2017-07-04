<%@ include file="/resource/jsp/common.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="javax.servlet.http.Cookie, com.landray.kmss.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Pragma" content="No-Cache"/>
<meta http-equiv="x-ua-compatible" content="IE=6"/>
<script type="text/javascript">
<%
	String KMSS_Parameter_Style = "default";
	request.setAttribute("KMSS_Parameter_Style", KMSS_Parameter_Style);
	String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
	request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
	String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath+"resource/";
	request.setAttribute("KMSS_Parameter_ResPath", KMSS_Parameter_ResPath);
	String KMSS_Parameter_StylePath = KMSS_Parameter_ResPath + "style/"+KMSS_Parameter_Style+"/";
	request.setAttribute("KMSS_Parameter_StylePath", KMSS_Parameter_StylePath);
	request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil.getUser().getFdId());
%>
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	Lang:"<%= request.getLocale().toString().toLowerCase().replace('_', '-') %>",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}"
};
</script>
<link rel="shortcut icon" href="${KMSS_Parameter_ContextPath}favicon.ico"> 
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js"></script>