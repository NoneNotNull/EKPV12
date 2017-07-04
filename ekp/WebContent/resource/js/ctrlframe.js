/*压缩类型：标准*/
/***********************************************
JS文件说明：
本JS文件中的函数不提供给普通模块调用。
该文件由主帧结构集调用，提供了帧结构的操作

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
Com_RegisterFile("ctrlframe.js");

//右边帧结构的大小映射表
var Frame_RightSizeMap = new Array();
Frame_RightSizeMap["0,0,*"] = -1;
Frame_RightSizeMap["0,8,*"] = -1;
Frame_RightSizeMap["*,8,*"] = 0;
Frame_RightSizeMap["*,8,0"] = 1;
Frame_RightSizeMap["*,0,0"] = 1;
Frame_RightSizeMap[-2] = "0,0,*";
Frame_RightSizeMap[-1] = "0,8,*";
Frame_RightSizeMap[0] = "*,8,*";
Frame_RightSizeMap[1] = "*,8,0";
Frame_RightSizeMap[2] = "*,0,0";

//帧结构集级别与帧结构名称的映射表
var Frame_WinLevelMap = new Array();
Frame_WinLevelMap["treeFrame"] = 1;
Frame_WinLevelMap["orgFrame"] = 2;
Frame_WinLevelMap["viewFrame"] = 3;
Frame_WinLevelMap["docFrame"] = 4;
Frame_WinLevelMap[1] = "treeFrame";
Frame_WinLevelMap[2] = "orgFrame";
Frame_WinLevelMap[3] = "viewFrame";
Frame_WinLevelMap[4] = "docFrame";

//全屏信息
var Frame_FullScreenInfo = new Object;
Frame_FullScreenInfo.IsFullScreen = false;

//自动隐藏监听器
var Frame_AutoHideListener = new Object;
Frame_AutoHideListener.TimeoutID = 0;
Frame_AutoHideListener.Active = false;

/***********************************************
功能：开始监听自动隐藏事件，由给目录树的JS调用
参数
	frameWin：需要监听的window对象
	isLocked：该帧是否锁定
***********************************************/
function Frame_FireHideEvent(frameWin, isLocked){
	var srcWinLv = Frame_GetWinLevel(frameWin);
	if(srcWinLv!=2)
		return;
	Frame_ClearHideEvent();
	if(!isLocked){
		var ctrlDoc = document.getElementsByName("ctrlFrame2")[0].contentWindow.document;
		Com_AddEventListener(ctrlDoc, "mouseover", Frame_DocutmetOnMouseOver);
		Com_AddEventListener(ctrlDoc, "mouseout", Frame_DocutmetOnMouseOut);
		Com_AddEventListener(frameWin.document, "mouseover", Frame_DocutmetOnMouseOver);
		Com_AddEventListener(frameWin.document, "mouseout", Frame_DocutmetOnMouseOut);
		Com_AddEventListener(frameWin, "unload", Frame_ClearHideEvent);
		Frame_AutoHideListener.Active = true;
	}
}

/***********************************************
功能：结束监听自动隐藏事件
***********************************************/
function Frame_ClearHideEvent(){
	clearTimeout(Frame_AutoHideListener.TimeoutID);
	Frame_AutoHideListener.Status = false;
	Frame_AutoHideListener.Size = 0;
	Frame_AutoHideListener.Active = false;
	var ctrlDoc = document.getElementsByName("ctrlFrame2")[0].contentWindow.document;
	Com_RemoveEventListener(ctrlDoc, "mouseover", Frame_DocutmetOnMouseOver);
	Com_RemoveEventListener(ctrlDoc, "mouseout", Frame_DocutmetOnMouseOut);
	var orgWin = document.getElementsByName("orgFrame")[0].contentWindow;
	Com_RemoveEventListener(orgWin.document, "mouseover", Frame_DocutmetOnMouseOver);
	Com_RemoveEventListener(orgWin.document, "mouseout", Frame_DocutmetOnMouseOut);
	Com_RemoveEventListener(orgWin, "unload", Frame_ClearHideEvent);
}

/***********************************************
功能：文档的OnMouseOver事件，用于判断是否触发隐藏动作
***********************************************/
function Frame_DocutmetOnMouseOver(){
	clearTimeout(Frame_AutoHideListener.TimeoutID);
	if(Frame_AutoHideListener.Status)
		Frame_AutoHideListener.TimeoutID = setTimeout("Frame_RunAutoHide(false);", 500);
}

/***********************************************
功能：文档的OnMouseOut事件，用于判断是否触发隐藏动作
***********************************************/
function Frame_DocutmetOnMouseOut(){
	clearTimeout(Frame_AutoHideListener.TimeoutID);
	if(!Frame_AutoHideListener.Status)
		Frame_AutoHideListener.TimeoutID = setTimeout("Frame_RunAutoHide(true);", 1000);
}

/***********************************************
功能：执行隐藏/显示动作
***********************************************/
function Frame_RunAutoHide(status){
	clearTimeout(Frame_AutoHideListener.TimeoutID);
	if(Frame_AutoHideListener.Status!=status)
		Frame_AutoHideListener.Size = Frame_SetLV2FrameSize(Frame_AutoHideListener.Size, true);
	Frame_AutoHideListener.Status = status;
}

