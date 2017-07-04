<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
			<table width="100%" class="tb_normal">
				<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.handlerNames_Send" bundle="sys-lbpmservice" /></td>
					<td>
						<label><input type="radio" name="wf_handlerSelectType" value="org" onclick="switchHandlerSelectType(value);" checked><kmss:message key="FlowChartObject.Lang.Node.selectAddress" bundle="sys-lbpmservice" /></label>
						<label><input type="radio" name="wf_handlerSelectType" value="formula" onclick="switchHandlerSelectType(value);"><kmss:message key="FlowChartObject.Lang.Node.selectFormList" bundle="sys-lbpmservice" /></label>
						<input name="wf_handlerNames" class="inputsgl" style="width:400px" readonly>
						<input name="wf_handlerIds" type="hidden" orgattr="handlerIds:handlerNames">
						<span id="SPAN_SelectType1">
						<a href="#" onclick="Dialog_Address(true, 'wf_handlerIds', 'wf_handlerNames', null, ORG_TYPE_ALL | ORG_TYPE_ROLE);"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<span id="SPAN_SelectType2" style="display:none ">
						<a href="#" onclick="selectByFormula('wf_handlerIds', 'wf_handlerNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<br/>
						<label style="display: none">
							<input type="checkbox" name="wf_ignoreOnHandlerEmpty" value="true" checked>
							<kmss:message key="FlowChartObject.Lang.Node.ignoreOnHandlerEmpty" bundle="sys-lbpmservice" />
						</label>
						<label>
							<input type="checkbox" name="wf_canAddOpinion" value="true">
							<kmss:message key="FlowChartObject.Lang.Node.canAddOpinion" bundle="sys-lbpmservice" />
						</label>
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
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Advance" bundle="sys-lbpm-engine" />">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.optHandlerNames_Send" bundle="sys-lbpmservice" /></td>
					<td>
						<label><input type="radio" name="wf_optHandlerSelectType" value="org" onclick="switchOptHandlerSelectType(value);" checked><kmss:message key="FlowChartObject.Lang.Node.selectAddress" bundle="sys-lbpmservice" /></label>
						<label><input type="radio" name="wf_optHandlerSelectType" value="formula" onclick="switchOptHandlerSelectType(value);"><kmss:message key="FlowChartObject.Lang.Node.selectFormList" bundle="sys-lbpmservice" /></label>
						<input name="wf_optHandlerIds" type="hidden" orgattr="optHandlerIds:optHandlerNames">
						<input name="wf_optHandlerNames" class="inputsgl" style="width:400px" readonly>
						<span id="SPAN_OptSelectType1">
						<a href="#" onclick="Dialog_Address(true, 'wf_optHandlerIds', 'wf_optHandlerNames', null, ORG_TYPE_ALL | ORG_TYPE_ROLE);"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<span id="SPAN_OptSelectType2" style="display:none ">
						<a href="#" onclick="selectByFormula('wf_optHandlerIds', 'wf_optHandlerNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<br><div id="DIV_OptHandlerCalType"><kmss:message key="FlowChartObject.Lang.Node.optHandlerCalType" bundle="sys-lbpmservice" />: 
						<label>
							<input name="wf_optHandlerCalType" type="radio" value="1">
							<kmss:message key="FlowChartObject.Lang.Node.handler" bundle="sys-lbpm-engine" />
						</label><label>
							<input name="wf_optHandlerCalType" type="radio" value="2" checked>
							<kmss:message key="FlowChartObject.Lang.Node.creator" bundle="sys-lbpm-engine" />
						</label><br></div><label>
							<input name="wf_useOptHandlerOnly" type="checkbox" value="true">
							<kmss:message key="FlowChartObject.Lang.Node.useOptHandlerOnly" bundle="sys-lbpmservice" />
						</label>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Popedom" bundle="sys-lbpmservice" />">
		<td>
		<table class="tb_normal" width="100%">
			<tr>
				<td rowspan="2" width="100px"><kmss:message key="FlowChartObject.Lang.Right.canViewCurNodePopedomSet" bundle="sys-lbpm-engine" /></td>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Right.nodeCanViewCurNode" bundle="sys-lbpm-engine" /></td>
				<td>
					<input type="hidden" name="wf_nodeCanViewCurNodeIds">
					<textarea name="wf_nodeCanViewCurNodeNames" style="width:100%;height:50px" readonly></textarea>
					<a href="#" onclick="selectNotionNodes('wf_nodeCanViewCurNodeIds', 'wf_nodeCanViewCurNodeNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
				</td>
			</tr>
			<tr>
				<td width="100px"><kmss:message key="FlowChartObject.Lang.Right.otherCanViewCurNode" bundle="sys-lbpm-engine" /></td>
				<td>
					<input type="hidden" name="wf_otherCanViewCurNodeIds" orgattr="otherCanViewCurNodeIds:otherCanViewCurNodeNames">
					<textarea name="wf_otherCanViewCurNodeNames" style="width:100%;height:50px" readonly></textarea>
					<a href="#" onclick="Dialog_Address(true,'wf_otherCanViewCurNodeIds','wf_otherCanViewCurNodeNames', ';',ORG_TYPE_ALL);"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
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
var handlerSelectType = AttributeObject.NodeData["handlerSelectType"];
var optHandlerSelectType = AttributeObject.NodeData["optHandlerSelectType"];


