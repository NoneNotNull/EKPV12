/**********************************************************
功能：自动决策分支节点
使用：
	自动决策分支节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/
FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-autobranchnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		var nodeType = new FlowChartObject.Nodes.NodeType("autoBranchNode");
		nodeType.Hotkey = "X";
		nodeType.ImgIndex = 26;
		nodeType.ButtonIndex = 8;
		nodeType.Initialize = function(){
			//模板不缩小。 @作者：曹映辉 @日期：2013年3月5日 
			if(FlowChartObject.isNeedSmall&&!FlowChartObject.IsEdit&&!FlowChartObject.IsTemplate){
				this.Small_WidthRank=82;
				this.Small_HeightRank=45;
				this.Small_ImgageURL="../images/autobranchnode_small.gif";
			}
			this.CanLinkOutCount = 2;
			this.TypeCode = FlowChartObject.NODETYPE_CONDITION;
			//this.AttributePage = "attribute_autobranchnode.html";
			FlowChartObject.Nodes.CreateDiamondDOM(this);
			this.RefreshInfo = function() {
				var info = "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
				info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
				this.Info = Com_FormatText(info);
			};
		};
		
		FlowChartObject.Rule.ForbidMap.autoBranchNode = new Array("manualBranchNode");
	});
})(FlowChartObject);