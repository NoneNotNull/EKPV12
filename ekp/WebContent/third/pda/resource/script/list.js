/*压缩类型：标准*/
/*******************************************************************************
 * JS文件说明： 该文件用于视图数据显示
 * 全局变量说明：
 * S_CurrentLabelId			当前显示label的id
 * S_CurPageInfo			当前页信息
 * S_RowSize				每页大小设置
 * S_LabelMap				页签信息map
 ******************************************************************************/
document.writeln("<script src='"+Com_Parameter.ResPath+"js/json2.js'></script>");
document.writeln("<script src='"+Com_Parameter.ContextPath+"third/pda/resource/script/map.js'></script>");

var http_request     = null;
if(window.S_RowSize == null){
	S_RowSize = 6;
}
/*******************************
 * 增加label信息
 ******************************/
function addLabelInfo(id,dataUrl,createUrl){
	if(window.S_LabelMap == null){
		window.S_LabelMap = new Map();
	}
	var LabelObj = new Object();
	LabelObj.labelId = id;
	LabelObj.dataUrl = dataUrl;
	LabelObj.createUrl = createUrl;
	window.S_LabelMap.put(id,LabelObj);
}
/******************************
*跳转至某页
*******************************/
function gotoPage(flag){
	var page=window.S_CurPageInfo;
	var requestPageno=0;
	if(flag=="first")
		requestPageno = 1;
	else if(flag=="prev")
		requestPageno = parseInt(page.pageno)-1;
	else if(flag=="next")
		requestPageno = parseInt(page.pageno)+1;
	else if(flag=="last")
		requestPageno = page.pageCount;
	_iniListPage(false);
	_requestJsonContent(window.S_CurrentLabelId,requestPageno);
}
/******************************
*label显示逻辑,超出屏幕的label将隐藏
*滑动或点击才正式展开
*******************************/
function showLabel(labelId){
	var labelWidth=72;
	window.S_LabelWidth = labelWidth;
	var ulObj = document.getElementById("lab_group");
	if(ulObj==null)
		return;
	var banner=document.getElementById("div_banner");
	var liArr = ulObj.getElementsByTagName("div");
	var labWidth=(liArr.length * labelWidth+(liArr.length-1)*2)+20;
	var width = banner.offsetWidth;
	if(width==null || width==0)
		width=banner.clientWidth?banner.clientWidth:width;
	var startIndex=0;
	var endIndex=liArr.length-1;
	if(labWidth > width){
		var limit=parseInt((width-20)/labelWidth);
		var labToal=liArr.length;
		window.S_LabLimit=limit;
		if(limit>=labToal){
			startIndex=0;
			endIndex=labToal-1;
		}else{
			var currentIndex=0;
			for(var i=0;i<labToal;i++){
				var id=liArr[i].getAttribute("id");
				if(id==("li_"+labelId)){
					currentIndex=i;
					break;
				}
			}
			var rightDiv=document.getElementById("div_LabExpandRight");
			var leftDiv=document.getElementById("div_LabExpandLeft");
			var pageInt=parseInt((currentIndex)/limit);
			startIndex=limit*pageInt;
			endIndex=(pageInt+1)*limit-1;
			if((labToal-1)<=endIndex){
				endIndex=labToal-1;
				rightDiv.style.display="none";
			}else{
				rightDiv.style.display="block";
			}
			window.S_LabRightIndex=endIndex;
			if(startIndex>0){
				leftDiv.style.display="block";
			}else{
				leftDiv.style.display="none";
			}
			var labelDivVar=document.getElementById("div_labelArea");
			Com_AddEventListener(labelDivVar,"touchstart",_touchstart);
			Com_AddEventListener(labelDivVar,"touchmove",_touchmove);
			Com_AddEventListener(labelDivVar,"touchend",_touchend);
		}
	}
	_resetStyle(ulObj,liArr,startIndex,endIndex);
}

