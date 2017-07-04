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
		<kmss:auth requestURL="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTagApplicationLog.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTagApplicationLog.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagApplicationLog"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdId"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdModelName"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.fdModelName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdModelId"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.fdModelId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdTagName"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.fdTagName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdValue"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.fdValue}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdAccount"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.fdAccount}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-tag" key="table.sysOrgElement"/>.<bean:message  bundle="sys-tag" key="sysOrgElement.fdId"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.sysOrgElement.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.docCreateTime}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagApplicationLog.docStatus"/>
		</td><td width=35%>
			<c:out value="${sysTagApplicationLogForm.docStatus}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>