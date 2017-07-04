<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSignatureDocumentSignatureForm, 'deleteall');">
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
				<sunbor:column property="kmSignatureDocumentSignature.fdDocumentSignatureId">
					<bean:message bundle="km-signature" key="documentSignature.id"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentSignature.fdRecordId">
					<bean:message bundle="km-signature" key="documentSignature.recordid"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentSignature.fdFieldName">
					<bean:message bundle="km-signature" key="documentSignature.fieldname"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentSignature.fdFieldValue">
					<bean:message bundle="km-signature" key="documentSignature.fieldvalue"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentSignature.fdUserName">
					<bean:message bundle="km-signature" key="documentSignature.username"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentSignature.fdDateTime">
					<bean:message bundle="km-signature" key="documentSignature.datetime"/>
				</sunbor:column>
				<sunbor:column property="kmSignatureDocumentSignature.fdHostName">
					<bean:message bundle="km-signature" key="documentSignature.hostname"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSignatureDocumentSignature" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do" />?method=view&fdId=${kmSignatureDocumentSignature.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSignatureDocumentSignature.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmSignatureDocumentSignature.fdDocumentSignatureId}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentSignature.fdRecordId}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentSignature.fdFieldName}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentSignature.fdFieldValue}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentSignature.fdUserName}" />
				</td>
				<td>
					<kmss:showDate value="${kmSignatureDocumentSignature.fdDateTime}" />
				</td>
				<td>
					<c:out value="${kmSignatureDocumentSignature.fdHostName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>