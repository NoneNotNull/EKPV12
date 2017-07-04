<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*,
				com.landray.kmss.sys.person.actions.SysPersonSettingAction" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
	
<%
if (request.getAttribute(SysPersonSettingAction.SYS_PERSON_SETTING_ALL) == null) {
	SysPersonSettingAction.processLinkNav(request);
}
%>
<c:set var="tempate_rander" scope="page">
	{$
			<ul class='lui_list_nav_list'>
	$} 
	for(var i=0;i < data.length;i++){
		if (data[i].id != null) {
			var xid = encodeURIComponent(data[i].id);
			if (data[i].id == '${SYS_PERSON_SETTING_LINK.fdLinkId }') {
				{$<li class="lui_list_nav_selected"><a href="${ LUI_ContextPath }/sys/person/setting.do?setting={%xid%}" title="{%data[i].text%}" target="{%data[i].target%}">{%data[i].text%}</a></li>$}
			} else {
				{$<li><a href="${ LUI_ContextPath }/sys/person/setting.do?setting={%xid%}" title="{%data[i].text%}" target="{%data[i].target%}">{%data[i].text%}</a></li>$}
			}
		} else if (data[i].fdId != null) {
			if (data[i].fdId == '${SYS_PERSON_SETTING_LINK.fdId }') {
				{$<li class="lui_list_nav_selected"><a href="${ LUI_ContextPath }/sys/person/setting.do?fdId={%data[i].fdId%}" title="{%data[i].text%}" target="{%data[i].target%}">{%data[i].text%}</a></li>$}
			} else {
				{$<li><a href="${ LUI_ContextPath }/sys/person/setting.do?fdId={%data[i].fdId%}" title="{%data[i].text%}" target="{%data[i].target%}">{%data[i].text%}</a></li>$}
			}
		}
	}
	{$
		</ul>
	$}
</c:set>
<template:include file="/sys/person/template/person.base.template.jsp">
	<template:replace name="title">${ lfn:message('sys-person:person.setting') }</template:replace>
	<template:replace name="nav">
	<c:set var="noShowSettingOption" value="true" scope="page" />
	<%@ include file="/sys/person/portal/usertitle.jsp" %>
	
	<ui:accordionpanel cfg-memoryExpand="person_setting_nav">
		<ui:content title="${lfn:message('sys-person:person.link.type.setting.info') }">
			<ui:dataview>
				<ui:source type="Static">
					${SYS_PERSON_SETTING_ALL.settingInfoJson }
				</ui:source>
				<ui:render type="Template">
				${tempate_rander }
				</ui:render>
			</ui:dataview>
		</ui:content>
		<ui:content title="${lfn:message('sys-person:person.link.type.setting.home') }">
			<ui:dataview>
				<ui:source type="Static">
					${SYS_PERSON_SETTING_ALL.settingHomeJson }
				</ui:source>
				<ui:render type="Template">
				${tempate_rander }
				</ui:render>
			</ui:dataview>
		</ui:content>
		<ui:content title="${lfn:message('sys-person:person.link.type.setting') }">
			<ui:dataview>
				<ui:source type="Static">
					${SYS_PERSON_SETTING_ALL.settingJson }
				</ui:source>
				<ui:render type="Template">
				${tempate_rander }
				</ui:render>
			</ui:dataview>
		</ui:content>
	</ui:accordionpanel>
	</template:replace>
		
	<template:replace name="script">
		<script>
		seajs.use(['lui/jquery'], function($) {
			var setTitle = function() {
				var selected = $('.lui_list_nav_selected');
				if (selected.length == 0) {
					setTimeout(setTitle, 500);
					return;
				}
				selected.each(function() {
					document.title = $(this).children('a').text() + " - " + "${ lfn:message('sys-person:person.setting') }";
				});
			};
			$(document).ready(setTitle);
		});
		</script>
	</template:replace>
</template:include>