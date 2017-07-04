<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_import/tibSysSapRfcImport.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_import/tibSysSapRfcImport.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_import/tibSysSapRfcImport.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_import/tibSysSapRfcImport.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapRfcImportForm, 'deleteall');">
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
				<sunbor:column property="tibSysSapRfcImport.fdOrder">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterUse">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterType">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterLength">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterLength"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterTypeName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterTypeName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterRequired">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterRequired"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParameterMark">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdHierarchyId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdFunction.fdId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdFunction"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcImport.fdParent.fdId">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSapRfcImport" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_import/tibSysSapRfcImport.do" />?method=view&fdId=${tibSysSapRfcImport.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSapRfcImport.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdOrder}" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibSysSapRfcImport.fdParameterUse}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdParameterName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdParameterType}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdParameterLength}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdParameterTypeName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibSysSapRfcImport.fdParameterRequired}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdParameterMark}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdFunction.fdId}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcImport.fdParent.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
