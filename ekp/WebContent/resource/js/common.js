/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件是系统中最基础的JS文件，所有页面必须首先载入该文件。
该文件提供了一些常用的方法，并提供了跨浏览器的JS替代方案。

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/

Com_RegisterFile("common.js");
/***********************************************
功能：引入JS文件
参数
	fileList：文件名列表，用|分隔多值
	contextPath：文件路径，默认值为"js/"
	extendName：文件扩展名，默认从文件名中获取
***********************************************/
function Com_IncludeFile(fileList, contextPath, extendName, isOuter){
	var i, j, fileType;
	contextPath = contextPath || "js/";
	isOuter = isOuter || false;
	var topList = ["jquery.js"];
	function isInTopList(f) {
		for (var i = 0; i < topList.length; i ++) {
			if (f.indexOf(topList[i]) > -1) {
				return true;
			}
		}
		return false;
	}
	
	fileList = fileList.split("|");
	var outFiles = [];
	for(i=0; i<fileList.length; i++){
		fileList[i] = contextPath + fileList[i];
		if(Com_ArrayGetIndex(Com_Parameter.JsFileList, fileList[i])==-1){
			Com_Parameter.JsFileList[Com_Parameter.JsFileList.length] = fileList[i];
			if(extendName==null){
				j = fileList[i].lastIndexOf(".");
				if(j>-1)
					fileType = fileList[i].substring(j+1);
				else
					fileType = "js";
			}else{
				fileType = extendName;
			}
			//缓存处理
			//debugger;
			if(fileList[i].indexOf('s_cache=')<0){
				if(fileList[i].indexOf("?")>=0){
					fileList[i] = fileList[i] + "&s_cache=" + Com_Parameter.Cache;
				}else{
					fileList[i] = fileList[i] + "?s_cache=" + Com_Parameter.Cache;
				}
			}
			switch(fileType){				  
				case "js":
				case "jsp":
					if(isOuter){
						outFiles.push("<script src="+fileList[i]+"></script>");
					}else{
						if (isInTopList(fileList[i])) {
							outFiles.unshift("<script src="+Com_Parameter.ResPath+fileList[i]+"></script>");
						} else {
							outFiles.push("<script src="+Com_Parameter.ResPath+fileList[i]+"></script>");
						}
					}
					break;
				case "css":
					if(isOuter){
						outFiles.push("<link rel=stylesheet href="+fileList[i]+">");
					}else{
						outFiles.push("<link rel=stylesheet href="+Com_Parameter.ResPath+fileList[i]+">");
					}
			}
		}
	}
	document.writeln(outFiles.join("\r\n"));
}

/***********************************************
功能：新建文档函数
参数：
	modelName：模板域模型
	strUrl:必选，创建的url，其中id参数用参数!{id},显示名参数用!{name}
***********************************************/
function Com_NewFile(modelName,strUrl){
	if(modelName==null || strUrl==null) return;
	var href = location.href;	
	var method = Com_GetUrlParameter(href,"method");
	if(Com_GetUrlParameter(href,"method")=="add"){
		var i=strUrl.indexOf("?");
		if(i>0) strUrl = strUrl.substring(i);
		var paraList = strUrl.split("&");
		var hasValue = false;
		for(i=0;i<paraList.length;i++){
			var j=paraList[i].indexOf("=");
			if(j<0) continue;
			if(paraList[i].indexOf("=!{")>0){
				var paramName = paraList[i].substring(0,j);
				var paramValue = Com_GetUrlParameter(href,paramName);
				if(paramValue!=null && paramValue!="") {
					hasValue = true;
					break;
				}
			}
		}
		if(!hasValue) {
			var strUrl = Dialog_Template(modelName,strUrl,false,true);
			if(strUrl==null) {Com_Parameter.CloseInfo=null;Com_CloseWindow();}
			else window.open(strUrl,"_self");
				
		}		
	}else if(method.indexOf("list")>0){
		Dialog_Template(modelName,strUrl);
	}
}

