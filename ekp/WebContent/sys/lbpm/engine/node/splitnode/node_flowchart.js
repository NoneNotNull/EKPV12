/**********************************************************
功能：并行分支开始节点
使用：
	并行分支开始节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpm-engine");
FlowChartObject.Lang.Include("sys-lbpm-engine-node-splitnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		
		function FlowChart_OAProcess_SplitJoinNodeCreate(){
			var sNode = new FlowChart_Node("splitNode");
			sNode.MoveTo(EVENT_X, EVENT_Y, true);
			sNode.Data.splitType = "all";
			var eNode = new FlowChart_Node("joinNode");
			eNode.MoveTo(EVENT_X, EVENT_Y + 100, true);
			eNode.Data.joinType = "all";
			FlowChartObject.Nodes.RelateNodes(new Array(sNode, eNode));
			
			var line = new FlowChart_Line();
			line.LinkNode(sNode, eNode, FlowChartObject.NODEPOINT_POSITION_BOTTOM, FlowChartObject.NODEPOINT_POSITION_TOP);
			line.Refresh(FlowChartObject.LINE_REFRESH_TYPE_DOM);
			
			FlowChartObject.Nodes.AutoLink(sNode, eNode);
		}
		
		//并行分支开始和结束节点的虚拟节点
		var nodeType = new FlowChartObject.Nodes.NodeType("splitJoinNode");
		nodeType.Hotkey = "B";
		nodeType.ImgIndex  = 34;
		nodeType.ButtonIndex = 9;
		nodeType.CreateNode = FlowChart_OAProcess_SplitJoinNodeCreate;
		//并行分支开始节点
		nodeType = new FlowChartObject.Nodes.NodeType("splitNode");
		nodeType.ShowInOperation = false;
		nodeType.Initialize = function(){
			this.CanLinkOutCount = 2;
			this.TypeCode = FlowChartObject.NODETYPE_CONDITION;
			FlowChartObject.Nodes.CreateSplitDOM(this);
		};
		
	});
})(FlowChartObject);