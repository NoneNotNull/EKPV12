﻿/**********************************************************
功能：流程图编辑状态的JS定义
使用：
	由panel.js在编辑状态下引入
必须实现的方法：
	FlowChartObject.Mode.Initialize（模式初始化）
	FlowChartObject.Operation.Initialize（操作初始化）
作者：叶中奇
创建时间：2008-05-05
修改记录：
**********************************************************/

//====================必须实现的方法====================
//功能：模式初始化


//显示分组器[模式|连线-控件|操作|显示|流程检测*|帮助*]
FlowChartObject.ViewGroup = function() {
	this.ChangeMode = [];
	this.Action = [];
	this.Select = [];
	this.View = [];
	this.ExtAction = [];
	this.Help = [];
	this.Register = function(name, operation) {
		if (operation.ReferInfos[name]) {
			var info = operation.ReferInfos[name];
			this[info.group].push(operation);
		}
	};
	this.Each = function(list, fun, args) {
		for (var i = 0; i < list.length; i ++) {
			fun(list[i], i, args);
		}
	};
};

//------------ 工具栏 -------------
FlowChartObject.Buttons = {
		ButtonOperations: new FlowChartObject.ViewGroup(),
		Initialize: function() {
			var groups = FlowChartObject.Buttons.ButtonOperations;
			var buttonbar = parent.ButtonBarObject; // TODO 工具栏对象来源的依赖问题
			FlowChartObject.Operation.ButtonBar = buttonbar;
			var addButtonFun = function(operation) {
				var info = operation.ReferInfos.Button;
				operation.AddRefer(buttonbar.AddButton(
						operation, isNaN(info.imgIndex) ? info.imgUrl : info.imgIndex));
				if (operation.ReferInfos.Selected) {
					operation.SetSelected(true);
				}
			};
			if (groups.ChangeMode.length > 0) {
				buttonbar.AddLine();
				groups.Each(groups.ChangeMode, addButtonFun);
			}
			if (groups.Action.length > 0) {
				buttonbar.AddLine();
				groups.Each(groups.Action, addButtonFun);
			}
			if (groups.View.length > 0) {
				buttonbar.AddLine();
				groups.Each(groups.View, addButtonFun);
			}
			if (groups.ExtAction.length > 0) {
				buttonbar.AddLine();
				groups.Each(groups.ExtAction, addButtonFun);
			}
			if (groups.Help.length > 0) {
				buttonbar.AddLine();
				groups.Each(groups.Help, addButtonFun);
			}
		},
		Register: function(operation) {
			FlowChartObject.Buttons.ButtonOperations.Register("Button", operation);
		}
};

//------------ 右键菜单 -------------
FlowChartObject.Menu = {
		Enable: Com_GetUrlParameter("showMenu") != 'false',
		MenuOperations: new FlowChartObject.ViewGroup(),
		Initialize: function() {
			if (!FlowChartObject.Menu.Enable)
				return;
			var menu1 = new RightButtonMenu(), menu2;
			var groups = FlowChartObject.Menu.MenuOperations;
			
			var addMenuFun = function(operation, i, menu) {
				menu.AddItem(operation, operation.ReferInfos.Menu.hotkeyNotice);
			};
			if (groups.ChangeMode.length > 1) {
				menu2 = menu1.AddMenu(FlowChartObject.Lang.Operation.MenuAdd).Menu;
				groups.Each(groups.ChangeMode, addMenuFun, menu2);
				
				menu1.AddLine();
			}
			if (groups.ChangeMode.length == 1) {
				groups.Each(groups.ChangeMode, addMenuFun, menu1);
				
				menu1.AddLine();
			}
			
			groups.Each(groups.Action, addMenuFun, menu1);
			
			menu1.AddLine();
			menu2 = menu1.AddMenu(FlowChartObject.Lang.Operation.MenuSelect).Menu;
			groups.Each(groups.Select, addMenuFun, menu2);
			
			menu2 = menu1.AddMenu(FlowChartObject.Lang.Operation.MenuView).Menu;
			groups.Each(groups.View, addMenuFun, menu2);
			
			if (groups.ExtAction.length > 0) {
				menu1.AddLine();
				groups.Each(groups.ExtAction, addMenuFun, menu1);
			}
			
			if (groups.Help.length > 0) {
				menu1.AddLine();
				groups.Each(groups.Help, addMenuFun, menu1);
			}
			
			FlowChartObject.Operation.Menu = menu1;
		},
		Register: function(operation) {
			if (!FlowChartObject.Menu.Enable)
				return;
			FlowChartObject.Menu.MenuOperations.Register("Menu", operation);
		}
};

