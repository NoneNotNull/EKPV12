<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table class="tb_normal" width="100%">
	<tr>
		<td rowspan="2" width="100px"><kmss:message key="FlowChartObject.Lang.Right.modifyNotionPopedomSet" bundle="sys-lbpm-engine" /></td>
		<td width="100px"><kmss:message key="FlowChartObject.Lang.Right.canModifyHandlerNodeNames" bundle="sys-lbpm-engine" /></td>
		<td>
			<input type="hidden" name="wf_canModifyHandlerNodeIds">
			<textarea name="canModifyHandlerNodeNames" style="width:100%;height:50px" readonly></textarea>
			<a href="#" onclick="selectNodes('wf_canModifyHandlerNodeIds', 'canModifyHandlerNodeNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
		</td>
	</tr>
	<tr>
		<td width="100px"><kmss:message key="FlowChartObject.Lang.Right.mustModifyHandlerNodeNames" bundle="sys-lbpm-engine" /></td>
		<td>
			<input type="hidden" name="wf_mustModifyHandlerNodeIds">
			<textarea name="mustModifyHandlerNodeNames" style="width:100%;height:50px" readonly></textarea>
			<a href="#" onclick="selectNodes('wf_mustModifyHandlerNodeIds', 'mustModifyHandlerNodeNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
			<br><kmss:message key="FlowChartObject.Lang.Right.mustModifyHandlerNodeNote" bundle="sys-lbpm-engine" />
		</td>
	</tr>
	<tr>
		<td rowspan="3" width="100px"><kmss:message key="FlowChartObject.Lang.Right.canViewCurNodePopedomSet" bundle="sys-lbpm-engine" /></td>
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
	<tr>
		<td width="100px"><kmss:message key="FlowChartObject.Lang.Right.canModifyNotionPopedom" bundle="sys-lbpm-engine" /></td>
		<td>
			<label>
				<input name="wf_canModifyNotionPopedom" type="checkbox" value="true">
			</label>
		</td>
	</tr>
	<tr>
		<td width="100px"><kmss:message key="FlowChartObject.Lang.Right.canModifyFlow" bundle="sys-lbpm-engine" /></td>
		<td colspan="2">
			<label>
				<input name="wf_canModifyFlow" type="radio" value="true">
				<kmss:message key="FlowChartObject.Lang.Yes" bundle="sys-lbpm-engine" />
			</label><label>
				<input name="wf_canModifyFlow" type="radio" value="false" checked>
				<kmss:message key="FlowChartObject.Lang.No" bundle="sys-lbpm-engine" />
			</label>
		</td>
	</tr>
</table>

<script>
function selectNodes(idField, nameField){
	var data = new KMSSData(), NodeData = AttributeObject.NodeData;
	for(var i=0; i<FlowChartObject.Nodes.all.length; i++){
		var node = FlowChartObject.Nodes.all[i];
		if(node.Data.id == NodeData.id)
			continue;
		var nodDesc = AttributeObject.Utils.nodeDesc(node);
		if ((nodDesc.isHandler && !nodDesc.isDraftNode) || nodDesc.isSendNode) {
			data.AddHashMap({id:node.Data.id, name:node.Data.id+"."+node.Data.name});
		}
	}
	var dialog = new KMSSDialog(true, true);
	dialog.winTitle = FlowChartObject.Lang.dialogTitle;
	dialog.AddDefaultOption(data);
	dialog.BindingField(idField, nameField, ";");
	dialog.Show();
}

//选择可查看当前节点的节点  add by limh 2010年9月19日
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

AttributeObject.Init.AllModeFuns.push(function() {
	AttributeObject.Utils.loadNodeNameInfo("wf_canModifyHandlerNodeIds", "canModifyHandlerNodeNames");
	AttributeObject.Utils.loadNodeNameInfo("wf_mustModifyHandlerNodeIds", "mustModifyHandlerNodeNames");
	//增加可查看当前节点意见的节点数据的加载 add by limh 2010年9月19日
	AttributeObject.Utils.loadNodeNameInfo("wf_nodeCanViewCurNodeIds", "wf_nodeCanViewCurNodeNames");
});
</script>