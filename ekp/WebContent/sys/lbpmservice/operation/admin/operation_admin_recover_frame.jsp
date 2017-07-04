<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.constant.LbpmConstants" %>
<%@ include file="/resource/jsp/common.jsp"%>
<!doctype html>
<html>
	<head>
		<meta http-equiv="x-ua-compatible" content="IE=5"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><bean:message key="lbpmNode.processingNode.adminrecover.dialog.title" bundle="sys-lbpmservice"/></title>
	</head>

<script type="text/javascript">
<%
	String KMSS_Parameter_Style = request.getParameter("s_css");
	if(KMSS_Parameter_Style==null || KMSS_Parameter_Style.equals("")){
		Cookie[] cookies = request.getCookies();
		if (cookies != null && cookies.length > 0)
			for (int i = 0; i < cookies.length; i++)
				if ("KMSS_Style".equals(cookies[i].getName())) {
					KMSS_Parameter_Style = cookies[i].getValue();
					break;
				}
	}
	if(KMSS_Parameter_Style==null || KMSS_Parameter_Style.equals(""))
		KMSS_Parameter_Style="default";
	pageContext.setAttribute("KMSS_Parameter_Style", KMSS_Parameter_Style);
	String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
	pageContext.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
	String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath+"resource/";
	pageContext.setAttribute("KMSS_Parameter_ResPath", KMSS_Parameter_ResPath);
	String KMSS_Parameter_StylePath = KMSS_Parameter_ResPath + "style/"+KMSS_Parameter_Style+"/";
	pageContext.setAttribute("KMSS_Parameter_StylePath", KMSS_Parameter_StylePath);
%>
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}"
}; 
</script>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js"></script>
<script src="<c:url value="/sys/lbpm/flowchart/js/workflow.js"/>"></script>

<frameset framespacing=1 bordercolor=#003048 frameborder=1 rows="*">
	<frame frameborder="0" noresize scrolling="yes" id="topFrame"
		src="<c:url value="/sys/lbpmservice/operation/admin/operation_admin_recover_select.jsp"/>" onload="">
</frameset>
</html>

