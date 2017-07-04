/**********************************************************
功能：记录流程流转过程
使用：
	该JS并不属于流程图的主体功能，只是用于方便记录流转过程而开发，一般用于程序的调试
	若要使用该JS，在panel.js中手动引入即可，无需修改其它地方
作者：叶中奇
创建时间：2008-05-05
修改记录：
**********************************************************/
FlowChartObject.Record = new Object();
FlowChartObject.Record.index = 0;
FlowChartObject.Record.CurrentNodes = new Array();
FlowChartObject.Record.CurrentRunning = null;
FlowChartObject.Record.Status = STATUS_NORMAL;

//功能：初始化，注册模式和快捷键
FlowChartObject.Record.Initialize = function(){
	if(!FlowChartObject.IsEdit)
		return;
	var mode = new FlowChart_Mode("record");
	mode.OnMouseUp = FlowChart_Mode_Record_OnMouseUp;
	mode.OnDblClick = FlowChart_Mode_Record_OnDblClick;
	mode.Initialize = FlowChart_Mode_Record_Initialize;
	mode.Clear = FlowChart_Mode_Record_Clear;
	var operation = new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, "record");
	FlowChartObject.Operation.Hotkey.NormalHotkeys["R".charCodeAt(0)] = operation;
};

//功能：模式切换时的初始化动作
function FlowChart_Mode_Record_Initialize(){
	var nodes = FlowChartObject.Record.CurrentNodes;
	if(FlowChartObject.Record.Status == STATUS_NORMAL && 
		FlowChartObject.StatusData!=null &&
		FlowChartObject.StatusData.historyNodes.length>0){
		if(FlowChartObject.StatusData.runningNodes==null || FlowChartObject.StatusData.runningNodes.length==0){
			FlowChartObject.Record.Status = STATUS_PASSED;
		}else{
			for(var i=0; i<FlowChartObject.StatusData.runningNodes.length; i++)
				nodes[nodes.length] = FlowChartObject.Nodes.GetNodeById(FlowChartObject.StatusData.runningNodes[i].id);
			FlowChartObject.Record.Status = STATUS_RUNNING;
		}
	}
	if(FlowChartObject.Record.CurrentRunning!=null)
		FlowChartObject.Record.CurrentRunning.Select(true);
}

//功能：模式切换时的结束动作
function FlowChart_Mode_Record_Clear(){
	if(FlowChartObject.Record.CurrentRunning!=null)
		FlowChartObject.Record.CurrentRunning.Select(false);
	if(FlowChartObject.StatusData!=null && confirm("是否要拷贝流转记录？"))
		window.clipboardData.setData("Text", WorkFlow_BuildXMLString(FlowChartObject.StatusData, "process-status"));
}

//功能：鼠标放开动作，选中当前处理节点
function FlowChart_Mode_Record_OnMouseUp(){
	if(event.button!=1){
		//右键切换模式
		FlowChartObject.Mode.Change("normal");
		FlowChartObject.Operation.Menu.CancelShow = true;
		return;
	}
	//流程已经完成后不处理
	if(FlowChartObject.Record.Status==STATUS_PASSED)
		return;
	var obj = Com_GetEventSrcObject();
	//点击对象不是正在执行的节点时不处理
	if(obj==null || Com_ArrayGetIndex(FlowChartObject.Record.CurrentNodes, obj)==-1)
		return;
	FlowChart_Record_SetCurrentRunning(obj);
}

//功能：鼠标双击动作
function FlowChart_Mode_Record_OnDblClick(){
	//流程完成后不处理
	if(FlowChartObject.Record.Status==STATUS_PASSED)
		return;
	var obj = Com_GetEventSrcObject();
	if(obj==null)
		return;
	var originNode = FlowChartObject.Record.CurrentRunning;
	switch(obj.Name){
		case "Line":
			//双击连线时候，走连线的路由
			if(obj.StartNode==originNode){
				FlowChart_Record_FinishCurrentNode(obj.EndNode.Data.id, true);
				FlowChart_Record_FinishLine(obj);
				FlowChart_Record_ActiveNode(obj.EndNode);
			}
		break;
		case "Node":
			//双击节点的时候，视为特殊处理
			if(FlowChartObject.Record.Status == STATUS_NORMAL){
				if(obj.TypeCode==NODETYPE_START){
					FlowChart_Record_ActiveNode(obj);
					FlowChartObject.Record.Status = STATUS_RUNNING;
				}
				break;
			}
			if(obj.TypeCode==NODETYPE_START)
				break;
			FlowChart_Record_FinishCurrentNode(obj.Data.id, false);
			FlowChart_Record_ActiveNode(obj);
		break;
	}
}

