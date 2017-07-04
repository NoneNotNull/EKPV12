<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">选择树菜单</template:replace>
	<template:replace name="body">
	<script>
		seajs.use(['theme!form']);
		</script>
	<script>
		function selectCustomPage(rid,rname){
			var data = {
					"fdId":rid,
					"fdName":rname
			}
			window.$dialog.hide(data);
		}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top">
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/sys/portal/sys_portal_tree/sysPortalTree.do?method=select&fdType=${ param['fdType'] }&rowsize=10"}
					</ui:source>
					<list:colTable sort="false" onRowClick="selectCustomPage('!{fdId}','!{fdName}')">
						<list:col-serial></list:col-serial>
						<list:col-auto props="fdName"></list:col-auto>
						<list:col-html title="">
							{$
								<a class='com_btn_link' href="javascript:void(0)" onclick="selectCustomPage('{%row['fdId']%}','{%row['fdName']%}')">选择</a>
							$}
						</list:col-html>
					</list:colTable>
				</list:listview>
				<div style="height: 10px;"></div>
				<list:paging layout="sys.ui.paging.simple"></list:paging>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>