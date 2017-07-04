<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">选择portlet</template:replace>
	<template:replace name="body">
	<script>
		seajs.use(['theme!form']);
		</script>
	<script>
		function selectPortletRender(rid,rname){
			var data = {
					"renderId":rid,
					"renderName":rname
			}
			window.$dialog.hide(data);
		}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top">
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=selectRender&format=${ param['format'] }&scene=${ param['scene'] }"}
					</ui:source>
					<list:colTable sort="false" onRowClick="selectPortletRender('!{fdId}','!{fdName}')">
						<list:col-serial></list:col-serial>
						<list:col-auto props="fdName"></list:col-auto>
						<list:col-html title="${ lfn:message('sys-portal:sys.portal.thumbnail') }">
							if($.trim(row['fdThumb'])==""){
								{$无预览图$}
							}else{
								{$
									<img width="250" src="${ LUI_ContextPath }{%row['fdThumb']%}" />
								$}
							}
						</list:col-html>
						<list:col-html title="">
							{$
								<a class='com_btn_link' href="javascript:void(0)" onclick="selectPortletRender('{%row['fdId']%}','{%row['fdName']%}')">${ lfn:message('sys-portal:sysPortalPage.msg.select') }</a>
							$}
						</list:col-html>
					</list:colTable>
					<%--
					<list:rowTable>
						<ui:layout type="Template">
						{$
						<div>
							<table style="width:100%">
								<tr>
									<td style="width:300px;background-color: ghostwhite">名称</td>
									<td style="width:260px;background-color: ghostwhite">缩略图</td>
									<td style="background-color: ghostwhite"></td>
								</tr>
							</table>
						</div>
						<div data-lui-mark="table.content.inside" style="height:300px;overflow-y:auto;"></div>
						$}
						</ui:layout>
						<list:row-template>
						{$
						<table style="width:100%">
							<tr>
								<td style="width:300px;border-top: 0px;">
									{%row['fdName']%}
								</td>
								<td style="width:260px;border-top: 0px;">
									<img width="250" src="${ LUI_ContextPath }/{%row['fdThumb']%}" />
								</td>
								<td style="border-top: 0px;">
								<a href="javascript:void(0)" onclick="selectPortletRender('{%row['fdId']%}','{%row['fdName']%}')">选择</a>
								</td>
							</tr>
						</table>
						$}
						</list:row-template>
					</list:rowTable>
					 --%>
				</list:listview>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>