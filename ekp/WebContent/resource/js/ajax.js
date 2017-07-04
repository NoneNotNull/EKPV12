var requestURL;
var xmlHttpRequest;
var divName;
var propertyName_;
function createXmlHttpRequest(){
	if (window.XMLHttpRequest) { // Non-IE browsers
      xmlHttpRequest = new XMLHttpRequest();
    }else if (window.ActiveXObject) { // IE   
    	try {
			xmlHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (othermicrosoft) {
			try {
				xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (failed) {
				xmlHttpRequest = false;
			}
		}
	}
}
function processPropertyUniqueCheck(url) {
    url=createUrl(url);
    //debugger;
    createXmlHttpRequest();
    if (xmlHttpRequest) {
    	//在FF下，第一次执行完onreadystatechange后，继续执行到send，但后面就不会再回头执行onreadystatechange
    	var btype=getOs();
    	//onreadystatechange在IE和FF下会区分方法是否带括号
       	xmlHttpRequest.onreadystatechange = (btype!="Firefox")?(processPropertyUniqueStatechange):(processPropertyUniqueStatechange());
        xmlHttpRequest.open("GET", url, true);
        xmlHttpRequest.send();
        //这里加一行挡住FF，让它再执行一次
    	xmlHttpRequest.onreadystatechange = (btype!="Firefox")?(processPropertyUniqueStatechange):(processPropertyUniqueStatechange());
	}
}
function getOs(){
 	if(navigator.userAgent.indexOf("MSIE")>0) {
 		return "MSIE";       //IE浏览器
 	}else if(isFirefox=navigator.userAgent.indexOf("Firefox")>0){
 		return "Firefox";    //Firefox浏览器
 	}else if(isSafari=navigator.userAgent.indexOf("Safari")>0) {
 		return "Safari";     //Safari浏览器
 	}else if(isMozilla=navigator.userAgent.indexOf("Gecko/")>0){
 		return "Gecko";      //Gecko浏览器(或者叫chrome浏览器)
	}else if(isCamino=navigator.userAgent.indexOf("Camino")>0){
 		return "Camino";     //Camino浏览器
	}
}
function createUrl(url){
	return url;
}
Com_IncludeFile("data.js");
function processPropertyUniqueStatechange() {
  	  if (xmlHttpRequest.readyState == 4) { // Complete
  		 //火狐下本地响应成功返回0而不是200（没有通过Web服务器形式的Ajax请求返回值都是0）
	     if (xmlHttpRequest.status == 200 || xmlHttpRequest.status == 0) { // OK response
			var responseText = xmlHttpRequest.responseText;
			var obj = document.getElementById(divName);
			if(responseText == "0"){
				obj.innerHTML = "<font color = red>"+Data_GetResourceString("ajaxJS.info.nameIsSame")+"</font>";
			}else{
				obj.innerHTML = "";
			} 
			if(responseText == "0"){
				document.getElementsByName(propertyName_)[0].focus();
			}
			   	         
	     } else {
	       alert("Problem with server response:\n " + xmlHttpRequest.statusText);
	     }
    }
}

function propertyUniqueCheck(url,propertyName,serviceName){
		var fdId = document.getElementsByName("fdId")[0].value;
	    var propertyValue = document.getElementsByName(propertyName)[0].value;	   
	    divName =  propertyName+"_id";
	    propertyName_ = propertyName;
		var url = encodeURI(url+"&fdId="+fdId+"&serviceName="+serviceName+"&propertyName="+propertyName+"&propertyValue="+propertyValue);
		processPropertyUniqueCheck(url);				
}
function propertyValueChange(obj,url,propertyName,serviceName,modelId){
		var fdId = modelId;
	    var propertyValue = obj.value;   
	    divName =  propertyName+"_id";
	    propertyName_ = propertyName;
		var url = encodeURI(url+"&fdId="+fdId+"&serviceName="+serviceName+"&propertyName="+propertyName+"&propertyValue="+propertyValue);
		processPropertyUniqueCheck(url);				
}
