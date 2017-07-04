<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<script>Com_IncludeFile("formula.js");</script>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
		<table width="100%" class="tb_normal">
			<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessTitle" bundle="sys-lbpmservice-node-subprocess" /></td>
				<td>
					<input type="hidden" name="templateId">
					<input type="text" name="templateName" readOnly style="width:90%" class="inputSgl">
					<a href="javascript:void(0);" onclick="selectSubFlow();"><kmss:message key="FlowChartObject.Lang.Node.select" bundle="sys-lbpmservice" /></a>
					<span class="txtstrong">*</span>
					<input type="hidden" name="modelName">
					<input type="hidden" name="createParam">
					<input type="hidden" name="dictBean">
				</td>
			</tr>
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartIdentityType" bundle="sys-lbpmservice-node-subprocess" /></td>
				<td>
					<label><input type="radio" name="startIdentityType" onclick="changeIdentityType(this);" value="1" checked><kmss:message key="FlowChartObject.Lang.Node.subprocessStartIdentityTypeDraftsman" bundle="sys-lbpmservice-node-subprocess" /></label>
					<!--label><input type="radio" name="startIdentityType" onclick="changeIdentityType(this);" value="2">前一节点审批人</label-->
					<label><input type="radio" name="startIdentityType" onclick="changeIdentityType(this);" value="3"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartIdentityTypeAddress" bundle="sys-lbpmservice-node-subprocess" /></label>
					<label><input type="radio" name="startIdentityType" onclick="changeIdentityType(this);" value="4"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartIdentityTypeFormula" bundle="sys-lbpmservice-node-subprocess" /></label>
					<div id="IdentityType_3" style="display:none;">
						<input type="hidden" name="addressValueId">
						<input type="text" name="addressValueName" style="width:85%" class="inputSgl">
						<a href="javascript:void(0);" 
							onclick="Dialog_Address(true, 'addressValueId','addressValueName', ';', ORG_TYPE_PERSON, null, null, null, true);">
							<kmss:message key="FlowChartObject.Lang.Node.select" bundle="sys-lbpmservice" /></a>
						<span class="txtstrong">*</span>
					</div>
					<div id="IdentityType_4" style="display:none;">
						<input type="hidden" name="formulaValueId">
						<input type="text" name="formulaValueName" style="width:85%" class="inputSgl">
						<a href="javascript:void(0);" 
							onclick="Formula_Dialog('formulaValueId','formulaValueName', 
								FlowChartObject.FormFieldList, 'com.landray.kmss.sys.organization.model.SysOrgElement[]'
								, null, 'com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction;com.landray.kmss.sys.lbpmservice.formula.LbpmSubProcessFunction', FlowChartObject.ModelName);">
								<kmss:message key="FlowChartObject.Lang.Node.select" bundle="sys-lbpmservice" /></a>
						<span class="txtstrong">*</span>
						<p style="margin-top: 3px;padding-top: 0px;"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartIdentityTypeFormulaInfo" bundle="sys-lbpmservice-node-subprocess" /></p>
					</div>
				</td>
			</tr>
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartCountType" bundle="sys-lbpmservice-node-subprocess" /></td>
				<td>
					<label><input type="radio" name="startCountType" value="1" checked><kmss:message key="FlowChartObject.Lang.Node.subprocessStartCountTypeOne" bundle="sys-lbpmservice-node-subprocess" /></label>
					<label><input type="radio" name="startCountType" value="2"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartCountTypeMulti" bundle="sys-lbpmservice-node-subprocess" /></label>
				</td>
			</tr>
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartRule" bundle="sys-lbpmservice-node-subprocess" /></td>
				<td>
					<label><input type="checkbox" name="skipDraftNode" value="true"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartRuleSkipDraftNode" bundle="sys-lbpmservice-node-subprocess" /></label>
					<label><input type="checkbox" name="wf_synchronizeRight" value="true"><kmss:message key="FlowChartObject.Lang.Node.subprocessSynchronizeRight" bundle="sys-lbpmservice-node-subprocess" /></label>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="txtstrong">
					<kmss:message key="FlowChartObject.Lang.Node.subprocessParameterIntroduce" bundle="sys-lbpmservice-node-subprocess" />
					</div>
					<table class="tb_normal" id="paramTable" style="width:100%">
						<tr>
							<td style="width:10%"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartParamNo" bundle="sys-lbpmservice-node-subprocess" /></td>
							<td style="width:30%"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartParamName" bundle="sys-lbpmservice-node-subprocess" /></td>
							<td style="width:40%"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartParamExpression" bundle="sys-lbpmservice-node-subprocess" /></td>
							<td style="width:30%"><a href="javascript:void(0);" onclick="addSubProcessParamenter(this);"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartParamAdd" bundle="sys-lbpmservice-node-subprocess" /></a></td>
						</tr>
						<tr KMSS_IsReferRow="1" style="display:none">
							<td KMSS_IsRowIndex="1"></td>
							<td>
								<input type="hidden" name="startParamenters.name.notNull">
								<input type="hidden" name="startParamenters.name.value">
								<input type="hidden" name="startParamenters.name.type">
								<input type="text" name="startParamenters.name.text" readonly="readonly" style="width:90%" class="inputSgl">
							</td>
							<td>
								<input type="hidden" name="startParamenters.expression.value">
								<input type="text" name="startParamenters.expression.text" readonly="readonly" style="width:80%" class="inputSgl">
								<a href="javascript:void(0);"  onclick="showParamenterFormulaDialog(this);"><kmss:message key="FlowChartObject.Lang.Node.select" bundle="sys-lbpmservice" /></a>
								<span class="txtstrong">*</span>
							</td>
							<td>
								<a href="javascript:void(0);" onclick="DocList_DeleteRow();"><kmss:message key="FlowChartObject.Lang.Node.subprocessStartParamDel" bundle="sys-lbpmservice-node-subprocess" /></a>
								<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveUp" bundle="sys-lbpmservice" /></a>
								<a href="javascript:void(0);" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveDown" bundle="sys-lbpmservice" /></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessExceptionConfig" bundle="sys-lbpmservice-node-subprocess" /></td>
				<td>
					<label><input type="checkbox" name="onErrorNotify" value="2"><kmss:message key="FlowChartObject.Lang.Node.subprocessExceptionNotifyPrivilege" bundle="sys-lbpmservice-node-subprocess" /></label>
					<label><input type="checkbox" name="onErrorNotify" value="1"><kmss:message key="FlowChartObject.Lang.Node.subprocessExceptionNotifyDraftsman" bundle="sys-lbpmservice-node-subprocess" /></label>
				</td>
			</tr>
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.description" bundle="sys-lbpm-engine" /></td>
				<td>
					<textarea name="wf_description" style="width:100%"></textarea>
					<kmss:message key="FlowChartObject.Lang.Node.imgLink" bundle="sys-lbpm-engine" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Event" bundle="sys-lbpm-engine" />">
		<td>
		<c:import url="/sys/lbpm/flowchart/page/node_event_attribute.jsp" charEncoding="UTF-8" />
		</td>
	</tr>
