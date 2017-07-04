/**********************************************************
功能：流程图阅读状态的JS定义
使用：
	由panel.js在阅读状态下引入
必须实现的方法：
	FlowChartObject.Mode.Initialize（模式初始化）
	FlowChartObject.Operation.Initialize（操作初始化）
作者：叶中奇
创建时间：2008-05-05
修改记录：
**********************************************************/
//====================必须实现的方法====================
//功能：模式初始化
FlowChartObject.Mode.Initialize = function(){
	//普通模式
	var mode = new FlowChart_Mode("normal");
	mode.OnMouseDown = FlowChart_Mode_Normal_OnMouseDown;
	mode.OnMouseMove = FlowChart_Mode_Normal_OnMouseMove;
	mode.OnMouseUp = FlowChart_Mode_Normal_OnMouseUp;
	mode.OnDblClick = FlowChart_Mode_Normal_OnDblClick;
	mode.Clear = FlowChart_Mode_Normal_Clear;
	mode.EventSrc = null;
	mode.EventX = 0;
	mode.EventY = 0;
	//EventChain是一个操作链对象，具有Start、Move、End、Cancel方法
	mode.EventChain = null;
	mode.UserDefaultCursor = true;
	FlowChartObject.Mode.Current = mode;
	
	
	//播放模式
	mode = new FlowChart_Mode("play");
	mode.Initialize = FlowChart_Mode_Play_Initialize;
	mode.OnMouseUp = FlowChart_Mode_Play_OnMouseUp;
	mode.Clear = FlowChart_Mode_Play_Clear;
	mode.HideLines = FlowChart_Mode_Play_HideLines;
	mode.PlayLines = new Array();		//播放连线对象
	mode.HistoryIndex = -1;				//当前播放到历史信息的第几步
	mode.StatusData = null;				//状态数据
	mode.CurStepNode = null;			//当前步骤的节点信息
	mode.NxtStepInfo = null;			//下一步的信息
	mode.IntervalTime = 100;			//播放每个动作的间隔时间
	mode.LinePlayCount = 10;			//播放线段时分解为多少个动作
	mode.NodePlayCount = 5;				//播放节点时分解为多少个动作
	mode.CalculateStepInfo = FlowChart_Mode_Play_CalculateStepInfo;
	mode.UserDefaultCursor = true;
};


//====================普通模式方法====================
//功能：普通模式鼠标点下事件
function FlowChart_Mode_Normal_OnMouseDown(e){
	FlowChartObject.Nodes.InfoBox.Hide();
	if(EVENT_MOUSE!=1)
		return;
	this.EventSrc = Com_GetEventSrcObject();
	if(this.EventSrc!=null && this.EventSrc.Name=="Node"){
		this.EventSrc.ShowDetail(true);
	}
	this.EventX = EVENT_X;
	this.EventY = EVENT_Y;
}

//功能：普通模式鼠标移动事件
function FlowChart_Mode_Normal_OnMouseMove(e){
	//操作对象不为空，鼠标不是按住左键，说明鼠标已经移出屏幕，然后再移进，处理收尾动作
	if(this.EventChain!=null && EVENT_MOUSE!=1){
		this.EventChain.Cancel(this);
		this.EventChain = null;
		return;
	}
	if(EVENT_MOUSE==0){
		//普通移动模式，看是否需要显示节点信息
		var obj = Com_GetEventSrcObject();
		if(obj==null || obj.Name!="Node")
			FlowChartObject.Nodes.InfoBox.Hide();
		else
			obj.ShowDetail(true);
		return;
	}else if(EVENT_MOUSE==1){
		if(this.EventChain!=null){
			//this.EventChain.Start(this);
			this.EventChain.Move(this);
		}else{
			if(Math.abs(this.EventX - EVENT_X) + Math.abs(this.EventY - EVENT_Y)>3){
				this.EventChain = FlowChartObject.SelectArea;
				this.EventChain.Start(this);
				this.EventChain.Move(this);
			}
		}
	}
}

