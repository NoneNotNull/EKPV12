<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTagMainRelation.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTagMainRelation.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagMainRelation"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMainRelation.fdId"/>
		</td><td width=35%>
			<c:out value="${sysTagMainRelationForm.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-tag" key="table.sysTagMain"/>.<bean:message  bundle="sys-tag" key="sysTagMain.fdId"/>
		</td><td width=35%>
			<c:out value="${sysTagMainRelationForm.sysTagMain.fdId}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMainRelation.fdTagName"/>
		</td><td width=35%>
			<c:out value="${sysTagMainRelationForm.fdTagName}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>