</table>


<script>
DocList_Info.push("paramTable");

function formatJson(value) {
	return value.replace(/"/ig,'\\"').replace(/\r\n/ig,'\\r\\n');
}

AttributeObject.Init.AllModeFuns.push(initSubProcessInfo);

function nodeDataCheck(data){
	if (document.getElementsByName('modelName')[0].value == '') {
		alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertModelNameNotNull" bundle="sys-lbpmservice-node-subprocess" />');
		return false;
	}
	var startIdentityType = getRadioValue(document.getElementsByName('startIdentityType'));
	if (startIdentityType == '3' && (document.getElementsByName('addressValueId')[0].value == '')) {
		alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertAddressValueIdNotNull" bundle="sys-lbpmservice-node-subprocess" />');
		return false;
	}
	else if (startIdentityType == '4' && (document.getElementsByName('formulaValueId')[0].value == '')) {
		alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertFormulaValueIdNotNull" bundle="sys-lbpmservice-node-subprocess" />');
		return false;
	}
	var expressionValues= document.getElementsByName("startParamenters.expression.value");
	for (var i = 0; i < expressionValues.length; i ++) {
		var value = expressionValues[i].value;
		if (value == '') {
			alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertExpressionValueNotNull" bundle="sys-lbpmservice-node-subprocess" />');
			return false;
		}
	}

	if (AttributeObject.NodeData['configContent'] != null) {
		var json = eval("(" + AttributeObject.NodeData['configContent'] + ")");
		var startCountType = getRadioValue(document.getElementsByName('startCountType'));
		var templateId = document.getElementsByName('templateId')[0].value;
		if (json.startCountType != startCountType || json.subProcess.templateId != templateId) {
			var nodes = getRelationRecoverNode();
			if (nodes != null && nodes.length > 0) {
				var alertNames = [];
				for (var i = 0; i < nodes.length; i ++) {
					var node = nodes[i];
					alertNames.push(node.Data.id + "." + node.Data.name);
				}
				node.NeedReConfig = true;
				alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.Node.subprocessAlertConfigRelationNode, alertNames.join("; ")));
			}
		}
	}
	return true;
}
AttributeObject.CheckDataFuns.push(nodeDataCheck);


