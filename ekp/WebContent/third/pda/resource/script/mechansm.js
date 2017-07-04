/*压缩类型：标准*/
/*******************************************************************************
 * JS文件说明： 该文件为机制显示所需js，主要处理机制点评，推荐，关联，沟通信息
 * S_CurrentMechansm        当前显示的机制
 * S_MechansmMap			页面所有机制MAP
 * S_PageLan			    多语言
 ******************************************************************************/
document.writeln("<script src='"+Com_Parameter.ResPath+"js/json2.js'></script>");
document.writeln("<script src='"+Com_Parameter.ContextPath+"third/pda/resource/script/map.js'></script>");

if(window.S_PageLan==null)
	window.S_PageLan={"prePage":"Last","nextPage":"Next","success":"Success"};
/**
 * 注册机制信息，机制使用前必须注册。
 * @param key
 * @param value    格式：
 * {
			"listUrl":"列表请求数据URL",
			"parameter":"参数列表",
			"contentDiv":"操作内容显示html元素ID",
			"listDiv":"列表内容显示html元素ID",
			"getViewHtml":视图数据显示函数,
			"needPage":"是否需要分页信息",
			"customRequestData":自定义数据请求函数,
			"afterDraw":数据请求处理后，定义需要执行的函数
	}
 * @return
 */
function addMechansmInfo(key,value){
	if(window.S_MechansmMap==null)
		window.S_MechansmMap = new Map();
	window.S_MechansmMap.put(key,value);
}
/**
 * 显示某个注册机制的展示内容
 * @param thisObj
 * @param mechansminfoKey
 * @return
 */
function showMechansmInfo(thisObj,mechansminfoKey){
	var isCollapse="0";
	var requestInfo=window.S_MechansmMap.get(mechansminfoKey);
	if(thisObj!=null){
		isCollapse=thisObj.getAttribute("isCollapse");
		thisObj.setAttribute("key",mechansminfoKey);
		var hrefArr=document.getElementsByName(thisObj.getAttribute("name"));
		if(hrefArr!=null && hrefArr.length>0){
			for ( var i = 0; i < hrefArr.length; i++) {
				if(hrefArr[i]!=thisObj 
				   && hrefArr[i].getAttribute("isCollapse")=="1"
				   && hrefArr[i].getAttribute("key")!=""){
					hrefArr[i].setAttribute("isCollapse","0");
					hrefArr[i].setAttribute("class","link");
					var contentId=window.S_MechansmMap.get(hrefArr[i].getAttribute("key"))["contentDiv"];
					var contenDiv=document.getElementById(contentId);
					if(contenDiv!=null)
						contenDiv.style.display="none";
				}
			}
		}
	}
	var divObj=null;
	if(requestInfo["contentDiv"]!=null)
		divObj=document.getElementById(requestInfo["contentDiv"]);
	if(isCollapse==null ||isCollapse=="0"){
		if(divObj!=null)
			divObj.style.display="block";
		if(thisObj!=null){
			thisObj.setAttribute("isCollapse","1");
			thisObj.setAttribute("class","visited");
			window.S_CurrentMechansm=thisObj;
		}
		if(requestInfo["customRequestData"])
			requestInfo["customRequestData"]();
		else
			requestMechansmInfo(1,mechansminfoKey);
	}else{
		if(divObj!=null)
			divObj.style.display="none";
		if(thisObj!=null){
			thisObj.setAttribute("isCollapse","0");
			thisObj.setAttribute("class","link");
		}
		window.S_CurrentMechansm=null;
	}
}

function requestMechansmInfo(pageno,mechansminfoKey){
	var requestInfo=window.S_MechansmMap.get(mechansminfoKey);
	var ajaxObj=createAjaxObj();
	ajaxObj.onreadystatechange=function(){
		if (ajaxObj.readyState == 4) {
 			if (ajaxObj.status == 200) {
 				showMechansmList(ajaxObj.responseText,mechansminfoKey);
	 		}
	 	}
		return ;
	};
	ajaxObj.open("POST", requestInfo["listUrl"], true);
	ajaxObj.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	if(pageno==null ||parseInt(pageno) <= 0)
		pageno=1;
	ajaxObj.send("pageno="+pageno+requestInfo["parameter"]);
	return ;
}

