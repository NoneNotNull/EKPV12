/****************************************************************************************
功能：流程图形界面主体函数，功能的扩展请查阅相关文档
子组件：
	FlowChartObject.Nodes（节点对象）
	FlowChartObject.Lines（连线对象）
	FlowChartObject.Points（操作点对象）
	FlowChartObject.SelectArea（选择区域）
	FlowChartObject.Mode（操作模式对象）
	FlowChartObject.Operation（操作对象：菜单/按钮/快捷键）
	FlowChartObject.Lang（语言包）
相关文件：
	menu.js（菜单）
	component.js（流程组件）
	edit.js/view.js（编辑/阅读状态相应操作）
	lang.js（语言包）
	样式写在了相关的html文件中
	相关图片、鼠标
JS文件中：
	view.js和edit.js会在相应的模式载入，必须实现的方法有：
		FlowChartObject.Mode.Initialize
		FlowChartObject.Operation.Initialize
	扩展的JS在url中通过extend参数带入，参数值只需文件名，不需要扩展名，所有js文件应该放在同一目录
作者：叶中奇
创建时间：2008-05-01
修改记录：
	2008-05-01：升级原有流程图功能
****************************************************************************************/
//====================常量定义====================
ICONTYPE_BIG = 1;					//大图标
ICONTYPE_SMALL = 2;					//小图标

STATUS_UNINIT = 0;					//状态：未初始化
STATUS_NORMAL = 1;					//状态：普通
STATUS_PASSED = 2;					//状态：曾经流过
STATUS_RUNNING = 3;					//状态：当前

NODETYPE_NORMAL = 0;				//普通节点
NODETYPE_START = 1;					//开始节点
NODETYPE_END = 2;					//结束节点
NODETYPE_CONDITION = 3;				//条件节点

NODEPOINT_POSITION_TOP = "1";		//节点位置：上
NODEPOINT_POSITION_RIGHT = "2";		//节点位置：右
NODEPOINT_POSITION_BOTTOM = "3";	//节点位置：下
NODEPOINT_POSITION_LEFT = "4";		//节点位置：左
NODEPOINT_POSITION_ALL = new Array(NODEPOINT_POSITION_TOP, NODEPOINT_POSITION_RIGHT, NODEPOINT_POSITION_BOTTOM, NODEPOINT_POSITION_LEFT);

NODESTYLE_STATUSCOLOR = new Array("#E1F0FD", "#FFFFEE", "#E4FEEF", "#FED6D6"); 	//节点各个状态下的颜色

LINE_REFRESH_TYPE_TEXT = 1;												//刷新文本信息
LINE_REFRESH_TYPE_DOM = 2;												//刷新DOM模型显示
LINE_REFRESH_TYPE_ALL = LINE_REFRESH_TYPE_TEXT | LINE_REFRESH_TYPE_DOM;

LINESTYLE_WEIGHT = 2;													//线条粗细
LINESTYLE_STATUSCOLOR = new Array("#444444", "#444444", "#009900");		//连线各个状态下的颜色
LINESTYLE_SELECTEDCOLOR = "#FF4444";									//选中时候线条颜色

EVENT_X = 0;															//当前鼠标坐标x值
EVENT_Y = 0;															//当前鼠标坐标y值
EVENT_MOUSE = 0;														//当前鼠标点击

DOUBLEWORDCODE = 128;													//判定双字节的字符码
DISPLAY_WINDOWSTATUS = true;											//是否
GRID_SIZE = 20;                                                         //网格大小

MODEL_NAME = Com_GetUrlParameter("modelName");
MODEL_ID = Com_GetUrlParameter("modelId");

//====================全局变量定义====================
var FlowChartObject = new Object();
//是否需要在流出图展示时缩小非人工处理节点 （默认 缩小，不缩小是改为false） #作者：曹映辉 #日期：2013年4月3日 
FlowChartObject.isNeedSmall=true;
parent.FlowChartObject = FlowChartObject;
FlowChartObject.IsEdit = Com_GetUrlParameter("edit")=="true";			//编辑模式
FlowChartObject.IsTemplate = Com_GetUrlParameter("template")=="true";	//是否模板
FlowChartObject.IsDetail = FlowChartObject.IsEdit || FlowChartObject.IsTemplate;	//是否详细信息
FlowChartObject.Name = "process";										//流程名称
FlowChartObject.IconType = ICONTYPE_SMALL;								//图标
FlowChartObject.Zoom = 100;												//显示比例
FlowChartObject.ProcessData = null;										//流程数据
FlowChartObject.StatusData = null;										//状态数据
FlowChartObject.Currents = new Array();									//当前选定

FlowChartObject.Nodes = new Object();									//节点
FlowChartObject.Lines = new Object();									//连线
FlowChartObject.Points = new Object();									//操作点
FlowChartObject.NodeDescMap = {};
FlowChartObject.NodeTypeDescs = {}; // 节点类型描述信息

FlowChartObject.Rule = new Object();									//连接规则
FlowChartObject.Rule.ForbidMap = new Object();							//ForbidMap.startNode = new Array("endNode")，表示Type=startNode的节点不允许连接到Type=endNode的节点

FlowChartObject.Mode = new Object();									//操作模式
FlowChartObject.Mode.all = new Object();								//模式对象列表
FlowChartObject.Mode.Current = null;									//当前模式
FlowChartObject.Mode.RefreshOptPoint = Com_EmptyFunction;				//更新操作点的显示
FlowChartObject.Mode.OnDblClickListeners = []; //模式节点双击监听函数，可以中断当前模式的函数调用，但是否调用由模式决定

FlowChartObject.SelectArea = new Object();								//选择区域
FlowChartObject.SelectArea.Show = false;								//选择区域是否显示

