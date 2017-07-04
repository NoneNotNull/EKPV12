<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<tr LKS_LabelName="<c:if test="${empty param.cateTitle}"><bean:message bundle="sys-simplecategory"
		key="table.sysSimpleCategory" /></c:if><c:if test="${not empty param.cateTitle}">${param.cateTitle}</c:if>">
		<td>
			<table class="tb_normal" width="100%" ${param.styleValue}>
		<c:import url="/kms/common/resource/ui/sysCategoryMain_edit_body.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="${param.formName}" />
			<c:param name="requestURL" value="${param.requestURL}" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
			<c:param name="mainModelName" value="${param.mainModelName}" />
		</c:import> 
			</table>
		</td>
	</tr>
