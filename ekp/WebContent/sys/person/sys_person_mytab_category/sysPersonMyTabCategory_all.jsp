<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="person.cfg">
	<template:replace name="content">
	
		<ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
		<ui:content title="${lfn:message('sys-person:home.taball') }">
		<ui:toolbar layout="sys.ui.toolbar.default" style="float:right;" count="5">
			<ui:button href="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do?method=add&type=shortcut" target="_blank" title="${lfn:message('sys-person:btn.add.shortcut') }" text="${lfn:message('sys-person:btn.add.shortcut') }" />
			<ui:button href="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do?method=add&type=hotlink" target="_blank" title="${lfn:message('sys-person:btn.add.hotlink') }" text="${lfn:message('sys-person:btn.add.hotlink') }" />
			<ui:button id="upRowButton" onclick="SysPersonUpRow();" title="${lfn:message('button.moveup') }" text="${lfn:message('button.moveup') }" />
			<ui:button onclick="SysPersonDownRow();" title="${lfn:message('button.movedown') }" text="${lfn:message('button.movedown') }" />
			<ui:button onclick="PersonRefreshList();" title="${lfn:message('button.refresh') }" text="${lfn:message('button.refresh') }" />
			<ui:button onclick="PersonOnUpdateStatus(2, true);" title="${lfn:message('sys-person:btn.start') }" text="${lfn:message('sys-person:btn.start') }" />
			<ui:button onclick="PersonOnUpdateStatus(1, true);" title="${lfn:message('sys-person:btn.stop') }" text="${lfn:message('sys-person:btn.stop') }" />
			<ui:button onclick="PersonOnDeleteAll(true);" title="${lfn:message('button.deleteall') }" text="${lfn:message('button.deleteall') }" />
		</ui:toolbar>
		
		<html:form action="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do">
		<div class="clr"></div>
		<div id="list_div" data-refresh="all">
		<c:import url="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory_listFragment.jsp" charEncoding="utf-8" />
		</div>
		
		<div id="orderSaveBtn" 
			style="display:none;width:100px;height:40px;background-color: #F19703;color: #fff;line-height: 40px;text-align: center;cursor: pointer;" 
			onclick="SysPersonUpdataOrder(true);" title="${lfn:message('sys-person:btn.save.order') }"><bean:message bundle="sys-person" key="btn.save.order" /></div>
			
		<div style="margin:20px 0px; border-top: 1px #C0C0C0 dashed; text-align: center; padding-top:10px;">
			<div style="display:inline;vertical-align: top;"><bean:message bundle="sys-person" key="nav.config.example" /></div>
			<div style="display:inline; margin-left:20px;">
				<img src="<c:url value="/sys/person/resource/images/sample.png" />" style="border:1px #C0C0C0 solid; width:400px;">
			</div>
		</div>
		</html:form>
		</ui:content>
		</ui:panel>
		<script src="<c:url value="/sys/person/resource/utils.js" />"></script>
		<script>
			var statusInfo = {
					"1": "<kmss:message key="status.stoped" bundle="sys-person" />",
					"2": "<kmss:message key="status.started" bundle="sys-person" />"
			};
			var sysDelInfo = "${lfn:escapeJs(lfn:message('sys-person:hint.delete.pushed.link'))}";
		</script>
	</template:replace>
</template:include>