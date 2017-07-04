/**********************************************************
功能：人工决策节点
使用：
	人工决策节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-manualbranchnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		var nodeType = new FlowChartObject.Nodes.NodeType("manualBranchNode");
		nodeType.Hotkey = "Z";
		nodeType.ImgIndex = 25;
		nodeType.ButtonIndex = 7;
		nodeType.Initialize = function(){
			//模板不缩小。@作者：曹映辉 @日期：2013年4月7日 
			if(FlowChartObject.isNeedSmall&&!FlowChartObject.IsEdit&&!FlowChartObject.IsTemplate){
				this.Small_WidthRank=82;
				this.Small_HeightRank=48;
				this.Small_ImgageURL="../images/manualbranchnode_small.gif";
			}
			this.CanLinkOutCount = 2;
			//this.AttributePage = "attribute_manalbranchnode.html";
			FlowChartObject.Nodes.CreateDiamondDOM(this);
			this.RefreshInfo = function() {
				var info = "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
				info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
				this.Info = Com_FormatText(info);
			};
		};
	});
	
	FlowChartObject.Rule.InitializeFuns.push(function(FlowChartObject) {
		var forbitMap = FlowChartObject.Rule.ForbidMap;
		var nodeTypes = FlowChartObject.Nodes.Types;
		for (var o in nodeTypes) {
			var nodeType = nodeTypes[o];
			var desc = FlowChartObject.Nodes.nodeDesc(nodeType);
			if ((!desc.isHandler && !desc.isDraftNode) || desc.isSendNode) {
				var forbit = forbitMap[nodeType.Type];
				if (forbit == null) {
					forbit = new Array();
					forbitMap[nodeType.Type] = forbit;
				}
				forbit.push("manualBranchNode");
			}
		}
	});
})(FlowChartObject);