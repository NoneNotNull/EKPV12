<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	request.setAttribute("datas", SysUiPluginUtil.getThemes().values());
%>
<ui:json var="columns">
	[
		{id:"fdId", name:"ID"},
		{id:"fdName", name:"名称"},
		{id:"fdPath", name:"路径"},
		{id:"fdThumb", name:"缩略图"}
	]
</ui:json>
<ui:json var="paths">
	[
		{name:"主题样式"}
	]
</ui:json>
<c:set var="onRowClick" scope="request">onRowClick(this);</c:set>
<template:include file="/sys/ui/help/common/list.jsp">
	<template:replace name="head">
		<template:super/>
		<script>
			function onRowClick(obj){
				var row = LUI.$(obj);
				var url = location.href;
				var from = Com_GetUrlParameter(url, "from");
				if(from==null){
					url = row.attr('kmss_help');
					if(url!=null){
						location.href = '${LUI_ContextPath}'+url;
					}
				}else{
					location.href = Com_SetUrlParameter(from, "fdId", row.attr('kmss_id'));
				}
			}
		</script>
	</template:replace>
</template:include>
