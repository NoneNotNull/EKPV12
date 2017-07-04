<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>

<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js|docutil.js|dialog.js|formula.js");
</script>
<script src="../js/workflow.js"></script>
<script src="../js/attribute.js"></script>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
<script>
var dialogObject = window.dialogArguments?window.dialogArguments:opener.Com_Parameter.Dialog;
FlowChartObject = dialogObject.Window.FlowChartObject;
var LineObject = dialogObject.Line;
var LineData = dialogObject.Line.Data;

function initDocument(){
	WorkFlow_PutDataToField(LineData, function(propertyName){
		return "wf_"+propertyName;
	});
	
	if(LineObject.StartNode.TypeCode == FlowChartObject.NODETYPE_CONDITION){
		document.getElementById("conditionId").style.display="";
	}

	if(FlowChartObject.IsEdit){
		document.getElementsByName("btnOK")[0].value = FlowChartObject.Lang.OK;
		document.getElementsByName("btnCancel")[0].value = FlowChartObject.Lang.Cancel;
		document.getElementsByName("wf_name")[0].focus();
		DIV_ReadButtons.style.display = "none";
	}else{
		disabledOperation();
		document.getElementsByName("btnClose")[0].value = FlowChartObject.Lang.Close;
		DIV_EditButtons.style.display = "none";
	}
	dialogHeight = "250px";
}

function disabledOperation(){
	var i;
	var fields = document.getElementsByTagName("A");
	for(i=0; i<fields.length; i++)
		fields[i].style.display = "none";
	fields = document.getElementsByTagName("INPUT");
	for(i=0; i<fields.length; i++){
		if(fields[i].type!="button")
			fields[i].disabled = true;
	}
	fields = document.getElementsByTagName("SELECT");
	for(i=0; i<fields.length; i++)
		fields[i].disabled = true;
	fields = document.getElementsByTagName("TEXTAREA");
	for(i=0; i<fields.length; i++)
		fields[i].disabled = true;
}

function writeMessage(key){
	document.write(FlowChartObject.Lang.Line[key]);
}

function writeLineData(){
	var data = new Object();
	WorkFlow_GetDataFromField(data, function(fieldName){
		if(fieldName.substring(0,3)=="wf_")
			return fieldName.substring(3);
		return null;
	});
	if(!lineDataCheck(data))
		return;
	for(var o in data)
		LineData[o] = data[o];
	returnValue = true;
	window.close();
}
function lineDataCheck(data){
	return true;
}

function openExpressionEditor() {
	Formula_Dialog("wf_condition", "wf_disCondition",FlowChartObject.FormFieldList,"Boolean",null,"com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction",FlowChartObject.ModelName);
}
</script>
</head>
<body onload="initDocument();">
<br><br>
<center>
<kmss:message key="FlowChartObject.Lang.Line.id" bundle="sys-lbpm-engine" />: <input name="wf_id" class="inputread" size="4" readonly>
<br><br>
<table width="590px" class="tb_normal">
	<tr>
		<td width="100px"><script>writeMessage("name")</script></td>
		<td>
			<input name="wf_name" class="inputsgl" style="width:100%" onkeydown="if(event.keyCode==13){document.getElementsByName('btnOK')[0].click();}">
		</td>
	</tr>
	<tr id="conditionId" style="display:none">
		<td width="100px"><script>writeMessage("condition")</script></td>
		<td>
			<input type="hidden" name="wf_condition">
			<input style="width:100%" class="inputsgl" readonly name="wf_disCondition"><br>
			<a href="#" onclick="openExpressionEditor();"><script>writeMessage("formula")</script></a>
		</td>
	</tr>
</table>
<br><br>
<div id="DIV_EditButtons">
	<input name="btnOK" type="button" class="btnopt" onclick="writeLineData();">
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input name="btnCancel" type="button" class="btnopt" onclick="window.close();">
</div>
<div id="DIV_ReadButtons">
	<input name="btnClose" type="button" class="btnopt" onclick="window.close();">
</div>
</center>
</body>
</html>