FlowChartObject.Operation = new Object();								//操作
FlowChartObject.Operation.all = new Object();							//操作列表
FlowChartObject.Operation.list = []; // 操作列表
FlowChartObject.Operation.Hotkey = new Object();						//热键
FlowChartObject.Operation.Hotkey.CtrlHotkeys = new Object();			//Ctrl键的快捷方式
FlowChartObject.Operation.Hotkey.ShiftHotkeys = new Object();			//Shift键的快捷方式
FlowChartObject.Operation.Hotkey.NormalHotkeys = new Object();			//正常键的快捷方式

// 全局常量拷贝到FlowChartObject空间
FlowChartObject.ModelName = MODEL_NAME;
FlowChartObject.ModelId = MODEL_ID;
FlowChartObject.MODEL_NAME = MODEL_NAME;
FlowChartObject.MODEL_ID = MODEL_ID;

FlowChartObject.HasParentProcess = Com_GetUrlParameter("hasParentProcess")=="true"; // 子流程信息
FlowChartObject.HasSubProcesses = Com_GetUrlParameter("hasSubProcesses")=="true";

FlowChartObject.ICONTYPE_BIG = ICONTYPE_BIG;
FlowChartObject.ICONTYPE_SMALL = ICONTYPE_SMALL;

FlowChartObject.STATUS_UNINIT = STATUS_UNINIT;
FlowChartObject.STATUS_NORMAL = STATUS_NORMAL;
FlowChartObject.STATUS_PASSED = STATUS_PASSED;
FlowChartObject.STATUS_RUNNING = STATUS_RUNNING;

FlowChartObject.NODETYPE_NORMAL = NODETYPE_NORMAL;
FlowChartObject.NODETYPE_START = NODETYPE_START;
FlowChartObject.NODETYPE_END = NODETYPE_END;
FlowChartObject.NODETYPE_CONDITION = NODETYPE_CONDITION;

FlowChartObject.NODEPOINT_POSITION_TOP = NODEPOINT_POSITION_TOP;
FlowChartObject.NODEPOINT_POSITION_RIGHT = NODEPOINT_POSITION_RIGHT;
FlowChartObject.NODEPOINT_POSITION_BOTTOM = NODEPOINT_POSITION_BOTTOM;
FlowChartObject.NODEPOINT_POSITION_LEFT = NODEPOINT_POSITION_LEFT;
FlowChartObject.NODEPOINT_POSITION_ALL = NODEPOINT_POSITION_ALL;

FlowChartObject.NODESTYLE_STATUSCOLOR = NODESTYLE_STATUSCOLOR;

FlowChartObject.LINE_REFRESH_TYPE_TEXT = LINE_REFRESH_TYPE_TEXT;
FlowChartObject.LINE_REFRESH_TYPE_DOM = LINE_REFRESH_TYPE_DOM;
FlowChartObject.LINE_REFRESH_TYPE_ALL = LINE_REFRESH_TYPE_ALL;

FlowChartObject.LINESTYLE_WEIGHT = LINESTYLE_WEIGHT;
FlowChartObject.LINESTYLE_STATUSCOLOR = LINESTYLE_STATUSCOLOR;
FlowChartObject.LINESTYLE_SELECTEDCOLOR = LINESTYLE_SELECTEDCOLOR;

FlowChartObject.FormFieldList = [];

// 事件
FlowChartObject.Event = {
		events : {},
		addListener: function(type, listener) {
			var ls = FlowChartObject.Event.events[type];
			if (ls == null) {
				ls = [];
				FlowChartObject.Event.events[type] = ls;
			}
			ls.push(listener);
		},
		removeListener: function(type, listener) {
			var ls = FlowChartObject.Event.events[type];
			if (ls != null) {
				 var index = ls.indexOf(listener);
				 if (index > -1) {
					 ls.splice(index, 1);
				 }
			}
		},
		fireEvent: function(type) {
			var ls = FlowChartObject.Event.events[type];
			if (ls != null) {
				for (var i = 0; i < ls.length; i ++) {
					ls[i]();
				}
			}
		}
};

//注册需要初始化的组件
FlowChartObject.InitializeArray = new Array(
	FlowChartObject.Nodes,
	FlowChartObject.Lines,
	FlowChartObject.Points,
	FlowChartObject.Mode,
	FlowChartObject.Operation,
	FlowChartObject.SelectArea,
	FlowChartObject.Rule
);

//====================操作模式对象类====================
function FlowChart_Mode(name){
	this.Name = name;
	this.Type = name;
	this.UserDefaultCursor = false;
	this.OnMouseDown = Com_EmptyFunction;
	this.OnMouseMove = Com_EmptyFunction;
	this.OnMouseUp = Com_EmptyFunction;
	this.OnDblClick = Com_EmptyFunction;
	this.Initialize = Com_EmptyFunction;
	this.Clear = Com_EmptyFunction;
	this.CurrentLine = null;
	this.CurrentNode = null;
	FlowChartObject.Mode.all[name] = this;
}

