<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.mainModelForm]}"/>
<c:set var="currModelName" value="${param.currModelName}"/>
<c:set var="currModelId" value="${param.currModelId}"/>
<c:if test="${not empty currModelName}"> 
	<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
	<iframe id="relationIframe" src="<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do" />?method=view&forward=docView&fdId=${requestScope.sysRelationMainForm.fdId}&currModelId=${requestScope.currModelId}&currModelName=${requestScope.currModelName}&fdKey=${requestScope.fdKey}&showCreateInfo=${requestScope.showCreateInfo}&frameName=sysRelationContent"
		 width=100% frameborder=0 scrolling=no  >
	</iframe>
</c:if>
 