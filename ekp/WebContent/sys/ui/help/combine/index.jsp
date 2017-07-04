<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
Collection<SysUiCombin> list = SysUiPluginUtil.getCombins().values();
request.setAttribute("list",list);
%>
<template:include ref="default.simple">
	<template:replace name="body">
		<script>
			seajs.use(['theme!form']);
		</script>
		<div style="margin:20px auto; width:95%;">
			<div style="margin-bottom: 10px;">
			当前路径：部件类型 >>其它组件
			</div>
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					 <td width="5%">序号</td>
					 <td width="20%">ID</td>
					 <td width="20%">名称</td>
					 <td width="55%">文件路径</td>
				</tr>
				<c:forEach items="${list}" var="combine" varStatus="vstatus">
					<tr onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';">
						<td><center>${vstatus.index+1}</center></td>
						<td>${ combine.fdId }</td>
						<td>${ combine.fdName }</td>
						<td>${ combine.fdFile }</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</template:replace>
</template:include>
