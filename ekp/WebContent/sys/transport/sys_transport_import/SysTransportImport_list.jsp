<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/transport/sys_transport_import/SysTransportImport.do">
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.add"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do" />?method=add&fdModelName=${param.fdModelName }');">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTransportImportForm, 'deleteall');">
</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysTransportImportConfig.fdName">
					<bean:message  bundle="sys-transport" key="fdName"/>
				</sunbor:column>
				<sunbor:column property="sysTransportImportConfig.fdImportType">
					<bean:message  bundle="sys-transport" key="fdImportType"/>
				</sunbor:column>
				<sunbor:column property="sysTransportImportConfig.creator.fdOrder">
					<bean:message  bundle="sys-transport" key="creator"/>
				</sunbor:column>
				<sunbor:column property="sysTransportImportConfig.createTime">
					<bean:message  bundle="sys-transport" key="createTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="config" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do" />?method=view&fdId=${config.fdId}&fdModelName=${param.fdModelName }">
				<td>
					<input type="checkbox" name="List_Selected" value="${config.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${config.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${config.fdImportType}"
							enumsType="sysTransport_importType" bundle="sys-transport"/>
				</td>
				<td>
					<c:out value="${config.creator.fdName}" />
				</td>
				<td>
					<sunbor:date value="${config.createTime}"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>