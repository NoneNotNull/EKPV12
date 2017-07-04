<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<tr LKS_LabelName="<c:if test="${empty param.cateTitle}"><bean:message bundle="sys-simplecategory"
		key="table.sysSimpleCategory" /></c:if><c:if test="${not empty param.cateTitle}">${param.cateTitle}</c:if>">
		<td>
			<table class="tb_normal" width="100%" ${param.styleValue}>
		<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_view_body.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="${param.formName}" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
		</c:import> 
			</table>
		</td>
	</tr>
