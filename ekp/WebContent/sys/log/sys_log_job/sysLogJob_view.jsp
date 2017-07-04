<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-log" key="table.sysLogJob"/></div>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysLogJobForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogJob.fdStartTime"/>
		</td><td width=35%>
			<bean:write name="sysLogJobForm" property="fdStartTime"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogJob.fdEndTime"/>
		</td><td width=35%>
			<bean:write name="sysLogJobForm" property="fdEndTime"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogJob.fdSubject"/>
		</td><td colspan=3>
			<bean:write name="sysLogJobForm" property="fdSubject"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogJob.fdJobClass"/>
		</td><td width=35%>
			<bean:write name="sysLogJobForm" property="fdJobClass"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogJob.fdSuccess"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysLogJobForm.fdSuccess}" enumsType="common_yesno" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogJob.fdMessages"/>
		</td><td colspan=3>
			<pre><bean:write name="sysLogJobForm" property="fdMessages"/></pre>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>