//功能：切换模式
FlowChartObject.Mode.Change = function(modeName){
	if(FlowChartObject.Mode.Current.Name == modeName)
		return;
	//切换模式
	FlowChartObject.Operation.Menu.Hide();
	FlowChartObject.Mode.Current.Clear();
	FlowChartObject.Operation.all.ChangeMode[FlowChartObject.Mode.Current.Name].SetSelected(false);
	var mode = FlowChartObject.Mode.all[modeName];
	if(mode==null)
		mode = FlowChartObject.Mode.all["node"];
	FlowChartObject.Mode.Current = mode;
	mode.Name = modeName;
	mode.Initialize();
	FlowChartObject.Operation.all.ChangeMode[modeName].SetSelected(true);
	if(mode.UserDefaultCursor){
		document.body.style.cursor = "default";
	}else{
		if (FlowChartObject.Operation.all.ChangeMode[modeName].ReferInfos.Cursor) {
			document.body.style.cursor = "url("+FlowChartObject.Operation.all.ChangeMode[modeName].ReferInfos.Cursor+"), default";
		} else {
			document.body.style.cursor = "url(../cursor/"+modeName.toLowerCase()+".cur), default";
		}
	}
};
//====================操作对象类和通用操作====================
function FlowChart_Operation(name, runFunc, checkFunc, argument, referInfos, supportMode){
	if(argument==null){
		this.Text = FlowChartObject.Lang.Operation.Text[name];
		this.Title = FlowChartObject.Lang.Operation.Title[name];
		FlowChartObject.Operation.all[name] = this;
	}else{
		this.Text = FlowChartObject.Lang.Operation.Text[name][argument];
		this.Title = FlowChartObject.Lang.Operation.Title[name][argument];
		if(FlowChartObject.Operation.all[name]==null)
			FlowChartObject.Operation.all[name] = new Object();
		FlowChartObject.Operation.all[name][argument] = this;
	}
	FlowChartObject.Operation.list.push(this);
	this.Selected = false;
	this.Run = runFunc;
	this.Check = checkFunc;
	this.Argument = argument;
	this.Refers = new Array();
	this.ReferInfos = referInfos == null ? {Hotkey:null, Button:null, Menu:null} : referInfos;
	
	this.AddRefer = FlowChart_Operation_AddRefer;
	this.SetSelected = FlowChart_Operation_SetSelected;
	this.SupportMode = supportMode == null ? FlowChart_Operation_DefaultSupportMode : supportMode;
}

//功能：判断操作是否适合当前模式
function FlowChart_Operation_DefaultSupportMode(FlowChartObject) {
	return true;
}

//功能：添加引用，用于更新选择状态
function FlowChart_Operation_AddRefer(obj){
	this.Refers[this.Refers.length] = obj;
}

//功能：设置是否选中
function FlowChart_Operation_SetSelected(selected){
	if(this.Selected==selected)
		return;
	this.Selected = selected;
	for(var i=0; i<this.Refers.length; i++)
		this.Refers[i].SetSelected(selected);
}


//====================选择相关方法====================
//功能：选择流程元素
//参数：
//	Elem：流程元素
//	delOther：true=去除当前选中的其他元素 false=将当前元素添加到选中列表中，默认
//	selType：true=选中 false=不选中 null=反向选中
FlowChartObject.SelectElement = function(Elem, delOther, selType){
	if(delOther){
		//清除已被选定元素
		for(var i=0; i<FlowChartObject.Currents.length; i++)
			if(FlowChartObject.Currents[i]!=Elem)
				FlowChartObject.Currents[i].Select(false);
		FlowChartObject.Currents = new Array();
	}
	if(Elem!=null){
		//设置是否选中
		Elem.Select(selType);
		//更新FlowChartObject.Currents
		i = Com_ArrayGetIndex(FlowChartObject.Currents, Elem);
		if(Elem.IsSelected){
			if(i==-1)
				FlowChartObject.Currents[FlowChartObject.Currents.length] = Elem;
		}else{
			if(i>-1)
				FlowChartObject.Currents = Com_ArrayRemoveElem(FlowChartObject.Currents, Elem);
		}
	}
	FlowChartObject.fireSelectElementListeners(Elem);
};

//功能：选择变更事件监听
FlowChartObject.SelectElementListeners = [];

FlowChartObject.IndexSelectElementListener = function(func) {
	var index = -1;
	var listeners = FlowChartObject.SelectElementListeners;
	for (var i = 0; i < listeners.length; i ++) {
		var listener = listeners[i];
		if (listener == func) {
			index = i;
			break;
		}
	}
	return index;
};

FlowChartObject.AddSelectElementListener = function(func) {
	if (FlowChartObject.IndexSelectElementListener(func) == -1) {
		FlowChartObject.SelectElementListeners.push(func);
	}
};

FlowChartObject.RemoveSelectElementListener = function(func) {
	if (FlowChartObject.IndexSelectElementListener(func) > -1) {
		FlowChartObject.SelectElementListeners.splice(index, 1);
	}
};

FlowChartObject.fireSelectElementListeners = function(Elem) {
	var listeners = FlowChartObject.SelectElementListeners;
	for (var i = 0; i < listeners.length; i ++) {
		var listener = listeners[i];
		listener(Elem);
	}
};

//功能：选择区域的初始化动作
FlowChartObject.SelectArea.Initialize = function(){
	var newElem = document.createElement("div");
	newElem.className = "select_area";
	newElem.style.display = "none";
	document.body.appendChild(newElem);
	FlowChartObject.SelectArea.DOMObject = newElem;
};

//功能：开始拖拽选择区域
FlowChartObject.SelectArea.Start = function(mode){
	var obj = FlowChartObject.SelectArea.DOMObject;
	obj.style.display = "inline";
	obj.style.left = mode.EventX + "px";
	obj.style.top = mode.EventY + "px";
	obj.style.width = 0 + "px";
	obj.style.height = 0 + "px";
	obj.KMSS_X = mode.EventX;
	obj.KMSS_Y = mode.EventY;
	FlowChartObject.SelectArea.Show = true;
};

//功能：选择区域拖拽中
FlowChartObject.SelectArea.Move = function(){
	var obj = FlowChartObject.SelectArea.DOMObject;
	var ds = EVENT_X - obj.KMSS_X;
	if(ds>=0){
		obj.style.left = obj.KMSS_X + "px";
		obj.style.width = ds + "px";
	}else{
		obj.style.left = (obj.KMSS_X + ds)  + "px";
		obj.style.width = (-ds) + "px";
	}
	ds = EVENT_Y - obj.KMSS_Y;
	if(ds>=0){
		obj.style.top = obj.KMSS_Y + "px";
		obj.style.height = ds + "px";
	}else{
		obj.style.top = (obj.KMSS_Y + ds) + "px";
		obj.style.height = (-ds) + "px";
	}
};


