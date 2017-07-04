<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/search/sys_search_main/sysSearchMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/search/sys_search_main/sysSearchMain.do?method=add&fdModelName=${param.fdModelName}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/search/sys_search_main/sysSearchMain.do" />?method=add&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/search/sys_search_main/sysSearchMain.do?method=deleteall&fdModelName=${param.fdModelName}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysSearchMainForm, 'deleteall');">
		</kmss:auth>
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
				<sunbor:column property="sysSearchMain.fdName">
					<bean:message  bundle="sys-search" key="sysSearchMain.fdName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysSearchMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/search/sys_search_main/sysSearchMain.do" />?method=view&fdId=${sysSearchMain.fdId}&fdModelName=${param.fdModelName}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysSearchMain.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysSearchMain.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>