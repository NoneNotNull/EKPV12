<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSapSyncCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibSapSyncCategory.fdName">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncCategory.fdOrder">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncCategory.fdHierarchyId">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncCategory.fdParent.fdName">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSapSyncCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do" />?method=view&fdId=${tibSapSyncCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSapSyncCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSapSyncCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibSapSyncCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibSapSyncCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibSapSyncCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
