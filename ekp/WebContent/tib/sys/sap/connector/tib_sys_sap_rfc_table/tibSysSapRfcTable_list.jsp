<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_table/tibSysSapRfcTable.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_table/tibSysSapRfcTable.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_table/tibSysSapRfcTable.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_table/tibSysSapRfcTable.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapRfcTableForm, 'deleteall');">
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
				<sunbor:column property="tibSysSapRfcTable.fdOrder">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdUse">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdUse"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdParameterName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdParameterType">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterType"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdParameterLength">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterLength"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdParameterTypeName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterTypeName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdParameterRequired">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterRequired"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdMark">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdMark"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdFunction">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdFunction"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdParentId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcTable.fdHierarchyId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdHierarchyId"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSapRfcTable" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_table/tibSysSapRfcTable.do" />?method=view&fdId=${tibSysSapRfcTable.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSapRfcTable.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdUse}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdParameterName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdParameterType}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdParameterLength}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdParameterTypeName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdParameterRequired}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdMark}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdFunction}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdParentId}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcTable.fdHierarchyId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
