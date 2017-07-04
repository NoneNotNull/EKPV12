<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_setting_ext/tibSysSoapSettingExt.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_setting_ext/tibSysSoapSettingExt.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/soap/connector/tib_sys_soap_setting_ext/tibSysSoapSettingExt.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_setting_ext/tibSysSoapSettingExt.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSoapSettingExtForm, 'deleteall');">
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
				<sunbor:column property="tibSysSoapSettingExt.fdWsExtName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapSettingExt.fdWsExtValue">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtValue"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapSettingExt.fdServer.docSubject">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdServer"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSoapSettingExt" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/soap/connector/tib_sys_soap_setting_ext/tibSysSoapSettingExt.do" />?method=view&fdId=${tibSysSoapSettingExt.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSoapSettingExt.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSoapSettingExt.fdWsExtName}" />
				</td>
				<td>
					<c:out value="${tibSysSoapSettingExt.fdWsExtValue}" />
				</td>
				<td>
					<c:out value="${tibSysSoapSettingExt.fdServer.docSubject}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
