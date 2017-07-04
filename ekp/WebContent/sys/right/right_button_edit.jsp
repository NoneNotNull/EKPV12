<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="com.landray.kmss.sys.right.forms.ChangeRightForm"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js");
</script>
<kmss:windowTitle subjectKey="sys-right:right.change.title"
	 moduleKey="${param.moduleMessageKey}" />
<html:form action="/sys/right/right.do?method=rightUpdate">
	<div id="optBarDiv"><html:submit>
		<bean:message key="button.submit" />
	</html:submit><input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>
	<center>
	<table class="tb_normal" width=100%>
		<html:hidden property="fdId" /> 
		<input type="hidden" name="moduleModelName" value="${param.moduleModelName }">
		<%
		if(StringUtil.isNotNull(request.getParameter("authReaderNoteFlag"))){
			((ChangeRightForm)request.getAttribute("changeRightForm")).setAuthReaderNoteFlag(request.getParameter("authReaderNoteFlag"));
		}
		%> 
		<c:import url="/sys/right/right_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="changeRightForm" />
			<c:param name="moduleModelName" value="${param.moduleModelName}" />
		</c:import>
	</table>
	</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
