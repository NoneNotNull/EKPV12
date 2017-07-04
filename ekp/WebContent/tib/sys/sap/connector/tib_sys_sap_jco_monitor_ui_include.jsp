<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/tib/common/tib_ui_list.jsp">
	<template:replace name="title">${ lfn:message('tib-common:module.tib.manage') }</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;" id="categoryId">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('tib-common:module.tib.common') }" href="/tib/common/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('tib-sys-sap-connector:module.tib.sys.sap.connector') }" href="/tib/sys/sap/connector/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('tib-sys-sap-connector:table.tibSysSapConnectingSetting') }" href="/tib/sys/sap/connector/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoCheck') }" href="/tib/sys/sap/connector/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<%-- 右边框内容 --%>
	<template:replace name="content">
		<%-- 显示列表按钮行 --%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td align="right">
						<ui:toolbar>
							<ui:button text="${lfn:message('button.refresh')}" onclick="location.reload();"></ui:button>
						</ui:toolbar>						
					</td>
				</tr>
			</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/tib/sys/sap/connector/tib_sys_sap_jco_monitor_ui.jsp'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="" name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>   
		</list:listview> 
		
		<br>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>