/***********************************************
功能：新建文档函数，选择简单分类
参数：
	modelName：分类域模型
	strUrl:必选，创建的url，其中id参数用参数!{id},显示名参数用!{name}
add by wubing date:2009-07-30
***********************************************/
function Com_NewFileFromSimpleCateory(modelName,strUrl){
	if(modelName==null || strUrl==null) return;
	var href = location.href;	
	var method = Com_GetUrlParameter(href,"method");
	if(Com_GetUrlParameter(href,"method")=="add"){
		var i=strUrl.indexOf("?");
		if(i>0) strUrl = strUrl.substring(i);
		var paraList = strUrl.split("&");
		var hasValue = false;
		for(i=0;i<paraList.length;i++){
			var j=paraList[i].indexOf("=");
			if(j<0) continue;
			if(paraList[i].indexOf("=!{")>0){
				var paramName = paraList[i].substring(0,j);
				var paramValue = Com_GetUrlParameter(href,paramName);
				if(paramValue!=null && paramValue!="") {
					hasValue = true;
					break;
				}
			}
		}
		if(!hasValue) {
			var strUrl = Dialog_SimpleCategoryForNewFile(modelName,strUrl,false,true);
			if(strUrl==null) {Com_Parameter.CloseInfo=null;Com_CloseWindow();}
			else window.open(strUrl,"_self");
				
		}		
	}else if(method.indexOf("list")>0){
		Dialog_SimpleCategoryForNewFile(modelName,strUrl);
	}
}

/***********************************************
功能：注册js文件
参数：
	fileName：文件名
***********************************************/
function Com_RegisterFile(fileName){
	fileName = "js/" + fileName;
	if(Com_ArrayGetIndex(Com_Parameter.JsFileList, fileName)==-1)
		Com_Parameter.JsFileList[Com_Parameter.JsFileList.length] = fileName;
}

/***********************************************
功能：获取数组中指定关键字的位置
参数：
	arr：数组
	key：关键字
返回：关键字所在的位置，找不到则返回-1
***********************************************/
function Com_ArrayGetIndex(arr, key){
	for(var i=0; i<arr.length; i++)
		if(arr[i]==key)
			return i;
	return -1;
}

/***********************************************
功能：关闭窗口
***********************************************/
function Com_CloseWindow() {
	if (Com_Parameter.CloseInfo != null) {
		if (typeof(seajs) != 'undefined') {
			seajs.use('lui/dialog', function(dialog) {
						dialog.confirm(Com_Parameter.CloseInfo,
								function(value) {
									if (value) {
										____Com_CloseWindow();
									} else
										return;
								});
					});
		} else {
			if (!confirm(Com_Parameter.CloseInfo))
				return;
			____Com_CloseWindow();
		}
	} else {
		____Com_CloseWindow();
	}
}

function ____Com_CloseWindow() {
	// 遍历所有父窗口判断是否存在$dialog
	var parent = window;
	while (parent) {
		if (typeof(parent.$dialog) != 'undefined') {
			parent.$dialog.hide();
			return;
		}
		if (parent == parent.parent)
			break;
		parent = parent.parent;
	}

	try {
		var win = window;
		for (var frameWin = win.parent; frameWin != null && frameWin != win; frameWin = win.parent) {
			if (frameWin["Frame_CloseWindow"] != null) {
				frameWin["Frame_CloseWindow"](win);
				return;
			}
			win = frameWin;
		}
	} catch (e) {
	}
	try {

		top.opener = top;
		top.open("", "_self");
		top.close();
	} catch (e) {
	}
}

/***********************************************
功能：设置窗口的标题
参数：
	Title：标题文本
***********************************************/
function Com_SetWindowTitle(Title){
	try{
		document.title = Title;
	}catch(err){
	}
}

Com_Parameter.IE = (typeof window.ActiveXObject!="undefined");		//全局变量，判断当前浏览器是否为IE浏览器

