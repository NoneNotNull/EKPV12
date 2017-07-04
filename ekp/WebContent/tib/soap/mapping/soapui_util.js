
//============================测试方法开始=============================//
function test() {
//  var Func_Name = "httpEkp函数";
	var Func_Name = "手机号归属地函数";
	SoapUI_Func_Template(Func_Name, function(rtnObj){
		alert("rtnObj="+ XML2String(rtnObj));
		alert("rtnObj="+ Json2XMLString(rtnObj));
	},"xml");
// var mainId = "13bb71be6c2eaf35a28b17b449f8772e";
// // xml转json
// var jsonObj = XML2Json(xmlObj);
// var jsonObj2 =
// {"Input":{"soapenv:Envelope":{"soapenv:Body":{"web:SapJsonWebservice":{"RFCName":"9999999"}}}}};
}

function test3(){
//	var Func_Name = "httpEkp函数";
	var Func_Name = "手机号归属地函数";
//	var json = {"Input":{"soapenv:Envelope":{"soapenv:Body":{"web:wsTest":{"arg0":{
//		"arrStr":"1111"}}}}}};
	var json = {"Input":{"soap:Envelope":{"soap:Body":{"web:getMobileCodeInfo":{"web:mobileCode":"18988772114"}}}}};
	SoapUI_Func_Result(Func_Name, json, function(rtnObj){
		alert("rtnObj="+ rtnObj);
		alert("rtnObj="+ Json2XMLString(rtnObj)); // 弹出整串XMLString
		var value = rtnObj.Output["soap:Envelope"]["soap:Body"]["getMobileCodeInfoResponse"]["getMobileCodeInfoResult"];
		alert("value="+value); // 弹出[object Object]
		alert("value['#text']="+ value['#text']);
	});
}

//============================测试方法结束=============================//


/**
 * 提供Json模版
 * @param Func_Name    主文档名称
 * @param Back_Funcs   自定义的回调函数;
 * @param Back_Type    需要的返回类型，json or xml
 */
function SoapUI_Func_Template(Func_Name, Back_Funcs, Back_Type) {
	var data = new KMSSData();
	data.SendToBean("tibSysSoapInputTemplateBean&mainName="+ Func_Name, 
			function(rtnData){
				back_template(rtnData, Back_Funcs, Back_Type);
			}
	);
}

/**
 * 拿模版的回调函数
 * @param rtnData	   回调值
 * @param Back_Funcs   自定义的回调函数;
 * @param Back_Type    需要的返回类型，json or xml
 */
function back_template(rtnData, Back_Funcs, Back_Type) {
	if (!rtnData) {
		return;
	}
	var templateXml = rtnData.GetHashMapArray()[0]["templateXml"];
	var xmlObj = String2XML(templateXml);
	var rtnObj = null;
	// 判断返回类型，XML or JSON
	if (Back_Type && Back_Type == "xml") {
		rtnObj = xmlObj;
	} else {
		rtnObj = XML2Json(xmlObj);
	}
	if (!Back_Funcs) 
		return ;
	// 判断函数数组的形式
	if (Object.prototype.toString.call(Back_Funcs) == '[object Array]') {
		for (var i = 0, len = Back_Funcs.length; i < len; i++) {
			if ('[object Function]' == Object.prototype.toString
					.call(Back_Funcs[i])) {
				Back_Funcs[i].call(this, rtnObj);
			}
		}
	} else {
		if ('[object Function]' == Object.prototype.toString
				.call(Back_Funcs)) {
			Back_Funcs.call(this, rtnObj);
		}
	}
	
}  

/**
 * 传入赋值好的Json
 * （支持只赋其中少量节点的值，即节点可以不完整，但不能错误，错误则无数据填充）
 * 得到返回数据的Json
 * @param Func_Name    		主文档名称
 * @param Request_Content   传入的内容，Json,Xml对象,Xml字符串
 * @param Back_Funcs   		自定义的回调函数;
 * @param Back_Type    		需要的返回类型，json or xml
 */
function SoapUI_Func_Result(Func_Name, Request_Content, Back_Funcs, Back_Type) {
	// 判断传入类型XML对象，JSON，字符串
	var requestXml = "";
	if (typeof Request_Content == "object" && Request_Content.nodeType == 9){
		requestXml = XML2String(Request_Content);
	} else if (isJson(Request_Content)) {
		requestXml = Json2XMLString(Request_Content);
	} else {
		requestXml = Request_Content;
	}
	alert("requestXml==="+requestXml);
	var data = new KMSSData();
	data.SendToBean("tibSysSoapBackXmlBean&requestXml="+ requestXml +"&mainName="+ Func_Name, 
			function(rtnData){
				back_resultXml(rtnData, Back_Funcs, Back_Type);
			}
	);
}

