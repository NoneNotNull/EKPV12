/**********************************************************
功能：起草人节点
使用：
	起草人节点节点类型初始化方法
作者：傅游翔
创建时间：2012-7-20
修改记录：
**********************************************************/
FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-draftnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		//起草人节点
		var nodeType = new FlowChartObject.Nodes.NodeType("draftNode");
		nodeType.ShowInOperation = false;
		nodeType.Initialize = function(){
			this.CanDelete = false;
			this.CanCopy = false;
			this.CanLinkInCount = 1;
			this.CanChangeIn = false;
			//this.AttributePage = "attribute_draftnode.html";
			FlowChartObject.Nodes.CreateRectDOM(this);
		};
	});
})(FlowChartObject);