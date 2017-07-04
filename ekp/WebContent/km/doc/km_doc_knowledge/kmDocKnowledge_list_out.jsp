<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/doc/km_doc_knowledge/kmDocKnowledge.do">
<div>
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
				<sunbor:column property="kmDocKnowledge.docSubject">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
				</sunbor:column>
				<sunbor:column property="kmDocKnowledge.docCreator.fdName">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreator" />
				</sunbor:column>
				<sunbor:column property="kmDocKnowledge.docCreateTime">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreateTime" />
				</sunbor:column>
				<sunbor:column property="kmDocKnowledge.docDept.fdName">
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmDocKnowledge"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=view&fdId=${kmDocKnowledge.fdId}"
				kmss_target="_blank">
				<td width="40pt">${vstatus.index+1}</td>
				<td width="300pt" style="text-align:left"><c:out value="${kmDocKnowledge.docSubject}" />
				</td>
				<td width="100pt" style="text-align:center"><c:out
					value="${kmDocKnowledge.docCreator.fdName}" /></td>
				<td width="150pt" style="text-align:center"><kmss:showDate
					value="${kmDocKnowledge.docCreateTime}" type="datetime" /></td>
				<td width="150pt" style="text-align:center"><c:out
					value="${kmDocKnowledge.docDept.fdName}" /></td>
			</tr>
		</c:forEach>
	</table>

	<%
	}
	%>
	<table border="0" width="100%">
		<tr>
			<td align="right"><a href="#"
				onclick="Com_OpenWindow('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=list&ownerId=${ownerId}"/>','_blank')">
			<bean:message bundle="km-doc" key="kmDoc.title.more" /></a></td>
		</tr>
	</table>
</html:form>

<script>
window.onload = function(){
	setTimeout(dyniFrameSize,100);
};
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.forms[0];
		if (arguObj != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch (e) {}
};
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
