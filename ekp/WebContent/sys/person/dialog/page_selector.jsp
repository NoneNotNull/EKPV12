<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">选择自定义页面</template:replace>
	<template:replace name="body">
	
	<script>
		function selectCustomPage(rid,rname){
			var data = {
					"fdId":rid,
					"fdName":rname,
					"fdType":"html"
			};
			window.returnValue = data;
			window.close();
		}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top">
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/sys/portal/sys_portal_html/sysPortalHtml.do?method=select"}
					</ui:source>
					<list:colTable sort="false">
						<list:col-serial></list:col-serial>
						<list:col-auto props="fdName"></list:col-auto>
						<list:col-html title="">
							{$
								<a class='com_btn_link' href="javascript:void(0)" onclick="selectCustomPage('{%row['fdId']%}','{%row['fdName']%}')">选择</a>
							$}
						</list:col-html>
					</list:colTable>
				</list:listview>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>