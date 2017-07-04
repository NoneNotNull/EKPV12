<%@page import="com.landray.kmss.web.filter.ResourceCacheFilter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ include file="/resource/jsp/common.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="No-Cache">
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
	request.setAttribute("currentUser", UserUtil.getKMSSUser(request));
	request.setAttribute("LUI_Cache",ResourceCacheFilter.cache);
%>
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	Cache:${ LUI_Cache }
};
</script>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js?s_cache=${LUI_Cache}"></script>
<script>
var S_PortalInfo = {
	welcome:"${lfn:message('home.welcome')}",
	home:"${lfn:message('home.home')}",
	logout:"${lfn:message('home.logout')}",
	UserName:"<c:out value="${currentUser.userName}" />"
};

function logout(){
	if(confirm('<bean:message key="home.logout.confirm"/>')){
		Com_OpenWindow('<c:url value="/logout.jsp"/>','_self');
	}
}
Com_IncludeFile("ctrlframe.js");
</script>
<link rel="shortcut icon" href="${KMSS_Parameter_ContextPath}favicon.ico">