//功能：选择区域拖拽完毕
FlowChartObject.SelectArea.End = function(){
	var evn = Com_GetEventObject();
	var i, x1, x2, y1, y2;
	var obj = FlowChartObject.SelectArea.DOMObject;
	//计算选择区域坐标
	var ds = EVENT_X - obj.KMSS_X;
	if(ds>=0){
		x1 = obj.KMSS_X;
		x2 = x1 + ds;
	}else{
		x2 = obj.KMSS_X;
		x1 = x2 + ds;
	}
	ds = EVENT_Y - obj.KMSS_Y;
	if(ds>=0){
		y1 = obj.KMSS_Y;
		y2 = y1 + ds;
	}else{
		y2 = obj.KMSS_Y;
		y1 = y2 + ds;
	}
	//若没有按ctrl键，取消选定现有元素
	if(!evn.ctrlKey){
		FlowChartObject.SelectElement(null, true);
	}
	//选定区域中的节点
	for(i=0; i<FlowChartObject.Nodes.all.length; i++){
		var node = FlowChartObject.Nodes.all[i];
		var w = node.Width / 2;
		var h = node.Height / 2;
		if(x1 <= node.Data.x - w && y1 <= node.Data.y - h && x2 >= node.Data.x + w && y2 >= node.Data.y + h){
			FlowChartObject.SelectElement(node);
		}
	}
	//选定区域中的连线
	outloop:
	for(i=0; i<FlowChartObject.Lines.all.length; i++){
		var line = FlowChartObject.Lines.all[i];
		for(var j=0; j<line.Points.length; j++){
			var p = line.Points[j];
			if(x1>p.x || x2<p.x || y1>p.y || y2<p.y){
				continue outloop;
			}
		}
		FlowChartObject.SelectElement(line);
	}
	//更新界面状态和变量
	FlowChartObject.Mode.RefreshOptPoint();
	obj.style.display = "none";
	FlowChartObject.SelectArea.Show = false;
};

//功能：取消选择区域
FlowChartObject.SelectArea.Cancel = function(){
	if(FlowChartObject.SelectArea.Show){
		FlowChartObject.SelectArea.DOMObject.style.display = "none";
	}
};

//====================其它FlowChartObject方法====================
//功能：读取已定义好的XML文档，画流出图，xml可以是字符串，也可以是xml对象
FlowChartObject.DrawFlowByXML = function(xml){
	//读取数据
	var processData = WorkFlow_LoadXMLData(xml);
	FlowChartObject.DrawFlowByData(processData);
};

FlowChartObject.DrawFlowByData = function(processData){
	FlowChartObject.ProcessData = processData;
	if (!FlowChartObject.IsDetail && FlowChartObject.ProcessData 
			&& (FlowChartObject.ProcessData.isDetail == 'true')) {
		FlowChartObject.IsDetail = true;
	}
	//初始化
	if(processData.iconType!=null && processData.iconType!="")
		FlowChartObject.IconType = parseInt(processData.iconType, 10);
	FlowChartObject.Nodes.Index = parseInt(processData.nodesIndex, 10);
	FlowChartObject.Lines.Index = parseInt(processData.linesIndex, 10);
	var i;
	//画节点
	for(i=0; i<processData.nodes.length; i++)
		new FlowChart_Node(processData.nodes[i].XMLNODENAME, processData.nodes[i]);
	FlowChartObject.Nodes.RefreshAllRelatedNodes();
	//画连线
	for(i=0; i<processData.lines.length; i++)
		new FlowChart_Line(processData.lines[i]);
	
	FlowChartObject.Event.fireEvent("DrawFlowByDataAfter");
};

//功能：将流程信息转换为XML
FlowChartObject.BuildFlowXML = function(){
	//返回数据
	return WorkFlow_BuildXMLString(FlowChartObject.BuildFlowData(), "process");
};

FlowChartObject.LinesSort = function(line1, line2){
	if(line1.StartNode==line2.StartNode){
		if(line1.EndNode.Data.y==line2.EndNode.Data.y)
			return line1.EndNode.Data.x - line2.EndNode.Data.x;
		return line1.EndNode.Data.y - line2.EndNode.Data.y;
	}
	if(line1.StartNode.Data.y==line2.StartNode.Data.y)
		return line1.StartNode.Data.x - line2.StartNode.Data.x;
	return line1.StartNode.Data.y - line2.StartNode.Data.y;
};

//功能：将流程信息转换为对象
FlowChartObject.BuildFlowData = function(){
	//节点排序
	FlowChartObject.Nodes.all.sort(function(node1, node2){
		if(node1.Data.y==node2.Data.y)
			return node1.Data.x - node2.Data.x;
		return node1.Data.y - node2.Data.y;
	});
	//连线排序
	FlowChartObject.Lines.all.sort(FlowChartObject.LinesSort);
	
	var processData = FlowChartObject.ProcessData;
	processData.nodesIndex = FlowChartObject.Nodes.Index;
	processData.linesIndex = FlowChartObject.Lines.Index;
	processData.iconType = FlowChartObject.IconType;
	//构造所有节点
	var nodes = new Array();
	for(var i=0; i<FlowChartObject.Nodes.all.length; i++){
		var node = FlowChartObject.Nodes.all[i];
		node.FormatXMLData();
		nodes[i] = node.Data;
	}
	processData.nodes = nodes;
	//构造所有连线
	var lines = new Array();
	for(var i=0; i<FlowChartObject.Lines.all.length; i++){
		var line = FlowChartObject.Lines.all[i];
		line.FormatXMLData();
		lines[i] = line.Data;
	}
	processData.lines = lines;
	return processData;
};

