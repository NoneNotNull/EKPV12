/**********************************************************
功能：机器人节点
使用：
	机器人节点节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-robotnode");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		var nodeType = new FlowChartObject.Nodes.NodeType("robotNode");
		nodeType.Hotkey = "C";
		nodeType.ImgIndex = 27;
		nodeType.ButtonIndex = 4;
		nodeType.Initialize = function(){
			//模板不缩小。 @作者：曹映辉 @日期：2013年3月5日 
			if(FlowChartObject.isNeedSmall&&!FlowChartObject.IsEdit&&!FlowChartObject.IsTemplate){
				this.Small_WidthRank=99;
				this.Small_HeightRank=20;
				this.Small_ImgageURL="../images/robotnode_small.gif";
			}
			//this.AttributePage = "attribute_robotnode.html";
			FlowChartObject.Nodes.CreateRectDOM(this);
			this.RefreshInfo = function() {
				var info = "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
				info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
				this.Info = Com_FormatText(info);
			};
		};
	});
})(FlowChartObject);