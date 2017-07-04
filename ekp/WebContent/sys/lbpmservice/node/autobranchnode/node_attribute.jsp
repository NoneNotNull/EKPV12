<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
			<table width="100%" class="tb_normal">
				<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
				<tr>
					<td colspan="2">
						<table class="tb_normal" id="lineTable">
							<tr class="tr_normal_title">
								<td style="width:94px"><kmss:message key="FlowChartObject.Lang.Line.nextNode" bundle="sys-lbpm-engine" /></td>
								<td style="width:135px"><kmss:message key="FlowChartObject.Lang.Line.name" bundle="sys-lbpm-engine" /></td>
								<td style="width:330px"><kmss:message key="FlowChartObject.Lang.Line.condition" bundle="sys-lbpm-engine" /></td>
							</tr>
							<tr KMSS_IsReferRow="1" style="display:none">
								<td></td>
								<td>
									<input name="lineName" class="inputsgl">
									<input name="nextNodeName" type="hidden">
								</td>
								<td>
									<input type="hidden" name="lineCondition">
									<input name="lineDisCondition" class="inputsgl" readonly style="width:100%"><br>
									<a href="#" onclick="openExpressionEditor();"><kmss:message key="FlowChartObject.Lang.Line.formula" bundle="sys-lbpm-engine" /></a>
									<span style="width:180px"></span>
									<a href="#" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveUp" bundle="sys-lbpmservice" /></a>
									<a href="#" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Operation.operationMoveDown" bundle="sys-lbpmservice" /></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Line.tip" bundle="sys-lbpm-engine" /></td>
					<td width="490px">
						<kmss:message key="FlowChartObject.Lang.Line.note" bundle="sys-lbpm-engine" />
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
DocList_Info.push("lineTable");

AttributeObject.Init.AllModeFuns.push(function() {
	var NodeData = AttributeObject.NodeData;
	var LineOut = AttributeObject.NodeObject.LineOut;

	function getSortData(){
		var o1=[],o2=[];
		if(LineOut!=null && LineOut.length>0){
			LineOut = LineOut.sort(FlowChartObject.LinesSort);
			for(var i=0;i<LineOut.length;i++){
				var nn = LineOut[i].EndNode.Data.id + "." + LineOut[i].EndNode.Data.name;
				var o = {nextNodeName:nn, name : LineOut[i].Data["name"]||"",
						condition:LineOut[i].Data["condition"]||"",disCondition:LineOut[i].Data["disCondition"]||"",
						priority:LineOut[i].Data["priority"]||""
					};
				if(o["priority"]==""){
					o2[o2.length] = o;
				}else{
					o1[o["priority"]] = o;
				}
			}
		}
		o1 = o1.concat(o2);
		return o1;
	}

	var a = getSortData();
	if(a!=null && a.length>0){
		for(var i=0;i<a.length;i++){
			if(!a[i]){
				continue;
			}
			var row = DocList_AddRow("lineTable",[a[i]["nextNodeName"]],
				{lineName : a[i]["name"]||"",nextNodeName : a[i]["nextNodeName"],
				lineCondition : a[i]["condition"]||"", lineDisCondition : a[i]["disCondition"]||""});
			row.style.verticalAlign="top";
		}
	}
});


function openExpressionEditor() {
	var index = getElementIndex();
	Formula_Dialog(document.getElementsByName("lineCondition")[index-1],
			document.getElementsByName("lineDisCondition")[index-1],
			FlowChartObject.FormFieldList,
			"Boolean",
			null,
			"com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction",
			FlowChartObject.ModelName);
}

function getElementIndex(){
	var row = DocListFunc_GetParentByTagName("TR");
	var table = DocListFunc_GetParentByTagName("TABLE", row);
	for(var i=1; i<table.rows.length; i++){
		if(table.rows[i]==row){
			return i;
		}
	}
	return -1;
}

function nodeDataCheck(data){
	var allEmpty = true;
	var LineOut = AttributeObject.NodeObject.LineOut;
	if(LineOut!=null && LineOut.length>0){
		for(var i=0;i<LineOut.length;i++){
			var nn = LineOut[i].EndNode.Data.id + "." + LineOut[i].EndNode.Data.name;
			//var nextNodeName = LineOut[i].EndNode.Data.name;
			var o = getLineValue(nn);
			if(o==null){
				return true;
			}
			LineOut[i].Data["name"] = o["name"];
			LineOut[i].Data["condition"] = o["condition"];
			LineOut[i].Data["disCondition"] = o["disCondition"];
			LineOut[i].Data["priority"] = o["priority"];
			if (allEmpty && o["condition"] != null && Com_Trim(o["condition"]) != '') {
				allEmpty = false;
			}
		}
	}
	if (allEmpty) {
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkConditionAllEmpty" bundle="sys-lbpmservice-node-autobranchnode" />');
		return false;
	}

	return true;
}

AttributeObject.CheckDataFuns.push(nodeDataCheck);

function getLineValue(nextNodeName){
	var lineName = document.getElementsByName("lineName");
	var lineCondition = document.getElementsByName("lineCondition");
	var lineDisCondition = document.getElementsByName("lineDisCondition");
	var nextNodeNames = document.getElementsByName("nextNodeName");
	for(var i=0;i<nextNodeNames.length;i++){
		if(nextNodeNames[i].value==nextNodeName){
			return {name:lineName[i].value,condition:lineCondition[i].value,disCondition:lineDisCondition[i].value,priority:""+i};
		}
	}
	return null;
}

AttributeObject.SubmitFuns.push(AttributeObject.Utils.refreshLineOut);

</script>