//------------ 快捷键 -------------
FlowChartObject.Hotkeys = {
		HotkeyOperations: {
			"shift": [],
			"ctrl": [],
			"normal": []
		},
		Initialize: function() {
			var shiftKeys = FlowChartObject.Operation.Hotkey.ShiftHotkeys;
			var ctrlKeys = FlowChartObject.Operation.Hotkey.CtrlHotkeys;
			var normalKeys = FlowChartObject.Operation.Hotkey.NormalHotkeys;
			var operations = FlowChartObject.Hotkeys.HotkeyOperations;
			FlowChartObject.Hotkeys.Bind(shiftKeys, operations["shift"]);
			FlowChartObject.Hotkeys.Bind(ctrlKeys, operations["ctrl"]);
			FlowChartObject.Hotkeys.Bind(normalKeys, operations["normal"]);
		},
		Bind: function(hotKeys, operations) {
			for (var i = 0 ; i < operations.length; i ++) {
				var hotkeyInfo = operations[i].ReferInfos.Hotkey;
				// 数字类型判断
				if ((typeof hotkeyInfo.key) == 'number') {
					hotKeys[hotkeyInfo.key] = operations[i];
				} else {
					hotKeys[hotkeyInfo.key.charCodeAt(0)] = operations[i];
				}
			}
		},
		Register: function(operation) {
			if (operation.ReferInfos.Hotkey) {
				var hotkeyInfo = operation.ReferInfos.Hotkey;
				var types = hotkeyInfo.types || ["normal"];
				for (var i = 0; i < types.length; i ++) {
					var type = types[i];
					var hotKeys = FlowChartObject.Hotkeys.HotkeyOperations[type];
					hotKeys.push(operation);
				}
			}
		}
};

FlowChartObject.InitializeArray.push(FlowChartObject.Buttons, FlowChartObject.Menu, FlowChartObject.Hotkeys);


//功能：操作初始化
FlowChartObject.Operation.InitializeFuns = [];
FlowChartObject.Operation.Initialize = function(){
	var i = 0;
	// 控件操作的加载
	if (FlowChartObject.IsEdit) {
		for(var p in FlowChartObject.Nodes.Types){
			var typeObj = FlowChartObject.Nodes.Types[p];
			if(typeObj.ShowInOperation){
				// TODO 需要增加控件属性，支持构建操作信息
				var operation = new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, p);
				if (typeObj.ImgIndex != null || typeObj.ImgUrl != null) {
					operation.ReferInfos.Button = {};
					operation.ReferInfos.Button.group = "ChangeMode";
					if (typeObj.ImgUrl != null) {
						operation.ReferInfos.Button.imgUrl = typeObj.ImgUrl;
					} else {
						operation.ReferInfos.Button.imgIndex = typeObj.ImgIndex;
					}
					if (typeObj.Cursor != null) {
						operation.ReferInfos.Cursor = typeObj.Cursor;
					}
				}
				if (typeObj.Hotkey) {
					operation.ReferInfos.Hotkey = {};
					operation.ReferInfos.Hotkey.key = typeObj.Hotkey;
					operation.ReferInfos.Menu = {};
					operation.ReferInfos.Menu.group = "ChangeMode";
					operation.ReferInfos.Menu.hotkeyNotice = typeObj.Hotkey;
				}
				operation.ReferInfos.Index = typeObj.ButtonIndex;
			}
		}
	}
	var funs = FlowChartObject.Operation.InitializeFuns;
	for (i = 0; i < funs.length; i ++) {
		funs[i](FlowChartObject);
	}
	for (i = 0; i < FlowChartObject.Operation.list.length; i++) {
		FlowChartObject.Operation.list[i].__index = i; // 解决chrome排序问题
	}
	FlowChartObject.Operation.list.sort(function(opr1, opr2) {
		if (opr1.ReferInfos.Index == null) {
			opr1.ReferInfos.Index = 100;
		}
		if (opr2.ReferInfos.Index == null) {
			opr2.ReferInfos.Index = 100;
		}
		var index = opr1.ReferInfos.Index - opr2.ReferInfos.Index;
		return (index == 0) ? (opr1.__index - opr2.__index) : index;
	});
	// 有效操作加载
	var allOpers = FlowChartObject.Operation.list;
	for (i = 0; i < allOpers.length; i ++) {
		if (allOpers[i].SupportMode(FlowChartObject)) {
			FlowChartObject.Buttons.Register(allOpers[i]);
			FlowChartObject.Menu.Register(allOpers[i]);
			FlowChartObject.Hotkeys.Register(allOpers[i]);
		}
	}
};


//====================操作定义====================

//---------基本默认操作------------

// 属性展现操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("Attribute", FlowChart_Operation_Attribute, FlowChart_Operation_Attribute_Check, null, {
		Hotkey:{types:["normal"], key:13}, 
		Button:{group:'Action', imgIndex:1}, 
		Menu:{group:'Action', hotkeyNotice:FlowChartObject.Lang.Operation.DblClick+"/Enter"}
	});
});
//功能：属性
function FlowChart_Operation_Attribute(){
	if(FlowChartObject.Mode.Current.Type!="normal" || !FlowChart_Operation_Attribute_Check())
		return;
	FlowChartObject.Currents[0].ShowAttribute();
}
//功能：属性状态检查
function FlowChart_Operation_Attribute_Check(){
	return FlowChartObject.Currents.length==1 && FlowChartObject.Currents[0].ShowAttribute!=null;
}

