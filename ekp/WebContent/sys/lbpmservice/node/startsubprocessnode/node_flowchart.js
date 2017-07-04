/**********************************************************
功能：启动子流程节点
使用：
	启动子流程节点节点类型初始化方法
作者：傅游翔
创建时间：2012-6-6
修改记录：
**********************************************************/

FlowChartObject.Lang.Include("sys-lbpmservice");
FlowChartObject.Lang.Include("sys-lbpmservice-node-subprocess");

(function(FlowChartObject) {
	
	FlowChartObject.Nodes.InitializeTypes.push(function() {
		
		//子流程开始节点
		var nodeType = new FlowChartObject.Nodes.NodeType("startSubProcessNode");
		nodeType.ShowInOperation = true;
		nodeType.Hotkey = "P";
		nodeType.ImgIndex = 28;
		nodeType.ButtonIndex = 5;
		nodeType.Initialize = function(){
			this.CanLinkOutCount = 2;
			FlowChartObject.Nodes.CreateRectDOM(this);
			//this.AttributePage = "attribute_startsubprocess.html";
			if (this.Data['configContent'] == null) {
				this.SetStatus(FlowChartObject.STATUS_UNINIT);
			}
			this.RefreshInfo = function() {
				var info = "·" + FlowChartObject.Lang.Node.name + ": " + this.Data.name;
				info += "\r\n·" + FlowChartObject.Lang.Node.id + ": " + this.Data.id;
				this.Info = Com_FormatText(info);
			};
		};
		
	});
	
	FlowChartObject.Operation.InitializeFuns.push(function() {
		new FlowChart_Operation("ViewNodeSubs", function() {
			if (FlowChartObject.InfoDialog && FlowChartObject.InfoDialog.listSubFrame) {
				FlowChartObject.InfoDialog.listSubFrame.show();
			}
		}, null, null, {
			Button:{group:'View', imgIndex:30}, 
			Menu:{group:'View'}
		}, function(FlowChartObject) {
			return !FlowChartObject.IsTemplate && !FlowChartObject.IsEdit && FlowChartObject.HasSubProcesses;
		});
	});
	FlowChartObject.Operation.InitializeFuns.push(function() {
		new FlowChart_Operation("ViewParent", function() {
			var url = "sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=viewParent&fdId=";
			url = Com_Parameter.ContextPath + url + FlowChartObject.MODEL_ID;
			window.open(url);
		}, null, null, {
			Button:{group:'View', imgIndex:31}, 
			Menu:{group:'View'}
		}, function(FlowChartObject) {
			return !FlowChartObject.IsTemplate && !FlowChartObject.IsEdit && FlowChartObject.HasParentProcess;
		});
	});
})(FlowChartObject);

(function(Dialog) {
	Dialog.AddEventListener(window, "load", function() {

		var url = "sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=listNodeSubs&parentId=";
		url = Com_Parameter.ContextPath + url + FlowChartObject.MODEL_ID;
		Dialog.listSubFrame = new Dialog();
		Dialog.listSubFrame.initElement();
		Dialog.listSubFrame.position(5, 5);
		Dialog.listSubFrame.size(300, 200);
		Dialog.listSubFrame.setUrl(url);
		Dialog.listSubFrame.setTitle(FlowChartObject.Lang.Node.subprocessListDialogTitle);
		Dialog.listSubFrame.srcUrl = url;
		Dialog.listSubFrame.setNodeId = function(nodeId) {
			this.setUrl(this.srcUrl + "&nodeId=" + nodeId);
		};
		Dialog.listSubFrame._super_Show = Dialog.listSubFrame.show;
		Dialog.listSubFrame.show = function(url) {
			var currs = FlowChartObject.Currents;
			if (currs != null && currs.length == 1 && currs[0].Type == 'startSubProcessNode') {
				this.setNodeId(currs[0].Data.id);
			} else {
				this.setNodeId("");
			}
			this._super_Show();
		};
		FlowChartObject.AddSelectElementListener(function() {
			if (FlowChartObject.InfoDialog.listSubFrame.isShow()) {
				FlowChartObject.InfoDialog.listSubFrame.show();
			}
		});
		
		//Dialog.viewSubFrame = new Dialog();
		//Dialog.viewSubFrame.initElement();
		//Dialog.viewSubFrame.position(10, 10);
		//Dialog.viewSubFrame.size(300, 300);
	});
})(FlowChartObject.InfoDialog);