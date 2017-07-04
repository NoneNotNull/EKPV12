<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do">
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>

	<%
	} else {
	%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				</td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="kmsMultidocKnowledge.docSubject">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocKnowledge.docCreator.fdName">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreator" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocKnowledge.docCreateTime">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreateTime" />
				</sunbor:column>
				<sunbor:column property="kmsMultidocKnowledge.docDept.fdName">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsMultidocKnowledge"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=view&fdId=${kmsMultidocKnowledge.fdId}"
				kmss_target="_blank">
				<td width="40pt">${vstatus.index+1}</td>
				<td width="300pt" style="text-align:left"><c:out value="${kmsMultidocKnowledge.docSubject}" />
				</td>
				<td width="100pt" style="text-align:center"><c:out
					value="${kmsMultidocKnowledge.docCreator.fdName}" /></td>
				<td width="100pt" style="text-align:center"><kmss:showDate
					value="${kmsMultidocKnowledge.docCreateTime}" type="datetime" /></td>
				<td width="150pt" style="text-align:center"><c:out
					value="${kmsMultidocKnowledge.docDept.fdName}" /></td>
			</tr>
		</c:forEach>
	</table>

	<%
	}
	%>
	<table border="0" width="100%">
		<tr>
			<td align="right"><a href="#"
				onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=list&ownerId=${ownerId}"/>','_blank')">
			<bean:message bundle="kms-multidoc" key="kmsMultidoc.title.more" /></a></td>
		</tr>
	</table>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
