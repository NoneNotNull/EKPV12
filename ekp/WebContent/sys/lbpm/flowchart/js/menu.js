/**********************************************************
功能：右键菜单对象的定义
样例：请参考panel.js
作者：叶中奇
创建时间：2008-05-05
修改记录：
**********************************************************/

var RightButtonMenuObject = null;
//=====================右键菜单=======================
/**********************************************************
功能：菜单对象
参数：
	ParentMenu
		菜单项对象（父级菜单项）
**********************************************************/
function RightButtonMenu(ParentMenu){
	//==========属性==========
	this.Left = 0;								//横坐标
	this.Top = 0;								//纵坐标
	this.Items = new Array;						//菜单项
	this.CurItem = null;						//当前扩展的子菜单项
	this.Parent = ParentMenu;					//父级菜单，null则表示该菜单是一级菜单
	this.CancelShow = false;					//暂时取消菜单显示
	
	//==========方法==========
	this.Show = RightButtonMenu_Show;			//显示菜单
	this.Hide = RightButtonMenu_Hide;			//隐藏菜单
	this.AddLine = RightButtonMenu_AddLine;		//添加分隔线
	this.AddItem = RightButtonMenu_AddItem;		//增加命令菜单项
	this.AddMenu = RightButtonMenu_AddMenu;		//增加子菜单项
	
	//==========初始化==========
	var newElem = document.createElement("table");
	newElem.className = "rightmenu_main";
	newElem.style.position = "absolute";
	newElem.style.display = "none";
	document.body.appendChild(newElem);
	this.DOMElement = newElem;
	newElem.LKSMenuObject = this;
	//newElem.onclick = RightButtonMenu_Item_OnClick;
	if(this.Parent==null){
		RightButtonMenuObject = this;
		//若为一级菜单，则添加文档事件
		document.oncontextmenu = function(e) {RightButtonMenuObject.Show(e);return false;};
		document.onclick = function(e) {RightButtonMenuObject.Hide(e);};
		document.onkeydown = function(e) {RightButtonMenuObject.Hide(e);};
	}
}

/**********************************************************
功能：菜单项对象
参数：
	Parent：所在的菜单对象
	itemType：菜单类型，可为以下值
		"cmd"：命令菜单项
		"submenu"：扩展菜单项
		"line"：菜单项的线
	根据itemType，可扩充第三和第四个参数
		cmd类型
			第三个参数：操作对象，类型为FlowChart_Operation（panel.js）
			第四个参数：热键名
		submenu类型
			第三个参数：显示文本
			第四个参数：显示标题
		line类型
			无扩展参数
扩展参数：
	根据不同的类型有不同的参数
返回：菜单项对象
**********************************************************/
function RightButtonMenu_Item(Parent, itemType){
	//==========属性==========
	this.Parent = Parent;			//所在菜单
	this.Text = null;				//文本
	this.Title = null;				//标题
	this.Enabled = true;			//是否可用
	this.Selected = false;			//是否选中
	this.Type = itemType;			//菜单类型
	this.Menu = (itemType=="submenu")?new RightButtonMenu(this):null;	//子菜单，Type="submenu"时生效
	this.Operation = null;			//操作，命令菜单生效
	this.HotkeyName = null;			//热键，命令菜单生效
	
	
	//==========方法==========
	this.SetDefaultCSS = RightButtonMenu_Item_SetCSS;						//重置菜单项的CSS
	this.SetSelected = RightButtonMenu_Item_SetSelected;					//设置菜单项是否被选中
	this.SetEnabled = RightButtonMenu_Item_SetEnabled;						//设置菜单项是否可用
	
	//==========初始化==========
	var tdObj = Parent.DOMElement.insertRow(-1).insertCell(-1);
	this.DOMElement = tdObj;
	tdObj.LKSMenuObject = this;
	tdObj.noWrap = true;
	switch(itemType){
		case "cmd":			//命令菜单
			this.Operation = arguments[2];
			this.HotkeyName = arguments[3];
			this.Text = this.Operation.Text;
			this.Title = this.Operation.Title;
			tdObj.title = this.Operation.Title==null?"":this.Operation.Title;
			var htmlCode = "<table border=0 cellpadding=0 cellspacing=0 width=100% height=100%><tr>";
			htmlCode += "<td width=10px class=rightmenu_check></td><td nowrap>"+this.Operation.Text+"</td><td style='text-align:right' nowrap>"+(this.HotkeyName==null?"":this.HotkeyName)+"</td><td width=10px></td></tr></table>";
			tdObj.innerHTML = htmlCode;
			tdObj.onmouseout = RightButtonMenu_Item_OnMouseout;
			tdObj.onmouseover = RightButtonMenu_Item_OnMouseover;
		break;
		
		case "submenu":		//扩展菜单
			this.Text = arguments[2];
			this.Title = arguments[3];
			tdObj.title = this.Title==null?"":this.Title;
			var htmlCode = "<table border=0 cellpadding=0 cellspacing=0 width=100% height=100%><tr>";
			htmlCode += "<td width=10px></td><td nowrap>"+this.Text+"</td><td style='text-align:right' width=10>»</td></tr></table>";
			tdObj.innerHTML = htmlCode;
			tdObj.onmouseover = RightButtonMenu_Item_OnMouseover;
		break;
		
		case "line":		//直线
			tdObj.className = "rightmenu_line";
		break;
	}
	tdObj.onclick = RightButtonMenu_Item_OnClick;
	tdObj.onmousedown = RightButtonMenu_OtherEvent;
	tdObj.onmouseup = RightButtonMenu_OtherEvent;
}

