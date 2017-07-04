<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">${lfn:message('km-collaborate:table.kmCollaborateCategory.tilteKind')}</template:replace>
	<template:replace name="head">
		<template:super/>
		<style type="text/css">
			.lui_listview_columntable_table tbody {
				overflow-y: auto;
				height: auto;
			}
		</style>
	</template:replace>
	<template:replace name="body">
	
	<script>
		function selectCollaborateCat(rid,rname){
			var data = {
					"fdId":rid,
					"fdName":rname
			}
			window.$dialog.hide(data);
		}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:auto">
		<tr>
			<td valign="top">
				<list:listview>
					<ui:source type="AjaxJson">
						{"url":"/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=list&forward=selectForPortlet&fdDeleted=true"}
					</ui:source>
					<list:colTable sort="false">
						<list:col-serial></list:col-serial>
						<list:col-auto props="fdName"></list:col-auto>
						<list:col-html title="">
							{$
								<a class='com_btn_link' href="javascript:void(0)" onclick="selectCollaborateCat('{%row['fdId']%}','{%row['fdName']%}')">
                                ${lfn:message('km-collaborate:kmCollaborateMain.choose')}</a>
							$}
						</list:col-html>
					</list:colTable>
				</list:listview>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>