/***********************************************
功能：往某个对象中添加一个事件
参数：
	obj：对象，如：window、document等
	eventType：事件名称，不以on开始，比如："load"、"mouseover"
	func：需要执行的函数
***********************************************/
function Com_AddEventListener(obj, eventType, func){
	if(Com_Parameter.IE)
		obj.attachEvent("on"+eventType, func);
	else
		obj.addEventListener(eventType, func, false);
}

/***********************************************
功能：往某个对象中删除一个事件
参数：
	obj：对象，如：window、document等
	eventType：事件名称，不以on开始，比如："load"、"mouseover"
	func：已经添加的函数
***********************************************/
function Com_RemoveEventListener(obj, eventType, func){
	if(Com_Parameter.IE)
		obj.detachEvent("on"+eventType, func);
	else
		obj.removeEventListener(eventType, func, false);
}

/***********************************************
功能：打开一个新窗口
参数：
	url：窗口路径，若Com_Parameter.IsAutoTransferPara设置为True，则自动往URL中添加当前窗口的参数
	target：
		null/""：在下一个帧中打开，若在第一帧调用则打开第三帧页面
		1/2/3/4：在指定的帧打开（见首页界面说明）
		string：目标帧名称
	winStyle：
		当在首页帧结构集中打开，仅当打开第4帧时该参数有效，其值可为：
			"max"：新开窗口最大化
			"mid"：新开窗口跟视图窗口各分一半的空间
			"min"：新开窗口最小化
		若不是在首页真结构集打开时，跟window.open的参数一样
	keepUrl:
		是否保留原有url，默认值为false（不保留）
返回：新窗口对象
***********************************************/
function Com_OpenWindow(url, target, winStyle, keepUrl){
	if(!keepUrl){
		if(Com_Parameter.IsAutoTransferPara)
			url = Com_CopyParameter(url, new Array("forward", "s_path"));
		if(!(url.indexOf("https://")==0 || url.indexOf("http://")==0)){
			url = Com_SetUrlParameter(url, "s_css", Com_Parameter.Style);
		}
	}
	var eventObj = Com_GetEventObject();
	if(eventObj!=null && eventObj.shiftKey==true){
		target = "_blank";
		document.selection.empty();
	}
	if(target=="1" || target=="2" || target=="3" || target=="4")
		target = parseInt(target);
	if(target==null || target=="" || target==1 || target==2 || target==3 || target==4){
		var win = Com_RunMainFrameFunc("Frame_OpenWindow", url, target, winStyle);
		if(win==null) {
			target = Com_GetUrlParameter(location.href, "s_target");
			if(target==null)
				target = "_blank";
			win = window.open(url, target);
		}
		return win;
	}else{
		if(winStyle==null || winStyle=="")
			return window.open(url, target);
		else
			return window.open(url, target, winStyle);
	}
}

/***********************************************
功能：拷贝当前URL的参数拷贝到指定的URL中
参数：
	url：目标URL
返回：拷贝后的新的URL
***********************************************/
function Com_CopyParameter(url, except){
	if(location.search=="")
		return url;
	var paraList = location.search.substring(1).split("&");
	var i, j, k, para, value;
	copyParameterOutLoop:
	for(i=0; i<paraList.length; i++){
		j = paraList[i].indexOf("=");
		if(j==-1)
			continue;
		para = paraList[i].substring(0, j);
		if(except!=null){
			if(except[0]!=null){
				for(k=0; k<except.length; k++)
					if(para==except[k])
						continue copyParameterOutLoop;
			}else if(para==except){
				continue;
			}
		}
		value = Com_GetUrlParameter(url, para);
		if(value==null)
			url = Com_SetUrlParameter(url, para, decodeURIComponent(paraList[i].substring(j+1)));
	}
	return url;
}

