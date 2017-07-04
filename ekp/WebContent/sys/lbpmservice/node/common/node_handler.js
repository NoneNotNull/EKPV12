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

FlowChartObject.Lang.Include("sys-lbpm-engine");

if(!FlowChartObject.OAProcess)
	FlowChartObject.OAProcess = new Object();


//审批、签字节点的更新提示信息
function FlowChart_OAProcess_ReviewNodeRefreshInfo(){
	var topframe = parent.parent;
	if (topframe.lbpm && topframe.lbpm.globals
			&& topframe.lbpm.globals.buildNextNodeHandlerNodeRefreshInfo) {
		this.Info = topframe.lbpm.globals.buildNextNodeHandlerNodeRefreshInfo(this.Data.id + '.' + this.Data.name, this.Data.processType, this.Data.handlerIds, (this.Data.handlerSelectType=="formula"));
		return;
	}
	var info = "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
	info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
	if(this.Status==STATUS_UNINIT){
		info += "\r\n·" + FlowChartObject.Lang.Node.AttributeNotSetting;
	}else{
		//处理人
		info += "\r\n·" + FlowChartObject.Lang.Node.handlerNames + ": ";
		info += (this.Data.handlerSelectType=="formula"?FlowChartObject.Lang.Node.HandlerIsFormula:
			(this.Data.handlerNames==null || this.Data.handlerNames==""?FlowChartObject.Lang.Node.HandlerIsEmpty:this.Data.handlerNames));
		//审批方式
		var processType = "";
		switch(this.Data.processType){
			case "0":
			case "1":
				processType = FlowChartObject.Lang.Node["processType_"+this.Data.processType];
			break;
			case "2":
				processType = FlowChartObject.Lang.Node["processType_"+this.Data.processType + "" + this.holdType];
				//processType = this.Type=="reviewNode"?FlowChartObject.Lang.Node.processType_20:FlowChartObject.Lang.Node.processType_21;
			break;
		}
		info += "\r\n·" + FlowChartObject.Lang.Node.processType + ": " + processType;
		//勾选项
		info += "\r\n·" + FlowChartObject.Lang.Node.Options + ": ";
		if(this.Data.ignoreOnHandlerEmpty=="true")
			info += FlowChartObject.Lang.Node.ignoreOnHandlerEmpty + ", ";
		if(this.Data.ignoreOnHandlerSame=="true"){
			if(this.Data.onAdjoinHandlerSame=="true"){
				info += FlowChartObject.Lang.Node.onAdjoinHandlerSame + ", ";
			}else{
				info += FlowChartObject.Lang.Node.onSkipHandlerSame + ", ";
			}
		}else if(this.Data.ignoreOnHandlerSame==null && this.Data.onAdjoinHandlerSame == null){
			info += FlowChartObject.Lang.Node.onAdjoinHandlerSame + ", ";
		}else{
			info += FlowChartObject.Lang.Node.ignoreOnHandlerSame + ", ";
		}
		if(this.Data.canModifyMainDoc=="true")
			info += FlowChartObject.Lang.Node.canModifyMainDoc + ", ";
		if(info.substring(info.length-2)==", "){
			info = info.substring(0, info.length-2);
		}else{
			info += FlowChartObject.Lang.None;
		}
		//节点帮助 增加对界面帮助描述超链接的转换功能 @作者：曹映辉 @日期：2011年9月1日 
		info += "\r\n·" + FlowChartObject.Lang.Node.description + ": " + (this.Data.description==null?"":this.Data.description.replace(/<span><a[^>]*href=[\'\"\s]*([^\s\'\"]*)[^>]*>(.+?)<\/a><\/span>/ig,"$2").replace(/(<pre>)|(<\/pre>)/ig,"").replace(/<br\/>/ig,"\r\n"));
	}
	this.Info = Com_FormatText(info);
}

FlowChartObject.OAProcess.ReviewNodeRefreshInfo = FlowChart_OAProcess_ReviewNodeRefreshInfo;

function FlowChart_OAProcess_ReviewNodeCheck(){
	if(!FlowChartObject.CheckFlowNode(this)){
		return false;
	}
	if(this.LineOut[0].EndNode.Type=="manualBranchNode"){
		if(this.LineOut[0].EndNode.Data.decidedBranchOnDraft && this.LineOut[0].EndNode.Data.decidedBranchOnDraft == "true") {
			// 在起草节点决定节点走向
			return true;
		}
		//下个节点是人工决策节点
		if(this.Data.processType=="2"){
			alert(FlowChartObject.Lang.GetMessage(
				FlowChartObject.Lang.checkFlowCanNotToManualBranch,
				FlowChartObject.Lang.Node["processType_"+this.Data.processType + "" + this.holdType],
				//this.Type=="reviewNode"?FlowChartObject.Lang.Node.processType_20:FlowChartObject.Lang.Node.processType_21,
				this.Data.id + "." + this.Data.name));
			return false;
		}
		if(this.Data.ignoreOnHandlerEmpty=="true"){
			alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.checkFlowIgnoreOnHandlerEmpty,this.Data.id + "." + this.Data.name));
			return false;
		}
	}
	return true;
}

FlowChartObject.OAProcess.ReviewNodeCheck = FlowChart_OAProcess_ReviewNodeCheck;

//流程检测
FlowChartObject.CheckFlow_Extend = function(startNodes, endNodes){
	for(var i=0; i<startNodes.length; i++){
		//检查处理人情况
		if(!FlowChart_OAProcess_TraceCheck(startNodes[i], "", "", {}, "")){
			return false;
		}
	}
	
	return true;
};

//检查处理人未设置的情况
function FlowChart_OAProcess_TraceCheck(node, idChain, modifyHandlerIds, parentMap, parentId){
	if(node.Type=="joinNode"){
		var startNodeId = node.RelatedNodes[0].Data.id;
		if(parentId.substring(0, startNodeId.length+1)!=startNodeId+"."){
			idChain += node.Data.id;
			FlowChart_OAProcess_Check_SelectTrace(idChain);
			alert(FlowChartObject.Lang.checkSplitNodeError1);
			return false;
		}
		parentId = parentMap[startNodeId];
	}else{
		if(parentMap[node.Data.id]==null){
			parentMap[node.Data.id] = parentId;
		}else{
			if(parentMap[node.Data.id]!=parentId){
				idChain += node.Data.id;
				if(parentId!=""){
					parentId = parentId.split(".")[0];
					var i = idChain.indexOf(parentId+";");
					if(i>-1)
						idChain = idChain.substring(i);
				}
				FlowChart_OAProcess_Check_SelectTrace(idChain);
				alert(FlowChartObject.Lang.checkSplitNodeError2);
				return false;
			}
		}
	}
	//该ID在id链中出现，说明产生了循环
	if(idChain.indexOf(node.Data.id+";")>-1){
		return true;
	}
	idChain += node.Data.id + ";";
	switch(node.Type){
		case "reviewNode":
		case "signNode":
		case "sendNode":
			if((node.Data.handlerIds==null || node.Data.handlerIds=="") && node.Data.ignoreOnHandlerEmpty=="false"){
				if(modifyHandlerIds.indexOf(node.Data.id+";")==-1){
					alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.checkFlowHandlerEmpty, node.Data.id + "." + node.Data.name));
					FlowChartObject.SelectElement(node);
					return false;
				}
			}
		case "draftNode":
			if(node.Type!="sendNode"){
				node.Data.canModifyHandlerNodeIds = FlowChart_OAProcess_RemoveInvalidIds(node.Data.canModifyHandlerNodeIds);
				node.Data.mustModifyHandlerNodeIds = FlowChart_OAProcess_RemoveInvalidIds(node.Data.mustModifyHandlerNodeIds);
				modifyHandlerIds += node.Data.mustModifyHandlerNodeIds + ";";
			}
		break;
		case "splitNode":
			parentId = node.Data.id;
		break;
	}
	for(var i=0; i<node.LineOut.length; i++){
		var nxtParentId = node.Type=="splitNode"?(parentId+"."+i):parentId;
		if(!FlowChart_OAProcess_TraceCheck(node.LineOut[i].EndNode, idChain, modifyHandlerIds, parentMap, nxtParentId))
			return false;
	}
	return true;
}

function FlowChart_OAProcess_Check_SelectTrace(idChain){
	var ids = idChain.split(";");
	var node = FlowChartObject.Nodes.GetNodeById(ids[0]);
	FlowChartObject.SelectElement(node);
	for(var i=1; i<ids.length; i++){
		var nxtNode = FlowChartObject.Nodes.GetNodeById(ids[i]);
		for(var j=0; j<node.LineOut.length; j++){
			if(node.LineOut[j].EndNode==nxtNode){
				FlowChartObject.SelectElement(node.LineOut[j]);
				break;
			}
		}
		FlowChartObject.SelectElement(nxtNode);
		node = nxtNode;
	}
}

