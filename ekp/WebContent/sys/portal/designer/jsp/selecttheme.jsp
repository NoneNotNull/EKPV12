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
		function selectPortletTheme(rid,rname){
			var data = {
					"ref":rid,
					"name":rname
			};
			window.$dialog.hide(data);
		}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top">
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=selectTheme"}
					</ui:source>
					<list:colTable sort="false" onRowClick="selectPortletTheme('!{fdId}','!{fdName}')">
						<list:col-serial></list:col-serial>
						<list:col-auto props="fdName"></list:col-auto>
						<list:col-html title="${ lfn:message('sys-portal:sys.portal.thumbnail') }">
							{$
								<img width="250" src="${ LUI_ContextPath }{%row['fdThumb']%}" />
							$}
						</list:col-html>
						<list:col-html title="">
							{$
								<a class='com_btn_link' href="javascript:void(0)" onclick="selectPortletTheme('{%row['fdId']%}','{%row['fdName']%}')">${ lfn:message('sys-portal:desgin.msg.select') }</a>
							$}
						</list:col-html>
					</list:colTable>
				</list:listview>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>