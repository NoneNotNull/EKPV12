<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/time/sys_time_area/sysTimeArea.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/time/sys_time_area/sysTimeArea.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/time/sys_time_area/sysTimeArea.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_area/sysTimeArea.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTimeAreaForm, 'deleteall');">
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
				<sunbor:column property="sysTimeArea.fdName">
					<bean:message  bundle="sys-time" key="sysTimeArea.fdName"/>
				</sunbor:column>
				<td>
					<bean:message  bundle="sys-time" key="sysTimeArea.scope"/>
				</td>
				<td>
					<bean:message  bundle="sys-time" key="sysTimeArea.timeAdmin"/>
				</td>
				<sunbor:column property="sysTimeArea.docCreator.fdName">
					<bean:message  bundle="sys-time" key="sysTimeArea.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTimeArea.docCreateTime">
					<bean:message  bundle="sys-time" key="sysTimeArea.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTimeArea" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/time/sys_time_area/sysTimeArea.do" />?method=view&fdId=${sysTimeArea.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTimeArea.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTimeArea.fdName}" />
				</td>
				<td>
					<kmss:joinListProperty value="${sysTimeArea.areaMembers}" properties="fdName" split=";"/>				
				</td>			
				<td>
					<kmss:joinListProperty value="${sysTimeArea.areaAdmins}" properties="fdName" split=";"/>	
				</td>	
				<td>
					<c:out value="${sysTimeArea.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTimeArea.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>