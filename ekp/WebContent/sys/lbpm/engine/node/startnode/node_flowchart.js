/**********************************************************
功能：开始节点
使用：
	开始节点节点类型初始化方法
作者：傅游翔
创建时间：2012-7-20
修改记录：
**********************************************************/
FlowChartObject.Lang.Include("sys-lbpm-engine-node-startnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		//开始节点
		var nodeType = new FlowChartObject.Nodes.NodeType("startNode");
		nodeType.ShowInOperation = false;
		nodeType.Initialize = function(){
			this.CanDelete = false;
			this.CanCopy = false;
			this.CanLinkInCount = 0;
			this.CanChangeOut = false;
			this.TypeCode = FlowChartObject.NODETYPE_START;
			FlowChartObject.Nodes.CreateRoundRectDOM(this);
		};
	});
})(FlowChartObject);