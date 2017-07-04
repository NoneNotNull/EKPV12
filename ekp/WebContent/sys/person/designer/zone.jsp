<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!list', 'theme!form', 'theme!portal']);
</script>
<title>
<portal:title/>
</title> 
</head>
<body class="portal_body">
<div style="margin: 0px auto;width: 980px;display: table;">
	<div style="margin: 0px auto;height: 50px;border: 1px #e5e5e5 solid;background: #82d0f4;text-align: center;">
		<portal:header/>
	</div>

<table style="width:980px; min-width:980px; margin:10px auto 10px auto;">
	<tr>
		<td valign="top" style="width: 150px">
			<div>
			<c:set var="noShowSettingOption" value="true" />
			<%@ include file="/sys/person/portal/usertitle.jsp" %>
			<ui:panel toggle="false">
				<ui:content title="TA的导航">
					<ul class='lui_list_nav_list'>
					<li><a href="javascript:;">TA的待办</a></li>
					<li><a href="javascript:;">TA的收藏</a></li>
					<li><a href="javascript:;">TA的订阅</a></li>
					<li><a href="javascript:;">TA的XXX</a></li>
					<li><a href="javascript:;">TA的XXX</a></li>
					</ul>
				</ui:content>
			</ui:panel>
			</div>
		</td>
		<td style="width: 15px;"></td>
		<td valign="top">
			<div class="lui_list_body_frame">
				<template:block name="content"></template:block>
			</div>
		</td>
	</tr>
</table>

	<div style="margin: 0px auto;height: 50px;border: 1px #e5e5e5 solid;background: #c8c8c8;text-align: center;">
	 	<portal:footer/>
	</div>
</div> 
</body>
</html>
