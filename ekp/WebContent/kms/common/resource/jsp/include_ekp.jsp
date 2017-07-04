<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%
	String KMSS_Parameter_Style="default"; // 
	request.setAttribute("KMSS_Parameter_Style", KMSS_Parameter_Style);
	String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
	request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
	String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath+"resource/";
	request.setAttribute("KMSS_Parameter_ResPath", KMSS_Parameter_ResPath);
	String KMSS_Parameter_StylePath = KMSS_Parameter_ResPath + "style/"+KMSS_Parameter_Style+"/";
	request.setAttribute("KMSS_Parameter_StylePath", KMSS_Parameter_StylePath);
	request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil.getUser().getFdId());
	request.setAttribute("currentUser", UserUtil.getKMSSUser(request));
	
	String Kms_Theme_Path_CSS = request.getContextPath() + "/kms/common/theme/default";
	request.setAttribute("kmsThemePathCss", Kms_Theme_Path_CSS);
	 
%>
<script type="text/javascript">
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