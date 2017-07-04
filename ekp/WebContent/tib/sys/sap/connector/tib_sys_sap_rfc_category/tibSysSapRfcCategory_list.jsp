<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapRfcCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibSysSapRfcCategory.fdName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcCategory.fdOrder">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcCategory.fdHierarchyId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcCategory.fdParent.fdName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSapRfcCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do" />?method=view&fdId=${tibSysSapRfcCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSapRfcCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSapRfcCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
