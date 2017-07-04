<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="useTab" value="false" scope="request"/>
<c:if test="${ param.formName!=null}">
	<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"/>
	<c:set var="currModelName" value="${mainModelForm.modelClass.name}" scope="request"/>
	<c:set var="useTab" value="${param.useTab}" scope="request"/>
</c:if>
<c:if test="${mainModelForm.method_GET=='add' || mainModelForm.method_GET=='edit'}">
	<c:set var="sysRelationMainForm" value="${mainModelForm.sysRelationMainForm}" scope="request"/>
	<c:set var="sysRelationMainPrefix" value="sysRelationMainForm." scope="request"/>
	<c:if test="${useTab == true || useTab=='true' }">
		<tr LKS_LabelName='<bean:message bundle="sys-relation" key="sysRelationMain.relation.info"/>' style="display:none">
			<td>
	</c:if>
	<%@include file="/sys/relation/sys_relation_main/sysRelationMain_edit.jsp"%>
	<c:if test="${useTab == true || useTab=='true' }">
			</td>
		</tr>
	</c:if>
</c:if>