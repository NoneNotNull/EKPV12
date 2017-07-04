<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="_status" value="${param.status}" scope="page" />
<%--未启动 --%>
<c:if test="${_status =='1' }">
	<div class="muiTaskStatusTag muiTaskInactive">
		<bean:message key="sysTaskMain.status.inactive" bundle="sys-task"/>
	</div>
</c:if>
<%--进行中 --%>
<c:if test="${_status =='2' }">
	<div class="muiTaskStatusTag muiTaskProgress">
		<bean:message key="sysTaskMain.status.progress" bundle="sys-task"/>
	</div>
</c:if>
<%--完成 --%>
<c:if test="${_status =='3' }">
	<div class="muiTaskStatusTag muiTaskComplete">
		<bean:message key="sysTaskMain.status.complete" bundle="sys-task"/>
	</div>
</c:if>
<%--暂停 --%>
<c:if test="${_status =='4' }">
	<div class="muiTaskStatusTag muiTaskTerminate">
		<bean:message key="sysTaskMain.status.terminate" bundle="sys-task"/>
	</div>
</c:if>
<%--已驳回--%>
<c:if test="${_status=='5' }">
	<div class="muiTaskStatusTag muiTaskOverrule">
		<bean:message key="sysTaskMain.status.overrule" bundle="sys-task" />
	</div>
</c:if>
<%--结项--%>
<c:if test="${_status=='6' }">
	<div class="muiTaskStatusTag muiTaskClose">
		<bean:message key="sysTaskMain.status.close" bundle="sys-task"/>
	</div>
</c:if>
