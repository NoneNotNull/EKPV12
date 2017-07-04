<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script>  
function config_gcalendar_onloadFunc(){
	var tbObj = document.getElementById("calendar.integrate.gcalendar");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	//var cms = document.getElementsByName("value(calendar.integrate.gcalendar.enabled)")[0];
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		var cfgFields = tbObj.rows[i].getElementsByTagName("INPUT");
		for(var j=0; j<cfgFields.length; j++){
			cfgFields[j].disabled = !field.checked;
		}
	}
}  
config_addOnloadFuncList(config_gcalendar_onloadFunc);  
</script>
<table class="tb_normal" width=100% id="calendar.integrate.gcalendar">
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				<label> 
					<html:checkbox property="value(calendar.integrate.gcalendar.enabled)" value="true" onclick="config_gcalendar_onloadFunc();"/>集成google日历（<a href='<c:url value="/third/gcalendar/applyClient.html"/>' target="_blank" style="color: red">“客户端账号申请”参考手册</a>）
				</label>
			</b>
		</td>
	</tr>
		
	<tr>
		<td class="td_normal_title" width="15%">客户端账号</td>
		<td>
			<xform:text showStatus="edit" property="value(calendar.integrate.gcalendar.consumer.key)" style="width:350px" subject="客户端账号" required="true"/><br>
			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">客户端密码</td>
		<td>
			<xform:text htmlElementProperties="type='password'" showStatus="edit" property="value(calendar.integrate.gcalendar.consumer.secret)" style="width:350px" subject="客户端密码" required="true"/><br>
			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">OAuth认证地址</td>
		<td>
			<xform:text showStatus="edit" property="value(calendar.integrate.gcalendar.OAuth.url)" style="width:350px" subject="OAuth认证地址" required="true"/><br>
			<span class="message">默认是：https://accounts.google.com/o/oauth2</span>
			
		</td>
	</tr>
	
</table> 