function getRelationRecoverNode() {
	var rtn = [];
	var nodes = FlowChartObject.Nodes.all;
	for (var i = 0; i < nodes.length; i ++) {
		var node = nodes[i];
		if (node.Type == "recoverSubProcessNode" && node.Data['configContent'] != null) {
			var json = (new Function("return ("+ node.Data['configContent'] + ")"))();
			if (json.subProcessNode == AttributeObject.NodeData.id) {
				rtn.push(node);
			}
		}
	}
	return rtn;
}

function writeJSON() {
	var getNameValue = function(name) {
		return (formatJson(document.getElementsByName(name)[0].value));
	}
	var config = [];
	config.push("{ \"subProcess\":{\"modelName\":");
	config.push("\"" + getNameValue('modelName') + "\"");
	config.push(",\"dictBean\":");
	config.push("\"" + getNameValue('dictBean') + "\"");
	config.push(",\"templateId\":");
	config.push("\"" + getNameValue('templateId') + "\"");
	config.push(",\"templateName\":");
	config.push("\"" + getNameValue('templateName') + "\"");
	config.push(",\"createParam\":");
	config.push("\"" + getNameValue('createParam') + "\"");
	config.push("}");

	var startIdentityType = getRadioValue(document.getElementsByName('startIdentityType'));
	var startIdentityNames = ["", ""];
	if (startIdentityType == "3") {
		startIdentityNames = [getNameValue("addressValueId"), getNameValue("addressValueName")];
	} else if (startIdentityType == "4") {
		startIdentityNames = [getNameValue("formulaValueId"), getNameValue("formulaValueName")];
	}
	config.push(",\"startIdentity\":{\"type\":");
	config.push(startIdentityType);
	config.push(",\"names\":");
	config.push("\"" + startIdentityNames[1] + "\"");
	config.push(",\"values\":");
	config.push("\"" + startIdentityNames[0] + "\"");
	config.push("}");
	
	config.push(",\"startCountType\":");
	config.push(getRadioValue(document.getElementsByName('startCountType')));

	config.push(",\"skipDraftNode\":");
	config.push("" + document.getElementsByName('skipDraftNode')[0].checked);

	var notifies = getCheckboxValue(document.getElementsByName('onErrorNotify'));
	var onErrorNotify = [];
	for (var i = 0; i < notifies.length; i ++) {
		onErrorNotify.push("" + notifies[i]);
	}
	config.push(",\"onErrorNotify\":");
	config.push("[" + onErrorNotify.join(",") + "]");

	config.push(",\"startParamenters\":");
	config.push(getParamentersJson());
	
	config.push("}");
	AttributeObject.NodeData['configContent'] = config.join("");
}

