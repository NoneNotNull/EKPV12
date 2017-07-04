<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">	
</div>
<p class="txttitle"><bean:message bundle="sys-log" key="sysLogOnline.Warning.title"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.Warning.onlineCount"/>
		</td><td id="onlineCountTd">
			<html:text property="value(onlineCount)" readonly="true"/>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.Warning.overDate"/>
		</td>
		<td>
			<html:text property="value(overDate)" readonly="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-log" key="sysLogOnline.Warning.remainDays"/>
		</td>
		<td id="remainDaysTd">
			<html:text property="value(remainDays)" readonly="true"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<bean:message bundle="sys-log" key="sysLogOnline.Warning.describe"/>
		</td>
	</tr>
</table>
</center>
</html:form>
<script>
window.onload = function(){
	var onlineCount = document.getElementsByName("value(onlineCount)")[0].value;
	var onlineCountTd = document.getElementById("onlineCountTd");
	if(onlineCount == -1){
		onlineCountTd.innerHTML = '<bean:message bundle="sys-log" key="sysLogOnline.Warning.onlineCount.unlimited"/>';
	}
	var remainDays = document.getElementsByName("value(remainDays)")[0].value;
	var remainDaysTd = document.getElementById("remainDaysTd");
	if(remainDays == -1){
		remainDaysTd.innerHTML = "";
	}
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>