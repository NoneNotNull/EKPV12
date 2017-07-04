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
		<kmss:auth requestURL="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTaskOverrule.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskOverrule"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysTaskOverruleForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
		</td>
		<td width=85% colspan=3>
			<a href="<c:url value="/sys/task/sys_task_main/sysTaskMain.do"/>?method=view&fdId=${sysTaskOverruleForm.fdTaskId}"  target="_self">
				<c:out value="${sysTaskOverruleForm.fdTaskName}"/>	
			</a>			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.fdReason"/>
		</td>
		<td width=85% colspan=3>
			<c:out value="${sysTaskOverruleForm.fdReason}"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.fdNotifyType"/>
		</td>
		<td width=85% colspan=3>
			<kmss:showNotifyType value="${sysTaskOverruleForm.fdNotifyType}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreator"/>
		</td><td width=35%>
			<c:out value="${sysTaskOverruleForm.docCreatorName}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskOverruleForm.docCreateTime}"/>
		</td>
	</tr>
	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>