AttributeObject.AppendDataFuns.push(writeJSON);

function getParamentersJson() {
	var rtn = [];
	var values = document.getElementsByName("startParamenters.name.value");
	var texts = document.getElementsByName("startParamenters.name.text");
	var types = document.getElementsByName("startParamenters.name.type");
	var notNulls = document.getElementsByName("startParamenters.name.notNull");
	var expressionValues= document.getElementsByName("startParamenters.expression.value");
	var expressionTexts= document.getElementsByName("startParamenters.expression.text");
	for (var i = 0; i < values.length; i ++) {
		rtn.push("{\"name\":{\"text\":\"" + formatJson(texts[i].value) 
				+ "\",\"value\":\"" + values[i].value
				+ "\",\"type\":\"" + types[i].value 
			    + "\",\"notNull\":\"" + notNulls[i].value + "\"}"
			    + ",\"expression\":{\"text\":\"" + formatJson(expressionTexts[i].value) 
				+ "\",\"value\":\"" + formatJson(expressionValues[i].value) + "\"}}");
	}
	return "[" + rtn.join(",") + "]";
}

function getRadioValue(radios) {
	for (var i = 0; i < radios.length; i ++) {
		var radio = radios[i];
		if (radio.checked) {
			return radio.value;
		}
	}
}
function getCheckboxValue(checkboxs) {
	var rtn = [];
	for (var i = 0; i < checkboxs.length; i ++) {
		if (checkboxs[i].checked) {
			rtn.push(checkboxs[i].value);
		}
	}
	return rtn;
}

function setRadio(radios, value) {
	value = value.toString();
	for (var i = 0; i < radios.length; i ++) {
		var radio = radios[i];
		if (radio.value == value) {
			radio.checked = true;
			break;
		}
	}
}
function setCheckbox(checkboxs, values) {
	for (var i = 0; i < values.length; i ++) {
		var value = values[i];
		setRadio(checkboxs, value);
	}
}

function initSubProcessInfo() {
	var config = AttributeObject.NodeData['configContent'];
	if (config != null && config != "") {
		var json = (new Function("return ("+ config + ")"))();
		initModelName(json);
		initParams(json);
	} else {
		SetStartCountTypeState('1');
	}
}
function initModelName(json) {
	document.getElementsByName('modelName')[0].value = json.subProcess.modelName;
	document.getElementsByName('dictBean')[0].value = json.subProcess.dictBean;
	document.getElementsByName('templateId')[0].value = json.subProcess.templateId;
	document.getElementsByName('templateName')[0].value = json.subProcess.templateName;
	document.getElementsByName('createParam')[0].value = json.subProcess.createParam;

	setRadio(document.getElementsByName('startIdentityType'), json.startIdentity.type);
	setRadio(document.getElementsByName('startCountType'), json.startCountType);
	setRadio(document.getElementsByName('skipDraftNode'), json.skipDraftNode);
	setCheckbox(document.getElementsByName('onErrorNotify'), json.onErrorNotify);

	if (json.startIdentity.type == 3) {
		document.getElementsByName('addressValueId')[0].value = json.startIdentity.values;
		document.getElementsByName('addressValueName')[0].value = json.startIdentity.names;
	} else if (json.startIdentity.type == 4) {
		document.getElementsByName('formulaValueId')[0].value = json.startIdentity.values;
		document.getElementsByName('formulaValueName')[0].value = json.startIdentity.names;
	}
	var div = document.getElementById("IdentityType_" + json.startIdentity.type);
	if (div != null) {
		div.style.display = "";
	}
	SetStartCountTypeState(json.startIdentity.type);
}
function initParams(json) {
	var params = json.startParamenters;
	for (var i = 0; i < params.length; i ++) {
		var row = params[i];
		var p = (row.name.notNull == 'true' || row.name.notNull == true) ? [null, null, null, ""] : [];
		DocList_AddRow("paramTable", p,
				{
					"startParamenters.name.type" : row.name.type, 
					"startParamenters.name.value" : row.name.value,
					"startParamenters.name.text" : row.name.text,
					"startParamenters.name.notNull" : row.name.notNull,
					"startParamenters.expression.value" : row.expression.value,
					"startParamenters.expression.text" : row.expression.text
				});
	}
}

