<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">选择连接</template:replace>
	<template:replace name="body">
	
	<script>
		function selectLink(fdId, fdName,fdUrl,fdIcon) {
			var data = {
					"fdId": fdId,
					"fdName":fdName,
					"fdUrl":fdUrl,
					"fdIcon":fdIcon
			};
			window.$dialog.hide(data);
		}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top">
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/sys/person/sys_person_link/sysPersonLink.do?method=select&fdType=${ param['fdType'] }"}
					</ui:source>
					<list:colTable sort="false" onRowClick="selectLink('!{fdId}','!{fdName}','!{fdUrl}','!{fdIcon}')">
						<list:col-serial></list:col-serial>
						<list:col-auto props="fdName;fdUrl"></list:col-auto>
						<list:col-html title="图标">
							{$<div class="lui_icon_l {%row['fdIcon']%}"></div>$}
						</list:col-html>
					</list:colTable>
				</list:listview>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>