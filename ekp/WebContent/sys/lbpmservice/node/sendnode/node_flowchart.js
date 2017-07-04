/**********************************************************
功能：审批节点
使用：
	审批节点节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-sendnode");

(function(FlowChartObject) {
	
	//抄送节点的更新提示信息
	function FlowChart_OAProcess_SendNodeRefreshInfo(){
		var topframe = parent.parent;
		if (topframe.lbpm && topframe.lbpm.globals
				&& topframe.lbpm.globals.buildNextNodeHandlerNodeRefreshInfo) {
			this.Info = topframe.lbpm.globals.buildNextNodeHandlerNodeRefreshInfo(this.Data.id + '.' + this.Data.name, this.Data.processType, this.Data.handlerIds, (this.Data.handlerSelectType=="formula"));
			return;
		}
		var info =  "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
		info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
		if(this.Status==FlowChartObject.STATUS_UNINIT){
			info += "\r\n·" + FlowChartObject.Lang.Node.AttributeNotSetting;
		}else{
			//抄送人
			info += "\r\n·" + FlowChartObject.Lang.Node.handlerNames_Send + ": ";
			info += this.Data.handlerNames==null || this.Data.handlerNames=="" ? FlowChartObject.Lang.Node.SenderIsEmpty:
				(this.Data.handlerSelectType=="formula"?FlowChartObject.Lang.Node.HandlerIsFormula:this.Data.handlerNames);
			//勾选项
			info += "\r\n·" + FlowChartObject.Lang.Node.Options + ": ";
			if(this.Data.ignoreOnHandlerEmpty=="true")
				info += FlowChartObject.Lang.Node.ignoreOnHandlerEmpty;
			else
				info += FlowChartObject.Lang.None;
			//节点帮助
			info += "\r\n·" + FlowChartObject.Lang.Node.description + ": " + (this.Data.description==null?"":this.Data.description);
		}
		this.Info = Com_FormatText(info);
	}
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		var nodeType = new FlowChartObject.Nodes.NodeType("sendNode");
		nodeType.Hotkey = "D";
		nodeType.ImgIndex  = 24;
		nodeType.ButtonIndex = 3;
		nodeType.Initialize = function(){
			FlowChartObject.Nodes.CreateBigRectDOM(this);
			if(this.Data.ignoreOnHandlerEmpty==null)
				this.SetStatus(FlowChartObject.STATUS_UNINIT);
			this.RefreshInfo = FlowChart_OAProcess_SendNodeRefreshInfo;
			this.ShowDetailAfter = FlowChartObject.OAProcess.ShowDetailAfter;
		};
	});
})(FlowChartObject);