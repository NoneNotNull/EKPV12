<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-log" key="table.sysLogLogin"/></div>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysLogLoginForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogLogin.fdCreateTime"/>
		</td><td width=35%>
			<bean:write name="sysLogLoginForm" property="fdCreateTime"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogLogin.fdOperator"/>
		</td><td width=35%>
			<bean:write name="sysLogLoginForm" property="fdOperator"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogLogin.fdIp"/>
		</td><td width=35% colspan='3'>
			<bean:write name="sysLogLoginForm" property="fdIp"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>