//拷贝操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("Copy", FlowChart_Operation_Copy, FlowChart_Operation_Copy_Check, null, {
		Hotkey:{types:["ctrl", "shift"], key:"C"}, 
		Button:{group:'Action', imgIndex:2}, 
		Menu:{group:'Action', hotkeyNotice:"Ctrl/Shift+C"}
	}, function(FlowChartObject) {
		return FlowChartObject.IsTemplate;
	});
});
//功能：拷贝
function FlowChart_Operation_Copy(){
	if(FlowChartObject.Mode.Current.Type!="normal")
		return;
	var nodeXML = "";
	var lineXML = "";
	for(var i=0; i<FlowChartObject.Currents.length; i++){
		var elem = FlowChartObject.Currents[i];
		if(elem.Name=="Node"){
			if(elem.CanCopy){
				nodeXML += "\r\n"+elem.GetXMLString();
				//关联的节点即使未被选中，也参与拷贝
				for(var j=0; j<elem.RelatedNodes.length; j++){
					if(Com_ArrayGetIndex(FlowChartObject.Currents, elem.RelatedNodes[j])==-1){
						nodeXML += "\r\n"+elem.RelatedNodes[j].GetXMLString();
					}
				}
			}
		}else{
			//连线的开始和结束都被选定，并且都可以被拷贝，连线才可以被拷贝
			if(elem.StartNode.CanCopy &&
				elem.EndNode.CanCopy &&
				Com_ArrayGetIndex(FlowChartObject.Currents, elem.StartNode)>-1 &&
				Com_ArrayGetIndex(FlowChartObject.Currents, elem.EndNode)>-1)
				lineXML += "\r\n"+elem.GetXMLString();
		}
	}
	if(nodeXML=="")
		return;
	//设置window的剪切板
	Com_SaveData("<"+FlowChartObject.Name+">\r\n<nodes>"+nodeXML+"\r\n</nodes>\r\n<lines>"+lineXML+"\r\n</lines>\r\n</"+FlowChartObject.Name+">");
}
//功能：拷贝状态检查
function FlowChart_Operation_Copy_Check(){
	for(var i=0; i<FlowChartObject.Currents.length; i++){
		var elem = FlowChartObject.Currents[i];
		if(elem.Name=="Node" && elem.CanCopy)
			return true;
	}
	return false;
}

//全选操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("SelectAll", FlowChart_Operation_SelectAll, null, null, {
		Hotkey:{types:["ctrl", "shift"], key:"A"}, 
		Button:{group:'ExtAction', imgIndex:5}, 
		Menu:{group:'Select', hotkeyNotice:"Ctrl/Shift+A"}
	});
});
//功能：全部选择
function FlowChart_Operation_SelectAll(){
	if(FlowChartObject.Mode.Current.Type!="normal")
		return;
	var i;
	//选中所有节点
	for(i=0; i<FlowChartObject.Nodes.all.length; i++)
		FlowChartObject.SelectElement(FlowChartObject.Nodes.all[i], false, true);
	//选中所有连线
	for(i=0; i<FlowChartObject.Lines.all.length; i++)
		FlowChartObject.SelectElement(FlowChartObject.Lines.all[i], false, true);
	FlowChartObject.Mode.RefreshOptPoint();
}

//全不选操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("SelectNone", FlowChart_Operation_SelectNone, null, null, {
		Hotkey:{types:["ctrl", "shift"], key:"D"}, 
		//Button:{group:'Select', imgIndex:5}, 
		Menu:{group:'Select', hotkeyNotice:"Ctrl/Shift+D"}
	});
});
//功能：全部不选
function FlowChart_Operation_SelectNone(){
	if(FlowChartObject.Mode.Current.Type!="normal")
		return;
	FlowChartObject.SelectElement(null, true);
	FlowChartObject.Mode.RefreshOptPoint();
}

//选定节点操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("SelectNodes", FlowChart_Operation_SelectNodes, null, null, {
		Hotkey:{types:["shift"], key:"N"}, 
		Menu:{group:'Select', hotkeyNotice:"Shift+N"}
	});
});
//功能：选择所有节点
function FlowChart_Operation_SelectNodes(){
	if(FlowChartObject.Mode.Current.Type!="normal")
		return;
	FlowChartObject.SelectElement(null, true);
	for(var i=0; i<FlowChartObject.Nodes.all.length; i++)
		FlowChartObject.SelectElement(FlowChartObject.Nodes.all[i], false, true);
	FlowChartObject.Mode.RefreshOptPoint();
}

