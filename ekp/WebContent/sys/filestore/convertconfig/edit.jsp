<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="auto">

	<template:replace name="head">
		<script type="text/javascript">
			Com_IncludeFile("jquery.js|calendar.js|dialog.js|data.js");
			function submitForm(method) {
				Com_Submit(document.sysFileConvertConfigForm, method);
			}

			Com_AddEventListener(window, "load", function() {
				setHiddenFileExtNames();
				setHiddenFileModelNames();
				setHiddenConverterKeys();
			});

			function contains(string, substr, isIgnoreCase) {
				if (isIgnoreCase) {
					string = string.toLowerCase();
					substr = substr.toLowerCase();
				}
				var startChar = substr.substring(0, 1);
				var strLen = substr.length;
				for (var j = 0; j < string.length - strLen + 1; j++) {
					if (string.charAt(j) == startChar)//如果匹配起始字符,开始查找
					{
						if (string.substring(j, j + strLen) == substr)//如果从j开始的字符与str匹配，那ok
						{
							return true;
						}
					}
				}
				return false;
			}

			function setHiddenFileExtNames(){
				var hidden=document.getElementById("fileExtNames");
				var source=document.getElementsByName("fdFileExtName")[0];
				var extNames="";
				for(var i=0;i<source.length;i++){
					if(source.options[i].value!=""){
						extNames+=";"+source.options[i].value;
					}
				}
				if(extNames!=""){
					extNames=extNames.substring(1);
				}
				hidden.value=extNames;
			}

			function setHiddenFileModelNames(){
				var hidden=document.getElementById("modelNames");
				var source=document.getElementsByName("fdModelName")[0];
				var modelNames="";
				for(var i=0;i<source.length;i++){
					if(source.options[i].value!=""){
						modelNames+=";"+source.options[i].value+":"+source.options[i].text;;
					}
				}
				if(modelNames!=""){
					modelNames=modelNames.substring(1);
				}
				hidden.value=modelNames;
			}

			function setHiddenConverterKeys(){
				var hidden=document.getElementById("converterKeys");
				var source=document.getElementsByName("fdConverterKey")[0];
				var convertKeys="";
				for(var i=0;i<source.length;i++){
					if(source.options[i].value!=""){
						convertKeys+=";"+source.options[i].value;
					}
				}
				if(convertKeys!=""){
					convertKeys=convertKeys.substring(1);
				}
				hidden.value=convertKeys;
			}
			
			function addFileExtNames(){
				var newExtName=document.getElementsByName("customExtName")[0].value;
				if(newExtName==""||contains(newExtName," ",true)){
					alert("扩展名不能为空或者不能包含空格");
					return;
				}
				var exsitExtNames=document.getElementById("fileExtNames").value;
				if(contains(exsitExtNames,newExtName,true)){
					alert("已经存在了该扩展名");
					return;
				}
				var source=document.getElementsByName("fdFileExtName")[0];
				var newFileExtName=document.createElement('option');
				newFileExtName.value=document.getElementsByName("customExtName")[0].value;
				newFileExtName.text=document.getElementsByName("customExtName")[0].value;
				newFileExtName.selected=true;
				try{
					source.add(newFileExtName,null); // standards compliant
				}catch(ex){
					source.add(newFileExtName); // IE only
				}
				document.getElementsByName("customExtName")[0].value="";
				setHiddenFileExtNames();
			}
			
			function addModelNames(){
				var modelRegex=document.getElementsByName("customModelRegex")[0].value;
				if(modelRegex==""||contains(modelRegex," ",true)){
					alert("模块匹配不能为空或者不能包含空格");
					return;
				}
				var newModelName=modelRegex+":"+"";
				var exsitModelNames=document.getElementById("modelNames").value;
				if(contains(exsitModelNames,newModelName,true)){
					alert("已经存在了该模块匹配");
					return;
				}
				var source=document.getElementsByName("fdModelName")[0];
				var newFileModelName=document.createElement('option');
				var modelRegex=document.getElementsByName("customModelRegex")[0].value;
				newFileModelName.value=modelRegex;
				newFileModelName.text=modelRegex;
				newFileModelName.selected=true;
				try{
					source.add(newFileModelName,null); // standards compliant
				}catch(ex){
					source.add(newFileModelName); // IE only
				}
				document.getElementsByName("customModelRegex")[0].value="";
				setHiddenFileModelNames();
			}
			
			function addConverterKeys(){
				var newConverterKey=document.getElementsByName("customConverterKey")[0].value;
				if(newConverterKey==""||contains(newConverterKey," ",true)){
					alert("转换器标识不能为空或者不能包含空格");
					return;
				}
				var exsitConverterKeys=document.getElementById("converterKeys").value;
				if(contains(exsitConverterKeys,newConverterKey,true)){
					alert("已经存在了该转换器标识");
					return;
				}
				var source=document.getElementsByName("fdConverterKey")[0];
				var newConverterKey=document.createElement('option');
				newConverterKey.value=document.getElementsByName("customConverterKey")[0].value;
				newConverterKey.text=document.getElementsByName("customConverterKey")[0].value;
				newConverterKey.selected=true;
				try{
					source.add(newConverterKey,null); // standards compliant
				}catch(ex){
					source.add(newConverterKey); // IE only
				}
				document.getElementsByName("customConverterKey")[0].value="";
				setHiddenConverterKeys();
			}
		</script>
	</template:replace>

	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<c:when test="${ sysFileConvertConfigForm.method_GET == 'add' }">
					<ui:button text="${lfn:message('button.save') }" order="2"
						onclick="submitForm('save');">
					</ui:button>
					<ui:button text="${lfn:message('button.saveadd') }" order="2"
						onclick="submitForm('saveadd');">
					</ui:button>
				</c:when>
				<c:when test="${ sysFileConvertConfigForm.method_GET == 'edit'}">
					<ui:button text="${lfn:message('button.submit') }" order="2"
						onclick="submitForm('update');">
					</ui:button>
				</c:when>
			</c:choose>
			<ui:button text="${lfn:message('button.close') }" order="5"
				onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
		<c:set var="sysFileConvertConfigForm"
			value="${sysFileConvertConfigForm}" scope="request" />
		<html:form
			action="/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do">
			<html:hidden property="fdId" />
			<input id="fileExtNames" type="hidden">
			<input id="modelNames" type="hidden">
			<input id="converterKeys" type="hidden">
			<div class="lui_form_content_frame" style="padding-top: 20px">
			<table class="tb_simple" style="width: 95%; height: 300px;">
				<tr>
					<td width="25%">文档类型</td>
					<td width="25%">文档模块</td>
					<td width="25%">转换器标识</td>
					<td width="25%">转换器位置</td>
				</tr>
				<tr>
					<td style=""><xform:select style="width:90%;height: 350px;"
						required="true" property="fdFileExtName" showPleaseSelect="false"
						htmlElementProperties="size='8'">
						<xform:customizeDataSource
							className="com.landray.kmss.sys.filestore.service.spring.SysFileStoreExtNamesDataSource"></xform:customizeDataSource>
					</xform:select></td>
					<td><xform:select style="width:90%;height: 350px;"
						required="true" property="fdModelName" showPleaseSelect="false"
						htmlElementProperties="size='8'">
						<xform:customizeDataSource
							className="com.landray.kmss.sys.filestore.service.spring.SysFileStoreModelNamesDataSource"></xform:customizeDataSource>
					</xform:select></td>
					<td><xform:select style="width:90%;height: 350px;"
						required="true" property="fdConverterKey" showPleaseSelect="false"
						htmlElementProperties="size='8'">
						<xform:customizeDataSource
							className="com.landray.kmss.sys.filestore.service.spring.SysFileStoreConverterKeysDataSource"></xform:customizeDataSource>
					</xform:select></td>
					<td><xform:select style="width:90%;height: 350px;"
						property="fdDispenser" showPleaseSelect="false"
						htmlElementProperties="size='8'" required="true">
						<xform:customizeDataSource
							className="com.landray.kmss.sys.filestore.service.spring.SysFileStoreDispenserDataSource"></xform:customizeDataSource>
					</xform:select></td>
				</tr>
				<tr>
					<td>
					<table width="90%">
						<tr>
							<td width="100%"><xform:text property="customExtName"
								style="width:95%;height:20px;"></xform:text></td>
							<td width="100%"><input type="button" value="添加"
								style="height: 20px;" onclick="addFileExtNames();"></td>
						</tr>
					</table>
					</td>
					<td>
					<table width="90%">
						<tr>
							<td width="100%"><xform:text property="customModelRegex"
								style="width:95%;height:20px;"></xform:text></td>
							<td width="100%"><input type="button" value="添加"
								style="height: 20px;" onclick="addModelNames();"></td>
						</tr>
					</table>
					</td>
					<td>
					<table width="90%">
						<tr>
							<td width="100%"><xform:text property="customConverterKey"
								style="width:95%;height:20px;"></xform:text></td>
							<td width="100%"><input type="button" value="添加"
								style="height: 20px;" onclick="addConverterKeys();"></td>
						</tr>
					</table>
					</td>
					<td></td>
				</tr>
			</table>
			</div>
		</html:form>
		<script language="JavaScript">
			$KMSSValidation(document.forms['sysFileConvertConfigForm']);
		</script>
	</template:replace>
</template:include>