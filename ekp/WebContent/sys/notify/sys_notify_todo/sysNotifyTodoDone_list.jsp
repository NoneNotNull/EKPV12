<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysNotifyTodoForm, 'deleteall');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<form action="<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do"/>" 
		method="POST" 
		name="sysNotifyTodoForm">
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input
					type="checkbox"
					name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="sysNotifyTodoDoneInfo.todo.fdSubject">
					<bean:message
						bundle="sys-notify"
						key="sysNotifyTodo.fdSubject" />
				</sunbor:column>
				<c:if test="${showApp==1}">
					<sunbor:column property="sysNotifyTodoDoneInfo.todo.fdAppName">
						<bean:message
							bundle="sys-notify"
							key="sysNotifyTodo.fdAppName" />
					</sunbor:column>
				</c:if>
				<c:if test="${param.fdType == null || param.fdType == ''}">
					<sunbor:column property="sysNotifyTodoDoneInfo.todo.fdType">
						<bean:message
							bundle="sys-notify"
							key="sysNotifyTodo.cate.title" />
					</sunbor:column>
				</c:if>
				<sunbor:column property="sysNotifyTodoDoneInfo.todo.fdCreateTime">
					<bean:message
						bundle="sys-notify"
						key="sysNotifyTodo.fdCreateDate" />
				</sunbor:column>
				<sunbor:column property="sysNotifyTodoDoneInfo.fdFinishTime">
					<bean:message
						bundle="sys-notify"
						key="sysNotifyTodo.finishDate" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach
			items="${queryPage.list}"
			var="sysNotifyTodoDoneInfo"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="${sysNotifyTodoDoneInfo.todo.fdLink}"/>">
				<td><input
					type="checkbox"
					name="List_Selected"
					value="${sysNotifyTodoDoneInfo.todo.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td style="text-align: left;" title="${sysNotifyTodoDoneInfo.todo.subject4View}">
					<c:choose>
						<c:when test="${fn:length(sysNotifyTodoDoneInfo.todo.subject4View)>33}">${fn:substring(sysNotifyTodoDoneInfo.todo.subject4View,0,32)}...</c:when>
						<c:otherwise><c:out value="${sysNotifyTodoDoneInfo.todo.subject4View}" /></c:otherwise>
					</c:choose>
				</td>
				<c:if test="${showApp==1}">
					<td>
						<c:set var="appName" value="${sysNotifyTodoDoneInfo.todo.fdAppName}"/>
						<c:choose>
							<c:when test="${appName==null || appName=='' }">
								<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.local.application.ekp.notify" />
							</c:when>
							<c:otherwise>
								<c:out value="${appName}"/>
							</c:otherwise>
						</c:choose>
					</td>
				</c:if>
				<c:if test="${param.fdType == null || param.fdType == ''}">
					<td><sunbor:enumsShow value="${sysNotifyTodoDoneInfo.todo.fdType}" enumsType="sys_todo_cate" bundle="sys-notify"/></td>
				</c:if>
				<td><kmss:showDate value="${sysNotifyTodoDoneInfo.todo.fdCreateTime}" type="datetime" /></td>
				<td><kmss:showDate value="${sysNotifyTodoDoneInfo.fdFinishTime}" type="datetime" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>