<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
seajs.use(['theme!form']);
function Sidebar_Refresh(){}
</script>
<title>
	<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body class="lui_form_body">
<c:set var="frameWidth" scope="page" value="${empty param.width ? '90%' : param.width}"/>
<c:set var="frameSidebar" scope="page" value="${empty param.sidebar ? 'yes' : param.sidebar}"/>
<template:block name="toolbar" />
<div class="lui_form_path_frame" style="width:${ frameWidth }; min-width:980px; margin:0px auto;">
	<template:block name="path" />
</div>
<div id="lui_validate_message" style="width:${ frameWidth }; min-width:980px; margin:0px auto;"></div>
<table style="width:${ frameWidth }; min-width:980px; margin: 0px auto;">
	<tr>
		<c:choose>
			<%-- sidebar 为yes表示侧边栏一定有 --%>
			<c:when test="${ frameSidebar == 'yes' }">
			
				<td valign="top" style="width:75%;">
					<div class="lui_form_content">
						<template:block name="content" />
					</div>
				</td>
				<td valign="top" style="width:25%;">
					<div style="padding-left:15px;" class="lui_form_sidebar">
						<template:block name="nav" />
					</div>
				</td>
			</c:when>
			<%-- sidebar 数值为no表示侧边栏一定没有 --%>
			<c:when test="${ param['sidebar'] == 'no' }">
				<td valign="top">
					<div class="lui_form_content">
						<template:block name="content" />
					</div>
				</td>
			</c:when>
			<%-- sidebar 数值为auto表示侧边栏宽度自由缩进 --%>
			<c:when test="${ param['sidebar'] == 'auto' }">
				<td valign="top">
					<div class="lui_form_content">
						<template:block name="content" />
					</div>
				</td>
				<td valign="top" style="width:25%;">
					<div style="padding-left:15px;" class="lui_form_sidebar">
						<template:block name="nav" />
					</div>
				</td>
			</c:when>
		</c:choose>
	</tr>
</table>
<script type="text/javascript">
	function Sidebar_Refresh(show){
		var sidebar = LUI.$(".lui_form_sidebar");
		if(sidebar.length > 0){
			var tdContain = sidebar.parent();
			tdContain.show();
			if(show){
				return;
			}
			var height = sidebar.height();
			if(height<30){
				tdContain.hide();
			}else{
				var width = tdContain.parent().width();
				if(width * 0.25 < 200){
					tdContain.css("max-width",'200px');
				}else{
					tdContain.css("max-width",width * 0.25 + 'px');
				}
			}
		}
	}
	LUI.ready(function(){Sidebar_Refresh();});
</script>
<div style="height:20px;"></div>
<ui:top id="top"></ui:top>
</body>
</html>