function labTurnToRight(){
	var ulObj = document.getElementById("lab_group");
	var rightDiv=document.getElementById("div_LabExpandRight");
	var leftDiv=document.getElementById("div_LabExpandLeft");
	if(ulObj!=null){
		var labels = ulObj.getElementsByTagName("div");
		if(window.S_LabRightIndex<labels.length-1){
			var startIndex=window.S_LabRightIndex+1;
			for(var i=0;i<labels.length;i++){
				if(i<=window.S_LabRightIndex){
					labels[i].style.display="none";
				}else if(i<=window.S_LabRightIndex+window.S_LabLimit){
					labels[i].style.display="block";
				}else{
					labels[i].style.display="none";
				}
			}
			if(window.S_LabRightIndex+window.S_LabLimit+1>labels.length)
				window.S_LabRightIndex=i-1;
			else
				window.S_LabRightIndex=window.S_LabRightIndex + window.S_LabLimit;
			var endIndex=window.S_LabRightIndex;
			leftDiv.style.display="block";
			if(window.S_LabRightIndex>=labels.length-1) rightDiv.style.display="none";
			_resetStyle(ulObj,labels,startIndex,endIndex);
		}
	}
}

function labTurnToLeft(){
	var ulObj = document.getElementById("lab_group");
	var rightDiv=document.getElementById("div_LabExpandRight");
	var leftDiv=document.getElementById("div_LabExpandLeft");
	if(ulObj!=null){
		var labels = ulObj.getElementsByTagName("div");
		if(window.S_LabRightIndex-window.S_LabLimit+1>0){
			var devInt=(window.S_LabRightIndex+1) % window.S_LabLimit;
			var deveVar=parseInt((window.S_LabRightIndex+1) / window.S_LabLimit);
			var endIndex= window.S_LabLimit-1;
			if(devInt==0)
				endIndex = window.S_LabRightIndex-window.S_LabLimit;
			else
				endIndex = window.S_LabRightIndex-devInt;
			var startIndex=endIndex-window.S_LabLimit+1;
			startIndex= startIndex<0?0:startIndex;
			for(var i=0;i<labels.length;i++){
				if(i>=startIndex && i<=endIndex)
					labels[i].style.display="block";
				else
					labels[i].style.display="none";
			}
			window.S_LabRightIndex=endIndex;
			rightDiv.style.display="block";
			if(window.S_LabRightIndex-window.S_LabLimit<0) leftDiv.style.display="none";
			_resetStyle(ulObj,labels,startIndex,endIndex);
		}
	}
}

/******************************
 * 切换label
 ******************************/
function changeShowData(labelId,isLink) {
	if(window.S_IsLabMoved==true)
		return;
	if(window.S_CurrentLabelId!=null && window.S_CurrentLabelId == labelId)
		return;
	if(isLink=='1'){
		var reuqestUrl="";
		if(window.S_LabelMap!=null){
			reuqestUrl = window.S_LabelMap.get(labelId).dataUrl;
			if(reuqestUrl.indexOf("/")==0)
				reuqestUrl= Com_Parameter.ContextPath + reuqestUrl.substring(1);	
		}
		if(reuqestUrl!="")
			window.open(reuqestUrl, '_blank');
		return;
	}
	_iniListPage(true);
	var labelObj = document.getElementById("li_" + labelId);
	if (labelObj != null) {
		//模块配置有label的情况
		var ulObj = document.getElementById("lab_group");
		var liArr = ulObj.getElementsByTagName("div");
		for ( var i = 0; i < liArr.length; i++){
			liArr[i].className = "";
		}
		labelObj.className = "select_lab";
	}
	_changeCreateBtn(labelId);
	_requestJsonContent(labelId,1);
}

/*******************************
 * cookie操作方法
 *****************************/
function writeCookie(name,value){
	var expdate = new Date(); 
    expdate.setTime(expdate.getTime() + (86400 * 1000 * 1)); 
	document.cookie=name + "="+ value +";expires="+expdate.toGMTString();
}

function deleteCookie(name) { 
    var expdate = new Date(); 
    expdate.setTime(expdate.getTime() - (86400 * 1000 * 1)); 
    document.cookie= name + "=;expires=" + expdate.toGMTString();
}

function GetCookie(name){
	var arr=document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	if(arr!=null)return decodeURIComponent(arr[2]);
	return null;
}

/******************************
 * JavaScript Page对象
 *******************************/
function Page(pageCount,pageno,nextPageStart){
	this.pageCount=pageCount;
	this.pageno=pageno;
	this.nextPageStart=nextPageStart;
	this.toString=function(){
		return "pageno="+this.pageno+",pageCount="+this.pageCount+",nextPageStart="+this.nextPageStart;
	};
}