//功能：读取流转过程信息
FlowChartObject.LoadStatusByXML = function(xml){
	//读取数据
	if(xml!=null){
		FlowChartObject.StatusData = WorkFlow_GetStatusObjectByXML(xml);
	}
	var statusData = FlowChartObject.StatusData;
	//设置状态
	if(statusData.runningNodes.length>0){
		for(var i=0; i<statusData.runningNodes.length; i++){
			var nodeInfo = statusData.runningNodes[i];
			FlowChartObject.RefreshHistoryStatus(nodeInfo.routePath);
			var node = FlowChartObject.Nodes.GetNodeById(nodeInfo.id);
			if(node==null)
				continue;
			node.SetStatus(STATUS_RUNNING);
			node.CanDelete = false;
		}
		refind: for(i=0; i<FlowChartObject.Lines.all.length; i++) {
			var line = FlowChartObject.Lines.all[i];
			if (line.Status == STATUS_PASSED) {
				if (line.EndNode.Status != STATUS_PASSED) {
					var node = line.EndNode;
					for (var l = statusData.historyNodes.length - 1; l >= 0; l --) {
						var hisNodeInfo = statusData.historyNodes[l];
						if (node.Data.id == hisNodeInfo.id) {
							node.SetStatus(STATUS_PASSED);
							if(hisNodeInfo.routeType!="NORMAL" || hisNodeInfo.targetId==null || hisNodeInfo.targetId=="")
								continue refind;
							var targetIds = hisNodeInfo.targetId.split(";");
							for(var j=0; j<targetIds.length; j++){
								for(var k=0; k<node.LineOut.length; k++){
									if(targetIds[j]==node.LineOut[k].EndNode.Data.id){
										node.LineOut[k].SetStatus(STATUS_PASSED);
										break;
									}
								}
							}
							continue refind;
						}
					}
				}
			}
		}
	}else{
		for(var i=0; i<statusData.historyNodes.length; i++){
			var nodeInfo = statusData.historyNodes[i];
			var node = FlowChartObject.Nodes.GetNodeById(nodeInfo.id);
			if(node==null)
				continue;
			node.SetStatus(STATUS_PASSED);
			if(nodeInfo.routeType!="NORMAL" || nodeInfo.targetId==null || nodeInfo.targetId=="")
				continue;
			var targetIds = nodeInfo.targetId.split(";");
			for(var j=0; j<targetIds.length; j++){
				for(var k=0; k<node.LineOut.length; k++){
					if(targetIds[j]==node.LineOut[k].EndNode.Data.id){
						node.LineOut[k].SetStatus(STATUS_PASSED);
						break;
					}
				}
			}
		}
	}
	for(var i=0; i<statusData.runningNodes.length; i++){
		var nodeInfo = statusData.runningNodes[i];
		var node = FlowChartObject.Nodes.GetNodeById(nodeInfo.id);
		if(node==null)
			continue;
		node.SetStatus(STATUS_RUNNING);
		node.CanDelete = false;
	}
};

//功能：根据流转路径，更新历史状态
FlowChartObject.RefreshHistoryStatus = function(routePath){
	if (routePath == "" || routePath == null) {
		return;
	}
	var statusData = FlowChartObject.StatusData;
	var hisNodeIdArr = routePath.split(";");
	for(var i=0; i<hisNodeIdArr.length; i++){
		//更新节点状态
		var hisNodeId = hisNodeIdArr[i].split(":");
		var node = FlowChartObject.Nodes.GetNodeById(hisNodeId[0]);
		if(node==null)
			continue;
		node.SetStatus(STATUS_PASSED);
		//更新连线状态
		var hisNodeInfo = WorkFlow_GetStatusInfoByModelId(statusData, hisNodeId[0]);
		if(hisNodeInfo.routeType!="NORMAL" || hisNodeInfo.targetId==null || hisNodeInfo.targetId=="")
			continue;
		var targetIds = hisNodeInfo.targetId.split(";");
		for(var j=0; j<targetIds.length; j++){
			for(var k=0; k<node.LineOut.length; k++){
				if(targetIds[j]==node.LineOut[k].EndNode.Data.id){
					node.LineOut[k].SetStatus(STATUS_PASSED);
					break;
				}
			}
		}
	}
};

//====================事件方法====================
//功能：鼠标点下事件
function FlowChart_Event_OnMouseDown(e){
	e = window.event || e;
	if(e.button==2){
		EVENT_MOUSE = 2;
		FlowChartObject.Mode.Current.OnMouseDown(e);
	}else if(e.button==0 || e.button==1){
		EVENT_MOUSE = 1;
		FlowChartObject.Mode.Current.OnMouseDown(e);
	}
}

//功能：鼠标移动事件
function FlowChart_Event_OnMouseMove(e){
	e = window.event || e;
	var scrollLeft = document.documentElement.scrollLeft || document.body.scrollLeft;
	var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
	EVENT_X = Math.round(e.clientX*100/FlowChartObject.Zoom) + scrollLeft;
	EVENT_Y = Math.round(e.clientY*100/FlowChartObject.Zoom) + scrollTop;
	FlowChart_RefreshWindowStatus();
	FlowChartObject.Mode.Current.OnMouseMove(e);
}

//功能：鼠标放开事件
function FlowChart_Event_OnMouseUp(e){
	e = window.event || e;
	if(EVENT_MOUSE>0){
		FlowChartObject.Mode.Current.OnMouseUp(e);
		EVENT_MOUSE = 0;
	}
}

//功能：鼠标双击事件
function FlowChart_Event_OnDblClick(e){
	e = window.event || e;
	FlowChartObject.Mode.Current.OnDblClick(e);
}

//功能：鼠标滚轮事件
function FlowChart_Event_OnMouseWheel(e){
	e = window.event || e;
	if(e.ctrlKey || e.shiftKey){
		FlowChart_Operation_ChangeZoom(e.wheelDelta/12);
		return false;
	}
}

