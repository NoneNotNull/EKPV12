<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_export/tibSysSapRfcExport.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_export/tibSysSapRfcExport.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_export/tibSysSapRfcExport.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_export/tibSysSapRfcExport.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapRfcExportForm, 'deleteall');">
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
				<sunbor:column property="tibSysSapRfcExport.fdOrder">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdParameterUse">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdParameterUse"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdParameterName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdParameterName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdParameterType">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdParameterType"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdParameterTypeName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdParameterTypeName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdParameterMark">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdParameterMark"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdHierarchyId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdFunction.fdId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdFunction"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcExport.fdParent.fdId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcExport.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSapRfcExport" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_export/tibSysSapRfcExport.do" />?method=view&fdId=${tibSysSapRfcExport.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSapRfcExport.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdOrder}" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibSysSapRfcExport.fdParameterUse}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdParameterName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdParameterType}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdParameterTypeName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdParameterMark}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdFunction.fdId}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcExport.fdParent.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
