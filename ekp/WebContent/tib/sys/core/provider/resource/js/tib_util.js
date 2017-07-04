/**
 * 返回能够调用的接口函数的清单
 * @param count   最多返回多少函数，0代表返回所有
 * @return 	一个json串，格式如下：
			{"1":{
				"fdName":"接口名称1",
				"fdKey":"接口关键字",
				"fdType":"接口类型，1：定制组件（此类组件由初始化导入，不可修改接口XML）；默认值：0",
				"fdControlPattern":"调度模式"
				},
			"2":{"fdName":"接口名称2",
				"fdKey":"接口关键字",
				"fdType":"接口类型，1：定制组件（此类组件由初始化导入，不可修改接口XML）；默认值：0",
				"fdControlPattern":"调度模式"
				}
			}

 */
function TIB_getIfaceList(count) {
	var backDataJson = "";
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath 
			+"tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=getFunJson&count="+ count, 
			TIB_callFunList, false);
	function TIB_callFunList(http_request) {
		backDataJson = http_request.responseText;
	}
	return backDataJson;
}



/**
 * 根据接口Key返回接口相关信息
 * @param key   配置的函数接口的关键字（唯一）
 * @return	一个json串，格式如下：
	{
	 "fdName":"接口名称",
	 "fdKey":"接口关键字",
	 "fdType":"接口类型，区别sap,soap,数据传输组件",
	 "fdNote":"接口说明",
	 "fdInfoExt":"接口扩展信息(json格式)",
	 "fdIfaceTags":"接口标签、分类"
	 "fdControlPattern":"调度模式
	 }
 */
function TIB_getIface(key) {
	var backDataJson = "";
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath 
				+"tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=getFunJson&key="+ key, 
				TIB_callFun, false);
	function TIB_callFun(http_request) {
		backDataJson = http_request.responseText;
	}
	return backDataJson;
}
 
 /**
  * 返回能够调用的接口函数的清单
  * @param count   最多返回多少函数，0代表返回所有
  * @return 	一个json串，格式如下：
  * 	{"1":{
	  			"fdName":"实现名称",
	  			"fdOrderBy":"实现执行顺序",
	  			"fdRefFuncType":"实现类型，区别sap,soap,数据传输组件",
	  			"fdRefFuncName":"关联函数名称"
  			},
  			"2":{
  				"fdName":"实现名称",
  				"fdOrderBy":"实现执行顺序",
  				"fdRefFuncType":"实现类型，区别sap,soap,数据传输组件",
  				"fdRefFuncName":"关联函数名称"
  			}
		}
  */
 function TIB_getImplList(key) {
 	var implListJson = "";
 	var data = new KMSSData();
 	data.SendToUrl(Com_Parameter.ContextPath 
 			+"tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=getImplList&key="+ key, 
 			TIB_callImplList, false);
 	function TIB_callImplList(http_request) {
 		implListJson = http_request.responseText;
 	}
 	return implListJson;
 }

/**
 * 根据接口Key返回接口的XML模板
 * @param key
 * @return
 */
function TIB_getIfaceXml(key) {
	var backInXml = "";
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath 
				+"tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=getFunXml&key="+ key, 
				TIB_callFunXml, false);
	function TIB_callFunXml(http_request) {
		backInXml = http_request.responseText;
	}
	return backInXml;
}

/**
 * 根据传入参数，返回执行后的结果（XML格式）
 * @param inXML
 * @return
 */
function TIB_executeToXml(inXML){
	if (typeof inXML == "object" && inXML.nodeType == 9){
		inXML = XML2String(inXML);
	}
	var backOutXml = "";
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath 
				+"tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=getFunBackXml&inXML="+ inXML, 
				TIB_callFunOutXml, false);
	function TIB_callFunOutXml(http_request) {
		backOutXml = http_request.responseText;
	}
	return backOutXml;
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


