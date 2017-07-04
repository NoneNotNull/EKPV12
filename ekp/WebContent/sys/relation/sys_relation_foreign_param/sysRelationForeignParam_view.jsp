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
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysRelationForeignParam.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysRelationForeignParam.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-relation" key="table.sysRelationForeignParam"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdId"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignParamForm.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParam"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignParamForm.fdParam}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParamName"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignParamForm.fdParamName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParamType"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignParamForm.fdParamType}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-relation" key="table.sysRelationForeignModule"/>.<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdId"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignParamForm.sysRelationForeignModule.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>