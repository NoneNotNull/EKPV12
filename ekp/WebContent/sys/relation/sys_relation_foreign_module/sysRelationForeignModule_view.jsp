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
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysRelationForeignModule.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysRelationForeignModule.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-relation" key="table.sysRelationForeignModule"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdId"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdModuleName"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdModuleName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdOrderBy"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdOrderBy}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdOrderByName"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdOrderByName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdPageSize"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdPageSize}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdSearchEngineBean}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchUrl"/>
		</td><td width=35%>
			<c:out value="${sysRelationForeignModuleForm.fdSearchUrl}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>