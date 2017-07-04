<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>


<div class="txttitle"><bean:message bundle="sys-notify" key="sysNotifyTodo.dataUpdate.title"/></div>
<br>
<center>
<div>

	<kmss:auth requestURL="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=mngList&owner=false">
<input type="button"
			value="<bean:message bundle="sys-notify" key="sysNotifyTodo.dataUpdate.dobutton"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=updateLevelByDefault" />','_self')">
	</kmss:auth>


<br>
<br>

<bean:message bundle="sys-notify" key="sysNotifyTodo.dataUpdate.description"/>
</div>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>