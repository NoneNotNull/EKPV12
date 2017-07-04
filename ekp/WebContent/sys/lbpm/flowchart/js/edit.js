/**********************************************************
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
FlowChartObject.Mode.Initialize = function(){
	//普通模式
	var mode = new FlowChart_Mode("normal");
	mode.OnMouseDown = FlowChart_Mode_Normal_OnMouseDown;
	mode.OnMouseMove = FlowChart_Mode_Normal_OnMouseMove;
	mode.OnMouseUp = FlowChart_Mode_Normal_OnMouseUp;
	mode.OnDblClick = FlowChart_Mode_Normal_OnDblClick;
	mode.Clear = FlowChart_Mode_Normal_Clear;
	mode.GetDxDy = FlowChart_Mode_Normal_GetDxDy;
	mode.EventSrc = null;
	mode.EventX = 0;
	mode.EventY = 0;
	//EventChain是一个操作链对象，具有Start、Move、End、Cancel方法
	mode.EventChain = null;
	mode.UserDefaultCursor = true;
	FlowChartObject.Mode.Current = mode;
	
	//连线模式
	mode = new FlowChart_Mode("line");
	mode.OnMouseDown = FlowChart_Mode_Line_OnMouseDown;
	mode.OnMouseMove = FlowChart_Mode_Line_OnMouseMove;
	mode.OnMouseUp = FlowChart_Mode_Line_OnMouseUp;
	mode.Clear = FlowChart_Mode_Line_Clear;
	
	//节点模式
	mode = new FlowChart_Mode("node");
	mode.OnMouseDown = FlowChart_Mode_Node_OnMouseDown;
	mode.OnMouseMove = FlowChart_Mode_Node_OnMouseMove;
	mode.OnMouseUp = FlowChart_Mode_Node_OnMouseUp;
	mode.Clear = FlowChart_Mode_Node_Clear;
};


//====================模式通用====================
//功能：更新操作点的显示
FlowChartObject.Mode.RefreshOptPoint = function(){
	var line = (FlowChartObject.Currents.length==1 && FlowChartObject.Currents[0].Name=="Line")?FlowChartObject.Currents[0]:null;
	FlowChartObject.Points.CurrentLine = line;
	var linePoints = FlowChartObject.Points.LinePoint;
	var i;
	//隐藏操作点
	if(line==null){
		for(i=0; i<linePoints.length; i++)
			linePoints[i].Show(false);
		return;
	}
	//显示操作点
	for(i=0; i<line.Points.length; i++){
		if(linePoints[i]==null){
			linePoints[i] = new FlowChart_Point("line");
		}
		linePoints[i].MoveTo(line.Points[i].x, line.Points[i].y);
		linePoints[i].Show(true);
	}
	
	//隐藏多余的操作点
	for(; i<linePoints.length; i++)
		linePoints[i].Show(false);
};

//功能：搜索鼠标落在了哪个节点上面
function FlowChart_Mode_GetEventNodeObject(){
	var nodes = FlowChartObject.Nodes.all;
	for(var i=0; i<nodes.length; i++){
		var w = nodes[i].Width / 2;
		var h = nodes[i].Height / 2;
		if(nodes[i].Data.x - w < EVENT_X && EVENT_X < nodes[i].Data.x + w
			&& nodes[i].Data.y - h < EVENT_Y && EVENT_Y < nodes[i].Data.y + h){
			return nodes[i];
		}
	}
	return null;
}

//功能：判断(x2, y2)是否落在(x1, y1)和(x3, y3)之间（近似）
function FlowChart_Mode_IsThreePointsInOneLine(x1, y1, x2, y2, x3, y3){
	var d = Com_GetDistance(x1, y1, x3, y3) - Com_GetDistance(x1, y1, x2, y2) - Com_GetDistance(x2, y2, x3, y3);
	return Math.abs(d)<3;
}

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
			this.EventChain.Move(this);
		}else{
			if(Math.abs(this.EventX - EVENT_X) + Math.abs(this.EventY - EVENT_Y)>3){
				if(this.EventSrc==null){
					this.EventChain = FlowChartObject.SelectArea;
				}else if(this.EventSrc.Name=="Node"){
					this.EventChain = FlowChartObject.Nodes.EventChain;
				}else if(this.EventSrc.Name=="Point"){
					this.EventChain = FlowChartObject.Points.EventChain;
				}
				if(this.EventChain!=null){
					this.EventChain.Start(this);
					this.EventChain.Move(this);
				}
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
		FlowChartObject.Mode.RefreshOptPoint();
	}

	//记录事件信息
	this.EventSrc = null;
}

//节点移动事件链
FlowChartObject.Nodes.EventChain = new Object();

FlowChartObject.Nodes.EventChain.Start = function(mode){
	var e = Com_GetEventObject();
	if(e.ctrlKey)
		FlowChartObject.SelectElement(mode.EventSrc, false, true);
	else
		FlowChartObject.SelectElement(mode.EventSrc, !mode.EventSrc.IsSelected, true);
	FlowChartObject.Mode.RefreshOptPoint();
}

FlowChartObject.Nodes.EventChain.Move = function(mode){
	var d = mode.GetDxDy();
	FlowChartObject.MoveElement(d.dx, d.dy);
}

FlowChartObject.Nodes.EventChain.End = function(mode){
	var d = mode.GetDxDy();
	FlowChartObject.MoveElement(d.dx, d.dy, true);
}

FlowChartObject.Nodes.EventChain.Cancel = function(mode){
	FlowChartObject.Nodes.EventChain.End(mode);
}

//操作点移动事件链
FlowChartObject.Points.EventChain = new Object();

FlowChartObject.Points.EventChain.Start = function(mode){
	var obj = mode.EventSrc;
	var line = FlowChartObject.Points.CurrentLine;
	if(obj.index!=0 && obj.index!=line.Points.length-1)
		return;
	//非中间点，显示操作连线
	var optLine = FlowChartObject.Lines.OptLine;
	optLine.Points = new Array();
	for(var i=0; i<line.Points.length; i++)
		optLine.Points[i] = line.Points[i];
	optLine.Refresh(LINE_REFRESH_TYPE_DOM);
	optLine.Show(true);
}

FlowChartObject.Points.EventChain.Move = function(mode){
	var obj = mode.EventSrc;
	obj.MoveTo(EVENT_X, EVENT_Y);
	var line = FlowChartObject.Points.CurrentLine;
	if(obj.index!=0 && obj.index!=line.Points.length-1){
		//移动的是中间点
		line.Points[obj.index] = {x:EVENT_X, y:EVENT_Y};
		line.Refresh(LINE_REFRESH_TYPE_DOM);
		return;
	}
	//更新操作线
	var optLine = FlowChartObject.Lines.OptLine;
	optLine.Points[obj.index] = {x:EVENT_X, y:EVENT_Y};
	optLine.Refresh(LINE_REFRESH_TYPE_DOM);
	//判断是否可以连接到某个点上
	var node = FlowChart_Mode_GetEventNodeObject();
	var point = null;
	if(node!=null){
		if(obj.index==0){
			if(FlowChartObject.Rule.CheckLinkBetween(node, line.EndNode, line))
				point = node.GetClosestPoint();
		}else{
			if(FlowChartObject.Rule.CheckLinkBetween(line.StartNode, node, line))
				point = node.GetClosestPoint();
		}
	}
	//根据查找结果显示或隐藏可连接点
	if(point!=null){
		FlowChartObject.Points.NodePoint.MoveTo(point.x, point.y);
		FlowChartObject.Points.NodePoint.Show(true);
	}else{
		FlowChartObject.Points.NodePoint.Show(false);
	}
}

FlowChartObject.Points.EventChain.End = function(mode){
	var obj = mode.EventSrc;
	var line = FlowChartObject.Points.CurrentLine;
	if(obj.index!=0 && obj.index!=line.Points.length-1){
		//中间点，刷新线段的文本位置
		line.Points[obj.index] = {
				x:Math.round(EVENT_X/GRID_SIZE)*GRID_SIZE,
				y:Math.round(EVENT_Y/GRID_SIZE)*GRID_SIZE
			};
		line.Refresh();
		FlowChartObject.Mode.RefreshOptPoint();
		return;
	}
	//非中间点，查看是否可以连接到某个节点
	var node = FlowChart_Mode_GetEventNodeObject();
	var point = null;
	if(node!=null){
		if(obj.index==0){
			if(FlowChartObject.Rule.CheckLinkBetween(node, line.EndNode, line)){
				line.LinkNode(node, null, node.GetClosestPoint().position, null);
				line.Refresh();
			}
		}else{
			if(FlowChartObject.Rule.CheckLinkBetween(line.StartNode, node, line)){
				line.LinkNode(null, node, null, node.GetClosestPoint().position);
				line.Refresh();
			}
		}
	}
	
	//隐藏操作线和可连接点，刷新操作点
	FlowChartObject.Lines.OptLine.Show(false);
	FlowChartObject.Points.NodePoint.Show(false);
	FlowChartObject.Mode.RefreshOptPoint();
}

FlowChartObject.Points.EventChain.Cancel = function(mode){
	FlowChartObject.Points.EventChain.End(mode);
}

//功能：普通模式清除动作
function FlowChart_Mode_Normal_Clear(){
	FlowChartObject.SelectElement(null, true);
	FlowChartObject.Mode.RefreshOptPoint();
	FlowChartObject.Nodes.InfoBox.Hide();
	if(this.EventChain!=null){
		this.EventChain.Cancel(this);
		this.EventChain = null;
	}
}

//功能：普通模式鼠标双击事件
function FlowChart_Mode_Normal_OnDblClick(e){
	var obj = Com_GetEventSrcObject();
	if(obj==null || e.ctrlKey || FlowChartObject.Currents.length!=1)
		return;
	if(e.shiftKey){
		switch(obj.Name){
			case "Point":
				//Shift+双击操作点，删除该拐点
				var line = FlowChartObject.Currents[0];
				var points = line.Points;
				if(obj.index==0 || obj.index==points.length-1)
					return;
				line.Points = Com_ArrayRemoveElem(points, points[obj.index]);
				line.Refresh();
				FlowChartObject.Mode.RefreshOptPoint();
				return;
			case "Line":
				//Shift+双击，若双击到连线而不是连线的文本，添加拐点
				for(var eventSrc=e.srcElement || e.target; eventSrc.LKSObject==null;)
					 eventSrc=eventSrc.parentNode;
				if(obj.DOMText==eventSrc)
					return;
				var points = obj.Points;
				var newPoints = new Array(points[0]);
				for(var i=1; i<points.length-1; i++){
					//注意这里循环到points.length-1，是因为若节点不落在前面的线段上，肯定落在最后一条线段上
					var p0 = points[i-1];
					var p1 = points[i];
					if(FlowChart_Mode_IsThreePointsInOneLine(p0.x, p0.y, EVENT_X, EVENT_Y, p1.x, p1.y))
						break;
					newPoints[i] = p1;
				}
				//插入新的点
				newPoints[newPoints.length] = {x:EVENT_X, y:EVENT_Y};
				//插入后续的点
				for(;i<points.length; i++)
					newPoints[newPoints.length] = points[i];
				obj.Points = newPoints;
				obj.Refresh();
				FlowChartObject.Mode.RefreshOptPoint();
				return;
		}
	}else{
		if(obj.ShowAttribute)
			obj.ShowAttribute();
	}
}

//功能：普通模式获取相对位移
function FlowChart_Mode_Normal_GetDxDy(){
	var x = this.EventX;
	var y = this.EventY;
	this.EventX = EVENT_X;
	this.EventY = EVENT_Y;
	return {dx:this.EventX-x, dy:this.EventY-y};
}

//====================连线模式代码====================
//功能：连线模式鼠标点击
function FlowChart_Mode_Line_OnMouseDown(e){
	if(EVENT_MOUSE!=1)
		return;
	var node = FlowChart_Mode_GetEventNodeObject();
	if(this.CurrentNode==null){
		//没有当前节点，判断是否可以拉出连线
		if(node==null)
			return;
		if(!FlowChartObject.Rule.CheckLinkOut(node))
			return;
		//开始拉出临时连线
		var line = FlowChartObject.Lines.OptLine;
		line.Points = new Array();
		line.Points[0] = node.GetClosestPoint();
		line.Points[1] = {x:EVENT_X, y:EVENT_Y};
		line.Refresh(LINE_REFRESH_TYPE_DOM);
		line.Show(true);
		//记录操作信息
		this.CurrentNode = node;
	}else{
		if(node!=null)
			return;
		//添加连线点
		var line = FlowChartObject.Lines.OptLine;
		line.Points[line.Points.length-1] = {
				x:Math.round(EVENT_X/GRID_SIZE)*GRID_SIZE,
				y:Math.round(EVENT_Y/GRID_SIZE)*GRID_SIZE
			};
		line.Points[line.Points.length] = {x:EVENT_X, y:EVENT_Y};
		line.Refresh(LINE_REFRESH_TYPE_DOM);
	}
}

//功能：连线模式鼠标移动
function FlowChart_Mode_Line_OnMouseMove(e){
	if(EVENT_MOUSE>1)
		return;
	var node = FlowChart_Mode_GetEventNodeObject();
	//判断是否需要显示节点操作点
	var point = null;
	if(node!=null){
		if(this.CurrentNode==null){
			//没有开始节点，判断节点是否可以流出
			if(FlowChartObject.Rule.CheckLinkOut(node))
				point = node.GetClosestPoint();
		}else{
			//有开始节点，判断节点是否可以流入
			if(FlowChartObject.Rule.CheckLinkBetween(this.CurrentNode, node))
				point = node.GetClosestPoint();
		}
	}
	if(point!=null){
		FlowChartObject.Points.NodePoint.MoveTo(point.x, point.y);
		FlowChartObject.Points.NodePoint.Show(true);
	}else{
		FlowChartObject.Points.NodePoint.Show(false);
	}

	//若有开始节点，则移动连线
	if(this.CurrentNode!=null){
		var line = FlowChartObject.Lines.OptLine;
		line.Points[line.Points.length-1] = {x:EVENT_X, y:EVENT_Y};
		line.Refresh(LINE_REFRESH_TYPE_DOM);
	}
}

//功能：连线模式鼠标放开
function FlowChart_Mode_Line_OnMouseUp(e){
	if(EVENT_MOUSE==2){
		if(this.CurrentNode!=null){
			this.Clear();
		}else{
			FlowChartObject.Mode.Change("normal");
		}
		FlowChartObject.Operation.Menu.CancelShow = true;
		return;
	}
	if(EVENT_MOUSE!=1)
		return;
			
	var startNode = this.CurrentNode;
	if(startNode==null)
		return;
	var node = FlowChart_Mode_GetEventNodeObject();
	if(node==null || !FlowChartObject.Rule.CheckLinkBetween(startNode, node))
		return;
	//创建新连线
	var points = FlowChartObject.Lines.OptLine.Points;
	var newLine = new FlowChart_Line();
	//注意到points[0]是在鼠标点击事件中通过node.GetClosestPoint()获取，所以可以获取position
	newLine.LinkNode(startNode, node, points[0].position, node.GetClosestPoint().position, points);
	newLine.Refresh(LINE_REFRESH_TYPE_DOM);
	//动作结束
	this.Clear();
}

//功能：清除连线模式动作
function FlowChart_Mode_Line_Clear(){
	FlowChartObject.Lines.OptLine.Show(false);
	FlowChartObject.Points.NodePoint.Show(false);
	this.CurrentNode = null;
}

//====================节点模式====================
//功能：节点模式鼠标点击事件
function FlowChart_Mode_Node_OnMouseDown(e){
	if(EVENT_MOUSE!=1)
		return;
	FlowChartObject.Nodes.Types[FlowChartObject.Mode.Current.Name].CreateNode();
	this.Clear();
}

//功能：节点模式鼠标移动事件
function FlowChart_Mode_Node_OnMouseMove(e){
	if(EVENT_MOUSE>1)
		return;
	var line = FlowChart_Mode_Node_GetEventLineObject();
	if(line==null){
		this.Clear();
	}else{
		if(this.CurrentLine!=null && this.CurrentLine!=line)
			this.CurrentLine.Select(false);
		this.CurrentLine = line;
		line.Select(true);
	}
}

//功能：节点模式鼠标放开
function FlowChart_Mode_Node_OnMouseUp(e){
	if(EVENT_MOUSE!=1 || !e.shiftKey){
		FlowChartObject.Mode.Change("normal");
		FlowChartObject.Operation.Menu.CancelShow = true;
	}
}

//功能：节点模式清除节点模式动作
function FlowChart_Mode_Node_Clear(){
	if(this.CurrentLine!=null){
		this.CurrentLine.Select(false);
		this.CurrentLine = null;
	}
}

//功能：获取当前可以插入节点的连线
function FlowChart_Mode_Node_GetEventLineObject(){
	var line = Com_GetEventSrcObject();
	if(line==null || line.Name!="Line")
		return null;
	//检查流出情况
	if(!FlowChartObject.Rule.CheckLinkOut(line.StartNode, FlowChartObject.Mode.Current.Name, line))
		return null;
	//检查流入情况
	if(!FlowChartObject.Rule.CheckLinkIn(FlowChartObject.Mode.Current.Name, line.EndNode, line))
		return null;
	return line;
}


//功能：移动选中的元素移动dx,dy个像素
//参数：toGrid：true=吸附到网格线 false=不吸附到网格线，默认
FlowChartObject.MoveElement = function(dx, dy, toGrid){
	var i, obj;
	var lineRefreshType = LINE_REFRESH_TYPE_DOM;
	if(toGrid){
		//若吸附到网格，计算实际的移动像素
		lineRefreshType = LINE_REFRESH_TYPE_ALL;
		for(i=0; i<FlowChartObject.Currents.length; i++){
			obj = FlowChartObject.Currents[i];
			if(obj.Name=="Node"){
				dx = Math.round((obj.Data.x+dx)/GRID_SIZE)*GRID_SIZE-obj.Data.x;
				dy = Math.round((obj.Data.y+dy)/GRID_SIZE)*GRID_SIZE-obj.Data.y;
				break;
			}
		}
	}
	//移动元素
	for(i=0; i<FlowChartObject.Currents.length; i++){
		obj = FlowChartObject.Currents[i];
		if(obj.Name=="Node"){
			obj.MoveBy(dx, dy, toGrid);
		}else{
			//连线移动的条件是开始节点和结束节点都被选中
			if(Com_ArrayGetIndex(FlowChartObject.Currents, obj.StartNode)>-1 &&
				Com_ArrayGetIndex(FlowChartObject.Currents, obj.EndNode)>-1){
				obj.MoveBy(dx, dy, lineRefreshType);
			}
		}
	}
};

