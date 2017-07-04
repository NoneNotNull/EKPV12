<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<% response.addHeader("X-UA-Compatible", "IE=5"); %>
<script>
Com_IncludeFile("dialog.js");
</script>
<style>
.message{
	color: #003366; 
}
</style>
<html>
	<div id="optBarDiv">
		<input type="button" value="导出模块版本" onclick="Com_OpenWindow('admin.do?method=exportModuleVersion','_self');">
		<input type="button" class="btnopt" value="备份配置文件" onclick="Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'admin.do?method=openBackup'),'700','300')"/>
		<input type="button" class="btnopt" value="保存" onclick="config_submitForm()"/>
	</div>
<head>
<title>系统配置</title>
<script>
//校验函数，通用函数，请使用该函数进行校验
var config_checkFuncList = new Array();
function config_addCheckFuncList(func){
	config_checkFuncList[config_checkFuncList.length]=func;
}

//唯一性校验，通用函数，请使用该函数进行唯一性校验
var config_validateUniqueParameter = new Array(); 
function config_addUniqueParameter(id, title){
	if(config_validateUniqueParameter[id]==null)
		config_validateUniqueParameter[id] = new Array();
	config_validateUniqueParameter[id][config_validateUniqueParameter[id].length] = title;
}
//页面加载,通用函数，页面加载请使用该函数
var config_onloadFuncList = new Array();
function config_addOnloadFuncList(func){
	config_onloadFuncList[config_onloadFuncList.length]=func;
}
//提交校验函数
function config_submitForm(){
	config_validateUniqueParameter = new Array();
	for(var i=0; i<config_checkFuncList.length; i++){
		if(!config_checkFuncList[i]()){
			return false;
		}
	}
	for (var i in config_validateUniqueParameter) { 
		var parameter = config_validateUniqueParameter[i];
		var alertMessage="";
		if(parameter.length>1){
			for(var j=0; j<parameter.length; j++){
				if(alertMessage==""){
					alertMessage = parameter[j];
				}else{
					if(alertMessage.indexOf(parameter[j])==-1){
						alertMessage += "\n" + parameter[j];
					}
				}
			}
			alert("不能同时选择:"+"\n"+alertMessage);
			return false;
		}
	}
	Com_Submit(document.forms[0], 'saveConfig');
}

//打开高级基础配置的高级选项
function config_openBaseAdvance(){
	var baseAdvance = document.getElementById("baseAdvance");
	var advanceCheckbox = document.getElementsByName("advanceCheckbox")[0];
	if(advanceCheckbox.checked){
		baseAdvance.style.display = 'block';
	}else{
		baseAdvance.style.display = 'none';
	}
}
</script>
</head>
<body>
<html:form action="/admin.do?method=saveConfig">
<p class="txttitle">系统配置</p>
<center>
<table id="Label_Tabel" width="95%">
	<tr LKS_LabelName="基础配置">
		<td>
			<c:forEach items="${sysConfigAdminForm.jspMap['base']}" var="jspList" varStatus="vstatus">
				<c:import url="${jspList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
			<c:forEach items="${sysConfigAdminForm.jspMap['baseAdvance']}" var="jspList" varStatus="vstatus">
				<c:import url="${jspList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
		</td>
	</tr>
	<tr LKS_LabelName="系统安全">
		<td>
			<c:forEach items="${sysConfigAdminForm.jspMap['authentication']}" var="integrateList" varStatus="vstatus">
				<c:import url="${integrateList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
		</td>
	</tr>
	<tr LKS_LabelName="集团应用">
		<td>
			<c:forEach items="${sysConfigAdminForm.jspMap['enterprise']}" var="integrateList" varStatus="vstatus">
				<c:import url="${integrateList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
		</td>
	</tr>
	<tr LKS_LabelName="集成配置">
		<td>
			<c:forEach items="${sysConfigAdminForm.jspMap['integrate']}" var="jspList" varStatus="vstatus">
				<c:import url="${jspList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
		</td>
	</tr>
	<tr LKS_LabelName="应用配置">
		<td>
			<c:forEach items="${sysConfigAdminForm.jspMap['application']}" var="otherList" varStatus="vstatus">
				<c:import url="${otherList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
			<c:forEach items="${sysConfigAdminForm.jspMap['other']}" var="otherList" varStatus="vstatus">
				<c:import url="${otherList}" charEncoding="UTF-8"/>
				<br>
			</c:forEach>
		</td>
	</tr>
</table>
</center>
<script>
window.onload = function(){
	for(var i=0; i<config_onloadFuncList.length; i++){
		config_onloadFuncList[i]();
	}
}
$KMSSValidation();
</script>
</html:form>
</body>
</html>
