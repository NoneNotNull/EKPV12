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
		<kmss:auth requestURL="/sys/tag/sys_tag_main/sysTagMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTagMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_main/sysTagMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTagMain.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagMain"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.fdId"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.fdModelName"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.fdModelName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.fdModelId"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.fdModelId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.docSubject"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.docSubject}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.fdKey"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.fdKey}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.fdTagName"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.fdTagName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-tag" key="table.sysOrgElement"/>.<bean:message  bundle="sys-tag" key="sysOrgElement.fdId"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.sysOrgElement.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.docCreateTime}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.docAlterTime"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.docAlterTime}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagMain.docStatus"/>
		</td><td width=35%>
			<c:out value="${sysTagMainForm.docStatus}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>