//功能：键盘按下事件，快捷键设定
function FlowChart_Event_OnKeyDown(e){
	e = window.event || e;
	if(e.ctrlKey){
		var keyInfo = FlowChartObject.Operation.Hotkey.CtrlHotkeys[e.keyCode];
		if(keyInfo!=null){
			keyInfo.Run(keyInfo.Argument);
			return false;
		}
	}else if(e.shiftKey){
		var keyInfo = FlowChartObject.Operation.Hotkey.ShiftHotkeys[e.keyCode];
		if(keyInfo!=null){
			keyInfo.Run(keyInfo.Argument);
			return false;
		}
	}else{
		var keyInfo = FlowChartObject.Operation.Hotkey.NormalHotkeys[e.keyCode];
		if(keyInfo!=null){
			keyInfo.Run(keyInfo.Argument);
			return false;
		}
	}
}

//====================常用函数====================
//功能：引入JS文件
function Com_IncludeJsFile(fileName, isOuter){
	isOuter = isOuter || false;
	if(Com_Parameter.Cache && fileName.indexOf('s_cache=')<0){
		if(fileName.indexOf("?")>=0){
			fileName += "&s_cache=" + Com_Parameter.Cache;
		}else{
			fileName += "?s_cache=" + Com_Parameter.Cache;
		}
	}
	if(isOuter) {
		document.writeln("<script src='"+fileName+"'></script>");
	} else {
		document.writeln("<script src='../js/"+fileName+"'></script>");
	}
}

function Com_RegisterFile(fileName){
	// do noting
}

//功能：获取元素在数组中的位置，找不到返回-1
function Com_ArrayGetIndex(arr, key){
	for(var i=0; i<arr.length; i++)
		if(arr[i]==key)
			return i;
	return -1;
}

//功能：删除数组中的某个元素
function Com_ArrayRemoveElem(arr, elem){
	var rtnArr = new Array;
	for(var i=0; i<arr.length; i++)
		if(arr[i]!=elem)
			rtnArr[rtnArr.length] = arr[i];
	return rtnArr;
}


//功能：格式化文本，当超过lineLen个字符时换行，当超过wordLen个字符时显示省略号
//参数：
//	lineMaxLen：默认为不自动换行
//	wordMaxLen：默认值为不出现省略号
function Com_FormatText(s, lineMaxLen, wordMaxLen){
	s = Com_FormatTextNormal(s, lineMaxLen, wordMaxLen);
	return Com_HtmlEscapeText(s);
}

function Com_FormatTextNormal(s, lineMaxLen, wordMaxLen){
	if(s==null || s=="")
		return s;
	s = Com_Trim(s);
	if(lineMaxLen!=null  || wordMaxLen!=null){
		//处理最大长度
		if(wordMaxLen!=null)
			wordMaxLen *= 2;
		else
			wordMaxLen = 1000000;
		var wordLen = 0;	//实际长度
		for(var i=0; i<s.length; i++){
			var l = (s.charCodeAt(i)>DOUBLEWORDCODE ? 2 : 1) + wordLen;
			if(l>wordMaxLen){
				//超过指定长度了
				for(i--; i>=0; i--){
					wordLen -= s.charCodeAt(i)>DOUBLEWORDCODE ? 2 : 1;
					if(wordLen+3<=wordMaxLen)
						break;
				}
				//考虑英文字符不能断的情况，往回查找可以断的点
				if(!Com_IsBreakableWord(s.charAt(i))){
					for(; i>=0; i--){
						if(Com_IsBreakableWord(s.charAt(i-1)))
							break;
						wordLen -= 1;
					}
				}
				s = s.substring(0, i)+"...";
				wordLen += 3;
				break;
			}
			wordLen = l;
		}
		if(lineMaxLen!=null){
			//处理转行情况
			lineMaxLen *= 2;
			var rtn = "";
			for(; wordLen>lineMaxLen;){
				var info1 = Com_GetNextBreakableInfo(s, 0, 0);
				//查找最后需要换行的地方
				for(var info2=info1; !info2.isEnd && info2.length<=lineMaxLen; info2=Com_GetNextBreakableInfo(s, info2.index, info2.length))
					info1 = info2;
				rtn += s.substring(0, info1.index) + "\r\n";
				s = s.substring(info1.index);
				wordLen -= info1.length;
			}
			s = rtn + s;
		}
	}
	return s;
}

function Com_HtmlEscapeText(s) {
	s = Com_HtmlEscape(s);
	var re = / /gi;
	s = s.replace(re, "&nbsp;");
	re = /\r\n/gi;
	s = s.replace(re, "<br>");
	return s;
}

//功能：去除字符串前后空格
function Com_Trim(s){
	s = s.replace(/^\s*(.*)/,"$1");
	return s.replace(/(.*?)\s*$/,"$1");
}

//功能：判定w是否是个可转行的字符串
function Com_IsBreakableWord(w){
	if(w.charCodeAt(0)>DOUBLEWORDCODE)
		return true;
	var re = /\w/gi;
	return !re.test(w);
}

//功能：获取字符串s从i开始的下一个可转行的地方，累计字符长度
function Com_GetNextBreakableInfo(s, i, wordLen){
	for(i++; i<s.length; i++){
		wordLen += s.charCodeAt(i)>DOUBLEWORDCODE ? 2 : 1;
		if(Com_IsBreakableWord(s.charAt(i)))
			return {index:i, length:wordLen, isEnd:false};
	}
	return {index:s.length, length:wordLen, isEnd:true};
}

//功能：获取事件触发的对象
function Com_GetEventSrcObject(){
	var evn = Com_GetEventObject();
	if(evn==null){
		return null;
	}
	for(var obj=evn.srcElement || evn.target; obj!=null; obj=obj.parentNode) {
		if(obj.LKSObject!=null){
			return obj.LKSObject;
		}
	}
	return null;
}

