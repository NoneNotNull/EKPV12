<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
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
</script>
<%
	String layoutId = request.getParameter("fdId");
	SysUiLayout layout = SysUiPluginUtil.getLayoutById(layoutId);
	SysUiAssembly assembly = SysUiPluginUtil.getAssemblyById(layout.getFdKind());
	request.setAttribute("layout", layout);
	request.setAttribute("assembly", assembly);
	request.setAttribute("viewVars", JSONArray.fromObject(layout.getFdVars()).toString());
%>
<template:block name="head">
	<div style="margin:10px 0px 0px 30px;">
		当前路径：部件类型 >>
		<a href="${LUI_ContextPath}${empty assembly.fdHelp ? '/sys/ui/help/assembly-help.jsp' : assembly.fdHelp}?fdId=${ assembly.fdId }" target="_self">${assembly.fdName}</a> >>
		${ layout.fdName }
	</div>
	<br><p class="txttitle">${ layout.fdName }（${ layout.fdId }）</p><br>
</template:block>
</head>
<body>
<template:block name="top" />
<table align="center" width="1000px" class="tb_normal">
	<tr class="tr_normal_title"><td colspan="1">基本信息</td></tr>
	<tr>
		<td colspan="2">
			<template:block name="description">
				<table width="100%" class="tb_normal">
					<tr>
						<td width="15%" class="td_normal_title">应用场景</td>
						<td width="35%">${ layout.fdFor }</td>
						<td width="15%" class="td_normal_title">类型</td>
						<td width="35%">${ layout.fdType }</td>
					</tr>
					<tr>
						<td class="td_normal_title">样式文件</td>
						<td>${ layout.fdCss }</td>
						<td class="td_normal_title">缩略图</td>
						<td>${ layout.fdThumb }</td>
						</tr>
				</table>
			</template:block>
		</td>
	</tr>
	<tr class="tr_normal_title">
		<td width="1000px">效果预览</td>
	</tr>
	<tr>
		<td style="vertical-align: top; background-color: #F3F3F3;">
			<div class="tb_noborder" style="border: 1px yellow dashed;" id="test-view-frame">
				<template:block name="example" />
			</div>
		</td>
	</tr>
	<tr class="tr_normal_title">
		<td colspan="1">详细说明</td>
	</tr>
	<tr>
		<td colspan="1"><template:block name="detail">无</template:block></td>
	</tr>
</table>
<br>
</body>
</html>
