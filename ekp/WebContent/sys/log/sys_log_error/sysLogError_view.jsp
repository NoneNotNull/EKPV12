<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-log" key="table.sysLogError"/></div>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysLogErrorForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdCreateTime"/>
		</td><td width=35%>
			<bean:write name="sysLogErrorForm" property="fdCreateTime"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdIp"/>
		</td><td width=35%>
			<bean:write name="sysLogErrorForm" property="fdIp"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdOperator"/>
		</td><td width=35%>
			<bean:write name="sysLogErrorForm" property="fdOperator"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdOperatorId"/>
		</td><td width=35%>
			<bean:write name="sysLogErrorForm" property="fdOperatorId"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdMethod"/>
		</td><td colspan=3>
			<bean:write name="sysLogErrorForm" property="fdMethod"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdUrl"/>
		</td><td colspan=3>
			<bean:write name="sysLogErrorForm" property="fdUrl"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogError.fdErrorInfo"/>
		</td><td colspan=3>
			<pre><bean:write name="sysLogErrorForm" property="fdErrorInfo"/></pre>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>