<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskEvaluate')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<%--删除--%>
			<kmss:auth
				 requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=deleteall" 
				 requestMethod="GET">							
				<ui:button text="${lfn:message('button.delete')}" onclick="del('sysTaskEvaluate.do?method=delete&fdId=${param.fdId}');"></ui:button>
			</kmss:auth>
			<%--关闭--%>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" href="/sys/task/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }" href="/sys/task/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<%--主内容--%>
	<template:replace name="content">
		<script>
			seajs.use(['lui/jquery','lui/dialog'], function($, dialog ) {
				//删除确认框
				window.del=function(url){
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							Com_OpenWindow(url,'_self');
						}
					});
				};
			});
		</script>
		<html:form action="/sys/task/sys_task_evaluate/sysTaskEvaluate.do" >
			<html:hidden property="fdId"/>
			<html:hidden property="fdTaskId"/>
			<html:hidden property="method_GET"/>
			<div class="lui_form_content_frame" >
				<p class="lui_form_subject">
					<bean:message bundle="sys-task" key="sysTaskEvaluate.detail" />
				</p>
				<table class="tb_normal" width=95%>
					<tr>
						<%--评价人--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskEvaluate.docCreatorId"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskEvaluateForm.docCreatorName}"/>
						</td>
						<%--评价时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskEvaluate.docCreateTime"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskEvaluateForm.docCreateTime}"/>
						</td>
					</tr>
					<tr>
						<%--满意度--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
						</td>
						<td width=85% colspan=3>
							<c:out value="${sysTaskEvaluateForm.fdApproveName}"/>
						</td>
					</tr>
					<tr>
						<%--评价说明--%>
						<td class="td_normal_title" width=15% valign="middle">
							<bean:message  bundle="sys-task" key="sysTaskEvaluate.docContent"/>
						</td>
						<td width=85% colspan=3>
							<c:out value="${sysTaskEvaluateForm.docContent}" escapeXml="false"></c:out>
						</td>
					</tr>
				</table>
			</div>
		</html:form>
	</template:replace>
	
</template:include>