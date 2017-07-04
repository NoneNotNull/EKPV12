<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" />
<c:if test="${mainModelForm.method_GET=='view'}">
	<%@ include	file="/sys/relation/sys_relation_main_many/sysRelationMain_view_script.jsp"%>
</c:if>
