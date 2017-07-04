<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/signature/km_signature_category/kmSignatureCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/signature/km_signature_category/kmSignatureCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/signature/km_signature_category/kmSignatureCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/signature/km_signature_category/kmSignatureCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSignatureCategoryForm, 'deleteall');">
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
				<sunbor:column property="signatureCategory.fdName">
					<bean:message bundle="km-signature" key="signatureCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="signatureCategory.fdOrder">
					<bean:message bundle="km-signature" key="signatureCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="signatureCategory.fdHierarchyId">
					<bean:message bundle="km-signature" key="signatureCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="signatureCategory.fdParent.fdName">
					<bean:message bundle="km-signature" key="signatureCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="signatureCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/signature/km_signature_category/kmSignatureCategory.do" />?method=view&fdId=${signatureCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${signatureCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${signatureCategory.fdName}" />
				</td>
				<td>
					<c:out value="${signatureCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${signatureCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${signatureCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>