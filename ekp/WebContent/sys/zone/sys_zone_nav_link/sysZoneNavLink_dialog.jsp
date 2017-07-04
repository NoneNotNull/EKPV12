<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title"><bean:message bundle="sys-zone" key="sysZoneNavLink.selectLink"/></template:replace>
	<template:replace name="body">
	<script>
		seajs.use(['theme!form']);
	</script>
	<table style="width: 95%;margin: 10px auto;" border="0">
		<tr>
			<td width="*">
			<div style="width: 100%;">
				<div data-lui-type="lui/search_box!SearchBox">
					<script type="text/config">
						{
							placeholder: "${lfn:message('sys-ui:ui.criteria.search')}",
							width: '90%'
						}
					</script>
					<ui:event event="search.changed" args="evt">
						LUI('listview').tableRefresh({criterions:[{key:"key", value: [evt.searchText]}]});
					</ui:event>
				</div>
				</div>
			</td>
		</tr>
	</table>
	<%-- 多选选中组件 --%>
	<c:if test="${param.multi != 'false'}">
	<div id="selectedBean" data-lui-type="lui/selected/multi_selected!Selected" style="width: 95%;margin: 10px auto;">
		<script type="lui/event" data-lui-event="changed" data-lui-args="evt">
			refreshCheckbox();
		</script>
	</div>
	</c:if>
	<script>
		var multi = ${param.multi == 'false' ? 'false' : 'true'};
		<%-- 刷新checkbox状态 --%>
		function refreshCheckbox() {
			var vals = LUI('selectedBean').getValues();
			LUI.$('[name="List_Selected"]').each(function() {
				for (var i = 0; i < vals.length; i ++) {
					if (vals[i].id == this.value) {
						if (!this.checked)
							this.checked = true;
						return;
					}
				}
				if (this.checked)
					this.checked = false;
			});
		}
		function submitSelected(data) {
			window.$dialog.hide(data || LUI('selectedBean').getValues());
		}
		<%-- 设置选中 --%>
		function selectLink(id, name, url, serverName, target, server) {
			var data = {
					"id": id,
					"name":name,
					"url":url.replace(/&amp;/g, "&"),
					"serverName":serverName,
					"target":target,
					"server":server
			};
			if (multi == false) {
				submitSelected([data]);
				return;
			}
			if (LUI('selectedBean').hasVal(data)) {
				LUI('selectedBean').removeVal(data);
				return;
			}
			LUI('selectedBean').addVal(data);
		}
	</script>
	
	<table class="tb_normal" style="margin:10px auto;width:95%;height:440px;">
		<tr>
			<td valign="top" id="_listview">
				<list:listview id="listview"  style="height: 390px;overflow: auto;">
					<ui:source type="AjaxJson">
						<c:if test="${empty selectUrl }">
						{"url":"/sys/zone/sys_zone_nav_link/sysZoneNavLink.do?method=select&key=!{searchText}&rowsize=8&showType=${param.showType}"}
						</c:if>
						<c:if test="${not empty selectUrl }">
						{"url":"${selectUrl }"}
						</c:if>
					</ui:source>
					<list:colTable sort="false" onRowClick="selectLink('!{fdId}', '!{name}','!{url}','!{serverName}','!{server}')">
						<c:if test="${param.multi != 'false'}">
						<list:col-checkbox></list:col-checkbox>
						</c:if>
						<list:col-serial headerStyle="width:8%"></list:col-serial>
						<list:col-auto props="name"></list:col-auto>
						<list:col-html title="${lfn:message('sys-zone:sysZoneNavLink.fdUrl') }" headerStyle="width:50%;">
							{$<div class="textEllipsis" style="text-align: left;">{%row['url']%}</div>$}
						</list:col-html>
						<list:col-auto props="serverName,targetText"></list:col-auto>
					</list:colTable>
					<%-- 列表加载后更新状态和绑定事件 --%>
					<ui:event event="load" args="evt"> 
						<c:if test="${param.multi != 'false'}">
						refreshCheckbox();
						</c:if> 
						var datas = evt.table.kvData;
						function getVal(id) {
							for (var i = 0; i < datas.length; i ++) {
								if (datas[i].fdId == id) {
									return datas[i];
								}
							}
							return null;
						}
						LUI.$('#listview [name="List_Tongle"]').bind('click', function() {
							if (this.checked) {
								LUI('selectedBean').addValAll(datas);
							} else {
								LUI('selectedBean').removeValAll();
							}
						});
						LUI.$('#listview [name="List_Selected"]').bind('click', function() {
							if (!this.checked) {
								LUI('selectedBean').removeVal(this.value);
							} else {
								var val = getVal(this.value);
								if (val != null)
									selectLink(val.fdId, val.name, val.url, val.serverName, val.target,  val.server);
							}
						});
					</ui:event>
				</list:listview>
				<list:paging layout="sys.ui.paging.simple"></list:paging>
			</td>
		</tr>
	</table>
	<c:if test="${param.multi != 'false'}">
	<div data-lui-mark="dialog.content.buttons" 
		style="text-align:right;position: fixed;bottom: 5px;left: 15px;width:95%;" 
		class="lui_dialog_common_buttons clearfloat">
		<ui:button onclick="submitSelected();" text="${lfn:message('button.ok') }" />
	</div>
	</c:if>
	</template:replace>
</template:include>
<style>
	.lui_listview_body .lui_listview_columntable_table{
		table-layout: fixed;
	}
</style>