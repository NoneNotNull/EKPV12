<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<div id="relation_div">
			<c:if test="${!empty sysRelationMainForm && !empty sysRelationMainForm.sysRelationEntryFormList}">
				<ui:accordionpanel>
					<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
						<ui:content title="${sysRelationEntryForm.fdModuleName}" expand="${vstatus.index==0?'true':'false' }">
							<ui:dataview>
								<ui:source type="AjaxJson">
									{
										url:'/sys/relation/relation.do?method=loadRelationResult&forward=listUi&currModelId=${param.currModelId}&currModelName=${param.currModelName}&sortType=time&fdKey=${param.fdKey}&fdType=${sysRelationEntryForm.fdType}&moduleModelId=${sysRelationEntryForm.fdId}&showCreateInfo=${param.showCreateInfo}&moduleModelName=${sysRelationEntryForm.fdModuleModelName}'
									}
								</ui:source>
								<ui:render ref="sys.ui.classic.tile" var-showCreator="true" var-showCreated="true" var-ellipsis="false">
								</ui:render>
							</ui:dataview>	
						</ui:content>
					</c:forEach>
				</ui:accordionpanel>
			</c:if>
		</div>
	</template:replace>
</template:include>
<script>
// 自适应高度
function dyniFrameSize(){
	if(window!=parent){
		var arguObj = document.getElementById("relation_div");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = arguObj.offsetHeight + "px";
		}
    }
	setTimeout(dyniFrameSize,50);
}
</script>
<style>
body{
	background-color: white;
}
</style>