AttributeObject.Init.AllModeFuns.push(function() {

	if(!handlerSelectType || handlerSelectType!="formula"){
		SPAN_SelectType1.style.display='';
		SPAN_SelectType2.style.display='none';;
	}else{
		SPAN_SelectType1.style.display='none';
		SPAN_SelectType2.style.display='';
	}

	if (!optHandlerSelectType || optHandlerSelectType!="formula"){
		document.getElementById('SPAN_OptSelectType1').style.display='';
		document.getElementById('SPAN_OptSelectType2').style.display='none';
		document.getElementById('DIV_OptHandlerCalType').style.display='';
	} else {
		document.getElementById('SPAN_OptSelectType1').style.display='none';
		document.getElementById('SPAN_OptSelectType2').style.display='';
		document.getElementById('DIV_OptHandlerCalType').style.display='none';
	}
});


//数据校验
AttributeObject.CheckDataFuns.push(function(data) {
	if(data.useOptHandlerOnly=="true" && data.optHandlerIds==""){
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkOptHandlerEmpty" bundle="sys-lbpmservice" />');
		return false;
	}
	return true;
});

function switchHandlerSelectType(value){
	if(handlerSelectType==value)
		return;
	handlerSelectType = value;
	SPAN_SelectType1.style.display=handlerSelectType!="formula"?"":"none";
	SPAN_SelectType2.style.display=handlerSelectType=="formula"?"":"none";
	document.getElementsByName("wf_handlerIds")[0].value = "";
	document.getElementsByName("wf_handlerNames")[0].value = "";
}

//备选审批人选择方式
function switchOptHandlerSelectType(value) {
	if(optHandlerSelectType==value)
		return;
	optHandlerSelectType = value;
	document.getElementById('SPAN_OptSelectType1').style.display=optHandlerSelectType!="formula"?"":"none";
	document.getElementById('SPAN_OptSelectType2').style.display=optHandlerSelectType=="formula"?"":"none";
	document.getElementById('DIV_OptHandlerCalType').style.display=optHandlerSelectType!="formula"?"":"none";
	document.getElementsByName("wf_optHandlerIds")[0].value = "";
	document.getElementsByName("wf_optHandlerNames")[0].value = "";
}
function selectNotionNodes(idField, nameField){
	var data = new KMSSData(), NodeData = AttributeObject.NodeData;
	for(var i=0; i<FlowChartObject.Nodes.all.length; i++){
		var node = FlowChartObject.Nodes.all[i];
		if(node.Data.id == NodeData.id)
			continue;
		var nodDesc = AttributeObject.Utils.nodeDesc(node);
		if (nodDesc.isHandler || nodDesc.isDraftNode || nodDesc.isSendNode) {
			data.AddHashMap({id:node.Data.id, name:node.Data.id+"."+node.Data.name});
		}
	}
	var dialog = new KMSSDialog(true, true);
	dialog.winTitle = FlowChartObject.Lang.dialogTitle;
	dialog.AddDefaultOption(data);
	dialog.BindingField(idField, nameField, ";");
	dialog.Show();
}
function selectByFormula(idField, nameField){
	Formula_Dialog(idField,
			nameField,
			FlowChartObject.FormFieldList, 
			"com.landray.kmss.sys.organization.model.SysOrgElement[]",
			null,
			"com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction",
			FlowChartObject.ModelName);
}
</script>