//选定连线操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("SelectLines", FlowChart_Operation_SelectLines, null, null, {
		Hotkey:{types:["shift"], key:"L"}, 
		Menu:{group:'Select', hotkeyNotice:"Shift+L"}
	});
});
//功能：选择所有连线
function FlowChart_Operation_SelectLines(){
	if(FlowChartObject.Mode.Current.Type!="normal")
		return;
	FlowChartObject.SelectElement(null, true);
	for(var i=0; i<FlowChartObject.Lines.all.length; i++)
		FlowChartObject.SelectElement(FlowChartObject.Lines.all[i], false, true);
	FlowChartObject.Mode.RefreshOptPoint();
}

//功能：全屏 TODO 全部暂时隐藏掉
function FlowChart_Operation_FullScreen(){
	parent.FlowChart_ChangeFullScreen();
	this.SetSelected(!this.Selected);
}

//放大画布操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("PanelUp", FlowChart_Operation_PanelUp, null, null, {
		Hotkey:{types:["shift"], key:40}, 
		Button:{group:'View', imgIndex:10}, 
		Menu:{group:'View', hotkeyNotice:"Shift+↓"}
	});
});
//功能：放大画布
function FlowChart_Operation_PanelUp(){
	FlowChart_Operation_PanelChange(1);
}

//缩小画布操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("PanelDown", FlowChart_Operation_PanelDown, null, null, {
		Hotkey:{types:["shift"], key:38}, 
		Button:{group:'View', imgIndex:11}, 
		Menu:{group:'View', hotkeyNotice:"Shift+↑"}
	});
});
//功能：缩小画布
function FlowChart_Operation_PanelDown(){
	FlowChart_Operation_PanelChange(-1);
}

function FlowChart_Operation_PanelChange(forward){
	if(parent.FULLSCREEN_STATUS)
		return;
	if(parent.FULLSCREEN_IFRAME) {
		var height = parent.FULLSCREEN_IFRAME.clientHeight+100*forward;
		if(height<300)
			height = 300;
		parent.FULLSCREEN_IFRAME.style.height =	height + "px";
	}
}

//放大操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ZoomIn", FlowChart_Operation_ZoomIn, null, null, {
		Button:{group:'View', imgIndex:13}, 
		Menu:{group:'View', hotkeyNotice:"Shift+"+FlowChartObject.Lang.Operation.WheelUp}
	});
});
function FlowChart_Operation_ZoomIn(){
	FlowChart_Operation_ChangeZoom(10);
}
//缩小操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ZoomOut", FlowChart_Operation_ZoomOut, null, null, {
		Button:{group:'View', imgIndex:14}, 
		Menu:{group:'View', hotkeyNotice:"Shift+"+FlowChartObject.Lang.Operation.WheelUp}
	});
});
function FlowChart_Operation_ZoomOut(){
	FlowChart_Operation_ChangeZoom(-10);
}
//功能：放大缩小
function FlowChart_Operation_ChangeZoom(d){
	FlowChartObject.Zoom += d;
	if(FlowChartObject.Zoom>200)
		FlowChartObject.Zoom = 200;
	if(FlowChartObject.Zoom<50)
		FlowChartObject.Zoom = 50;
	document.body.style.zoom = FlowChartObject.Zoom+"%";
	FlowChart_RefreshWindowStatus();
}

//重置显示比例操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ResetZoom", FlowChart_Operation_ResetZoom, null, null, {
		Hotkey:{types:["shift"], key:"R"}, 
		Button:{group:'View', imgIndex:12}, 
		Menu:{group:'View', hotkeyNotice:"Shift+R"}
	});
});
//功能：重置显示比例
function FlowChart_Operation_ResetZoom(){
	FlowChartObject.Zoom = 100;
	document.body.style.zoom = FlowChartObject.Zoom+"%";
	FlowChart_RefreshWindowStatus();
}

//显示帮助信息
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ShowHelp", FlowChart_Operation_ShowHelp, null, null, {
		Hotkey:{types:["shift"], key:"H"}, 
		Button:{group:'Help', imgIndex:18}, 
		Menu:{group:'Help', hotkeyNotice:"Shift+H"}
	});
});
//功能：显示帮助信息
function FlowChart_Operation_ShowHelp(){
	 window.open("./help.jsp", "_blank" );
}

FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, "normal", 
			{Hotkey:null, Button:null, Menu:null});
});

