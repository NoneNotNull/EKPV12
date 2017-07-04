<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSapSyncTempFuncForm, 'deleteall');">
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
				<sunbor:column property="tibSapSyncTempFunc.fdInvokeType">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdInvokeType"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdFuncMark">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdFuncMark"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdRfcImport">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdRfcImport"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdRfcExport">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdRfcExport"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdUse">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdUse"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdQuartzTime">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdQuartzTime"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdRfcSetting.docSubject">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdRfcSetting"/>
				</sunbor:column>
				<sunbor:column property="tibSapSyncTempFunc.fdQuartz.fdId">
					<bean:message bundle="tib-sap-sync" key="tibSapSyncTempFunc.fdQuartz"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSapSyncTempFunc" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do" />?method=view&fdId=${tibSapSyncTempFunc.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSapSyncTempFunc.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSapSyncTempFunc.fdInvokeType}" />
				</td>
				<td>
					<c:out value="${tibSapSyncTempFunc.fdFuncMark}" />
				</td>
				<td>
					<c:out value="${tibSapSyncTempFunc.fdRfcImport}" />
				</td>
				<td>
					<c:out value="${tibSapSyncTempFunc.fdRfcExport}" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibSapSyncTempFunc.fdUse}" enumsType="common_yesno" />
				</td>
				<td>
					<kmss:showDate value="${tibSapSyncTempFunc.fdQuartzTime}" />
				</td>
				<td>
					<c:out value="${tibSapSyncTempFunc.fdRfcSetting.docSubject}" />
				</td>
				<td>
					<c:out value="${tibSapSyncTempFunc.fdQuartz.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
