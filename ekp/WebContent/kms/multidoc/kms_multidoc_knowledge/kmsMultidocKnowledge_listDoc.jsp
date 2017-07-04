<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do">
<%
if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
%>
<%@ include file="/resource/jsp/list_norecord.jsp"%>
<%
} else {
%>
<div id="optBarDiv">
<kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsMultidocKnowledgeForm, 'deleteall');">
	</kmss:auth>
</div>
<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<table id="List_ViewTable">
	<tr>
		<sunbor:columnHead htmlTag="td">
			<td width="10pt"><input
				type="checkbox"
				name="List_Tongle"></td>
			<td width="40pt"><bean:message key="page.serial" /></td>
			<sunbor:column property="kmsMultidocKnowledge.docSubject">
				<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
			</sunbor:column>
			<sunbor:column property="kmsMultidocKnowledge.kmsMultidocTemplate.fdId">
				<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.fdTemplateName" />
			</sunbor:column>
			 
			<sunbor:column property="kmsMultidocKnowledge.docCreator.fdName">
				<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreator" />
			</sunbor:column>
			<sunbor:column property="kmsMultidocKnowledge.docDept.fdName">
				<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
			</sunbor:column>
			<sunbor:column property="kmsMultidocKnowledge.docStatus">
				<bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.docStatus" />
			</sunbor:column>
			<sunbor:column property="kmsMultidocKnowledge.docCreateTime">
				<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreateTime" />
			</sunbor:column>
		</sunbor:columnHead>
	</tr>
	<c:forEach
		items="${queryPage.list}"
		var="kmsMultidocKnowledge"
		varStatus="vstatus">
		<tr kmss_href="<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=${kmsMultidocKnowledge.fdId}" />" 
			kmss_target="_blank">
			<td><input type="checkbox" name="List_Selected" value="${kmsMultidocKnowledge.fdId}"></td>
			<td>${vstatus.index+1}</td>
			<td kmss_wordlength="50"><c:out value="${kmsMultidocKnowledge.docSubject}" /></td>
			<td><c:out value="${kmsMultidocKnowledge.kmsMultidocTemplate.fdName}" /></td>
			<td><c:out value="${kmsMultidocKnowledge.docCreator.fdName}" /></td>
			<td><c:out value="${kmsMultidocKnowledge.docDept.fdName}" /></td>
			<td><sunbor:enumsShow value="${kmsMultidocKnowledge.docStatus}" enumsType="common_status" /></td>
			<td><kmss:showDate value="${kmsMultidocKnowledge.docCreateTime}" type="datetime" /></td>
		</tr>
	</c:forEach>
</table>
<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
<%
}
%>

</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