/***********************************************
功能：提交表单，并保持提交后的URL参数不进行改变
参数：
	formObj：表单对象
	method：提交方法
***********************************************/
function Com_Submit(formObj, method, clearParameter){
	if (Com_Submit.ajaxBeforeSubmit) {
		Com_Submit.ajaxBeforeSubmit(formObj);
	}
	if (!bCancel){
		if(formObj.onsubmit!=null && !formObj.onsubmit()){
			if (Com_Submit.ajaxCancelSubmit) {
				Com_Submit.ajaxCancelSubmit(formObj);
			}
			return false;
		}
		//提交表单校验
		for(var i=0; i<Com_Parameter.event["submit"].length; i++){
			if(!Com_Parameter.event["submit"][i]()){
				if (Com_Submit.ajaxCancelSubmit) {
					Com_Submit.ajaxCancelSubmit(formObj);
				}
				return false;
			}
		}
		//提交表单消息确认
		for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
			if(!Com_Parameter.event["confirm"][i]()){
				if (Com_Submit.ajaxCancelSubmit) {
					Com_Submit.ajaxCancelSubmit(formObj);
				}
				return false;
			}
		}

	}
	var i;
	var url = Com_CopyParameter(formObj.action);
	if(clearParameter!=null){
		clearParameter = clearParameter.split(":");
		for(i=0; i<clearParameter.length; i++)
			url = Com_SetUrlParameter(url, clearParameter[i], null);
	}
	if(method!=null)
		url = Com_SetUrlParameter(url, "method", method);
	var seq = parseInt(Com_GetUrlParameter(url, "s_seq"));
	seq = isNaN(seq)?1:seq+1;
	url = Com_SetUrlParameter(url, "s_seq", seq);
	formObj.action = url;
	if (Com_Submit.ajaxSubmit) {
		Com_Submit.ajaxSubmit(formObj);
		if (Com_Submit.ajaxAfterSubmit) {
			Com_Submit.ajaxAfterSubmit(formObj);
		}
	} else {
		Com_DisableFormOpts();
		formObj.submit();
	}
	return true;
}

function Com_DisableFormOpts(){
	var btns = document.getElementsByTagName("INPUT");
	for(i=0; i<btns.length; i++)
		if(btns[i].type=="button" || btns[i].type=="image")
			btns[i].disabled = true;
	btns = document.getElementsByTagName("A");
	for(i=0; i<btns.length; i++){
		btns[i].disabled = true;
		btns[i].removeAttribute("href");
		btns[i].onclick = null;
		for (var j=0; j<btns[i].childNodes.length; j++){
			if(btns[i].childNodes[j].nodeType == 1) {
				btns[i].childNodes[j].disabled = true;
			}
		}
	}
	if(window.LUI){
		window.LUI.fire({'type':'topic','name':'btn_disabled','data':true} , window );
	}
	
}

/***********************************************
功能：提交表单，并保持提交后的URL参数不进行改变,所有按钮不变灰
参数：
	formObj：表单对象
	method：提交方法
***********************************************/
function Com_SubmitNoEnabled(formObj, method){
	if (!bCancel){
		if(formObj.onsubmit!=null && !formObj.onsubmit()){
			return false;
		}
		//提交表单校验
		for(var i=0; i<Com_Parameter.event["submit"].length; i++){
			if(!Com_Parameter.event["submit"][i]()){
				return false;
			}
		}
		//提交表单消息确认
		for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
			if(!Com_Parameter.event["confirm"][i]()){
				return false;
			}
		}
	}
	var url = Com_CopyParameter(formObj.action);
	if(method!=null)
		url = Com_SetUrlParameter(url, "method", method);
	var seq = parseInt(Com_GetUrlParameter(url, "s_seq"));
	seq = isNaN(seq)?1:seq+1;
	url = Com_SetUrlParameter(url, "s_seq", seq);
	formObj.action = url;
	formObj.submit();
	return true;
}

/***********************************************
功能：获取URL中的参数（调用该函数不需要考虑编码的问题）
参数：
	url：URL
	param：参数名
返回：参数值
***********************************************/
function Com_GetUrlParameter(url, param){
	var re = new RegExp();
	re.compile("[\\?&]"+param+"=([^&]*)", "i");
	var arr = re.exec(url);
	if(arr==null)
		return null;
	else
		return decodeURIComponent(arr[1]);
}

