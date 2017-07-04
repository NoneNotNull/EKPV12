<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:if test="${param.fdModeType!=2}">
	<kmss:auth
		requestURL="/sys/xform/base/sys_form_db_table/sysFormDbTable.do?method=config&fdModelName=${param.fdModelName}&fdTemplateModel=${param.fdTemplateModel}&fdFormType=${param.fdFormType}&fdModelId=${param.fdModelId}"
		requestMethod="GET">
		<c:url var="mappingUrl" scope="page" value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="config"/>
			<c:param name="fdFormId" value="${param.fdTemplateId}"/>
			<c:param name="fdKey" value="${param.fdKey}"/>
			<c:param name="fdModelName" value="${param.fdModelName}"/>
			<c:param name="fdTemplateModel" value="${param.fdTemplateModel}"/>
			<c:param name="fdFormType" value="${param.fdFormType}"/>
			<c:param name="fdModelId" value="${param.fdModelId}"/>
		</c:url>
		<ui:button order="1" parentId="toolbar" text="${ lfn:message('sys-xform:table.sysFormDbTable.btn') }" 
			onclick="Com_OpenWindow('${mappingUrl }', '_blank');">
		</ui:button>
	</kmss:auth>
</c:if>