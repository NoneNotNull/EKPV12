<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSignatureDocumentMainForm, 'deleteall');">
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
				<sunbor:column property="kmSignatureDocumentMain.fdDocumentId">
					<bean:message bundle="km-signature" key="document.documentid"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdRecordId">
					<bean:message bundle="km-signature" key="document.recordid"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdDocNo">
					<bean:message bundle="km-signature" key="document.docno"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdUserName">
					<bean:message bundle="km-signature" key="document.username"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdSecurity">
					<bean:message bundle="km-signature" key="document.security"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdDraft">
					<bean:message bundle="km-signature" key="document.draft"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdAuditor">
					<bean:message bundle="km-signature" key="document.check1"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdTitle">
					<bean:message bundle="km-signature" key="document.title"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.copyto">
					<bean:message bundle="km-signature" key="document.fdCopyTo"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.docSubject">
					<bean:message bundle="km-signature" key="document.subject"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdCopies">
					<bean:message bundle="km-signature" key="document.copies"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentMain.fdDateTime">
					<bean:message bundle="km-signature" key="document.datetime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSignatureDocumentMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do" />?method=view&fdId=${kmSignatureDocumentMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSignatureDocumentMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdDocumentId}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdRecordId}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdDocNo}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdUserName}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdSecurity}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdDraft}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdAuditor}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdTitle}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdCopyTo}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdCopies}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentMain.fdDateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>