/***********************************************
功能：设置URL参数，若参数不存在则添加一个，否则覆盖原有参数
参数：
	url：URL
	param：参数名
	value：参数值
返回：URL
***********************************************/
function Com_SetUrlParameter(url, param, value){
	var re = new RegExp();
	re.compile("([\\?&]"+param+"=)[^&]*", "i");
	if(value==null){
		if(re.test(url)){
			url = url.replace(re, "");
		}
	}else{
		value = encodeURIComponent(value);
		if(re.test(url)){
			url = url.replace(re, "$1"+value);
		}else{
			url += (url.indexOf("?")==-1?"?":"&") + param + "=" + value;
		}
	}
	if(url.charAt(url.length-1)=="?")
		url = url.substring(0, url.length-1);
	return url;
}
/********************************************
 功能：获取当前DNS
 ********************************************/
function Com_GetCurDnsHost(){
	var host = location.protocol.toLowerCase()+"//" + location.hostname;
	if(location.port!='' && location.port!='80'){
		host = host+ ":" + location.port;
	}
	return host;
}
/***********************************************
功能：替换HTML代码中的敏感字符
***********************************************/
function Com_HtmlEscape(s){
	if(s==null || s=="")
		return "";
	var re = /&/g;
	s = s.replace(re, "&amp;");
	re = /\"/g;
	s = s.replace(re, "&quot;");
	re = /'/g;
	s = s.replace(re, '&#39;');
	re = /</g;
	s = s.replace(re, "&lt;");
	re = />/g;
	return s.replace(re, "&gt;");
}

function Com_Trim(s){
	return s.replace(/(^\s*)|(\s*$)/g, "");
}

function Com_GetCurrentStyle(obj,property){
	if(Com_Parameter.IE){
		return obj.currentStyle[property];
	}else{
		return window.getComputedStyle(obj,null).getPropertyValue(property);
	}
}