//---- 子流程选择对话框
function addSubProcessParamenter(table) {
	while (table.tagName != 'TABLE') {
		table = table.parentNode;
	}
	var modelName = document.getElementsByName('modelName')[0];
	var dictBean = document.getElementsByName('dictBean')[0];
	var templateId = document.getElementsByName('templateId')[0];
	var url = "subProcessDictService&modelName=" + modelName.value + "&templateId=" + templateId.value;
	if (dictBean != null && dictBean.value != '') {
		url = dictBean.value;
	}
	
	Dialog_List(false, null, null, ";", url, function(data) {
		if (data != null) {
			var tr = DocList_AddRow(table);
			var inputs = tr.getElementsByTagName("input");
			var value = getElementsByName(inputs, "startParamenters.name.value");
			var text = getElementsByName(inputs, "startParamenters.name.text");
			var type = getElementsByName(inputs, "startParamenters.name.type");
			var notNull = getElementsByName(inputs, "startParamenters.name.notNull");
			if (value != null && text != null) {
				var rows = data.GetHashMapArray();
				value.value = rows[0].id;
				text.value = rows[0].name;
				type.value = rows[0].type;
				notNull.value = rows[0].notNull;
			}
		}
	});
}

// 参数公式对话框
function showParamenterFormulaDialog(tr) {
	while (tr.tagName != 'TR') {
		tr = tr.parentNode;
	}
	var inputs = tr.getElementsByTagName("input");
	var value = getElementsByName(inputs, "startParamenters.expression.value");
	var text = getElementsByName(inputs, "startParamenters.expression.text");
	var type = getElementsByName(inputs, "startParamenters.name.type");
	Formula_Dialog(value, text, 
			FlowChartObject.FormFieldList, type.value, function(data) {
		
	});
}

