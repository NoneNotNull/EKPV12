/**********************************************************
功能：子流程回收/结束节点
使用：
	子流程回收节点节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-subprocess");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		
		//子流程结束节点
		var nodeType = new FlowChartObject.Nodes.NodeType("recoverSubProcessNode");
		nodeType.ShowInOperation = true;
		nodeType.Hotkey = "R";
		nodeType.ImgIndex = 29;
		nodeType.ButtonIndex = 6;
		nodeType.Initialize = function() {
			this.CanLinkOutCount = 2;
			FlowChartObject.Nodes.CreateRectDOM(this);
			//this.AttributePage = "attribute_recoversubprocess.html";
			if (this.Data['configContent'] == null) {
				this.SetStatus(FlowChartObject.STATUS_UNINIT);
			}
			this.RefreshInfo = function() {
				var info = "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
				info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
				this.Info = Com_FormatText(info);
			};
			this.Check = function() {
				if(!FlowChartObject.CheckFlowNode(this)){
					return false;
				}
				var json = (new Function("return ("+this.Data['configContent']+")"))();
				var nodeId = json.subProcessNode;
				var nodes = FlowChartObject.Nodes.all;
				var existNode = false;
				for (var i = 0; i < nodes.length; i ++) {
					if (nodes[i].Data.id == nodeId) {
						existNode = true;
						break;
					}
				}
				if (!existNode) {
					alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.Node.subprocessRecoverProcessNotExist,this.Data.name, nodeId));
					return false;
				}
				if (this.NeedReConfig) {
					alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.Node.subprocessRecoverProcessNeedReConfig, nodeId + "." + this.Data.name));
					return false;
				}
				var isPreNode = function(node, configId, beginId) {
					if (node.Data.id == configId) {
						return true;
					}
					var l = node.LineIn.length;
					for(var i = 0; i < l; i++){
						var line = node.LineIn[i];
						if (line.StartNode != null && line.StartNode.Data.id != beginId) {
							if (isPreNode(line.StartNode, configId, beginId)) {
								return true;
							}
						}
					}
					return false;
				};
				if (!isPreNode(this, nodeId, this.Data.id)) {
					alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.Node.subprocessRecoverProcessNotLegality,this.Data.name, nodeId));
					return false;
				}
				for (var i = 0; i < nodes.length; i ++) {
					var recoverNode = nodes[i];
					if (recoverNode.Data.id != this.Data.id 
							&& recoverNode.Type == this.Type
							&& recoverNode.Data['configContent']) {
						var recoverNodeJson = (new Function("return ("+recoverNode.Data['configContent']+")"))();
						if (recoverNodeJson.subProcessNode == nodeId && (isPreNode(this, recoverNode.Data.id, this.Data.id))) {
							alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.Node.subprocessRecoverProcessRepeat,
									this.Data.id + '.' + this.Data.name, 
									recoverNode.Data.id + '.' + recoverNode.Data.name, 
									nodeId));
							return false;
						};
					}
				}
				return true;
			};
		};
		
	});
})(FlowChartObject);