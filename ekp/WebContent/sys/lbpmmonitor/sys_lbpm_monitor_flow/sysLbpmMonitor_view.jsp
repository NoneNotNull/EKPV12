<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="auto">
	<template:replace name="title">
		<c:out value="${ requestScope.docSubject } - ${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="2">
			<ui:button text="${lfn:message('button.close')}" order="5"
				onclick="Com_CloseWindow();">
			</ui:button>
			<ui:button text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.originDoc.view')}" order="4"
				onclick="javascript:Com_OpenWindow('${LUI_ContextPath }${modelViewPageUrl}','_blank');">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams id="simplecategoryId"
				moduleTitle="${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }"
				href="#" />
		</ui:combin>
	</template:replace>
	<template:replace name="content">

		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
				<a href="${LUI_ContextPath }${modelViewPageUrl}" target="_blank" class='lui_form_subject'>
					<c:if test="${not empty requestScope.docSubject}">
						<c:out value="${requestScope.docSubject}" />
					</c:if>
				</a>
			</div>
		</div>

		<div class="lui_form_content_frame">
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.flow.fdId" /></td>
					<td width=35%><c:out value="${sysLbpmMonitorForm.fdModelId}" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.flow.status" /></td>
					<td width=35%>
						<c:if test="${sysLbpmMonitorForm.docStatus=='20'}">
							<bean:message bundle="sys-lbpmmonitor" key="status.activated" />
						</c:if>
						<c:if test="${sysLbpmMonitorForm.docStatus=='21'}">
							<bean:message bundle="sys-lbpmmonitor" key="status.error" />
						</c:if>
						<c:if test="${sysLbpmMonitorForm.docStatus=='30'}">
							<bean:message bundle="sys-lbpmmonitor" key="status.completed" />
						</c:if>
						<c:if test="${sysLbpmMonitorForm.docStatus=='00'}">
							<bean:message bundle="sys-lbpmmonitor" key="status.discard" />
						</c:if>
						<c:if test="${sysLbpmMonitorForm.docStatus=='40'}">
							<bean:message bundle="sys-lbpmmonitor" key="status.suspend" />
						</c:if>
					</td>
				</tr>
				<td class="td_normal_title" width=15%><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.flow.docAuthor" /></td>
					<td width=35%><ui:person personId="${creator.fdId}"
					personName="${creator.fdName}"></ui:person></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="sys-lbpmmonitor" key="sysLbpmMonitor.flow.docAuthorTime" /></td>
					<td width=35%>
						<c:out value="${createdTime}"></c:out>
					</td>
				</tr>
			</table>
		</div>

		<ui:tabpage expand="false" >
			<%--流程机制 --%>
			<c:import url="/sys/lbpmmonitor/import/sysLbpmMonitorProcess_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="sysLbpmMonitorForm" />
				<c:param name="fdKey" value="${sysLbpmMonitorForm.fdKey}" />
				<c:param name="roleType" value="authority" />
				<c:param name="isSimpleWorkflow" value="true" />
			</c:import>
		</ui:tabpage>
		
	</template:replace>

</template:include>