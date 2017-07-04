<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="head">
		<style type="text/css">
			body{height: 150px;background-color: white;}
			input{ vertical-align:middle; margin:0; padding:0}
			table td{padding: 12px 0px;}
			.file-box{ position:relative;width:260px}
			.txt{ height:22px; border:1px solid #cdcdcd; width:180px;}
			.btn{ background-color:#FFF; border:1px solid #CDCDCD;height:24px; width:70px;cursor: pointer;}
			.file{ position:absolute; top:0; left:0px; z-index:10; height:24px; filter:alpha(opacity:0);opacity: 0;width:260px;cursor: pointer;}
		</style>
		<script type="text/javascript">
			function _submitForm(){
				var fileInfo = document.getElementById('textfield').value;
				if(fileInfo==''){
					alert('请选择需要上传的excel文件!');
					return ;
				}
				if(fileInfo.indexOf('.xls')==-1){
					alert('文件类型不符合要求，请重新选择文件上传!');
					return ;
				}
				document.forms[0].submit();
			}
			function _changeOpt(thisObj){
				document.forms[0].action = Com_SetUrlParameter(document.forms[0].action , "impt_opt" ,thisObj.value);
			}
		</script>
	</template:replace>
	<template:replace name="content">
		<c:set var="extParam" value=""/> 
		<c:forEach var="item" items="${param}">
				<c:set var="extParam" value="&${item.key}=${item.value}${extParam}"/>
		</c:forEach>
		<form action="${LUI_ContextPath}/sys/xform/import.do?method=excelImport&impt_opt=1${extParam}" 
			method="post" enctype="multipart/form-data">
			<table class="tb_simple" width="100%">
				<tr>
					<td width="20%" align="center" class="td_normal_title">导入选项</td>
					<td align="left">
						<nobr>
						<label><input type="radio" name="impt_opt" value="0" onclick="_changeOpt(this);"/>追加导入</label>
						&nbsp;&nbsp;
						<label><input type="radio" name="impt_opt" value="1" checked="checked" onclick="_changeOpt(this);"/>替换导入</label>
						&nbsp;&nbsp;
						<label><input type="radio" name="impt_opt" value="2" onclick="_changeOpt(this);"/>导入到选中区域</label>
						</nobr>
					</td>
				</tr>
				<tr>
					<td width="20%" align="center" class="td_normal_title">文件选择</td>
					<td align="left">
						<div class="file-box">
							<input type='text' name='textfield' id='textfield' class='txt' />  
	 						<input type='button' class='btn' value='浏览...' />
	    					<input type="file" name="fileUpload" accept=".xls,.xlsx" 
	    						class="file" id="fileField" size="28" 
	    						onchange="document.getElementById('textfield').value=this.value" />
    					</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<ui:button text="提交" onclick="_submitForm();"></ui:button>
					</td>
				</tr>
			</table>
		</form>
	</template:replace>
</template:include>
