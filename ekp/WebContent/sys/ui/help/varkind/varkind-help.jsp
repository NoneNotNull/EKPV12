<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	String varKindId = request.getParameter("fdId");
	SysUiVarKind varKind = SysUiPluginUtil.getVarKindById(varKindId);
	request.setAttribute("varKind-help", varKind);
%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super />
		<title>变量类型：${ requestScope['varKind-help'].fdName }</title>
		<link href="${LUI_ContextPath}/resource/style/default/doc/document.css" rel="stylesheet" type="text/css" />
	</template:replace>
	<template:replace name="body">
		<div style="margin:10px 0px 0px 30px;">
			当前路径：<a href="${LUI_ContextPath}/sys/ui/help/varkind/index.jsp?s_path=%E5%8F%98%E9%87%8F%E7%B1%BB%E5%9E%8B" target="_self">变量类型</a> >> ${ requestScope['varKind-help'].fdName }
		</div>
		<p class="txttitle">${ requestScope['varKind-help'].fdName }（${ requestScope['varKind-help'].fdId }）</p>
		<table align="center" width="1000px" class="tb_normal">
			<tr class="tr_normal_title"><td>基本信息</td></tr>
			<tr><td>
				<table width="100%" class="tb_normal">
					<tr>
						<td class="td_normal_title" width="15%">路径</td>
						<td>${ requestScope['varKind-help'].fdFile }</td>
					</tr>
				</table>
			</td></tr>
			<tr class="tr_normal_title"><td>使用说明</td></tr>
			<tr><td><template:block name="detail" /></td></tr>
		</table>
	</template:replace>
</template:include> 
