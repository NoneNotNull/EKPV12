<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<center>
<table class="tb_normal" width="100%" style="margin-top: -14px;">
	<tr>
		<td class="tr_normal_title" width="25px;"> 
			<bean:message key="page.serial" />
		</td>
		<td class="td_normal_title">
			<bean:message bundle="third-pda" key="pdaModuleConfigView.fdName"/>
		</td>
	</tr>
	<c:forEach items="${pdaModuleConfigMainForm.fdViewItems}" var="pdaModuleConfigViewForm" varStatus="vstatus">
		<tr>
			<td>${vstatus.index+1}</td>
			<td><c:out value="${pdaModuleConfigViewForm.fdName}" /></td>
		</tr>
	</c:forEach>
	</table>
</center>
