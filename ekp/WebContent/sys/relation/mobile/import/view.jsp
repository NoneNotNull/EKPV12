<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"/>
<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
<c:set var="currModelId" value="${mainModelForm.fdId}" scope="request"/>
<c:set var="currModelName" value="${mainModelForm.modelClass.name}" scope="request"/>
<c:if test="${not empty sysRelationMainForm.sysRelationEntryFormList}">
	<div data-dojo-type="mui/tabbar/TabBarButton"
		data-dojo-props='icon1:"mui mui-rela",
			href:"/sys/relation/mobile/index.jsp?modelName=${mainModelForm.modelClass.name}&modelId=${mainModelForm.fdId}"'>关联</div>
</c:if>