//粘贴操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("Paste", FlowChart_Operation_Paste, FlowChart_Operation_Paste_Check, null, {
		Hotkey:{types:["ctrl", "shift"], key:"V"}, 
		Button:{group:'Action', imgIndex:3}, 
		Menu:{group:'Action', hotkeyNotice:"Ctrl/Shift+V"}
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
});
//功能：粘贴
function FlowChart_Operation_Paste(){
	if(FlowChartObject.Mode.Current.Type!="normal" || !FlowChart_Operation_Paste_Check())
		return;
	FlowChartObject.SelectElement(null, true);
	//读取数据
	var processData = WorkFlow_LoadXMLData(Com_LoadData());
	var nodeIdMap = new Object();
	var newNodes = new Array();
	var data, i;
	//粘贴节点
	for(i=0; i<processData.nodes.length; i++){
		data = processData.nodes[i];
		FlowChart_Node_FormatData(data);
		var newId = "N"+(++FlowChartObject.Nodes.Index);
		nodeIdMap[data.id] = newId;
		data.id = newId;
		var node = new FlowChart_Node(data.XMLNODENAME, data);
		FlowChartObject.SelectElement(node, false, true);
		node.MoveTo(data.x, data.y, true);
		newNodes[newNodes.length] = node;
	}
	var relatedNodesIds = "";
	//更新ID信息
	for(i=0; i<newNodes.length; i++){
		node = newNodes[i];
		if(node.Data.relatedNodeIds!=null){
			var oldIdArr = node.Data.relatedNodeIds.split(";");
			var newIds = "";
			for(var j=0; j<oldIdArr.length; j++){
				var newId = nodeIdMap[oldIdArr[j]];
				if(newId==null)
					continue;
				newIds += ";" + newId;
			}
			if(newIds=="")
				node.Data.relatedNodeIds = null;
			else
				node.Data.relatedNodeIds = newIds.substring(1);
		}
		if(node.RefreshRefId!=null)
			node.RefreshRefId(nodeIdMap);
	}
	//链接关联节点
	FlowChartObject.Nodes.RefreshAllRelatedNodes();
	
	//粘贴连线
	for(i=0; i<processData.lines.length; i++){
		data = processData.lines[i];
		data.id = "L"+(++FlowChartObject.Lines.Index);
		data.startNodeId = nodeIdMap[data.startNodeId];
		data.endNodeId = nodeIdMap[data.endNodeId];
		var points = FlowChart_Line_GetPointsByString(data.points);
		for(var j=0; j<points.length; j++){
			points[j].x += 20;
			points[j].y += 20;
		}
		data.points = FLowChart_Line_GetPointsString(points);
		FlowChartObject.SelectElement(new FlowChart_Line(data), false, true);
	}
	
	FlowChartObject.Mode.RefreshOptPoint();
}
//功能：粘贴状态检查
function FlowChart_Operation_Paste_Check(){
	var data = Com_LoadData();
	if(data==null)
		return false;
	data = Com_Trim(data);
	var len = FlowChartObject.Name.length + 2;
	if(data.substring(0,len)!="<"+FlowChartObject.Name+">" || data.substring(data.length-len-1)!="</"+FlowChartObject.Name+">")
		return false;
	return true;
}


//删除操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("Delete", FlowChart_Operation_Delete, FlowChart_Operation_Delete_Check, null, {
		Hotkey:{key:46}, 
		Button:{group:'Action', imgIndex:4}, 
		Menu:{group:'Action', hotkeyNotice:"Delete"}
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
});
//功能：删除
function FlowChart_Operation_Delete(){
	if(FlowChartObject.Mode.Current.Type!="normal" || FlowChartObject.Currents.length==0)
		return;
	//查找删除后剩余的元素
	var remainArr = new Array();
	//需要删除的元素
	var deleteArr = new Array();
	var i;
	for(i=0; i<FlowChartObject.Currents.length; i++){
		if(FlowChartObject.Currents[i].CanDelete)
			deleteArr[deleteArr.length] = FlowChartObject.Currents[i];
		else
			remainArr[remainArr.length] =  FlowChartObject.Currents[i];
	}
	i = FlowChartObject.Currents.length-remainArr.length;
	if(i==0){
		//i==0，所有元素都不能删除
		alert(FlowChartObject.Lang.selectElemCannotDelete);
		return;
	}
	//提示删除信息
	var partInfo = remainArr.length>0?FlowChartObject.Lang.selectElemDeletePartInfo:"";
	if(!confirm(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.selectElemDeleteInfo, i, partInfo)))
		return;
	//整理连线和关联信息
	for(i=0; i<deleteArr.length; i++){
		if(deleteArr[i].Name=="Node"){
			for(var j=0; j<deleteArr[i].RelatedNodes.length; j++){
				if(Com_ArrayGetIndex(deleteArr, deleteArr[i].RelatedNodes[j])==-1)
					deleteArr[deleteArr.length] = deleteArr[i].RelatedNodes[j];
			}
			if(deleteArr[i].LineOut.length==1){
				var node = deleteArr[i];
				var endNode = node.LineOut[0].EndNode;
				for(var j=node.LineIn.length-1; j>=0; j--){
					var line = node.LineIn[j];
					if(FlowChartObject.Rule.CheckLinkBetween(line.StartNode, endNode, line)){
						line.LinkNode(null, endNode, null, node.LineOut[0].Data.endPosition);
						line.Refresh();
					}
				}
			}
		}
	}
	
	//删除
	for(var i=0; i<deleteArr.length; i++){
		deleteArr[i].Delete();
	}
	FlowChartObject.Currents = remainArr;
	FlowChartObject.Mode.RefreshOptPoint();
}
//功能：删除状态检查
function FlowChart_Operation_Delete_Check(){
	for(var i=0; i<FlowChartObject.Currents.length; i++)
		if(FlowChartObject.Currents[i].CanDelete)
			return true;
	return false;
}


