/**********************************************************
功能：并行分支结束节点
使用：
	并行分支结束节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpm-engine-node-joinnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		
		var nodeType = new FlowChartObject.Nodes.NodeType("joinNode");
		nodeType.ShowInOperation = false;
		nodeType.Initialize = function(){
			FlowChartObject.Nodes.CreateJoinDOM(this);
		};
		
	});
})(FlowChartObject);