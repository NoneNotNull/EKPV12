/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件实现了界面中滚动操作栏的功能。
本JS中的函数不提供给普通模块调用。

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
/***********************************************
滚动操作栏的应用说明：
	若要使用滚动操作栏的功能，请在页面中定义一个ID为"optBarDiv"的Div标签，并将需要出现在操作栏中的按钮放在该标签中。
***********************************************/
Com_RegisterFile("optbar.js");
Com_IncludeFile("optbar.css", "style/"+Com_Parameter.Style+"/optbar/");

var OptBar_BarList = new Array("optBarDiv");
var OptBar_ButtonList;
var OptBar_WindowList = new Array();
OptBar_WindowList[0] = window;
var OptBar_IncludeChildWindow = false;

/***********************************************
功能：获取操作条整体的HTML代码
说明：当需要实现多界面风格的时候，可以改写该函数。
参数：
	btnHTML：按钮部分的HTML代码
***********************************************/

if(window.OptBar_GetOuterHTML==null)
	OptBar_GetOuterHTML = function (btnHTML){
		//document.body.style.marginTop="32"; 
		if(document.getElementById("optBarMarginTop") == null){
			var elem = document.createElement("div"); 
			elem.setAttribute("id", "optBarMarginTop");
			elem.style.height = "32px";
			document.body.insertBefore(elem, document.body.firstChild);
		}
		var filePath = Com_Parameter.StylePath+"optbar/";
		var htmlCode = "<table class='optOuterContainerTab' cellspacing='0' border='0' cellpadding='0'>";
		htmlCode += "<tr><td class='optContainerTd'>";
		htmlCode += btnHTML;
		htmlCode += "</td></tr></table>";
		return htmlCode;
	};

/***********************************************
功能：获取操作条按钮部分的HTML代码
说明：当需要实现多界面风格的时候，可以改写该函数。
参数：
	OptBar_ButtonList：表格中INPUT对象列表
***********************************************/
if(window.OptBar_GetInnerHTML==null)
	OptBar_GetInnerHTML = function (){
		var filePath = Com_Parameter.StylePath+"optbar/";
		var htmlCode = "<table class='optInnerContainerTab' cellspacing='0' border='0' cellpadding='0'><tr>";
		for(var i=0; i<OptBar_ButtonList.length; i++){
			htmlCode += "<td class='innerTdBtn1'></td>";
			htmlCode += "<td class='innerTdBtn2'>";
			htmlCode += "<a href=\"javascript:void OptBar_ButtonList["+i+"].click();\" title=\""+OptBar_ButtonList[i].title+"\"><nobr>";
			htmlCode += OptBar_ButtonList[i].value+"</nobr></a></td>";
			htmlCode += "<td class='innerTdBtn3'></td>";
			htmlCode += "<td class='innerTdSpace'></td>";
		}
		htmlCode += "<td class='innerTdRight'></td></tr></table>";
		return htmlCode;
	};

/***********************************************
功能：画滚动操作条，该函数在界面onload事件中触发
***********************************************/
function OptBar_Draw(){
	try{
		if(parent.OptBar_IncludeChildWindow){
			parent.OptBar_AddWindow(window);
			Com_AddEventListener(window, "unload", function(){
				try{
					parent.OptBar_RemoveWindow(window);
				}catch(e){}
			});
			return;
		}
	}catch(e){}
	OptBar_Refresh(true);
}

function OptBar_AddWindow(win){
	for(var i=0; i<OptBar_WindowList.length; i++){
		if(OptBar_WindowList[i]==win){
			return;
		}
	}
	OptBar_WindowList[OptBar_WindowList.length] = win;
	OptBar_Refresh(true);
}

function OptBar_RemoveWindow(win){
	var winList = new Array();
	for(var i=0; i<OptBar_WindowList.length; i++){
		if(OptBar_WindowList[i]==win){
			continue;
		}
		winList[winList.length] = OptBar_WindowList[i];
	}
	OptBar_WindowList = winList;
	OptBar_Refresh(true);
}

/***********************************************
功能：更新滚动条
************************************************/
function OptBar_Refresh(refreshButtonList){
	if(refreshButtonList) OptBar_RefreshButtonList();
	var newElem = document.getElementById("S_OperationBar");
	if(OptBar_ButtonList.length==0){
		if(newElem!=null){
			newElem.style.display = "none";
		}
	}else{
		if(newElem==null){
			newElem = document.createElement("div");
			newElem.id = "S_OperationBar";
			document.body.appendChild(newElem);
			var tmpObj=document.getElementsByName("S_OperationBar");
			if(tmpObj.length>0)//若为IE兼容模式，ie兼容模式getElementsByName和getElementById可以混用
				setInterval("OptBar_ResetBarPosition()", 100);
		}else{
			newElem.style.display = "block";
		}
		newElem.innerHTML = OptBar_GetOuterHTML(OptBar_GetInnerHTML());
	}
}

/***********************************************
功能：重置滚动条的位置
***********************************************/
function OptBar_ResetBarPosition(){
	try{
		var optBar=document.getElementById("S_OperationBar");
		optBar.style.top=document.body.scrollTop;
	}catch(e){}
}

function OptBar_AddOptBar(barId){
	var lastBarId = OptBar_BarList[OptBar_BarList.length-1];
	OptBar_BarList[OptBar_BarList.length-1] = barId;
	OptBar_BarList[OptBar_BarList.length] = lastBarId;
}

function OptBar_RefreshButtonList(){
	OptBar_ButtonList = new Array();
	var btnObj;
	for(var w=0; w<OptBar_WindowList.length; w++){
		for(var i=0; i<OptBar_WindowList[w].OptBar_BarList.length; i++){
			btnObj = OptBar_WindowList[w].document.getElementById(OptBar_BarList[i]);
			if(btnObj==null)
				continue;
			btnObj.style.display = "none";
			btnObj = btnObj.getElementsByTagName("INPUT");
			for(var j=0; j<btnObj.length; j++){
				if(btnObj[j].style.display=="none")
					continue;
				switch(btnObj[j].type){
				case "button":
				case "submit":
				case "reset":
					break;
				default:
					continue;
				}
				OptBar_ButtonList[OptBar_ButtonList.length] = btnObj[j];
			}
		}
	}
}

Com_AddEventListener(window, "load", OptBar_Draw);

function getCookie()   
{   
	var arr,reg=new RegExp("(^| )isopen=([^;]*)(;|$)");   
	if(arr=document.cookie.match(reg)) return unescape(arr[2]);   
	else return null;   
}
function OptBar_LoadDataInit(){
	var mark=getCookie();
	if(mark=='open'){
		Com_IncludeFile("datainit.js");
	}
}
OptBar_LoadDataInit();