function Com_AddEventListener(obj, eventType, func){
	if(obj.addEventListener){
		obj.addEventListener(eventType, func, false);
	} else {
		obj.attachEvent("on"+eventType, func);
	}
}

function Com_GetEventObject(){
	if(window.event) {
 		return window.event;
	}
  	var func=Com_GetEventObject.caller;
    while(func!=null){
		var arg0=func.arguments[0];
		if(arg0){
			if(	(arg0.constructor == Event || arg0.constructor == MouseEvent || arg0.constructor == KeyboardEvent) 
				|| (typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)
				){
				return arg0;
			}
		}
		func=func.caller;
	}
	return null;
}

//功能：替换XML代码中的敏感字符
function Com_HtmlEscape(s){
	if(s==null || s=="")
		return "";
	var re = /&/g;
	s = s.replace(re, "&amp;");
	re = /\"/g;
	s = s.replace(re, "&quot;");
	re = /</g;
	s = s.replace(re, "&lt;");
	re = />/g;
	return s.replace(re, "&gt;");
}

//功能：获取两个坐标点的距离
function Com_GetDistance(x1, y1, x2, y2){
	var x = x1-x2;
	var y = y1-y2;
	return Math.sqrt(x*x+y*y);
}

//功能：计算中间点的位置
//参数：
//	points：线上的点坐标
//	mid：中间点离开始点距离占整条线段总距离的小数，0<=mid<1，如：0.5表示中间点在二分位上
//返回：从开始点到中间点的坐标数组
function Com_CalculateMiddlePoints(points, mid){
	var dsArr = new Array();	//每段线段的长度
	var ds = 0;					//总长度
	var i;
	for(i=0; i<points.length-1; i++){
		dsArr[i] = Com_GetDistance(points[i].x, points[i].y, points[i+1].x, points[i+1].y);
		ds += dsArr[i];
	}
	ds *= mid;					//中间点的长度
	var rtnVal = new Array();
	for(i=0; i<dsArr.length; i++){
		rtnVal[i] = points[i];
		if(dsArr[i]>ds){
			//中间点落在了该线段上，将文本信息的中间点和线段的中间点重合
			var p1 = points[i];
			var p2 = points[i+1];
			ds /= dsArr[i];
			rtnVal[rtnVal.length] = {x:Math.round(p1.x + (p2.x - p1.x)*ds), y:Math.round(p1.y + (p2.y - p1.y)*ds)};
			break;
		}
		ds -= dsArr[i];			//计算剩余长度
	}
	return rtnVal;
}

//功能：空函数，用于不需要处理事情的地方引用
function Com_EmptyFunction(){
}

//功能：获取URL中的参数
function Com_GetUrlParameter(param){
	var url = parent.location.href;
	var re = new RegExp();
	re.compile("[\\?&]"+param+"=([^&]*)", "i");
	var arr = re.exec(url);
	if(arr==null)
		return null;
	else
		return decodeURIComponent(arr[1]);
}

function Com_SaveData(dataString){
	if (window.clipboardData) {
		//var obj = document.getElementById("clipboardData");
		//obj.setAttribute("KMSS_ClipboardData", dataString);
		//obj.save("clipboardData");
		window.clipboardData.clearData();
		window.clipboardData.setData("Text", dataString);
	}else{
		$("#clipboardData").data('KMSS_ClipboardData', dataString);
	}
}

function Com_LoadData(){
	if (window.clipboardData) {
		//var obj = document.getElementById("clipboardData");
		//obj.load("clipboardData");
		//return obj.getAttribute("KMSS_ClipboardData");
		return window.clipboardData.getData("Text");
	}else{
		$("#clipboardData").data('KMSS_ClipboardData');
	}
}
//弹出对话框
function Com_PopupWindow(url,width,height,parameter){
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		var rtnVal=window.showModalDialog(url, parameter, winStyle);
		try {
			if(parameter.AfterShow)
				parameter.AfterShow(rtnVal);
		}catch(e){
			if(window.console){
				console.error(e);
			}
		}
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = parameter;
		var tmpwin=window.open(url, "_blank", winStyle);
		if(tmpwin){
			tmpwin.onbeforeunload=function(){
				if(parameter.AfterShow)
					parameter.AfterShow(tmpwin.returnValue);
			}
		}		
	}
}


//功能：更新window的状态栏信息
function FlowChart_RefreshWindowStatus(){
	if(DISPLAY_WINDOWSTATUS)
		window.status = FlowChartObject.Lang.EventCoordinate+"("+EVENT_X+", "+EVENT_Y+")  "+FlowChartObject.Lang.Zoom+FlowChartObject.Zoom+"%";
}

//重新设置父窗口Iframe的大小
function FlowChart_ResizeIframe(){
	if(document.body.scrollHeight<20){
		setTimeout("FlowChart_ResizeIframe();", 100);
		return;
	}
	parent.FULLSCREEN_IFRAME.style.height = (document.body.scrollHeight + 80) + "px";
}

