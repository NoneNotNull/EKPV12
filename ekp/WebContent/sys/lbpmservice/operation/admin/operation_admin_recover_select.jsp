<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.constant.LbpmConstants" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<script>
Com_IncludeFile("dialog.js|doclist.js");
</script>
<form>
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.ok"/>" onclick="Workflow_SubmitClose();" />
		<input type="button" value="<bean:message key="button.cancel" />" onclick="Com_CloseWindow();" />
	</div>
	<p class="txttitle">
		<bean:message  bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.dialog.title"/>
	</p>
	<center>
		<table class="tb_normal" width=95%>
			<tr>
				<td width="20%" class="td_normal_title">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.scope.title" />
				</td>
				<td>
					<label><input type="radio" name="_type" value="1" checked onclick="Workflow_SelectScopeTypeListener();">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.scopetype.assign" /></label>
					<label><input type="radio" name="_type" value="2" onclick="Workflow_SelectScopeTypeListener();">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.scopetype.all" /></label>
				</td>
			</tr>
			<tr id="_scope_type_1">
				<td class="td_normal_title">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.node.title" />
				</td>
				<td>
					<input type="hidden"  name="nodeId" value="">
					<input type="text" class="inputsgl" name="nodeName" value="" style="width:80%">
					<a href="javascript:void(0);" onclick="Workflow_Dialog_NodeList();" ><bean:message key="dialog.selectOther" /></a>
					<span class="txtstrong">*</span>
				</td>
			</tr>
		</table>
	</center>
</form>
<script>
var detailsXMLObjArray = parent.dialogArguments?parent.dialogArguments:parent.opener.Com_Parameter.Dialog;
var nodes = detailsXMLObjArray.nodes;

function Workflow_Dialog_NodeList(){
	var nodeData = new KMSSData();
	for (var i = 0; i < nodes.length; i ++) {
		var node = nodes[i];
		if (node.XMLNODENAME == "startSubProcessNode") {
			nodeData.AddHashMap({"id":node.id, "name":node.id + "." + node.name});
		}
	}
	var dialog = new KMSSDialog(true, true);
	dialog.winTitle = "<bean:message  bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.dialog.title"/>";
	dialog.AddDefaultOption(nodeData);
	dialog.BindingField("nodeId", "nodeName", ";", false);
	//dialog.SetAfterShow(Workflow_SetDialogReturnValue);
	dialog.notNull = true;
	dialog.Show();
}
function Workflow_SelectScopeTypeListener() {
	var types = document.getElementsByName("_type");
	for (var i = 0; i < types.length; i ++) {
		var typeRadio = types[i];
		var div = document.getElementById("_scope_type_" + typeRadio.value);
		if (div != null) {
			div.style.display = typeRadio.checked ? "" : "none";
		}
	}
}
function Workflow_SetDialogReturnValue() {
	var types = document.getElementsByName("_type");
	var type = null;
	for (var i = 0; i < types.length; i ++) {
		var typeRadio = types[i];
		if (typeRadio.checked) {
			type = typeRadio.value;
			break;
		}
	}
	var nodeId = document.getElementsByName("nodeId")[0].value;
	var returnValue = {scopeType:type, nodeIds:nodeId};
	parent.returnValue = returnValue;
}
function Workflow_ValidateScopeType() {
	var types = document.getElementsByName("_type");
	var type = null;
	for (var i = 0; i < types.length; i ++) {
		var typeRadio = types[i];
		if (typeRadio.checked && typeRadio.value == '1') {
			var nodeId = document.getElementsByName("nodeId")[0].value;
			if (nodeId == '') {
				alert("<bean:message  bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.scopetype.assign.alert"/>");
				return false;
			}
		}
	}
	return true;
}
function Workflow_SubmitClose() {
	if (Workflow_ValidateScopeType()) {
		Workflow_SetDialogReturnValue();
		parent.close();
	}
}
</script>
</body>
</html>