<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%--@ include file="kmDocKnowledge_list_query.jsp"--%>
<%
if (((com.sunbor.web.tag.Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
%>
<%@ include file="/resource/jsp/list_norecord.jsp"%>
<%
} else {
%>
<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<table id="List_ViewTable">
	<tr>
		<sunbor:columnHead htmlTag="td">
			<td width="10px"><input
				type="checkbox"
				name="List_Tongle"></td>
			<td width="40px"><bean:message key="page.serial" /></td>
			<sunbor:column property="kmDocKnowledge.docSubject">
				<bean:message
					bundle="sys-doc"
					key="sysDocBaseInfo.docSubject" />
			</sunbor:column>
			<sunbor:column property="kmDocKnowledge.docCreator.fdName">
				<bean:message
					bundle="sys-doc"
					key="sysDocBaseInfo.docCreator" />
			</sunbor:column>
			<sunbor:column property="kmDocKnowledge.docDept.fdName">
				<bean:message
					bundle="sys-doc"
					key="sysDocBaseInfo.docDept" />
			</sunbor:column>
			<sunbor:column property="kmDocKnowledge.docStatus">
				<bean:message
					bundle="km-doc"
					key="kmDoc.kmDocKnowledge.docStatus" />
			</sunbor:column>
			<sunbor:column property="kmDocKnowledge.docCreateTime">
				<bean:message
					bundle="sys-doc"
					key="sysDocBaseInfo.docCreateTime" />
			</sunbor:column>
		</sunbor:columnHead>
	</tr>
	<c:forEach
		items="${queryPage.list}"
		var="kmDocKnowledge"
		varStatus="vstatus">
		<tr kmss_href="<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId=${kmDocKnowledge.fdId}" />" 
			kmss_target="_blank">
			<td><input
				type="checkbox"
				name="List_Selected"
				value="${kmDocKnowledge.fdId}"></td>
			<td>${vstatus.index+1}</td>
			<td kmss_wordlength="50"><c:out value="${kmDocKnowledge.docSubject}" /></td>
			<td><c:out value="${kmDocKnowledge.docCreator.fdName}" /></td>
			<td><c:out value="${kmDocKnowledge.docDept.fdName}" /></td>
			<td><sunbor:enumsShow
				value="${kmDocKnowledge.docStatus}"
				enumsType="common_status" /></td>
			<td><kmss:showDate
				value="${kmDocKnowledge.docCreateTime}"
				type="datetime" /></td>
		</tr>
	</c:forEach>
</table>
<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
<%
}
%>
