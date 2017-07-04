<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysSimpleCategoryMain" value="${requestScope[param.formName]}" />
	<div id="optBarDiv"><c:if
		test="${sysSimpleCategoryMain.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.${param.formName}, 'update');" />
	</c:if> <c:if test="${sysSimpleCategoryMain.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.${param.formName}, 'save');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

