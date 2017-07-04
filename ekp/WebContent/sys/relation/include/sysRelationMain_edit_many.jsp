<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" />
<c:if test="${mainModelForm.method_GET=='add' || mainModelForm.method_GET=='edit'}">	
	<%@ include	file="/sys/relation/sys_relation_main_many/sysRelationMain_edit_many_script.jsp"%>
</c:if>