//====================菜单函数====================
//增加菜单分隔线
function RightButtonMenu_AddLine(){
	var rtnObj = new RightButtonMenu_Item(this, "line");
	this.Items[this.Items.length] = rtnObj;
	return rtnObj;
}
//增加操作菜单项
function RightButtonMenu_AddItem(operation, hotkeyName){
	var rtnObj = new RightButtonMenu_Item(this, "cmd", operation, hotkeyName);
	this.Items[this.Items.length] = rtnObj;
	return rtnObj;
}
//增加子菜单项
function RightButtonMenu_AddMenu(text, title){
	var rtnObj = new RightButtonMenu_Item(this, "submenu", text, title);
	this.Items[this.Items.length] = rtnObj;
	return rtnObj;
}

//显示菜单
function RightButtonMenu_Show(e){
	var event = e || window.event;
	if(this.CancelShow){
		this.CancelShow = false;
		return;
	}
	//隐藏子菜单
	if(this.CurItem!=null)
		this.CurItem.Menu.Hide();
	this.DOMElement.style.display = "";

	if(window.EVENT_X!=null){
		var xx = EVENT_X;
		var yy = EVENT_Y;
	}else{
		var xx = event.clientX;
		var yy = event.clientY;
	}
	
	//获取显示位置，同时判断显示的位置是否超出页面范围，若超出则修改显示位置
	if(this.Parent==null){
		//若该菜单为一级菜单，则显示在鼠标旁边
		this.Left = xx;
		if(xx+this.DOMElement.clientWidth>document.body.clientWidth)
			this.Left = xx-this.DOMElement.clientWidth;
		this.Top = yy;
		if(yy+this.DOMElement.clientHeight>document.body.clientHeight)
			this.Top = yy-this.DOMElement.clientHeight;
	}else{
		//若该菜单为子菜单，则显示在父菜单项旁边
		var p = this.Parent.Parent;
		this.Left = p.Left + p.DOMElement.clientWidth;
		if(this.Left+this.DOMElement.clientWidth>document.body.clientWidth)
			this.Left = p.Left-p.DOMElement.clientWidth-2;
		this.Top = yy-6;
		if(this.Top+this.DOMElement.clientHeight>document.body.clientHeight)
			this.Top = this.Top - this.DOMElement.clientHeight+25;
		p.CurItem = this.Parent;
		this.Parent.SetDefaultCSS();
	}
	this.DOMElement.style.left = this.Left + "px";
	this.DOMElement.style.top = this.Top + "px";
	
	//显示前，重置菜单项的可用属性
	for(var i=0; i<this.Items.length; i++)
		if(this.Items[i].Type!="line")
			this.Items[i].SetEnabled();
}

//隐藏菜单，同时隐藏子菜单
function RightButtonMenu_Hide(e){
	if(this.CurItem!=null)
		this.CurItem.Menu.Hide(e);
	if(this.Parent!=null){
		this.Parent.Parent.CurItem = null;
		this.Parent.SetDefaultCSS();
	}
	this.DOMElement.style.display = "none";
}

//====================菜单项函数====================

//重置菜单项的CSS
function RightButtonMenu_Item_SetCSS(){
	this.DOMElement.className = this.Type=="line"?"rightmenu_line":(this.Enabled?"rightmenu_nor":"rightmenu_dis");
}

//设置菜单项是否被选中，不传参数则取相反值
function RightButtonMenu_Item_SetSelected(selected){
	this.Selected = selected==null?!this.Selected:selected;
	this.DOMElement.firstChild.rows[0].cells[0].innerHTML = this.Selected?"√":"";
}

//设置菜单项是否可用，不传参数则根据设置函数重新获取（若没有设置函数则取原值）
function RightButtonMenu_Item_SetEnabled(enabled){
	if(enabled==null){
		if(this.Type=="cmd" && this.Operation.Check!=null)
			this.Enabled = this.Operation.Check(this.Operation.Argument);
	}else{
		this.Enabled = enabled;
	}
	this.SetDefaultCSS();
}

//HTML的onclick事件，禁止事件冒泡
function RightButtonMenu_Item_OnClick(e){
	var event = e || window.event;
	for(var obj=event.srcElement||event.target; obj!=null; obj=obj.parentNode){
		if(obj.LKSMenuObject!=null){
			obj = obj.LKSMenuObject;
			break;
		}
	}
	if(obj!=null && obj.Enabled && obj.Type=="cmd"){
		//若当前菜单项可用并且定义了点击操作函数，则执行点击操作，并隐藏当前菜单
		for(var p=obj; p.Parent!=null; p=p.Parent);		//p为当前菜单项所在的一级菜单
		p.Hide();
		obj.Operation.Run(obj.Operation.Argument);
	}
	if(window.event) {
		window.event.cancelBubble = true;
	} else {
		event.stopPropagation();
	}
}

//HTML的onmouseout事件，设置显示样式
function RightButtonMenu_Item_OnMouseout(e){
	this.LKSMenuObject.SetDefaultCSS();
}

//HTML的onmouseover事件
function RightButtonMenu_Item_OnMouseover(e){
	var obj = this.LKSMenuObject;
	if(obj.Enabled){
		//仅在当前项可用时生效
		if(obj.Parent.CurItem!=obj){
			//若展开的菜单项不是当前菜单项，则隐藏原展开的菜单项
			if(obj.Parent.CurItem!=null)
				obj.Parent.CurItem.Menu.Hide(e);
			//若当前项有子菜单，展现子菜单
			if(obj.Menu!=null)
				obj.Menu.Show(e);
		}
		this.className = "rightmenu_sel";
	}
}

function RightButtonMenu_OtherEvent(e){
	if(window.event) {
		window.event.cancelBubble = true;
	} else {
		e.stopPropagation();
	}
}