//切换大小图标操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ChangeIconType", FlowChart_Operation_ChangeIconType, null, null, {
		Button:{group:'ExtAction', imgIndex:15}, 
		Menu:{group:'ExtAction'}
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
});
//功能：切换大小图标
function FlowChart_Operation_ChangeIconType(){
	FlowChartObject.IconType = FlowChartObject.IconType==ICONTYPE_BIG?ICONTYPE_SMALL:ICONTYPE_BIG;
	var nodeList = FlowChartObject.Nodes.all;
	for(var i=0; i<nodeList.length; i++)
		if(nodeList[i].ChangeIconType!=null)
			nodeList[i].ChangeIconType();
	this.SetSelected(!this.Selected);
}


//格式化选定连线操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("FormatLine", FlowChart_Operation_FormatLine, FlowChart_Operation_FormatLine_Check, null, {
		Hotkey:{types:["shift"], key:"T"}, 
		Button:{group:'ExtAction', imgIndex:16}, 
		Menu:{group:'ExtAction', hotkeyNotice:"Shift+T"}
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
});
//功能：格式化选定连线
function FlowChart_Operation_FormatLine(){
	if(FlowChartObject.Mode.Current.Type!="normal")
		return;
	for(var i=0; i<FlowChartObject.Currents.length; i++){
		if(FlowChartObject.Currents[i].Name=="Line"){
			var line = FlowChartObject.Currents[i];
			var j, p1, p2, p3, isX;
			if(line.Points.length==2)
				continue;
			for(j=1; j<line.Points.length-1; j++){
				p1 = line.Points[j-1];
				p2 = line.Points[j];
				isX = (Math.abs(p1.x-p2.x)<Math.abs(p1.y-p2.y))	//根据角度判断是否调整x坐标
				if(isX)
					p2.x = p1.x;
				else
					p2.y = p1.y;
			}
			//最后一个节点根据上一个节点判断是是否调整x坐标
			if(isX)
				line.Points[j-1].y = line.Points[j].y;
			else
				line.Points[j-1].x = line.Points[j].x;
			//删除重叠的节点
			for(j=1; j<line.Points.length-1; j++){
				p1 = line.Points[j-1];
				p2 = line.Points[j];
				p3 = line.Points[j+1];
				if(p1.x==p2.x && p2.x==p3.x || p1.y==p2.y && p2.y==p3.y){
					line.Points = Com_ArrayRemoveElem(line.Points, p2);
					j--;
				}
			}
			line.Refresh();
		}
	}
	FlowChartObject.Mode.RefreshOptPoint();
}
//功能：格式化选定连线状态检查
function FlowChart_Operation_FormatLine_Check(){
	for(var i=0; i<FlowChartObject.Currents.length; i++)
		if(FlowChartObject.Currents[i].Name=="Line")
			return true;
	return false;
}

//流程检测操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("CheckFlow", FlowChartObject.CheckFlow, null, null, {
		Hotkey:{types:["shift"], key:"K"}, 
		Button:{group:'ExtAction', imgIndex:17}, 
		Menu:{group:'ExtAction', hotkeyNotice:"Shift+K"}
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
});
//功能：流程检测
//参数：isSilence：true=检测通过后不提示任何信息
//扩充：在流程检测通过后使用函数FlowChartObject.CheckFlow_Extend再次检测
FlowChartObject.CheckFlow = function(isSilence){
	//window.clipboardData.setData("Text",FlowChartObject.BuildFlowXML());
	//注意：死循环情况在创建节点的时候就已经避免，无需校验
	FlowChartObject.Mode.Change("normal");
	var nodeList = FlowChartObject.Nodes.all;
	
	var startNodes = new Array();
	var startCheckNodes = new Array();
	var endNodes = new Array();
	var endCheckNodes = new Array();
	FlowChartObject.SelectElement(null, true);
	FlowChartObject.Mode.RefreshOptPoint();
	for(var i=0; i<nodeList.length; i++){
		if(!nodeList[i].Check()){
			FlowChartObject.SelectElement(nodeList[i]);
			return false;
		}
		switch(nodeList[i].TypeCode){
			case NODETYPE_START:
				startNodes[startNodes.length] = nodeList[i];
				break;
			case NODETYPE_END:
				endNodes[endNodes.length] = nodeList[i];
				break;
			default:
				startCheckNodes[startCheckNodes.length] = nodeList[i];
				endCheckNodes[endCheckNodes.length] = nodeList[i];
		}
	}
	var success = true;
	//检查无法流入的节点
	for(var i=0; i<startNodes.length; i++)
		FlowChart_CheckFlow_RemoveStartTrace(startNodes[i], startCheckNodes);
	for(var i=0; i<startCheckNodes.length; i++){
		if(startCheckNodes[i]!=null){
			FlowChartObject.SelectElement(startCheckNodes[i]);
			success = false;
		}
	}
	if(!success){
		alert(FlowChartObject.Lang.checkFlowCanNotRouteStart);
		return false;
	}
	//检查无法流出的节点
	for(var i=0; i<endNodes.length; i++)
		FlowChart_CheckFlow_RemoveEndTrace(endNodes[i], endCheckNodes);
	for(var i=0; i<endCheckNodes.length; i++){
		if(endCheckNodes[i]!=null){
			FlowChartObject.SelectElement(endCheckNodes[i]);
			success = false;
		}
	}
	if(!success){
		alert(FlowChartObject.Lang.checkFlowCanNotRouteEnd);
		return false;
	}
	
	//检查扩展函数
	if(FlowChartObject.CheckFlow_Extend!=null && !FlowChartObject.CheckFlow_Extend(startNodes, endNodes))
		return false;
	//判断是否提示检测通过信息
	if(!isSilence)
		alert(FlowChartObject.Lang.checkFlowPass);
	return true;
};

