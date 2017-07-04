<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	String layoutId = request.getParameter("fdId");
	SysUiLayout layout = SysUiPluginUtil.getLayoutById(layoutId);
	SysUiAssembly assembly = SysUiPluginUtil.getAssemblyById(layout.getFdKind());
	request.setAttribute("layout", layout);
	request.setAttribute("assembly", assembly);
	request.setAttribute("viewVars", JSONArray.fromObject(layout.getFdVars()).toString());
%>
<template:include file="/sys/ui/help/view-help.jsp">
	<template:replace name="top">
		<div style="margin:10px 0px 0px 30px;">
			当前路径：部件类型 >>
			<a href="${LUI_ContextPath}${empty assembly.fdHelp ? '/sys/ui/help/assembly-help.jsp' : assembly.fdHelp}?fdId=${ assembly.fdId }" target="_self">${assembly.fdName}</a> >>
			${ layout.fdName }
		</div>
		<br><p class="txttitle">${ layout.fdName }（${ layout.fdId }）</p><br>
	</template:replace>
	<template:replace name="description">
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
	</template:replace>
</template:include> 
