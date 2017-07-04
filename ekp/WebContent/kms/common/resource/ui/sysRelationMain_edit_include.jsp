<%@ include file="/resource/jsp/common.jsp"%>
<c:if test="${mainModelForm.method_GET=='add' || mainModelForm.method_GET=='edit'}">
	<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
	<c:set var="sysRelationMainPrefix" value="sysRelationMainForm." scope="request"/>
	<%@ include	file="/kms/common/resource/ui/sysRelationMain_edit.jsp"%>
</c:if>