FlowChartObject.CheckFlowNode = function(node){
	//检查流入
	if(node.CanLinkInCount>0 && node.LineIn.length==0){
		alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.checkFlowNodeNoLineIn, node.Data.name));
		return false;
	}
	//检查流出
	if(node.CanLinkOutCount>0 && node.LineOut.length==0){
		alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.checkFlowNodeNoLineOut, node.Data.name));
		return false;
	}
	//检查是否初始化
	if(node.Status==STATUS_UNINIT){
		alert(FlowChartObject.Lang.GetMessage(FlowChartObject.Lang.checkFlowNodeInit, node.Data.name));
		return false;
	}
	return true;
};

//功能：提供给流程检测使用，将可连接到开始节点的节点删除
function FlowChart_CheckFlow_RemoveStartTrace(startNode, startCheckNodes){
	for(var i=0; i<startNode.LineOut.length; i++){
		var index = Com_ArrayGetIndex(startCheckNodes, startNode.LineOut[i].EndNode);
		if(index>-1){
			startCheckNodes[index] = null;
			FlowChart_CheckFlow_RemoveStartTrace(startNode.LineOut[i].EndNode, startCheckNodes);
		}
	}
}
//功能：提供给流程检测使用，将可连接到结束节点的节点删除
function FlowChart_CheckFlow_RemoveEndTrace(endNode, endCheckNodes){
	for(var i=0; i<endNode.LineIn.length; i++){
		var index = Com_ArrayGetIndex(endCheckNodes, endNode.LineIn[i].StartNode);
		if(index>-1){
			endCheckNodes[index] = null;
			FlowChart_CheckFlow_RemoveEndTrace(endNode.LineIn[i].StartNode, endCheckNodes);
		}
	}
}


// 节点过滤操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("FilterNodes", FlowChart_Operation_FilterNodes, null, null, {
		Button:{group:'ExtAction', imgIndex:33}, 
		Menu:{group:'ExtAction'}
	}, function(FlowChartObject) {
		return !FlowChartObject.IsTemplate && !FlowChartObject.IsEdit && window.parent && window.parent.parent && window.parent.parent.lbpm && window.parent.parent.lbpm.globals.getThroughNodes;
	});
});
// 功能：节点过滤
function FlowChart_Operation_FilterNodes() {
	var allNodes = FlowChartObject.Nodes.all;
	var allLines = FlowChartObject.Lines.all;
	var IndicatorDiv;
	//过滤掉流程自动决策分支不经过的节点，获取正确的节点
	window.parent.parent.lbpm.globals.getThroughNodes(function(throughtNodes){
		var throughtNodeIds = window.parent.parent.lbpm.globals.getIdsByNodes(throughtNodes).split(",");
		//设置显示所有节点
		for(var i=0;i<allNodes.length;i++){
			allNodes[i].Show(true);
		}
		//设置显示所有连线
		for(var i=0;i<allLines.length;i++){
			allLines[i].Show(true);
		}
		//保存需要隐藏的节点			
		var extendNodes = [];
		for(var i=0;i<allNodes.length;i++){
			var isContain=false;
			for(var j=0;j<throughtNodeIds.length;j++){
				if(allNodes[i].Data.id == throughtNodeIds[j]){
					
					isContain = true;
					break;
				}
			}	
			if(!isContain){
				extendNodes.push(allNodes[i]);
			}
		}

		//隐藏不通过的节点
		for(var i=0;i<extendNodes.length;i++){
			extendNodes[i].Show(false);
		}
		
		//隐藏不通过的节点连线
		var throughtIds = window.parent.parent.lbpm.globals.getIdsByNodes(throughtNodes)+",";

		for(var i=0;i<allLines.length;i++){
			var lineLinkNode = allLines[i].StartNode.Data.id+","+allLines[i].EndNode.Data.id+",";
			//alert("throughtIds:"+throughtIds+" lineLinkNode:"+lineLinkNode +"   index:"+throughtIds.indexOf(lineLinkNode));
			//如果连线的起始位置和结束位置包含的节点如（"N1,N2"）不在通过节点列表中则隐藏该连线
			if(throughtIds.indexOf(lineLinkNode) == -1){
				allLines[i].Show(false);
			}
			
		}
	},
	//请求前处理函数
	function(){
		//打开遮罩效果
		IndicatorDiv = window.parent.parent.lbpm.globals.openIndicatorDiv(this);
	},
	//请求完成后处理函数
	function(){
		//关闭遮罩层
		window.parent.parent.lbpm.globals.clearIndicatorDiv(IndicatorDiv,this);
	});
}