//====================数据初始化====================
FlowChartObject.Initialize = function(){
	try{
		document.execCommand("BackgroundImageCache", false, true);
	}catch(e){}
	parent.document.getElementById("btnModify").innerHTML = FlowChartObject.Lang.Node.popedomModify;
	parent.document.getElementById("btnOk").value = FlowChartObject.Lang.OK;
	parent.document.getElementById("btnCancel").value = FlowChartObject.Lang.Cancel;
	//parent.document.getElementById("btnApprovalType").value = FlowChartObject.Lang.approvalType;
	//var deployApproval = Com_GetUrlParameter("deployApproval");
	//if(deployApproval == null || deployApproval == 'false'){
		//parent.document.getElementById("btnApprovalType").style.display = "none";
	//}
	//修改文档的属性
	document.body.style.cursor="default";
	document.body.background = "../images/bg"+GRID_SIZE+".gif";
	document.onselectstart = function(){return false;};
	document.onhelp = function(){FlowChart_Operation_ShowHelp();return false;};
	Com_AddEventListener(document, "mousedown", FlowChart_Event_OnMouseDown);
	Com_AddEventListener(document, "mouseup", FlowChart_Event_OnMouseUp);
	Com_AddEventListener(document, "mousemove", FlowChart_Event_OnMouseMove);
	Com_AddEventListener(document, "dblclick", FlowChart_Event_OnDblClick);
	Com_AddEventListener(document, "keydown", FlowChart_Event_OnKeyDown);
	Com_AddEventListener(document, "mousewheel", FlowChart_Event_OnMouseWheel);
	Com_AddEventListener(document, "DOMMouseScroll", FlowChart_Event_OnMouseWheel); // Firefox
	
	//初始化子组件
	for(var i=0; i<FlowChartObject.InitializeArray.length; i++) {
		FlowChartObject.InitializeArray[i].Initialize();
	}
	if(parent.FULLSCREEN_IFRAME!=null) {
		if(FlowChartObject.Resize) {
			FlowChartObject.Resize(FlowChartObject.IsEdit);
		}
		if(!FlowChartObject.IsEdit){
			FlowChart_ResizeIframe();
		}
	}
	var FormFieldList = Com_GetUrlParameter("FormFieldList");
	if(FormFieldList!=null)
		FormFieldList = parent.parent[FormFieldList];
	if(FormFieldList!=null)
		FlowChartObject.FormFieldList = FormFieldList;
};

// ================= 连线校验 ====================
FlowChartObject.Rule.InitializeFuns = [];
FlowChartObject.Rule.Initialize = function() {
	var funs = FlowChartObject.Rule.InitializeFuns;
	for (var i = 0; i < funs.length; i ++) {
		funs[i](FlowChartObject);
	}
};

// ================= 节点类型描述 (先兼容，后续需要修改) ===================
FlowChartObject.Nodes.nodeDesc = function(node) {
	return {
		isHandler: FlowChartObject.Nodes.isHandler(node), 
		isDraftNode: FlowChartObject.Nodes.isDraftNode(node),
		isSendNode: FlowChartObject.Nodes.isSendNode(node)
	};
};
FlowChartObject.Nodes.isHandler = function(node) {
	return node.Desc ? (
			node.Desc.isHandler(node.Data) && 
			!node.Desc.isAutomaticRun(node.Data) && 
			!node.Desc.isBranch(node.Data) && 
			!node.Desc.isSubProcess(node.Data) && 
			!node.Desc.isConcurrent(node.Data) &&
			node.Desc.uniqueMark(node.Data) == null
		) ||  node.Desc.uniqueMark(node.Data) == 'signNodeDesc' : false;
};
FlowChartObject.Nodes.isDraftNode = function(node) {
	return node.Desc ? (
			node.Desc.uniqueMark(node.Data) == 'draftNodeDesc'
		) : false;
};
FlowChartObject.Nodes.isSendNode = function(node) {
	return node.Desc ? (
			node.Desc.isHandler(node.Data) && 
			node.Desc.isAutomaticRun(node.Data) && 
			!node.Desc.isBranch(node.Data) && 
			!node.Desc.isSubProcess(node.Data) && 
			!node.Desc.isConcurrent(node.Data) &&
			node.Desc.uniqueMark(node.Data) == null
		) : false;
};

// ================= 国际化语言 ==================

FlowChartObject.Lang = {};
FlowChartObject.Lang.Locale = "zh_CN";
FlowChartObject.Lang._langBundles = [];
FlowChartObject.Lang.Include = function(bundle) {
	var bs = FlowChartObject.Lang._langBundles;
	for (var i = 0; i < bs.length; i ++) {
		if (bs[i] == bundle) {
			return;
		}
	}
	var url = Com_Parameter.ContextPath + "sys/lbpm/flowchart/js/lang.jsp?locale=" + encodeURIComponent(FlowChartObject.Lang.Locale) + "&bundle=" + bundle;
	if(Com_Parameter.Cache) {
		url += "&s_cache=" + Com_Parameter.Cache;
	}
	document.writeln("<script src='"+url+"'></script>");
	bs.push(bundle);
};
FlowChartObject.Lang.Register = function(key, value) {
	var spaces = key.split('.');
	var nowLevel = window;
	var last = spaces[spaces.length - 1];
	for (var i = 0; i < spaces.length - 1; i ++) {
		if (nowLevel[spaces[i]] == null) {
			nowLevel[spaces[i]] = {};
		}
		nowLevel = nowLevel[spaces[i]];
	}
	nowLevel[last] = value;
};
FlowChartObject.Lang.GetMessage = function(msg, param1, param2, param3){
	var re;
	if(param1!=null){
		re = /\{0\}/gi;
		msg = msg.replace(re, param1);
	}
	if(param2!=null){
		re = /\{1\}/gi;
		msg = msg.replace(re, param2);
	}
	if(param3!=null){
		re = /\{2\}/gi;
		msg = msg.replace(re, param3);
	}
	return msg;
}; 

//引入相关的js文件
Com_IncludeJsFile("../../../../resource/js/jquery.js", true);
Com_IncludeJsFile("menu.js");
Com_IncludeJsFile("component.js");
Com_IncludeJsFile("workflow.js");
Com_IncludeJsFile("locale.jsp");
Com_IncludeJsFile("operations.js");
Com_IncludeJsFile("infodialog.js");
Com_IncludeJsFile("plugin_loader.jsp?modelName="+MODEL_NAME+(Com_Parameter.Cache ? "&s_cache="+Com_Parameter.Cache : ""), true);
Com_IncludeJsFile(FlowChartObject.IsEdit?"edit.js":"view.js");
//Com_IncludeJsFile("record.js");
Com_IncludeJsFile(Com_GetUrlParameter("extend")+".js");
