<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSoapSyncCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibSoapSyncCategory.fdName">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncCategory.fdOrder">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncCategory.fdHierarchyId">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncCategory.fdParent.fdName">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSoapSyncCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory.do" />?method=view&fdId=${tibSoapSyncCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSoapSyncCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSoapSyncCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>