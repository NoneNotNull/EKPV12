/*压缩类型：标准*/
/***********************************************
JS文件说明：
本JS文件提供了采用AJAX的方式访问XML数据的函数。

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
Com_RegisterFile("xml.js");
Com_IncludeFile("data.js");

var XMLDATABEANURL = Com_Parameter.ContextPath + "sys/common/dataxml.jsp?s_bean=";		//全局变量，获取普通XML数据的基准路径

//多浏览器支持新增
if(document.implementation && document.implementation.createDocument && "undefined" != typeof XMLDocument){
	// 补充XMLDocument判断，过滤ie9，防止js未定义错误
	XMLDocument.prototype.loadXML = function(xmlString){
		var childNodes = this.childNodes;
		for (var i = childNodes.length - 1; i >= 0; i--)
			this.removeChild(childNodes[i]);
		var dp = new DOMParser();
		var newDOM = dp.parseFromString(xmlString, "text/xml");
		var newElt = this.importNode(newDOM.documentElement, true);
		this.appendChild(newElt);
	};
}

/***********************************************
功能：载入一个XML文档
参数：
	xmldoc：必选，xmldoc的URL路径或xml对象
返回：xml对象
***********************************************/
function XML_Create(xmldoc, asyncFunction, parameter){
	if(Com_Parameter.XMLDebug)
		window.open(xmldoc, "_blank");
	var xml = {};
	var xmlhttp = {};
	if (window.XMLHttpRequest){
		// 所有浏览器
		xmlhttp=new XMLHttpRequest();
	}else if (window.ActiveXObject){
		// IE5 和 IE6
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	
	if(asyncFunction == null){
		//同步请求
		//fix by wubing date:2013-02-28
		if(xmldoc.length>2000){
			var bindex = xmldoc.indexOf("?");
			var url = xmldoc.substring(0,bindex);
			var p = xmldoc.substring(bindex+1);
			xmlhttp.open("POST", url, false);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.send(p); 
		}else{
			xmlhttp.open("POST", xmldoc, false);
			xmlhttp.send(null); 
		}
		xml = xmlhttp.responseXML; 
	}else{
		//异步请求
		//fix by wubing date:2013-02-28
		if(xmldoc.length>2000){
			var bindex = xmldoc.indexOf("?");
			var url = xmldoc.substring(0,bindex);
			var p = xmldoc.substring(bindex+1);
			xmlhttp.open("POST", url, true);
			xmlhttp.onreadystatechange = function(){
				if(xmlhttp.readyState==4){
					if(xmlhttp.status==200){
						asyncFunction(xmlhttp.responseXML,parameter);
					}
				}
			}
			xmlhttp.send(p);
		}else{
			xmlhttp.open("POST", xmldoc, true);
			xmlhttp.onreadystatechange = function(){
				if(xmlhttp.readyState==4){
					if(xmlhttp.status==200){
						asyncFunction(xmlhttp.responseXML,parameter);
					}
				}
			}
			xmlhttp.send(null);
		}
	} 
	return xml;
}

function XML_CreateByContent(xmlContent){
	var xml = {};
	if(Com_Parameter.IE){
		xml = new ActiveXObject("MSXML2.DOMDocument.3.0");		
		xml.loadXML(xmlContent);
	}else{
		xml = document.implementation.createDocument("","",null);
		var dp = new DOMParser();
	    var newDOM = dp.parseFromString(xmlContent, "text/xml");
	    var newElt = xml.importNode(newDOM.documentElement, true);
	    xml.appendChild(newElt);
	}
	return xml;
}

/***********************************************
功能：获取节点中某个属性的值
参数：
	xmlNode：必选，节点对象
	attName：必选，属性名
	defaultValue：可选，当属性不存在时返回的默认值。
返回：字符串，节点属性值。
***********************************************/
function XML_GetAttribute(xmlNode, attName, defaultValue){
	var attNode = xmlNode.getAttributeNode(attName);
	if(attNode==null)
		return defaultValue;
	else
		return attNode.value;
}

/***********************************************
功能：根据指定的路径获取XML节点列表
参数：
	xmlNode：必选，节点对象
	path：必选，字符串，路径，可以是任意的XPath能支持的所有格式。
返回：数组，节点列表。
备注：
	修改人：龚健
	日期：2009年7月30日
	修改功能：使用XPath技术来替换原有功能，path参数可以是任意的XPath能支持的所有格式。
***********************************************/
function XML_GetNodesByPath(xmlNode, path){
	if(window.XPathEvaluator){
		try {
	        var xpe = new XPathEvaluator();
	        var nsResolver = xpe.createNSResolver( xmlNode.ownerDocument == null ? xmlNode.documentElement : xmlNode.ownerDocument.documentElement);
	        var result = xpe.evaluate(path, xmlNode, nsResolver, 0, null);
	        var found = [];
	        var res;
	        while  (res = result.iterateNext())
	            found.push(res); 
	        return found;
		} catch(e) {
			// some andriod browser do not support, have a better solution?
			if(xmlNode.querySelectorAll){
				path = path.replace(/\//gi," ");
				return xmlNode.querySelectorAll(path);
			}
			throw e;
		}
    }else if("selectNodes" in xmlNode){
        return xmlNode.selectNodes(path);
    }else if(xmlNode.querySelectorAll){
		path = path.replace(/\//gi," ");
		return xmlNode.querySelectorAll(path);
	}
}

/***********************************************
功能：根据指定的属性的指定值查找给定节点下的节点列表
参数：
	xmlNode：必选，节点对象
	attName：必选，字符串，属性名
	attValue：必选，字符串，属性值
返回：数组，节点列表。
***********************************************/
function XML_GetNodesByAttribute(xmlNode, attName, attValue){
	var nodes = new Array;
	for(var node=xmlNode.firstChild; node!=null; node=node.nextSibling)
		if(node.nodeType==1 && XML_GetAttribute(node, attName)==attValue)
				nodes[nodes.length] = node;
	return nodes;
}