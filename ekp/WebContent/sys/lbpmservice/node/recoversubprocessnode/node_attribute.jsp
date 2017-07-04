<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
			<table width="100%" class="tb_normal">
				<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverTitle" bundle="sys-lbpmservice-node-subprocess" /></td>
					<td>
						<select id="subProcessNode" name="subProcessNode" onchange="clearParamTable();">
						</select>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverVariableScope" bundle="sys-lbpmservice-node-subprocess" /></td>
					<td>
						<label><input type="radio" name="variableScope" value="2" checked><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverVariableScopePassed" bundle="sys-lbpmservice-node-subprocess" /></label>
						<label><input type="radio" name="variableScope" value="3"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverVariableScopeAbandon" bundle="sys-lbpmservice-node-subprocess" /></label>
						<label><input type="radio" name="variableScope" value="1"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverVariableScopeEnd" bundle="sys-lbpmservice-node-subprocess" /></label>
					</td>
				</tr>
				<tr id="recoverRuleTR">
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRule" bundle="sys-lbpmservice-node-subprocess" /></td>
					<td>
						<label><input type="radio" name="recoverRuleType" onclick="changeRecoverRuleType(this);" value="1" checked><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRuleAllEnd" bundle="sys-lbpmservice-node-subprocess" /></label>
						<label><input type="radio" name="recoverRuleType" onclick="changeRecoverRuleType(this);" value="2"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRuleAnyEnd" bundle="sys-lbpmservice-node-subprocess" /></label>
						<label><input type="radio" name="recoverRuleType" onclick="changeRecoverRuleType(this);" value="3"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRuleFormula" bundle="sys-lbpmservice-node-subprocess" /></label>
						<div id="recoverRuleType_1" style="display:none;">
							<div><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRuleAllEndInfo" bundle="sys-lbpmservice-node-subprocess" /></div>
						</div>
						<div id="recoverRuleType_2" style="display:none;">
							<div><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRuleAnyEndInfo" bundle="sys-lbpmservice-node-subprocess" /></div>
						</div>
						<div id="recoverRuleType_3" style="display:none;">
							<input type="hidden" name="formulaValueId">
							<input type="text" name="formulaValueName" style="width:85%" class="inputSgl">
							<a href="javascript:void(0);" 
								onclick="showRecoverRuleFormula();">
									<kmss:message key="FlowChartObject.Lang.Node.select" bundle="sys-lbpmservice" /></a>
							<span class="txtstrong">*</span>
							<div><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverRuleFormulaInfo" bundle="sys-lbpmservice-node-subprocess" /></div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table class="tb_normal" id="paramTable" style="width:100%">
							<tr>
								<td style="width:10%"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverParamNo" bundle="sys-lbpmservice-node-subprocess" /></td>
								<td style="width:30%"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverParamName" bundle="sys-lbpmservice-node-subprocess" /></td>
								<td style="width:40%"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverParamExpression" bundle="sys-lbpmservice-node-subprocess" /></td>
								<td style="width:30%"><a href="javascript:void(0);" onclick="addSubProcessParamenter(this);"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverParamAdd" bundle="sys-lbpmservice-node-subprocess" /></a></td>
							</tr>
							<tr KMSS_IsReferRow="1" style="display:none">
								<td KMSS_IsRowIndex="1"></td>
								<td>
									<input type="hidden" name="recoverParamenters.name.value">
									<input type="hidden" name="recoverParamenters.name.type">
									<input type="text" name="recoverParamenters.name.text" readonly="readonly" style="width:90%" class="inputSgl">
								</td>
								<td>
									<input type="hidden" name="recoverParamenters.expression.value">
									<input type="text" name="recoverParamenters.expression.text" readonly="readonly" style="width:80%" class="inputSgl">
									<a href="javascript:void(0);"  onclick="showParamenterFormulaDialog(this);"><kmss:message key="FlowChartObject.Lang.Node.select" bundle="sys-lbpmservice" /></a>
									<span class="txtstrong">*</span>
								</td>
								<td>
									<a href="javascript:void(0);" onclick="DocList_DeleteRow();"><kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverParamDel" bundle="sys-lbpmservice-node-subprocess" /></a>
									<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveUp" bundle="sys-lbpmservice" /></a>
									<a href="javascript:void(0);" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveDown" bundle="sys-lbpmservice" /></a>
								</td>
							</tr>
						</table>
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
//初始化参数
DocList_Info.push("paramTable");

