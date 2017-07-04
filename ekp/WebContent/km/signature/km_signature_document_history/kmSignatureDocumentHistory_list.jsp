<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSignatureDocumentHistoryForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmSignatureDocumentHistory.fdMarkName">
					<bean:message bundle="km-signature" key="documentHistory.markname"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentHistory.fdUserName">
					使用用户
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentHistory.fdDateTime">
					使用时间
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSignatureDocumentHistory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do" />?method=view&fdId=${kmSignatureDocumentHistory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSignatureDocumentHistory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmSignatureDocumentHistory.fdMarkName}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentHistory.fdUserName}" />
				</td>
				<td>
					<kmss:showDate value="${kmSignatureDocumentHistory.fdDateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>