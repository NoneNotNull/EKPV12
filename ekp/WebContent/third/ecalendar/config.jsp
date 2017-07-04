<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script>  
function config_ecalendar_onloadFunc(){
	var tbObj = document.getElementById("calendar.integrate.ecalendar");
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

function testConnect(){
	var webServiceUrl = document.getElementsByName("value(calendar.integrate.ecalendar.webService.url)")[0].value;
	var domain= document.getElementsByName("value(calendar.integrate.ecalendar.domain)")[0].value;
	var version= document.getElementsByName("value(calendar.integrate.ecalendar.version)")[0].value;
	var type="";
	if(webServiceUrl!="" && domain!=""){
		var style = "dialogWidth:300; dialogHeight:300; status:1; help:0; resizable:1";
		var url = "<c:url value="/resource/jsp/frame.jsp"/>";
		var parameter = "webServiceUrl="+webServiceUrl+"&domain="+domain+"&version="+version;
		url = Com_SetUrlParameter(url, "url","<c:url value='/third/ecalendar/testConnect.jsp?"+parameter+"'/>");
		var rtnVal = window.showModalDialog(url, null, style);
	}else{
		alert("请先设置webService地址和exchange邮箱域名");
	}
}
config_addOnloadFuncList(config_ecalendar_onloadFunc);  


</script>
<table class="tb_normal" width=100% id="calendar.integrate.ecalendar">
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				<label> 
					<html:checkbox property="value(calendar.integrate.ecalendar.enabled)" value="true" onclick="config_ecalendar_onloadFunc();"/>集成exchange日历
				</label>
			</b>
		</td>
	</tr>
		
	<tr>
		<td class="td_normal_title" width="15%">webService地址</td>
		<td>
			<xform:text showStatus="edit" property="value(calendar.integrate.ecalendar.webService.url)" style="width:350px" subject="webService地址" required="true"/><br>
			<br>
			例：https://exchange2.landray.local/EWS/Exchange.asmx
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">exchange邮箱域名</td>
		<td>
			<xform:text showStatus="edit" property="value(calendar.integrate.ecalendar.domain)" style="width:350px" subject="exchange邮箱域名" required="true"/><br>
			<br>
			例：exchange2.landray.local
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">exchange版本</td>
		<td>
			<xform:select property="value(calendar.integrate.ecalendar.version)" showPleaseSelect="false" showStatus="edit">
				<xform:enumsDataSource enumsType="third_ecalendar_exchange_version" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="button" class="btnopt" value="测试连接" onclick="testConnect();">
		</td>
		
	</tr>
	
</table> 