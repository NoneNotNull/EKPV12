<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	Com_IncludeFile("doclist.js|data.js", null, "js");
</script>
<%@ include file="sysRelationModule_select_script.jsp"%>
<center>
<table id="moduleSelect" width=100% class="tb_normal">
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
			bundle="sys-relation" key="relation.module.title" /></td>
		<td><select id="module" onchange="changeModule(this);">
		</select></td>
	</tr>

	<tr>
		<td valign="top" colspan="2">
			<iframe id="sysRelationModule" frameborder="0" scrolling="no" width="100%"></iframe></td>
	</tr>
</table>
</center>
<script>
	//初始化值
	initDocument();
</script>
<%@ include file="/resource/jsp/view_down.jsp"%>