// 清除过滤操作
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ClearFilter", FlowChart_Operation_ClearFilter, null, null, {
		Button:{group:'ExtAction', imgIndex:32}, 
		Menu:{group:'ExtAction'}
	}, function(FlowChartObject) {
		return !FlowChartObject.IsTemplate;
	});
});

function FlowChart_Operation_ClearFilter() {
	var allNodes = FlowChartObject.Nodes.all;
	var allLines = FlowChartObject.Lines.all;
	//设置显示所有节点
	for(var i=0;i<allNodes.length;i++){
		allNodes[i].Show(true);
	}
	//设置显示所有连线
	for(var i=0;i<allLines.length;i++){
		allLines[i].Show(true);
	}
}

//普通模式切换
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, "normal", {
		Hotkey:{key:"Q"},
		Index: -10
	}, function(FlowChartObject) {
		return !FlowChartObject.IsTemplate && !FlowChartObject.IsEdit;
	});
	new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, "play", {
		Hotkey:{types:["shift"], key:"P"}, 
		Button:{group:'ChangeMode', imgIndex:21}, 
		Menu:{group:'ChangeMode', hotkeyNotice:'Shift+P'},
		Index: -10
	}, function(FlowChartObject) {
		return !FlowChartObject.IsTemplate && !FlowChartObject.IsEdit;
	});
});

//普通模式切换
FlowChartObject.Operation.InitializeFuns.push(function() {
	new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, "normal", {
		Hotkey:{key:"Q"},
		Button:{group:'ChangeMode', imgIndex:19},
		Selected:true,
		Index: -10
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
	
	new FlowChart_Operation("ChangeMode", FlowChartObject.Mode.Change, null, "line", {
		Hotkey:{key:"W"}, 
		Button:{group:'ChangeMode', imgIndex:20}, 
		Menu:{group:'ChangeMode', hotkeyNotice:'W'},
		Index: -5
	}, function(FlowChartObject) {
		return FlowChartObject.IsEdit;
	});
});


//====================连线规则定义====================
//功能：检查两个节点是否可以连接，line可传空值
FlowChartObject.Rule.CheckLinkBetween = function(startNode, endNode, line){
	if(startNode==endNode)
		return false;
	//检查连接节点是否没有改变
	if(line!=null && line.StartNode==startNode && line.EndNode==endNode)
		return true;
	//检查流入限制
	if(!FlowChartObject.Rule.CheckLinkIn(startNode.Type, endNode, line))
		return false;
	//检查流出限制，注意到前面已经判断了禁止规则，在这里无需再判断一次
	if(!FlowChartObject.Rule.CheckLinkOut(startNode, null, line))
		return false;
	//检查重复连线
	for(var i=0; i<startNode.LineOut.length; i++){
		if(startNode.LineOut[i].EndNode==endNode && startNode.LineOut[i]!=line)
			return false;
	}
	return true;
};

//功能：检查流入限制，startNodeType/line可传空值，用于新增连线或流程检查的时候
FlowChartObject.Rule.CheckLinkIn = function(startNodeType, endNode, line){
	if(!endNode.CanChangeIn)
		return false;
	if(endNode.CanLinkInCount==0 || endNode.CanLinkInCount==1 && endNode.LineIn.length==1 && endNode.LineIn[0]!=line)
		return false;
	if(startNodeType!=null)
		return FlowChartObject.Rule.CheckForbidMap(startNodeType, endNode.Type);
	return true;
};

//功能：检查流出限制，endNodeType/line可传空值，用于新增连线或流程检查的时候
FlowChartObject.Rule.CheckLinkOut = function(startNode, endNodeType, line){
	if(!startNode.CanChangeOut)
		return false;
	if(startNode.CanLinkOutCount==0 || startNode.CanLinkOutCount==1 && startNode.LineOut.length==1 && startNode.LineOut[0]!=line)
		return false;
	if(endNodeType!=null)
		return FlowChartObject.Rule.CheckForbidMap(startNode.Type, endNodeType);
	return true;
};

//功能：节点连接规则检查
FlowChartObject.Rule.CheckForbidMap = function(startNodeType, endNodeType){
	var rules = FlowChartObject.Rule.ForbidMap[startNodeType];
	if(rules!=null && Com_ArrayGetIndex(rules, endNodeType)>-1)
		return false;
	return true;
};