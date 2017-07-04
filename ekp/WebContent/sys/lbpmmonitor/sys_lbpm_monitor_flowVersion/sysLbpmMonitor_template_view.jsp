<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.view" sidebar="auto">
	<template:replace name="title">
		<c:out
			value="${ requestScope[formName].docSubject } - ${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			<ui:button text="${lfn:message('button.close')}" order="5"
				onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" id="simplecategoryId">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }" href="/sys/lbpmmonitor/index.jsp" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.versionMng') }" href="/sys/lbpmmonitor/sys_lbpm_monitor_flowVersion/index.jsp" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="content">

		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
				<c:if test="${empty lbpmTemplate.fdName}">
					<c:out value="${templateName}" />
				</c:if>
				<c:if test="${not empty lbpmTemplate.fdName}">
					<c:out value="${lbpmTemplate.fdName}" />
				</c:if>
			</div>
		</div>

		<div class="lui_form_content_frame">
			<table class="tb_normal" width=100%>
				<tr>
					<td><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.table.versionNum" /></td>
					<td><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.table.processCount" /></td>
					<td><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.table.finishProcessCount" /></td>
				</tr>
				<c:forEach items="${processCountList}" varStatus="status" var="processItem">
					<tr>
						<td>${ processItem[0] }</td>
						<td>${ processItem[1] }</td>
						<td>${finishedProcessCountList[status.index][1] }</td>
					</tr>
				</c:forEach>
			</table>
		</div>

	</template:replace>



</template:include>