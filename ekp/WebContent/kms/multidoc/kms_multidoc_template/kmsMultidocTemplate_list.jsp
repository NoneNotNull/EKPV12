<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import
	url="/sys/right/tmp_right_batch_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate" />
</c:import>
<html:form action="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=add"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=add&parentId=${param.parentId}" />');">
	</kmss:auth> <kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsMultidocTemplateForm, 'deleteall');">
	</kmss:auth></div>
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input
					type="checkbox"
					name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="kmsMultidocTemplate.fdName">
					<bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.fdName" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocTemplate.docCategory.fdName">
					<bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.docCategoryName" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocTemplate.fdOrder">
					<bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.fdOrder" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocTemplate.docCreator.fdName">
					<bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.docCreatorName" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocTemplate.docCreateTime">
					<bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.docCreateTime" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach
			items="${queryPage.list}"
			var="kmsMultidocTemplate"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do" />?method=view&fdId=${kmsMultidocTemplate.fdId}">
				<td><input
					type="checkbox"
					name="List_Selected"
					value="${kmsMultidocTemplate.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmsMultidocTemplate.fdName}" /></td>
				<td><c:out value="${kmsMultidocTemplate.docCategory.fdName}" /></td>
				<td><c:out value="${kmsMultidocTemplate.fdOrder}" /></td>
				<td><c:out value="${kmsMultidocTemplate.docCreator.fdName}" /></td>
				<td><kmss:showDate
					value="${kmsMultidocTemplate.docCreateTime}"
					type="datetime" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
