<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%-- 标签页标题--%>
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-task:module.sys.task') }"></c:out>
	</template:replace>
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" href="/sys/task/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<%--主内容--%>
	<template:replace name="content">
		<%--标题--%>
		<p class="lui_form_subject">
			<c:out value="${param.orgName}"></c:out>-<bean:message key="sysTaskAnalyze.detail"  bundle="sys-task"/>
		</p>
		<div style="text-align: center;padding: 10px;">
			<%--list视图--%>
			<list:listview id="listview">
				<ui:source type="AjaxJson">
					{url:'/sys/task/sys_task_main/sysTaskMain.do?method=${param.method}&fdId=${param.fdId}&orgId=${param.orgId}&isincludechild=${param.isincludechild}&isincludechildtask=${param.isincludechildtask}&fdStartDate=${param.fdStartDate}&fdEndDate=${param.fdEndDate}&dateQueryType=${param.dateQueryType}'}
				</ui:source>
				<%--列表形式--%>
				<list:colTable isDefault="false" layout="sys.ui.listview.listtable" 
					rowHref="/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=!{fdId}"  name="columntable">
					<list:col-serial></list:col-serial>
					<list:col-auto props=""></list:col-auto>
				</list:colTable>   
			</list:listview> 
			<br>
		 	<list:paging></list:paging>	 
	 	</div>
	</template:replace>
</template:include>