/****************************************************
 * 以下为私有函数
 ************************************************/
 function _resetStyle(divObj,liArr,startIndex,endIndex){
	 	for ( var i = startIndex; i <= endIndex; i++){
			liArr[i].style.display="block";
			if(i<endIndex)
				liArr[i].style.borderRight="1px solid #5e6a76";
		}
		var legthVar=endIndex-startIndex+1;
		var widthVar=((legthVar)*(window.S_LabelWidth)+(legthVar-1)*1);
		divObj.style.width=widthVar+"px";
		divObj.style.display="block";
}

 /*****滑动效果仅适用于safari/chrome浏览器******/
/*滑动开始*/	
function _touchstart(e){
	window.S_IsLabClicked=true;
	window.S_LabCurrentX=e.changedTouches[0].clientX;;
}

/*滑动move*/	
function _touchmove(e){
	if(window.S_IsLabClicked==true){
		window.S_IsLabMoved=true;
		window.S_IsLabClicked=false;
	}
}
	
/*滑动结束*/
function _touchend(e){
	if(window.S_IsLabMoved==true){
		if(window.pageX!=-1){
			var pointX=e.changedTouches[0].clientX;
			if(pointX>window.S_LabCurrentX)
				labTurnToLeft();
			else if(pointX<window.S_LabCurrentX)
				labTurnToRight();
		}
	}
	window.S_LabCurrentX=-1;
	window.S_IsLabMoved=false;
}
	
 /******************************
 *通过send请求至requesturl获取json数据
 *********************************/
function _requestJsonContent(labelId,pageno) {
	window.S_CurrentLabelId = labelId;
 	if(http_request!=null){
 		delete http_request;
 		http_request = null;
 	}
 	http_request = createAjaxObj();
	if (http_request == null)
		return false;
	var reuqestUrl = null;
	if(window.S_LabelMap!=null){
		reuqestUrl = window.S_LabelMap.get(labelId).dataUrl;
		if(reuqestUrl.indexOf("/")==0)
			reuqestUrl= Com_Parameter.ContextPath + reuqestUrl.substring(1);	
	}
	http_request.onreadystatechange = function() {
		if (http_request.readyState == 4) {
			if (http_request.status == 200) {
				_drawListData(labelId,http_request.responseText);
			} else if(http_request.status>=400 && http_request.status<500) {
				_writeErrorInfo("The URL :'"+reuqestUrl+"' Can Not Be Found.");
			}else if(http_request.status >= 500){
				_writeErrorInfo("The Server Can Not Be Connected.");
			}else{
				return false;
			}
		}
	};
	if(reuqestUrl!=null){	
		http_request.open("POST", reuqestUrl, true);
		http_request.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		if(pageno==null || parseInt(pageno) < 0) 
			 pageno=1;
		if(window.S_RowSize==""||window.S_RowSize==null)
			window.S_RowSize=6;
		http_request.send("pageno=" + pageno + "&rowsize="+ window.S_RowSize);
 	}
 	return true;
}
function _drawListData(key,jsonStr){
	var listObj = JSON.parse(jsonStr);
	var viewDiv= document.getElementById("div_view");
	if(listObj["errorPage"]=="true"){
		viewDiv.innerHTML="<div style='margin-top:8px;'>"+listObj["message"]+"<div>";
		_afterListpage(null,false);
	}else{
		var page=new Page(listObj["pageCount"],listObj["pageno"],listObj["nextPageStart"]);
		window.S_CurPageInfo = page;
		var docs=listObj["docs"];
		var ulListObj=document.getElementById("viewList_"+key);
		if(ulListObj==null || typeof(ulListObj)=='undefined'){
			ulListObj=document.createElement("UL");
			ulListObj.setAttribute("class", "viewList");
			ulListObj.setAttribute("id","viewList_"+key);
		}
		if(docs!=null && typeof(docs)!='undefined'){
			for ( var i = 0; i < docs.length; i++) {
				var liObj=document.createElement("LI");
				var html = "";
				if(docs[i]["url"]==""||docs[i]["url"]==null){
					html+="<a disabled='disabled'>";
					html+="<p class='font_gray'>";
				}else{
					var tmpUrl=docs[i]["url"];
					if(tmpUrl.indexOf("/")==0)
						tmpUrl=Com_Parameter.ContextPath + tmpUrl.substring(1);
					html+="<a href='"+tmpUrl+"'>";
					html+="<p>";
				}
				if(docs[i]["icons"]!=null){
					var icons=docs[i]["icons"];
					for(var j=0;j<icons.length;j++)
						if(icons[j].indexOf("/")==0){
							// 附件图片加载
							html+="<img src='"+ Com_Parameter.ContextPath + icons[j] + "' style='width:28px;height:28px'/>";
						}else{
							html+="<img src='"+ Com_Parameter.ContextPath + "third/pda/resource/images/icon/"+icons[j] + "'/>";
						}
				}
				html+=Com_HtmlEscape(docs[i]["subject"])+"</p>";
				html+="<p class='list_summary'>"+docs[i]["summary"]+"</p>";
				html+="</a>";
				liObj.innerHTML=html;
				ulListObj.appendChild(liObj);
			}
		}
		viewDiv.innerHTML=ulListObj.outerHTML;
		_afterListpage(page,true);
	}
}
function _writeErrorInfo(errorinfo){
	var viewDiv = document.getElementById("div_view");
	viewDiv.innerHTML = "<div style='margin-top:8px;'>"+errorinfo+"<div>";
	_afterListpage(null,false);
}
function _iniListPage(isChangeLabel){
	var loadingDiv  = document.getElementById("div_loading");
	var viewDiv = document.getElementById("div_view");
	var pageDiv = document.getElementById("div_page");
	if(isChangeLabel){
		loadingDiv.style.display="block";
		viewDiv.style.display="none";
		pageDiv.style.display="none";
	}else{
		loadingDiv.style.display="block";
		viewDiv.style.display="block";
		pageDiv.style.display="none";
	}
}
function _afterListpage(page,hasData){
	var loadingDiv  = document.getElementById("div_loading");
	var viewDiv = document.getElementById("div_view");
	var pageDiv = document.getElementById("div_page");
	if(hasData){
		viewDiv.style.display="block";
		loadingDiv.style.display="none";
		if(parseInt(page.pageno)<parseInt(page.pageCount))
			pageDiv.style.display="block";
		else
			pageDiv.style.display="none";
	}else{
		viewDiv.style.display="block";
		pageDiv.style.display="none";
		loadingDiv.style.display="none";
	}
}
function _changeCreateBtn(labelId){
	if(window.S_LabelMap!=null){
		var createUrl = window.S_LabelMap.get(labelId).createUrl;
		var otherBtn = document.getElementById("div_otherBtn");
		if(otherBtn!=null){
			if(createUrl!=null && createUrl!=''){
				var requestUrl = getRequestUrl(createUrl);
				Com_AddEventListener(otherBtn,"click",function(){
					gotoUrl(requestUrl);
				});
				otherBtn.style.display="block";
			}else{
				otherBtn.style.display="none";
			}
		}
	}
}