function formatJson(value) {
	return value.replace(/"/ig,'\\"').replace(/\r\n/ig,'\\r\\n');
}

AttributeObject.Init.AllModeFuns.push(initStartNodes,initRecoverConfig);

function nodeDataCheck(data){
	if (document.getElementsByName('subProcessNode')[0].value == '') {
		alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertSelectProcessNode" bundle="sys-lbpmservice-node-subprocess" />');
		return false;
	}
	var expressionValues= document.getElementsByName("recoverParamenters.expression.value");
	for (var i = 0; i < expressionValues.length; i ++) {
		var value = expressionValues[i].value;
		if (value == '') {
			alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertExpressionValueNotNull" bundle="sys-lbpmservice-node-subprocess" />');
			return false;
		}
	}
	var recoverRuleType = getRadioValue(document.getElementsByName('recoverRuleType'));
	if (recoverRuleType == '3') {
		if (document.getElementsByName('formulaValueName')[0].value == "") {
			alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertRecoverFormulaValueIdNotNull" bundle="sys-lbpmservice-node-subprocess" />');
			return false;
		}
	}
	return true;
}

AttributeObject.CheckDataFuns.push(nodeDataCheck);

function writeJSON(data) {
	var getNameValue = function(name) {
		return (formatJson(document.getElementsByName(name)[0].value));
	};
	var config = [];
	config.push("{ \"subProcessNode\":");
	config.push("\"" + getNameValue('subProcessNode') + "\"");
	
	config.push(",\"variableScope\":");
	config.push(getRadioValue(document.getElementsByName('variableScope')));

	config.push(",\"recoverRule\":{\"type\":");
	config.push(getRadioValue(document.getElementsByName('recoverRuleType')));
	config.push(",\"expression\":{\"text\":");
	config.push("\"" + formatJson(document.getElementsByName('formulaValueName')[0].value) + "\"");
	config.push(",\"value\":");
	config.push("\"" + formatJson(document.getElementsByName('formulaValueId')[0].value) + "\"");
	config.push("}}");

	config.push(",\"recoverParamenters\":");
	config.push(getParamentersJson());
	
	config.push("}");
	data['configContent'] = config.join("");

	AttributeObject.NodeObject.NeedReConfig = false;
}
AttributeObject.AppendDataFuns.push(writeJSON);

function getParamentersJson() {
	var rtn = [];
	var values = document.getElementsByName("recoverParamenters.name.value");
	var texts = document.getElementsByName("recoverParamenters.name.text");
	var types = document.getElementsByName("recoverParamenters.name.type");
	//var notNulls = document.getElementsByName("startParamenters.name.notNull");
	var expressionValues= document.getElementsByName("recoverParamenters.expression.value");
	var expressionTexts= document.getElementsByName("recoverParamenters.expression.text");
	for (var i = 0; i < values.length; i ++) {
		rtn.push("{\"name\":{\"text\":\"" + formatJson(texts[i].value) 
				+ "\",\"value\":\"" + formatJson(values[i].value)
				+ "\",\"type\":\"" + formatJson(types[i].value)  + "\"}"
			    + ",\"expression\":{\"text\":\"" + formatJson(expressionTexts[i].value) 
				+ "\",\"value\":\"" + formatJson(expressionValues[i].value) + "\"}}");
	}
	return "[" + rtn.join(",") + "]";
}

function initStartNodes() {
	var nodesObject = GetAllPreNodes(AttributeObject.NodeObject, AttributeObject.NodeObject, function(node){return node.Type == "startSubProcessNode"});//FlowChartObject.Nodes.all;
	var select = document.getElementById("subProcessNode");
	select.options.length = 0;
	var l = nodesObject.length;
	//select.options.add(new Option("=== 请选择 ===", "false"));
	for(var i = 0; i < l; i++){
		var node = nodesObject[i];
		//if(node.Data.id == NodeData.id)
		//	continue;
		//if (node.Type == "startSubProcessNode") {
			select.options.add(new Option(node.Data.id + ":" + node.Data.name, node.Data.id));
		//}
	}
}
function UtilContains(array, obj) {
	for (var i = 0; i < array.length; i ++) {
		if (obj == array[i]) {
			return true;
		}
	}
	return false;
}
function GetAllPreNodes(now, begin, condition, result, tmp) {
	now = now || NodeObject;
	begin = begin || NodeObject;
	result = result != null ? result : [];
	tmp = tmp != null ? tmp : [];
	if(now.LineIn) {
		if(now.LineIn.length > 1) {
			tmp.push(now); // 避免死循环
		}
		for(var i = 0; i < now.LineIn.length; i++){
			var line = now.LineIn[i];
			var startNode = line.StartNode;
			if (startNode != null && startNode.Data.id != begin.Data.id && !UtilContains(tmp, startNode)) {
				if (condition == null || condition(startNode)) {
					result.push(startNode);
				}
				GetAllPreNodes(startNode, begin, condition, result, tmp);
			}
		}
	}
	return result;
}
function initRecoverConfig() {
	var config = AttributeObject.NodeData['configContent'];
	if (config != null && config != "") {
		var json = eval("("+config+")");
		initModelName(json);
		initParams(json);
	} else {
		initFormulaKMSSDataFormFieldList();
		resetStartCountRelation();
	}
	changeRecoverRuleType();
}
function initModelName(json) {
	setRadio(document.getElementsByName('variableScope'), json.variableScope);
	setRadio(document.getElementsByName('recoverRuleType'), json.recoverRule.type);
	var select = document.getElementById("subProcessNode");
	var subProcessNodeIsOk = false;
	for (var i = 0; i < select.options.length; i ++) {
		var opt = select.options[i];
		if (opt.value == json.subProcessNode) {
			opt.selected = true;
			subProcessNodeIsOk = true;
			break;
		}
	}
	if (!subProcessNodeIsOk) {
		json.recoverParamenters = [];
		alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertReSelectProcessNode" bundle="sys-lbpmservice-node-subprocess" />');
	} else {
		initFormulaKMSSDataFormFieldList();
		resetStartCountRelation();
	}
	if (json.recoverRule.expression.value != null && json.recoverRule.expression.text != null) {
		document.getElementsByName('formulaValueId')[0].value = json.recoverRule.expression.value;
		document.getElementsByName('formulaValueName')[0].value = json.recoverRule.expression.text;
	}
	if (json.recoverRule.type == 3) {
		document.getElementById("recoverRuleType_3").style.display = "";
	}
}
function initParams(json) {
	var params = json.recoverParamenters;
	for (var i = 0; i < params.length; i ++) {
		var row = params[i];
		DocList_AddRow("paramTable", [],
				{
					"recoverParamenters.name.type" : row.name.type, 
					"recoverParamenters.name.value" : row.name.value,
					"recoverParamenters.name.text" : row.name.text,
					"recoverParamenters.expression.value" : row.expression.value,
					"recoverParamenters.expression.text" : row.expression.text
				});
	}
}

function addSubProcessParamenter(table) {
	while (table.tagName != 'TABLE') {
		table = table.parentNode;
	}

	var properties = FlowChartObject.FormFieldList;
	var kmssdata = new KMSSData();

	for (var i = 0; i < properties.length; i ++) {
		var p = properties[i];
		kmssdata.AddHashMap({id: p.name, name: p.label, type: p.type});
	}
	
	var dialog = new KMSSDialog(false, true);
	dialog.winTitle = '<kmss:message key="FlowChartObject.Lang.Node.subprocessRecoverParamTile" bundle="sys-lbpmservice-node-subprocess" />';
	dialog.AddDefaultOption(kmssdata);
	dialog.BindingField(null, null, ";", false);
	dialog.SetAfterShow(function(data) {
		if (data != null) {
			var rows = data.GetHashMapArray();
			for (var i = 0; i < rows.length; i ++) {
				var row = rows[i];
				DocList_AddRow("paramTable", [],
					{
						"recoverParamenters.name.type" : row.type, 
						"recoverParamenters.name.value" : row.id,
						"recoverParamenters.name.text" : row.name
					});
			}
		}
	});
	dialog.notNull = true;
	dialog.Show();
}

// 设置
function resetStartCountRelation() {
	var configContent = getStartNodeConfigContent();
	if (configContent == null) {
		return;
	}
	var json = eval("(" + configContent + ")");
	var recoverRuleDisplay = document.getElementById("recoverRuleTR");
	if (json.startCountType == '1' || json.startCountType == 1) {
		recoverRuleDisplay.style.display = 'none';
	} else {
		recoverRuleDisplay.style.display = '';
	}
}

function getStartNodeConfigContent() {
	var subProcessNode = document.getElementById("subProcessNode");
	if(!subProcessNode.value) {
		return null;
	}
	var node = FlowChartObject.Nodes.GetNodeById(subProcessNode.value);
	if (node == null)
		return null;
	var configContent = node.Data.configContent;
	return configContent;
}

function getFormulaKMSSDataUrl(configContent) {
	var json = eval("(" + configContent + ")");
	var url = "subProcessDictService&modelName=" + json.subProcess.modelName + "&templateId=" + json.subProcess.templateId;
	if (json.subProcess.dictBean != null && json.subProcess.dictBean != "") {
		url = json.subProcess.dictBean;
	}
	return url;
}

// 启动节点所选流程属性
var startNodeFormFieldList = [];

function initFormulaKMSSDataFormFieldList() {
	startNodeFormFieldList = [];
	var configContent = getStartNodeConfigContent();
	if (configContent == null) {
		return ;
	}
	var kmssData = new KMSSData();
	kmssData.SendToBean(getFormulaKMSSDataUrl(configContent) , function(data) {
		var rows = data.GetHashMapArray();
		var formFieldList = [];
		for (var i = 0; i < rows.length; i ++) {
			var row = rows[i];
			formFieldList.push({
				name: row.id,
				label: row.name,
				type: row.type
			});
		}
		startNodeFormFieldList = formFieldList;
	});
}

// 检查启动节点配置
function checkStartNodeConfig() {
	var configContent = getStartNodeConfigContent();
	if (configContent == null) {
		alert('<kmss:message key="FlowChartObject.Lang.Node.subprocessAlertConfigStartNode" bundle="sys-lbpmservice-node-subprocess" />');
		return false;
	}
	return true;
}

//参数公式对话框
function showParamenterFormulaDialog(tr) {
	while (tr.tagName != 'TR') {
		tr = tr.parentNode;
	}
	if (!checkStartNodeConfig()) {
		return ;
	}
	var inputs = tr.getElementsByTagName("input");
	var value = getElementsByName(inputs, "recoverParamenters.expression.value");
	var text = getElementsByName(inputs, "recoverParamenters.expression.text");
	var type = getElementsByName(inputs, "recoverParamenters.name.type");
	Formula_Dialog(value, text, startNodeFormFieldList, type.value);
}

function showRecoverRuleFormula() {
	if (!checkStartNodeConfig()) {
		return ;
	}
	Formula_Dialog('formulaValueId','formulaValueName', startNodeFormFieldList, 'Boolean'
			, null, "com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction;com.landray.kmss.sys.lbpmservice.formula.LbpmSubProcessFunction");
}

function changeRecoverRuleType() {
	var ruleTypes = document.getElementsByName("recoverRuleType");
	for (var i = 0; i < ruleTypes.length; i ++) {
		var ruleType = ruleTypes[i];
		var div = document.getElementById("recoverRuleType_" + ruleType.value);
		if (ruleType.checked) {
			div.style.display = "";
		} else {
			div.style.display = "none";
		}
	}
}

function clearParamTable() {
	// 重新计算数据字典
	initFormulaKMSSDataFormFieldList();
	resetStartCountRelation();
	
	var table = document.getElementById("paramTable");
	var rows = table.rows;
	if (rows.length < 2) {
		return;
	}
	var l = rows.length - 1;
	for (var i = l; i > 0; i --) {
		DocList_DeleteRow(rows[i]);
	}
}
function getRadioValue(radios) {
	for (var i = 0; i < radios.length; i ++) {
		var radio = radios[i];
		if (radio.checked) {
			return radio.value;
		}
	}
}
function setRadio(radios, value) {
	value = value.toString();
	for (var i = 0; i < radios.length; i ++) {
		var radio = radios[i];
		if (radio.value == value) {
			radio.checked = true;
		} else {
			radio.checked = false;
		}
	}
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
