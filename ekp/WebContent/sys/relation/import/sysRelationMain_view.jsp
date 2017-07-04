<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"/>
<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
<c:set var="currModelId" value="${mainModelForm.fdId}" scope="request"/>
<c:set var="currModelName" value="${mainModelForm.modelClass.name}" scope="request"/>
<c:if test="${not empty sysRelationMainForm.sysRelationEntryFormList}">
	<ui:accordionpanel style="min-width:200px;"> 
		<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" 
			varStatus="vstatus" var="sysRelationEntryForm">
				<c:set var="isExpanded" value="true"/>
				<c:if test="${ vstatus.index > 2}">
					<c:set var="isExpanded" value="false"/>
				</c:if>
				<ui:content title="${sysRelationEntryForm.fdModuleName}" expand="${isExpanded}">
					<ui:dataview>
						<ui:source type="AjaxJson">
							{
								url:'/sys/relation/relation.do?method=result&forward=listUi&currModelId=${currModelId}&currModelName=${currModelName}&fdKey=${param.fdKey}&sortType=time&fdType=${sysRelationEntryForm.fdType}&moduleModelId=${sysRelationEntryForm.fdId}&moduleModelName=${sysRelationEntryForm.fdModuleModelName}&showCreateInfo=${param.showCreateInfo}'
							}
						</ui:source>
						<ui:render ref="sys.ui.classic.tile" var-showCreator="true" var-showCreated="true" var-ellipsis="false">
						</ui:render>
						<ui:event event="load">
							if(window.Sidebar_Refresh){
								Sidebar_Refresh(true);
							}
						</ui:event>
					</ui:dataview>		
				</ui:content>
		</c:forEach>
	</ui:accordionpanel> 
</c:if>