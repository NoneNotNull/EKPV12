<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style>
.message{
	color: #003366; 
}
</style>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<script type="text/javascript">
    function validateSubmitForm(){ 
        
    	var daysOfBackupLog = document.getElementsByName("value(daysOfBackupLog)")[0].value;
    	if(daysOfBackupLog == ""){
    		alert("服务运行日志备份天数不能为空！");
    		return false;    	
    	} else if(!isInteger(daysOfBackupLog)){		 		
    		alert("服务运行日志备份天数必须为数字！");
    		return false;
    	} else if(daysOfBackupLog < 30 || daysOfBackupLog > 730){
    		alert("服务运行日志备份天数必须大于等于30天且小于等于2年！");
    		return false;
    	}   
    	
    	var daysOfClearLog = document.getElementsByName("value(daysOfClearLog)")[0].value;
    	if(daysOfClearLog == ""){
    		alert("清除服务运行日志备份天数不能为空！");
    		return false;  
    	} else if(!isInteger(daysOfClearLog)){
    		alert("清除服务运行日志备份天数必须为数字！");
    		return false;
    	} else if(daysOfClearLog < 365 || daysOfClearLog > 1825){
    		alert("清除服务运行日志备份天数必须大于等于1年且小于等于4年！");
    		return false;
    	}  

    	return true;
    }

    function isInteger(str) {
		var reg = /^-?([1-9]\d*|0)$/;  
		
		return reg.test(str);
    }    
</script>
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.save"/>"
		onclick="if(validateSubmitForm())Com_Submit(document.sysAppConfigForm, 'update');">
</div>

<p class="txttitle"><bean:message key="module.sys.webservice2.base" bundle="sys-webservice2"/></p>
<center>

<table class="tb_normal" width=95%>	
	<tr>
		<td class="td_normal_title" width="15%">服务运行日志备份天数</td>
		<td>
			<xform:text property="value(daysOfBackupLog)" subject="服务运行日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">说明：如果设置为180，当前日志保存180天内容，180天前的自动转移到日志备份表[sys_webservice_log_backup]中</span>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width="15%">清除服务运行日志备份天数</td>
		<td>
			<xform:text property="value(daysOfClearLog)" subject="清除服务运行日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">说明：如果设置为540，清除日志备份表[sys_webservice_log_backup]中540天前的数据</span>
		</td>
	</tr>		
</table>
</center>

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>