/**
 * 功能说明：
 * 1.当createUrl为以'h'开头的全路径时候处理
 *	 样列:http://localhost:7070/ekp_dev/third/pda/pda_module_label_list/pdaModuleLabelList.do?method=tainsit&fdLabelId=12eb396eea01a1f60641bb849e4b40a9
 *	 返回:requestUrl = /ekp_dev/third/pda/pda_module_label_list/pdaModuleLabelList.do?method=tainsit&fdLabelId=12eb396eea01a1f60641bb849e4b40a9
 * 2.当createUrl以'/'开头的处理(缺省以'/'开头)
 *   样列:/third/pda/pda_module_label_list/pdaModuleLabelList.do?method=tainsit&fdLabelId=12eb396eea01a1f60641bb849e4b40a9
 *   返回:requestUrl = /ekp_dev/third/pda/pda_module_label_list/pdaModuleLabelList.do?method=tainsit&fdLabelId=12eb396eea01a1f60641bb849e4b40a9
 * @param createUrl
 * @return String
 */
function getRequestUrl(createUrl) {
	var requestUrl = '';
	if (createUrl != null && createUrl != '') {
		if (createUrl.substring(0, 1) == "h") {
			var searchIndex = createUrl.search(Com_Parameter.ContextPath);
			var contextPathLeng = Com_Parameter.ContextPath.length;
			requestUrl = Com_Parameter.ContextPath + createUrl.substring(searchIndex + contextPathLeng,createUrl.length);
		} else {
			requestUrl = Com_Parameter.ContextPath + createUrl.substring(1);
		}
	}
	return requestUrl;
}