/**
 * 拿数据的回调函数
 * @param rtnData	   回调值
 * @param Back_Funcs   自定义的回调函数;
 * @param Back_Type    需要的返回类型，json or xml
 */
function back_resultXml(rtnData, Back_Funcs, Back_Type) {
	if (!rtnData) {
		return;
	}
	var resultXml = rtnData.GetHashMapArray()[0]["resultXml"];
	var xmlObj = String2XML(resultXml);
	var rtnObj = null;
	// 判断返回类型，XML or JSON
	if (Back_Type && Back_Type == "xml") {
		rtnObj = xmlObj;
	} else {
		rtnObj = XML2Json(xmlObj);
	}
	if (!Back_Funcs) 
		return ;
	// 判断函数数组的形式
	if (Object.prototype.toString.call(Back_Funcs) == '[object Array]') {
		for (var i = 0, len = Back_Funcs.length; i < len; i++) {
			if ('[object Function]' == Object.prototype.toString
					.call(Back_Funcs[i])) {
				Back_Funcs[i].call(this, rtnObj);
			}
		}
	} else {
		if ('[object Function]' == Object.prototype.toString
				.call(Back_Funcs)) {
			Back_Funcs.call(this, rtnObj);
		}
	}
}

/**
 * 判断是否为JSON
 */
function isJson(obj) {
	var isjson = typeof (obj) == "object"
			&& Object.prototype.toString.call(obj).toLowerCase() == "[object object]"
			&& !obj.length;
	return isjson;
};

/**
 * 把xmlString转化为对象
 * @param str
 * @returns
 */
function String2XML(str) {
	if (document.all) {
		var xmlDom = new ActiveXObject("Microsoft.XMLDOM");
		xmlDom.loadXML(str);
		return xmlDom;
	} else
		return new DOMParser().parseFromString(str, "text/xml");
}

/**
 * XML对象转字符串 
 * @param xmlObject
 * @returns
 */
function XML2String(xmlObject) {
	// for IE
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
		return xmlObject.xml;
	} else {
		// for other browsers
		return (new XMLSerializer()).serializeToString(xmlObject);
	}
} 


/**
 * xml转json
 * @param xml
 * @returns {___anonymous969_970}
 */
function XML2Json(xml) {
	// Create the return object
	var obj = {};
	if (xml.nodeType == 1) { 
		// do attributes
		if (xml.attributes.length > 0) {
			obj["@attributes"] = {};
			for ( var j = 0; j < xml.attributes.length; j++) {
				var attribute = xml.attributes.item(j);
				obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
			}
		}
	} else if (xml.nodeType == 3) { // text
		obj = xml.nodeValue;
	}
	// do children
	if (xml.hasChildNodes()) {
		for ( var i = 0; i < xml.childNodes.length; i++) {
			var item = xml.childNodes.item(i);
			var nodeName = item.nodeName;
			if (typeof (obj[nodeName]) == "undefined") {
				obj[nodeName] = XML2Json(item);
			} else {
				if (typeof (obj[nodeName].length) == "undefined") {
					var old = obj[nodeName];
					obj[nodeName] = [];
					obj[nodeName].push(old);
				}
				obj[nodeName].push(XML2Json(item));
			}
		}
	}
	return obj;
}; 


/**
 * json转xml
 * @param o
 * @param tab
 * @returns
 */
function Json2XMLString(o, tab) {
	var toXml = function(v, name, ind) {
		var xml = "";
		if (v instanceof Array) {
			for ( var i = 0, n = v.length; i < n; i++)
				xml += ind + toXml(v[i], name, ind + "\t") + "\n";
		} else if (typeof (v) == "object") {
			var hasChild = false;
			xml += ind + "<" + name;
			for ( var m in v) {
				if (m.charAt(0) == "@") {
					// 对属性进行遍历
					for (var n in v[m]) {
						xml +=" "+ n +"=\""+ v[m][n] +"\"";
					}
				} else
					hasChild = true;
			}
			xml += hasChild ? ">" : "/>";
			// 遍历节点，排除属性和注释
			if (hasChild) {
				for ( var m in v) {
					if (m == "#text")
						xml += v[m];
					else if (m == "#cdata")
						xml += "<![CDATA[" + v[m] + "]]>";
					else if (m.charAt(0) != "@" && m != "#comment")
						xml += toXml(v[m], m, ind + "\t");
				}
				xml += (xml.charAt(xml.length - 1) == "\n" ? ind : "") + "</"
						+ name + ">";
			}
		} else {
			xml += ind + "<" + name + ">" + v.toString() + "</" + name + ">";
		}
		return xml;
	}, xml = "";
	for ( var m in o)
		xml += toXml(o[m], m, "");
	return tab ? xml.replace(/\t/g, tab) : xml.replace(/\t|\n/g, "");
}