function loadNotNullProperties(modelName, templateId, dictBean) {
	var url = "subProcessDictService&modelName=" + modelName + "&templateId=" + templateId;
	if (dictBean != null && dictBean != "") {
		url = dictBean;
	}
	var kmssData = new KMSSData();
	kmssData.SendToBean(url , function(data) {
		var rows = data.GetHashMapArray();
		for (var i = 0; i < rows.length; i ++) {
			var row = rows[i];
			if (row.id != "docSubject") {
				continue;
			}
			DocList_AddRow("paramTable",
				[null, null, null, ""],
				{
					"startParamenters.name.type" : row.type, 
					"startParamenters.name.value" : row.id,
					"startParamenters.name.text" : row.name,
					"startParamenters.name.notNull" : row.notNull
				});
		}
	});
}
// 子流程选择框
function selectSubFlow() {
	var dialog = new KMSSDialog(false, false);
	var treeTitle = '<kmss:message key="FlowChartObject.Lang.Node.subprocessTitle" bundle="sys-lbpmservice-node-subprocess" />';
	var node = dialog.CreateTree(treeTitle);
	dialog.winTitle = treeTitle;
	var fdId = null;
	try {
		if (FlowChartObject.IsTemplate) { // just for template
			var dialogObject=window.dialogArguments?window.dialogArguments:opener.Com_Parameter.Dialog;
			var url = dialogObject.Window.parent.parent.location.href;
			fdId = Com_GetUrlParameter(url, 'fdId');
		}
	} catch (e) {}
	node.AppendBeanData("subProcessDialogService", null, null, false, fdId);
	dialog.notNull = true;
	dialog.BindingField('templateId', 'templateName');
	dialog.SetAfterShow(function(rtnData){
		if(rtnData!=null){
			var node = Tree_GetNodeByID(this.tree.treeRoot, this.rtnData.GetHashMapArray()[0].nodeId);
			var pNode = node;
			for(;  pNode.value.indexOf("&") == -1; pNode = pNode.parent){
				
			}
			// 回写全名
			var path = Tree_GetNodePath(node,"/",node.treeView.treeRoot);
			document.getElementsByName('templateName')[0].value = path;
			
			var modelName = document.getElementsByName('modelName')[0];
			var dictBean = document.getElementsByName('dictBean')[0];
			var createParam = document.getElementsByName('createParam')[0];

			
			modelName.value = findValueByName(pNode.value, 'MODEL_NAME');
			createParam.value = replaceParam(pNode.value, node.value);

			var dictBeanValue = findValueByName(pNode.value, 'DICT_BEAN');

			dictBeanValue = decodeURIComponent(dictBeanValue);
			dictBeanValue = replaceModelName(dictBeanValue, modelName.value);
			dictBeanValue = replaceCateid(dictBeanValue, node.value);
			dictBean.value = dictBeanValue;

			clearParamTable();
			loadNotNullProperties(modelName.value, node.value, dictBean.value);
		}
	});
	dialog.Show();
	//showConfigPanel(true);
	
}

function changeIdentityType(dom) {
	var td = dom;
	while (td.tagName != 'TD') {
		td = td.parentNode;
	}
	var value = dom.value;
	var divs = td.getElementsByTagName('DIV');
	for (var i = 0; i < divs.length; i ++) {
		var div = divs[i];
		if ("IdentityType_" + value == div.id) {
			div.style.display = "";
		} else {
			div.style.display = "none";
		}
	}
	SetStartCountTypeState(value);
}

function SetStartCountTypeState(identityType) {
	var startCountTypes = document.getElementsByName('startCountType');
	if (identityType == '1') {
		for (var i = 0; i < startCountTypes.length; i ++) {
			var startCountType = startCountTypes[i];
			if (startCountType.value == '1') {
				if (!startCountType.checked)
					startCountType.checked = true;
			}
			else if (!startCountType.disabled) {
				startCountType.disabled = true;
			}
		}
	}
	else {
		for (var i = 0; i < startCountTypes.length; i ++) {
			var startCountType = startCountTypes[i];
			if (startCountType.disabled) {
				startCountType.disabled = false;
			}
		}
	}
}

function clearParamTable() {
	var table = document.getElementById("paramTable");
	var rows = table.rows;
	var l = rows.length - 1;
	for (var i = l; i > 0; i --) {
		//table.deleteRow(i);
		DocList_DeleteRow(rows[i]);
	}
}

function findValueByName(value, name) {
	var vs = value.split("&"), i, v;
	for (i = 0; i < vs.length; i ++) {
		v = vs[i].split('=');
		if (name == v[0]) {
			return v[1];
		}
	}
	return '';
}
function replaceParam(url, cateid) {
	var re = /!\{cateid\}/gi;
	url = url.replace(/!\{cateid\}/gi, cateid);
	return url.substring(url.indexOf('&') + 1, url.length);
}
function replaceModelName(url, modelName) {
	var re = /!\{modelName\}/gi;
	url = url.replace(/!\{modelName\}/gi, modelName);
	return url;
}
function replaceCateid(url, cateid) {
	var re = /!\{cateid\}/gi;
	url = url.replace(/!\{cateid\}/gi, cateid);
	return url;
}
function getElementsByName(list, name) {
	for (var i = 0; i < list.length; i ++) {
		if (list[i].name == name) {
			return list[i];
		}
	}
	return null;
}
</script>