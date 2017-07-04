<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSoapSyncTempFuncForm, 'deleteall');">
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
				<sunbor:column property="tibSoapSyncTempFunc.fdInvokeType">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncTempFunc.fdInvokeType"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncTempFunc.fdFuncMark">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncTempFunc.fdFuncMark"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncTempFunc.fdUse">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncTempFunc.fdUse"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncTempFunc.fdQuartzTime">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncTempFunc.fdQuartzTime"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncTempFunc.fdQuartz.fdId">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncTempFunc.fdQuartz"/>
				</sunbor:column>
				<sunbor:column property="tibSoapSyncTempFunc.fdSoapMain.docSubject">
					<bean:message bundle="tib-soap-sync" key="tibSoapSyncTempFunc.fdSoapMain"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSoapSyncTempFunc" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do" />?method=view&fdId=${tibSoapSyncTempFunc.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSoapSyncTempFunc.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSoapSyncTempFunc.fdInvokeType}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncTempFunc.fdFuncMark}" />
				</td>
				<td>
					<xform:radio value="${tibSoapSyncTempFunc.fdUse}" property="fdUse" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<kmss:showDate value="${tibSoapSyncTempFunc.fdQuartzTime}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncTempFunc.fdQuartz.fdId}" />
				</td>
				<td>
					<c:out value="${tibSoapSyncTempFunc.fdSoapMain.docSubject}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>