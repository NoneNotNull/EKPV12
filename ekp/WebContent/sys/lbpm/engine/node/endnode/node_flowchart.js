/**********************************************************
功能：结束节点
使用：
	结束节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/
FlowChartObject.Lang.Include("sys-lbpm-engine-node-endnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		
		var nodeType = new FlowChartObject.Nodes.NodeType("endNode");
		nodeType.ShowInOperation = false;
		nodeType.Initialize = function(){
			this.CanDelete = false;
			this.CanCopy = false;
			this.CanLinkOutCount = 0;
			this.TypeCode = FlowChartObject.NODETYPE_END;
			FlowChartObject.Nodes.CreateRoundRectDOM(this);
		};
		
	});
})(FlowChartObject);