//功能：普通模式鼠标放开事件
function FlowChart_Mode_Normal_OnMouseUp(e){
	if(this.EventChain!=null){
		this.EventChain.End(this);
		this.EventChain = null;
	} else if(this.EventSrc!=null && (this.EventSrc.Name=="Node" || this.EventSrc.Name=="Line") &&
		this.EventSrc==Com_GetEventSrcObject()){
		//选择流程元素
		if(e.ctrlKey)
			FlowChartObject.SelectElement(this.EventSrc, false, null);
		else
			FlowChartObject.SelectElement(this.EventSrc, true, true);
	}
	this.EventSrc = null;
}

//功能：普通模式鼠标双击事件
function FlowChart_Mode_Normal_OnDblClick(e){
	var obj = Com_GetEventSrcObject();
	var event = e || window.event;
	if(obj==null || event.ctrlKey || event.shiftKey || FlowChartObject.Currents.length!=1)
		return;
	for (var i = 0; i < FlowChartObject.Mode.OnDblClickListeners.length; i ++) {
		if (FlowChartObject.Mode.OnDblClickListeners[i](obj, event, "normal") == true) {
			return;
		}
	}
	if(obj.ShowAttribute)
		obj.ShowAttribute();
}

//功能：普通模式清除动作
function FlowChart_Mode_Normal_Clear(e){
	FlowChartObject.SelectElement(null, true);
	FlowChartObject.Nodes.InfoBox.Hide();
	FlowChartObject.SelectArea.Cancel();
}

//====================播放模式方法====================
//功能：播放模式初始化
function FlowChart_Mode_Play_Initialize(){
	this.StatusData = FlowChartObject.StatusData;
	//初始化所有节点和连线的状态
	FlowChart_Mode_Play_ClearStatus();
	//初始化过程变量
	var startNode = FlowChartObject.Nodes.GetNodeById(this.StatusData.historyNodes[0].id);
	startNode.SetStatus(FlowChartObject.STATUS_RUNNING);
	this.HistoryIndex = -1;
	this.CalculateStepInfo();
	//开始执行播放动作
	this.IntervalId = setInterval("FlowChart_Mode_Play_NextStep();", this.IntervalTime);
}

//功能：获取下一步骤节点的信息
function FlowChart_Mode_Play_CalculateStepInfo(){
	//初始化下一步动作
	this.CurStepNode = null;
	this.NxtStepInfo = new Array();
	this.NxtStepInfo.nodePlayCount = 0;
	this.NxtStepInfo.linePlayCount = 0;
	//计算下一个可播放的节点
	var index = this.HistoryIndex + 1;
	var node = null;
	if(index<this.StatusData.historyNodes.length){
		for(; index<this.StatusData.historyNodes.length; index++){
			node = FlowChartObject.Nodes.GetNodeById(this.StatusData.historyNodes[index].id);
			if(node!=null){
				break;
			}
		}
	}
	//无下一个播放节点，结束
	if(node==null){
		return;
	}
	//计算播放数据
	this.CurStepNode = node;
	this.HistoryIndex = index;
	var hisInfo = this.StatusData.historyNodes[index];
	if(hisInfo.targetId==null || hisInfo.targetId==""){
		return;
	}
	var nxtIds = hisInfo.targetId.split(";");
	for(var i=0; i<nxtIds.length; i++){
		var tagNode = FlowChartObject.Nodes.GetNodeById(nxtIds[i]);
		if(tagNode==null){
			continue;
		}
		var stepInfo = new Object();
		stepInfo.node = tagNode;
		if(hisInfo.routeType=="NORMAL"){
			for(var j=0; j<node.LineOut.length; j++){
				if(node.LineOut[j].EndNode==tagNode){
					stepInfo.line = node.LineOut[j];
					stepInfo.points = node.LineOut[j].Points;
					break;
				}
			}
		}
		if(stepInfo.line==null){
			stepInfo.points = new Array(
					{x:node.Data.x, y:node.Data.y},
					{x:tagNode.Data.x, y:tagNode.Data.y});
		}
		this.NxtStepInfo[this.NxtStepInfo.length] = stepInfo;
	}
}

