<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="kmCollaborateMainForm" value="${requestScope[param.formName]}" />
<c:set var="communicateUrl"
value="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add&fdModelName=${kmCollaborateMainForm.modelClass.name}&fdModelId=${kmCollaborateMainForm.fdId}&key=${param.key}" />
<kmss:auth requestURL="${communicateUrl}" requestMethod="GET">
	<c:if test="${empty param.commuTitle}">
		<c:set var="_contentBtnTitle" value="${lfn:message('km-collaborate:table.kmCollaborateMainTitle')}"/>
	</c:if>
	<c:if test="${not empty param.commuTitle}">
		<c:set var="_contentBtnTitle" value="${param.commuTitle}"/>
	</c:if>
	<ui:button parentId="toolbar" text="${_contentBtnTitle}" 
		onclick="Com_OpenWindow('${communicateUrl}','_blank');" order="3">
	</ui:button>
</kmss:auth>
<c:if test="${empty param.commuTitle}">
	<c:set var="_contentTitle" value="${lfn:message('km-collaborate:kmCollaborateMain.tab.communicate.label')}"/>
</c:if>
<c:if test="${not empty param.commuTitle}">
	<c:set var="_contentTitle" value="${param.commuTitle}"/>
</c:if>
<ui:content title="${_contentTitle}">
	<ui:event event="show">
		document.getElementById('communicateContent').src = '<c:url value="/km/collaborate/import/kmCollaborateMain_list.jsp"/>?fdModelId=${kmCollaborateMainForm.fdId}&fdModelName=${kmCollaborateMainForm.modelClass.name}&include=enter';
	</ui:event>
	<table width="100%" ${param.styleValue}>
		<tr>
			<td>
				<iframe src="" width=100% height="1000" frameborder=0 scrolling="no" id="communicateContent">
				</iframe>
			</td>
		</tr>
	</table>
</ui:content>

