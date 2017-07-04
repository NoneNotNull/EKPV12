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
		<kmss:auth requestURL="/sys/time/sys_time_vacation/sysTimeVacation.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTimeVacation.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_vacation/sysTimeVacation.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTimeVacation.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="top.close();">
</div>
<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimeVacation"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysTimeVacationForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.fdName"/>
		</td>
		<td width=85% colspan=3>
			<bean:write name="sysTimeVacationForm" property="fdName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.time"/>
		</td><td width=35% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimeVacation.start"/>
			<c:out value="${sysTimeVacationForm.fdStartDate}"/>
			<c:out value="${sysTimeVacationForm.fdStartTime}"/>
			<bean:message  bundle="sys-time" key="sysTimeVacation.end"/>
			<c:out value="${sysTimeVacationForm.fdEndDate}"/>
			<c:out value="${sysTimeVacationForm.fdEndTime}"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${sysTimeVacationForm.docCreatorName}"/>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTimeVacationForm.docCreateTime}"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>