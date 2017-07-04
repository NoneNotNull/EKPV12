<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.mainModelForm]}"/>
<c:set var="currModelName" value="${param.currModelName}"/>
<c:if test="${not empty currModelName}">
	<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
	<c:set var="currModelId" value="${mainModelForm.fdId}" scope="request"/>
	<iframe id="relationIframe" src="<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do" />?method=view&forward=docView&fdId=${sysRelationMainForm.fdId}&currModelId=${currModelId}&currModelName=${currModelName}&fdKey=${fdKey}&showCreateInfo=${showCreateInfo}&frameName=sysRelationContent"
		 width=100% frameborder=0 scrolling=no >
	</iframe>
</c:if>