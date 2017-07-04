<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");</script>
<script>
var param = window.dialogArguments || opener.DialogParams;
var formFiels = param.formFiels;
Com_SetWindowTitle(param.title);
function initFiels() {
	var table = document.getElementById('showTable');
	for (var i = 0; i < formFiels.length; i ++) {
		var tr = table.insertRow(-1);
		var td = tr.insertCell(-1);
		td.innerHTML = '' + (i + 1);
		td = tr.insertCell(-1);
		td.innerHTML = formFiels[i].label;
		td = tr.insertCell(-1);
		td.innerHTML = formFiels[i].type;
		td = tr.insertCell(-1);
		var subLength = formFiels[i].len;
		if(subLength == null){
			subLength = 0;
		}else{
			subLength = subLength.substring(subLength.indexOf('.') + 1, subLength.length);
		}
		td.innerHTML = subLength;
	}
}
Com_AddEventListener(window, 'load', initFiels);
</script>

<center>
<table id="showTable" class="tb_normal" width="95%">
	<tr class="tr_normal_title">
		<td width="20px"><kmss:message key="sys-xform:sysFormDbFormFields.no" /></td>
		<td width="40%"><kmss:message key="sys-xform:sysFormDbFormFields.name" /></td>
		<td width="40%"><kmss:message key="sys-xform:sysFormDbFormFields.type" /></td>
		<td width="40%"><kmss:message key="sys-xform:sysFormDbColumn.fdLength" /></td>
	</tr>
</table>
<br style="height:10px;"/>
<input type=button class="btndialog" style="width:50px" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();">
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>