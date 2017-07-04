<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<%
String ru = request.getParameter("requestURL");
String a = ru.substring(ru.lastIndexOf("/")+1);
%>
<div id="optBarDiv"><kmss:auth
	requestURL="${param.requestURL}?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('<%=a%>?method=edit&fdId=${param.fdId}&fdModelName=${param.fdModelName}','_self');">
</kmss:auth> <kmss:auth
	requestURL="${param.requestURL}?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('<%=a%>?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
