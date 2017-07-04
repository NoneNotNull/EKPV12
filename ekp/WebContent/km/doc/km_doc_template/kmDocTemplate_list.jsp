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
		value="com.landray.kmss.km.doc.model.KmDocTemplate" />
</c:import>
<html:form action="/km/doc/km_doc_template/kmDocTemplate.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/km/doc/km_doc_template/kmDocTemplate.do?method=add"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/km/doc/km_doc_template/kmDocTemplate.do?method=add&parentId=${param.parentId}" />');">
	</kmss:auth> <kmss:auth
		requestURL="/km/doc/km_doc_template/kmDocTemplate.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmDocTemplateForm, 'deleteall');">
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
				<sunbor:column property="kmDocTemplate.fdName">
					<bean:message
						bundle="km-doc"
						key="kmDocTemplate.fdName" />
				</sunbor:column>
				<sunbor:column property="kmDocTemplate.docCategory.fdName">
					<bean:message
						bundle="km-doc"
						key="kmDocTemplate.docCategoryName" />
				</sunbor:column>
				<sunbor:column property="kmDocTemplate.fdOrder">
					<bean:message
						bundle="km-doc"
						key="kmDocTemplate.fdOrder" />
				</sunbor:column>
				<sunbor:column property="kmDocTemplate.docCreator.fdName">
					<bean:message
						bundle="km-doc"
						key="kmDocTemplate.docCreatorName" />
				</sunbor:column>
				<sunbor:column property="kmDocTemplate.docCreateTime">
					<bean:message
						bundle="km-doc"
						key="kmDocTemplate.docCreateTime" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach
			items="${queryPage.list}"
			var="kmDocTemplate"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="/km/doc/km_doc_template/kmDocTemplate.do" />?method=view&fdId=${kmDocTemplate.fdId}">
				<td><input
					type="checkbox"
					name="List_Selected"
					value="${kmDocTemplate.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmDocTemplate.fdName}" /></td>
				<td><c:out value="${kmDocTemplate.docCategory.fdName}" /></td>
				<td><c:out value="${kmDocTemplate.fdOrder}" /></td>
				<td><c:out value="${kmDocTemplate.docCreator.fdName}" /></td>
				<td><kmss:showDate
					value="${kmDocTemplate.docCreateTime}"
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
