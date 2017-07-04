<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapServerSettingForm, 'deleteall');">
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
				<sunbor:column property="tibSysSapServerSetting.fdServerCode">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdServerCode"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapServerSetting.fdServerName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdServerName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapServerSetting.fdServerIp">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdServerIp"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapServerSetting.fdTibSysSapCode">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdTibSysSapCode"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapServerSetting.fdClientCode">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdClientCode"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapServerSetting.fdLanguage">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdLanguage"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapServerSetting.fdUpdateTime">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdUpdateTime"/>
				</sunbor:column>
				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSapServerSetting" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do" />?method=view&fdId=${tibSysSapServerSetting.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSapServerSetting.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSapServerSetting.fdServerCode}" />
				</td>
				<td>
					<c:out value="${tibSysSapServerSetting.fdServerName}" />
				</td>
				<td>
					<c:out value="${tibSysSapServerSetting.fdServerIp}" />
				</td>
				<td>
					<c:out value="${tibSysSapServerSetting.fdTibSysSapCode}" />
				</td>
				<td>
					<c:out value="${tibSysSapServerSetting.fdClientCode}" />
				</td>
				<td>
					<c:out value="${tibSysSapServerSetting.fdLanguage}" />
				</td>
				<td>
					<kmss:showDate value="${tibSysSapServerSetting.fdUpdateTime}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