/***********************************************
功能：获取Event对象，必须在事件触发中调用
返回：Event对象
***********************************************/
function Com_GetEventObject(){
	if(Com_Parameter.IE) 
 		return window.event;
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

/***********************************************
功能：设置对象的OuterHTML
参数：
	obj：对象
	htmlCode：html代码
返回：html代码
***********************************************/
function Com_SetOuterHTML(obj, htmlCode){
	if(Com_Parameter.IE){
		obj.outerHTML = htmlCode;
	}else{
		if(htmlCode==""){
			try{
				obj.parentNode.removeChild(obj);
			}catch(e){}
		}else{
			var r = obj.ownerDocument.createRange();
			r.setStartBefore(obj);
			var df = r.createContextualFragment(htmlCode);
			obj.parentNode.replaceChild(df, obj);
		}
	}
	return htmlCode;
}

/***********************************************
功能：设置对象的innerText
参数：
	obj：对象
	text：显示文字
***********************************************/
function Com_SetInnerText(obj, text){
	if("textContent" in obj)
		obj.textContent = text;
	else
		obj.innerText = text;
}

/***********************************************
功能：将某个对象中的属性值替换字符串中的“!{属性名}”变量
注意：若对象中没有该属性，此方法会自动认为该属性为""
参数：
	str：原字符串
	obj：查找属性值的对象
返回：替换后的字符串
***********************************************/
function Com_ReplaceParameter(str, obj){
	var re = new RegExp("!\\{([^\(\)]+?)\\}");
	for(var arr=re.exec(str); arr!=null; arr=re.exec(str)){
		var value = eval("obj."+arr[1]);
		str = RegExp.leftContext+(value==null?"":encodeURIComponent(value))+RegExp.rightContext;
	}
	return str;
}

/***********************************************
功能：禁止当前事件的默认行为
***********************************************/
function Com_EventPreventDefault(){
	var eventObj = Com_GetEventObject();
	if(eventObj!=null){
		if(Com_Parameter.IE)
			eventObj.returnValue = false;
		else
			eventObj.preventDefault();
	}
}

/***********************************************
功能：禁止当前事件的冒泡行为
***********************************************/
function Com_EventStopPropagation(){
	var eventObj = Com_GetEventObject();
	if(eventObj!=null){
		if(Com_Parameter.IE)
			eventObj.cancelBubble = true;
		else
			eventObj.stopPropagation(); 
	}
}

//=============================以下函数为内部函数，普通模块请勿调用==============================

/***********************************************
功能：运行主帧的一个函数
参数：
	funcName：函数名（字符串）
	arg1、arg2、arg3、arg4：参数
返回：函数的返回值
***********************************************/
function Com_RunMainFrameFunc(funcName, arg1, arg2, arg3, arg4){
	try{
		var win = window;
		for(var frameWin = win.parent; frameWin!=null && frameWin!=win; frameWin=win.parent){
			if(frameWin[funcName]!=null)
				return frameWin[funcName](win, arg1, arg2, arg3, arg4);
			win = frameWin;
		}
	}catch(e){}
	return null;
}

var bCancel = false; 
Com_Parameter.event = new Array;
Com_Parameter.event["submit"] = new Array;
Com_Parameter.event["confirm"] = new Array;

Com_Parameter.Loaded = false;
Com_AddEventListener(window, "load", function(){
	Com_Parameter.Loaded = true;
});

function Com_FireLKSEvent(eventName, parameter){
	eventName = "LKS_"+eventName;
	if(Com_Parameter.event[eventName]!=null){
		for(var i=0; i<Com_Parameter.event[eventName].length; i++)
			Com_Parameter.event[eventName][i](parameter);
	}
}

function Com_AttachLKSEvent(eventName, func){
	eventName = "LKS_"+eventName;
	if(Com_Parameter.event[eventName]==null)
		Com_Parameter.event[eventName] = new Array;
	Com_Parameter.event[eventName][Com_Parameter.event[eventName].length] = func;
}

Com_AddEventListener(document, "keydown", function(){
	var eventObj = Com_GetEventObject();
	if(eventObj.keyCode==8){
		var eleObj = eventObj.srcElement || eventObj.target;
		var tagName = eleObj.tagName;
		switch(tagName){
		case "INPUT":
		case "TEXTAREA":
			if (eleObj.readOnly) //防止历史返回
				return false;
			break;
		default:
			return false;
		}
	}
	return true;
});
if(Com_Parameter.IE && !window.__Com_WinOpenFunc){
	var __Com_CookieInfo = function(path){
		if(path=='about:blank'){
			return '';
		}
		var index = path.indexOf("?");
		if(index>-1){
			path = path.substring(0, index);
		}
		index = path.indexOf("://");
		if(index>-1){
			path = path.substring(index+3);
			index = path.indexOf("/");
			if(index>-1){
				path = path.substring(index);
			}else{
				return '';
			}
		}
		var domain = location.hostname;
		index = domain.indexOf('.');
		if(index>-1){
			domain = '; domain=' + domain.substring(index+1);
		}else{
			domain = '';
		}
		return domain + ';path='+path;
	};
	document.cookie = 'docReferer=; expires=Fri, 31 Dec 1999 23:59:59 GMT;' + __Com_CookieInfo(location.href);
	var __Com_WinOpenFunc = window.open;
	window.open = function(){
		var cookieInfo = __Com_CookieInfo(arguments[0]);
		if(cookieInfo!=''){
			document.cookie = 'docReferer=' + encodeURIComponent(location.href)
				+ ';expires=' + (new Date(new Date().getTime()+5000).toGMTString())
				+ cookieInfo;
		}
		if(__Com_WinOpenFunc.apply){
			return __Com_WinOpenFunc.apply(window, arguments);
		}else{
			switch(arguments.length){
			case 0:
				return null;
			case 1:
				return __Com_WinOpenFunc(arguments[0]);
			case 2:
				return __Com_WinOpenFunc(arguments[0],arguments[1]);
			default:
				return __Com_WinOpenFunc(arguments[0],arguments[1],arguments[2]);
			}
		}
	};
}

//=============================以上函数为内部函数，普通模块请勿调用==============================