/***********************************************
功能：执行右边帧的上下移动动作
***********************************************/
function Frame_MoveBy(frameWin, direct){
	var frame = Frame_GetFrame(frameWin);
	var frameset = frame.parentNode;

	var sizeList, curSize, i;
	if(frameset.rows==""){
		sizeList = frameset.cols.split(",");
		i = Frame_GetFrameIndex(frame) - 1;
		curSize = parseInt(sizeList[i]) + direct*180;
		if(curSize>360)
			return;
		sizeList[i] = curSize<0?0:curSize;
		frameset.cols = sizeList.join(",");
	}else{
		i = Frame_RightSizeMap[frameset.rows]+direct;
		if(Math.abs(i)>1)
			return;
		frameset.rows = Frame_RightSizeMap[i];
	}
}

/***********************************************
功能：根据帧的窗口对象获取帧对象
***********************************************/
function Frame_GetFrame(frameWin){
	var frameList = document.getElementsByTagName("frame");
	for(var i=1; i<frameList.length; i++)
		if(frameList[i].contentWindow==frameWin)
			return frameList[i];
}

/***********************************************
功能：获取帧在帧结构集中的索引号
***********************************************/
function Frame_GetFrameIndex(frame){
	var frameset = frame.parentNode;
	var i = -1;
	for(var frameElem=frameset.firstChild; frameElem!=null; frameElem=frameElem.nextSibling)
	{
		if(frameElem.tagName=="FRAME")
			i++;
		if(frameElem==frame)
			return i;
	}
}

/***********************************************
功能：根据帧的窗口获取窗口级别（1表示一级窗口）
***********************************************/
function Frame_GetWinLevel(frameWin){
	return Frame_WinLevelMap[Frame_GetFrame(frameWin).name];
}

/***********************************************
功能：设置二级窗口的大小
参数：
	size：窗口大小
	remainCtrl：是否保留控制帧
***********************************************/
function Frame_SetLV2FrameSize(size, remainCtrl){
	var frameset = document.getElementsByName("downFrameset")[0];
	var sizeList = frameset.cols.split(",");
	var orgSize = sizeList[2];
	sizeList[2] = size;
	if(!remainCtrl)
		sizeList[3] = size==0?0:8;
	frameset.cols = sizeList.join(",");
	return orgSize;
}

/***********************************************
功能：打开一个窗口，提供给Com_OpenWindow调用
***********************************************/
function Frame_OpenWindow(frameWin, url, target, winStyle){
	var srcWinLv = Frame_GetWinLevel(frameWin);
	if(target==null || target=="")
		target = srcWinLv==1?3:srcWinLv+1;
	else
		target = parseInt(target);
	if(target>3)
		return window.open(url, "_blank");
	var i;
	if(winStyle!="remain"){
		if(target==2)
			Frame_SetLV2FrameSize(180);
		else
			if(srcWinLv<2 || target<2)
				Frame_SetLV2FrameSize(0);
		if(target<4)
			i = 2;
		else{
			if(srcWinLv<3)
				i = -2;
			else{
				switch(winStyle){
					case "max":
						i = -1;
						break;
					case "mid":
						i = 0;
						break;
					case "min":
						i = 1;
						break;
					default:
						if(srcWinLv==4)
							i = null;
						else
							i = 0;
				}
			}
		}
		if(i!=null)
			document.getElementsByName("rightFrameset")[0].rows = Frame_RightSizeMap[i];
		i = Math.min(srcWinLv, target);
		for(i=i+1; i<5; i++)
			window.open("about:blank", Frame_WinLevelMap[i]);
	}
	return window.open(url, Frame_WinLevelMap[target]);
}

/***********************************************
功能：关闭窗口，提供给Com_CloseWindow调用
***********************************************/
function Frame_CloseWindow(frameWin){
	if(Frame_FullScreenInfo.IsFullScreen)
		Frame_SetFullScreen(frameWin);
	var srcWinLv = Frame_GetWinLevel(frameWin);
	if(srcWinLv==1)
		return;
	for(var i=srcWinLv; i<5; i++)
		window.open("about:blank", Frame_WinLevelMap[i]);
	switch(srcWinLv){
		case 2:
			Frame_SetLV2FrameSize(0);
		default:
			document.getElementsByName("rightFrameset")[0].rows = Frame_RightSizeMap[2];
	}
}

/***********************************************
功能：将窗口设置为全屏或取消全屏，提供给docutil调用。
***********************************************/
function Frame_SetFullScreen(frameWin){
	var srcWinLv = Frame_GetWinLevel(frameWin);
	if(srcWinLv<3)
		return;
	if(Frame_AutoHideListener.Active)
		Frame_RunAutoHide(true);
	if(Frame_FullScreenInfo.IsFullScreen){
		document.getElementsByName("mainFrameset")[0].rows = Frame_FullScreenInfo.mainFrameset;
		document.getElementsByName("downFrameset")[0].cols = Frame_FullScreenInfo.downFrameset;
		document.getElementsByName("rightFrameset")[0].rows = Frame_FullScreenInfo.rightFrameset;
	}else{
		Frame_FullScreenInfo.mainFrameset = document.getElementsByName("mainFrameset")[0].rows;
		Frame_FullScreenInfo.downFrameset = document.getElementsByName("downFrameset")[0].cols;
		Frame_FullScreenInfo.rightFrameset = document.getElementsByName("rightFrameset")[0].rows;
		document.getElementsByName("mainFrameset")[0].rows = "0,*";
		document.getElementsByName("downFrameset")[0].cols = "0,0,0,0,*";
		document.getElementsByName("rightFrameset")[0].rows = Frame_RightSizeMap[srcWinLv==3?2:-2];
	}
	Frame_FullScreenInfo.IsFullScreen = !Frame_FullScreenInfo.IsFullScreen;
	return Frame_FullScreenInfo.IsFullScreen;
}