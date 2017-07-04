/**********************************************************
功能：流程图的扩展功能
使用：
	通过流程图html中的extend参数声明该文件名，由panel.js引入
必须实现的方法：
	FlowChartObject.Nodes.InitializeTypes（节点类型定义）
作者：叶中奇
创建时间：2008-05-05
修改记录：
**********************************************************/
//定义流程扩展名
FlowChartObject.Name = "lks-oa-process";

if(!FlowChartObject.OAProcess)
	FlowChartObject.OAProcess = new Object();

function FlowChart_OAProcess_GetNewNodeIds(oldIds,idMap){
	if(oldIds==null || oldIds=="")
		return "";
	var newIds = "";
	var oldIdArr = oldIds.split(";");
	for(var i=0; i<oldIdArr.length; i++){
		var newId = idMap[oldIdArr[i]];
		if(newId==null)
			continue;
		newIds += ";" + newId;
	}
	if(newIds=="")
		return "";
	return newIds.substring(1);
}

FlowChartObject.OAProcess.GetNewNodeIds = FlowChart_OAProcess_GetNewNodeIds;

function FlowChart_OAProcess_ShowDetailAfter(show) {
	if (!show) {
		if(FlowChart_OAProcess_ShowDetailAfter._TimeoutId!=0){
			clearTimeout(FlowChart_OAProcess_ShowDetailAfter._TimeoutId);
			FlowChart_OAProcess_ShowDetailAfter._TimeoutId = 0;
		}
	} else {
		var topframe = parent.parent;
		if (topframe.lbpm && topframe.lbpm.globals
				&& topframe.lbpm.globals.buildNextNodeHandlerNodeShowDetail) {
			FlowChart_OAProcess_ShowDetailAfter._TimeoutId = setTimeout(function() {
				if (FlowChartObject.Nodes.InfoBox.Current != null)
					topframe.lbpm.globals.buildNextNodeHandlerNodeShowDetail(document, FlowChartObject.Nodes.InfoBox.Current.Data);
			}, 500);
		}
	}
}

FlowChartObject.OAProcess.ShowDetailAfter = FlowChart_OAProcess_ShowDetailAfter;


//去除不存在的ID
function FlowChart_OAProcess_RemoveInvalidIds(ids){
	if(ids==null || ids=="")
		return "";
	var originIds = ids.split(";");
	ids = "";
	for(var i=0; i<originIds.length; i++){
		if(FlowChartObject.Nodes.GetNodeById(originIds[i])!=null)
			ids += ";" + originIds[i];
	}
	return ids.substring(1);
}

FlowChartObject.OAProcess.RemoveInvalidIds = FlowChart_OAProcess_RemoveInvalidIds;

//OA流程初始化代码
FlowChartObject.OAProcess.Initialize = function(){
	var xmlString = parent.WorkFlow_GetProcessData();
	if(xmlString==null || xmlString==""){
		xmlString = '<process nodesIndex="3" linesIndex="2" iconType="2"><nodes><startNode id="N1" name="'+FlowChartObject.Lang.Operation.Text.ChangeMode.startNode+
			'" x="400" y="60" /><draftNode id="N2" name="'+FlowChartObject.Lang.Operation.Text.ChangeMode.draftNode+
			'" x="400" y="140" /><endNode id="N3" name="'+FlowChartObject.Lang.Operation.Text.ChangeMode.endNode+
			'" x="400" y="380" /></nodes>'+
			'<lines><line id="L1" startPosition="3" endPosition="1" startNodeId="N1" endNodeId="N2" points="0,0;0,0" />'+
			'<line id="L2" startPosition="3" endPosition="1" startNodeId="N2" endNodeId="N3" points="0,0;0,0" /></lines></process>';
	}
	if (typeof(xmlString) == 'string') {
		FlowChartObject.DrawFlowByXML(xmlString);
	} else {
		FlowChartObject.DrawFlowByData(xmlString);
	}
	xmlString = parent.WorkFlow_GetStatusData();
	if(xmlString!=null && xmlString!=""){
		FlowChartObject.LoadStatusByXML(xmlString);
	}
};

//更新节点处理人信息
FlowChartObject.Nodes.updateHandlerInfo = function(id, handlerIds, handlerNames){
	var node = FlowChartObject.Nodes.GetNodeById(id);
	if(node==null)
		return;
	node.Data.handlerIds = handlerIds;
	node.Data.handlerNames = handlerNames;
	node.Refresh();
};

//初始化声明
FlowChartObject.InitializeArray.push(FlowChartObject.OAProcess);