//功能：结束连线状态
function FlowChart_Record_FinishLine(line){
	line.SetStatus(STATUS_PASSED);
}

//功能：完成当前节点
function FlowChart_Record_FinishCurrentNode(targetId, isRouting){
	var node = FlowChartObject.Record.CurrentRunning;
	//更新状态数据
	var statusData = FlowChart_Record_GetStatusData();
	var runningNodes = new Array();
	for(var i=0; i<statusData.runningNodes.length; i++){
		if(node.Data.id==statusData.runningNodes[i].id){
			statusData.runningNodes[i].isRouting = isRouting?"true":"false";
			statusData.runningNodes[i].targetId = targetId;
			statusData.historyNodes[statusData.historyNodes.length] = statusData.runningNodes[i];
		}else{
			runningNodes[runningNodes.length] = statusData.runningNodes[i];
		}
	}
	statusData.runningNodes = runningNodes;
	//更新临时数据
	node.SetStatus(STATUS_PASSED);
	FlowChartObject.Record.CurrentNodes = Com_ArrayRemoveElem(FlowChartObject.Record.CurrentNodes, node);
	FlowChart_Record_SetCurrentRunning(null);
}

//功能：激活当前节点
function FlowChart_Record_ActiveNode(node){
	if(Com_ArrayGetIndex(FlowChartObject.Record.CurrentNodes, node)>-1)
		return;
	//新流入的节点
	FlowChartObject.Record.CurrentNodes[FlowChartObject.Record.CurrentNodes.length] = node;
	var statusData = FlowChart_Record_GetStatusData();
	var newRunningNode = new Object();
	newRunningNode.id = node.Data.id;
	newRunningNode.XMLNODENAME = "node";
	statusData.runningNodes[statusData.runningNodes.length] = newRunningNode;
	node.SetStatus(STATUS_RUNNING);
	FlowChart_Record_SetCurrentRunning(node);
	if(node.TypeCode==NODETYPE_END){
		FlowChart_Record_FinishCurrentNode();
		FlowChartObject.Record.Status = STATUS_PASSED;
		return;
	}
	if(node.Type=="splitNode"){
		var targetIds = "";
		for(var i=0; i<node.LineOut.length; i++){
			targetIds += ";" + node.LineOut[i].EndNode.Data.id;
		}
		FlowChart_Record_FinishCurrentNode(targetIds.substring(1), true);
		for(var i=0; i<node.LineOut.length; i++){
			FlowChart_Record_FinishLine(node.LineOut[i]);
			FlowChart_Record_ActiveNode(node.LineOut[i].EndNode);
		}
		return;
	}
}

//功能：获取流程状态数据
function FlowChart_Record_GetStatusData(){
	if(FlowChartObject.StatusData==null){
		FlowChartObject.StatusData = new Object();
		FlowChartObject.StatusData.historyNodes = new Array();
		FlowChartObject.StatusData.runningNodes = new Array();
	}
	return FlowChartObject.StatusData;
}

//功能：设置当前正在执行的节点
function FlowChart_Record_SetCurrentRunning(node){
	if(FlowChartObject.Record.CurrentRunning==node)
		return;
	if(FlowChartObject.Record.CurrentRunning!=null)
		FlowChartObject.Record.CurrentRunning.Select(false);
	if(node!=null)
		node.Select(true);
	FlowChartObject.Record.CurrentRunning = node;
}

//功能：注册初始化操作
FlowChartObject.InitializeArray[FlowChartObject.InitializeArray.length] = FlowChartObject.Record;