function showMechansmList(content,mechansminfoKey){
	var listObj = JSON.parse(content);
	var requestInfo=window.S_MechansmMap.get(mechansminfoKey);
	var contentDiv=document.getElementById(requestInfo["listDiv"]);
	if(listObj["errorPage"]=="true"){
		contentDiv.innerHTML="<div style='margin: 10px 0px;'>"+listObj["message"]+"</div>";
	}else{
		/**视图数据获取显示**/
		var html=requestInfo["getViewHtml"](listObj["docs"]);
		
		/**分页显示**/
		if(requestInfo["needPage"]=="true"){
			var count=parseInt(listObj["count"],10);
			if(count>10){
				var pageCount=parseInt(listObj["pageCount"],10);
				var pageNo=parseInt(listObj["pageno"],10);
				html+="<div class='div_listPage'>";
				if(pageNo>1)
					html+="<a onclick=\"requestMechansmInfo("+(pageNo-1)+",'"+mechansminfoKey+"')\">"+window.S_PageLan["prePage"]+"</a>";
				if(pageCount<=5){
					for(var i=1;i<=pageCount;i++)
						html+="<a "+(i==pageNo?"class='selected'":"")+" onclick=\"requestMechansmInfo("+i+",'"+mechansminfoKey+"')\">"+i+"</a>";
				}else{
					var start=1;
					if((pageNo-2)>1){
						html+="<a onclick=\"requestMechansmInfo(1,'"+mechansminfoKey+"')\">1..</a>";
						start=pageNo-2;
						if(pageNo+2>pageCount)
							start=pageCount-4;
					}else{
						start = 1;
					}
					for(var i = start;i< start+5;i++){
						if(i<=pageCount){
							html+="<a "+(i==pageNo?"class='selected'":"")+" onclick=\"requestMechansmInfo("+i+",'"+mechansminfoKey+"')\">"+i+"</a>";
						}
					}
					if(pageNo+2<pageCount)
						html+="<a onclick=\"requestMechansmInfo("+pageCount+",'"+mechansminfoKey+"')\">.."+pageCount+"</a>";
				}
				if(pageNo<pageCount)
					html+="<a onclick=\"requestMechansmInfo("+(pageNo+1)+",'"+mechansminfoKey+"')\">"+window.S_PageLan["nextPage"]+"</a>";
				html+="</div>";
			}
			_changeMechansmNum(""+count);
		}
		contentDiv.innerHTML=html;
		if(requestInfo["afterDraw"])
			requestInfo["afterDraw"]();
	}
	
}

/**
 * 采用ajax的post方式提交表单内容
 * @param formObj
 * @param beforeSubmitForm
 * @param afterSubmitForm
 * @return
 */
function submitMechansmForm(formObj,beforeSubmitForm,afterSubmitForm){
	var reqObj=createAjaxObj();
	var todayVar=new Date();
	if(beforeSubmitForm){
		if(!beforeSubmitForm(formObj))
			return false;
	}
	reqObj.onreadystatechange=function(){
		if (reqObj.readyState == 4) {
 			if (reqObj.status == 200) {
 				successAlert("提交成功");//window.S_PageLan["success"]
 				if(afterSubmitForm)
 					afterSubmitForm(formObj,reqObj);
 				_changeMechansmNum();
	 		}
	 	}
		return ;
	};
	reqObj.open("POST", formObj.action, true);
	reqObj.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	reqObj.send(_getFormData(formObj));
	return false;
}
function _getFormData(formObj){
	var dataStr="";
	var inpArr=formObj.getElementsByTagName("*");
	for(var i=0;i<inpArr.length;i++){
		var tagname=inpArr[i].tagName.toLowerCase();
		if(tagname=='input'||tagname=='textarea'||tagname=='select'){
			var eName=inpArr[i].getAttribute("name");
			if(tagname=='select'){
				if(eName!=null && eName!="")
					dataStr+= "&"+eName+"="+encodeURIComponent(inpArr[i].options[inpArr[i].selectedIndex].value);
			}else{
				if(eName!=null && eName!="")
					dataStr+= "&"+eName+"="+ encodeURIComponent(inpArr[i].value);
			}
		}
	}
	return dataStr==""?"":dataStr.substr(1);
}

function _setInnerText(obj,txt){
	if("textContent" in obj)
		obj.textContent = txt;
	else
		obj.innerText = txt;
}

function _changeMechansmNum(countStr){
	if(window.S_CurrentMechansm!=null){
		var scoreInfo=window.S_CurrentMechansm.innerText||window.S_CurrentMechansm.textContent;
		if(scoreInfo.indexOf("(")>0){
			var prefix=scoreInfo.substring(0,scoreInfo.indexOf("("));
			var numinfo=scoreInfo.substring(scoreInfo.indexOf("(")+1,scoreInfo.indexOf(")"));
			countStr=countStr==null||countStr==''?""+(parseInt(numinfo)+1):countStr;
			_setInnerText(window.S_CurrentMechansm,(prefix+"("+countStr+")"));
		}else{
			countStr=countStr==''||countStr==null?"1":countStr;
			_setInnerText(window.S_CurrentMechansm,(scoreInfo+"("+countStr+")"));
		}
	}
}