//功能：播放下一步动作
function FlowChart_Mode_Play_NextStep(){
	var mode = FlowChartObject.Mode.Current;
	if(mode.NxtStepInfo.linePlayCount==0){
		//开始播放连线
		mode.HideLines();
		mode.CurStepNode.SetStatus(FlowChartObject.STATUS_RUNNING);
		for(var i=0; i<mode.NxtStepInfo.length; i++){
			var points = mode.NxtStepInfo[i].points;
			if(points==null){
				continue;
			}
			var line = mode.PlayLines[i];
			if(line==null){
				line = new FlowChart_Line(null, "play", 3);
				mode.PlayLines[i] = line;
				line.Select(true);
			}else{
				line.Show(true);
			}
			line.Points = new Array(points[0], points[0]);
			line.Refresh(FlowChartObject.LINE_REFRESH_TYPE_DOM);
		}
		mode.NxtStepInfo.linePlayCount++;
		return;
	}
	if(mode.NxtStepInfo.linePlayCount<=mode.LinePlayCount){
		//连线播放进行中
		for(var i=0; i<mode.NxtStepInfo.length; i++){
			if(mode.NxtStepInfo[i].points==null){
				continue;
			}
			var line = mode.PlayLines[i];
			if(mode.NxtStepInfo.linePlayCount==mode.LinePlayCount){
				line.Points = mode.NxtStepInfo[i].points;
			}else{
				line.Points = Com_CalculateMiddlePoints(mode.NxtStepInfo[i].points, mode.NxtStepInfo.linePlayCount*1.0/mode.LinePlayCount);
			}
			line.Refresh(FlowChartObject.LINE_REFRESH_TYPE_DOM);
		}
		mode.NxtStepInfo.linePlayCount++;
		return;
	}
	if(mode.NxtStepInfo.nodePlayCount==0){
		//开始改变节点显示
		mode.CurStepNode.SetStatus(FlowChartObject.STATUS_PASSED);
		for(var i=0; i<mode.NxtStepInfo.length; i++){
			mode.NxtStepInfo[i].node.SetStatus(FlowChartObject.STATUS_RUNNING);
			if(mode.NxtStepInfo[i].line!=null){
				mode.NxtStepInfo[i].line.SetStatus(FlowChartObject.STATUS_PASSED);
			}
		}
		mode.NxtStepInfo.nodePlayCount++;
		return;
	}
	if(mode.NxtStepInfo.nodePlayCount<=mode.NodePlayCount){
		//节点显示停滞
		mode.NxtStepInfo.nodePlayCount++;
		return;
	}
	//进入下一个步播放
	mode.CalculateStepInfo();
	if(mode.CurStepNode==null){
		//播放完毕
		FlowChartObject.Mode.Change("normal");
	}
}

//功能：播放模式鼠标放开
function FlowChart_Mode_Play_OnMouseUp(){
	if(EVENT_MOUSE!=1){
		//右键切换模式
		FlowChartObject.Mode.Change("normal");
		FlowChartObject.Operation.Menu.CancelShow = true;
		return;
	}
}

//功能：播放模式结束
function FlowChart_Mode_Play_Clear(){
	if(this.StatusData==null)
		return;
	this.HideLines();
	clearInterval(this.IntervalId);
	FlowChart_Mode_Play_ClearStatus();
	FlowChartObject.LoadStatusByXML();
}

//功能：清除当前显示状态
function FlowChart_Mode_Play_ClearStatus(){
	for(var i=0; i<FlowChartObject.Nodes.all.length; i++)
		FlowChartObject.Nodes.all[i].SetStatus(FlowChartObject.STATUS_NORMAL);
	for(var i=0; i<FlowChartObject.Lines.all.length; i++)
		FlowChartObject.Lines.all[i].SetStatus(FlowChartObject.STATUS_NORMAL);
}

//功能：隐藏播放中的连线
function FlowChart_Mode_Play_HideLines(){
	for(var i=0; i<this.PlayLines.length; i++){
		if(this.PlayLines[i]!=null){
			this.PlayLines[i].Show(false);
		}
	}
}
