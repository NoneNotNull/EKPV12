/**
 * 设置拉线事件
 */
jsPlumb.bind("jsPlumbConnection", function(conn) {
	var sourceText = $(conn.source[0]).prev().text();
	var targetText = $(conn.target[0]).next().text();
	var sourceArr = getFieldInfoArr(sourceText);
	var targetArr = getFieldInfoArr(targetText);
	if (targetArr == null && targetArr.length <= 0) {
		return;
	}
	if (sourceArr[0].toLowerCase().indexOf(targetArr[0].toLowerCase()) == -1) {
		jsPlumbDemo.setPaintStyleYellow(conn);
	} else if (targetArr.length > 1 && sourceArr[1] == "null" && targetArr[1] == "notnull") {
		jsPlumbDemo.setPaintStyleYellow(conn);
	}
});

/**
 * 取属性
 * @param fieldNodeName
 * @return
 */
function getFieldInfoArr(fieldNodeName) {
	var startIndex = fieldNodeName.indexOf("(");
	if (startIndex != -1) {
		var fieldInfo = fieldNodeName.substring(startIndex + 1, fieldNodeName.length - 1);
		var fieldInfoArr = fieldInfo.split(",");
		return fieldInfoArr;
	}
	return null;
}

function ifaceChange() {
	var ifaceId = $("#tibSysCoreIfaceId").val();
	if (ifaceId == "") {
		$("#treeDiv").empty();
		return;
	}
	// 提示加载图片
	FUN_AppendLoadImg("tibSysCoreIfaceId");
	var kmssData = new KMSSData();
	kmssData.SendToUrl(Com_Parameter.ContextPath +
			"tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=getIfaceXml&ifaceId="+ ifaceId, 
			function(http_request){call_createTree(http_request);}, false);
}

// 外部定义，防止点击节点的bug
var sourceTree = null;
function call_createTree(http_request) {
	var ifaceXml = http_request.responseText;
	ifaceXml = ifaceXml.replace(/\\\"/g, "\"");
	var doc = TIB_SysUtil.createXmlObj(ifaceXml);
	var inObjs = $(doc).find("tib in");
	// 画源树
	sourceTree = new dTree('sourceTree');
	sourceTree.add(0,-1,'tib');
	sourceTree.add(1,0,'in','in', "", "", "", "", true);
	impl_loopNode(sourceTree, $(inObjs), 1, "/tib/in");
	document.getElementById("treeDiv").innerHTML = sourceTree;
	// 移除点
	jsPlumb.detachAllConnections();
	jsPlumb.deleteEveryEndpoint();
	jsPlumbDemo.init();
	// 提示加载图片
	FUN_RemoveLoadImg("tibSysCoreIfaceId");
	// 设置鼠标移动到圆点变粗
	jsPlumbDemo.setTibJsPlumb_endpoint();
}

/**
* 递归，为xml转树调用(带拉线的)
* @param d
* @param obj
* @param parentId
* @return
*/
function impl_loopNode(dObj, obj, parentId, xpath) {
	var tempXPath = xpath;
	if (obj.length > 0) {
		var pid = parentId;
		obj.each(function(){
			var tagName = $(this)[0].tagName;
			if ("in" != tagName) {
				xpath = tempXPath +"/"+ tagName;
				var ctype = $($(this)[0]).attr("ctype");
				var nodeName = tagName;
				if (ctype != undefined) {
					nodeName += "("+ ctype;
					var length = $($(this)[0]).attr("length");
					if (length != undefined) {
						nodeName += "("+ length +")";
					}
					var required = $($(this)[0]).attr("required");
					if (required != undefined && required == "0") {
						nodeName += ",null"; 
					} else {
						nodeName += ",notnull"; 
					}
					var multi = $($(this)[0]).attr("multi");
					if (multi != undefined && multi == "1") {
						nodeName += ",multi";
					}
					nodeName += ")";
				}
				//alert("tagName="+tagName+",ctype="+ctype);
				var id = impl_getMaxId(dObj);
				dObj.add(id, pid, nodeName,'url', '', '' ,'', '', true, xpath, "tleft");
				parentId = id;
			}
			impl_loopNode(dObj, $(this).children(), parentId, xpath);
		});
	}
}

//求最大的ID+1(防止ID重复)
function impl_getMaxId(dObj) {
	var allo = dObj.aNodes;
	var max = 0;
	for(var i=0;i<allo.length;i++) { 
		if (allo[i].id > max) {
			max = allo[i].id;
		}
	}
	if (parseInt(max) >= 0) {
		return max + 1;
	} else {
		return 0;
	}
}

// 选择函数之后显示模版
function call_funcChange(funcId, providerKey) {
	var isConnLine = false;
	if (funcId == null) {
		funcId = $("input[name=fdImplRef]").val();
		if (funcId == null || funcId == "") {
			return;
		}
		isConnLine = true;
	}
	if (providerKey == null) {
		providerKey = $("input[name=fdFuncType]").val();
	}
	$("input[name=fdFuncTypeName]").val(Plugin_HandInfo[providerKey]["providerName"]);
	// 提示加载图片
	FUN_AppendLoadImg("fdImplRefName");
	var params = {
		"funcId" : funcId,
		"providerKey" : providerKey
	};
	TIB_SysUtil.tibDataSendToBean("tibSysCoreIfaceTemplateBean", params, 
			function(rtnData){call_funcTemplate(rtnData, providerKey, isConnLine);});
}

//外部定义，防止点击节点的bug
var targetTree = null;
function call_funcTemplate(rtnData, providerKey, isConnLine) {
	// 移除加载提示
	FUN_RemoveLoadImg("fdImplRefName");
	var rtnDataObj = rtnData.GetHashMapArray()[0];
	if (rtnDataObj != null) {
		// 移除提示信息
		FUN_RemoveValidMsg("fdImplRefName");
		var templateXml = rtnDataObj["templateXml"];
		var xmlObj = TIB_SysUtil.createXmlObj(templateXml);
		eval(Plugin_HandInfo[providerKey]["convertXmlJsFunc"]).call(this, xmlObj);
		targetTree = new dTree("targetTree");
		module_impl_loopNode(targetTree, $(xmlObj), "-1", "");
		document.getElementById("targetTreeDiv").innerHTML = targetTree;
		// 移除点
		jsPlumb.detachAllConnections();
		jsPlumb.deleteEveryEndpoint();
		jsPlumbDemo.init();
		Plumb_ConnFlag = true;
		if (isConnLine) {
			// 编辑页面_设置连线
			setMappConn();
		}
	} else {
		// 进行提示信息
		FUN_AppendValidMsg("fdImplRefName!"+ TibProvider_Lang.getError);
	}
	// 设置鼠标移动到圆点变粗
	jsPlumbDemo.setTibJsPlumb_endpoint();
}

/**
* 递归，为各自组件xml转树调用(带拉线的)
* @param d
* @param obj
* @param parentId
* @return
*/
function module_impl_loopNode(dObj, obj, parentId, xpath) {
	var tempXPath = xpath;
	if (obj.length > 0) {
		var pid = parentId;
		obj.each(function(){
			var tagName = $(this)[0].tagName;
			var name = $($(this)[0]).attr("name");
			if (name != undefined) {
				tagName = name;
			}
			if (undefined != tagName) {
				xpath = tempXPath +"/"+ tagName;
				var ctype = $($(this)[0]).attr("ctype");
				var nodeName = tagName;
				if (ctype != undefined) {
					nodeName += "("+ ctype;
					var length = $($(this)[0]).attr("length");
					if (length != undefined) {
						nodeName += "("+ length +")";
					}
					var required = $($(this)[0]).attr("required");
					if (required != undefined) {
						if (required == "0") {
							nodeName += ",null"; 
						} else {
							nodeName += ",notnull"; 
						}
					} 
					var multi = $($(this)[0]).attr("multi");
					if (multi != undefined && multi == "1") {
						nodeName += ",multi";
					}
					nodeName += ")";
				}
				var id = impl_getMaxId(dObj);
				var isPreview = $($(this)[0]).attr("isPreview");
				if (isPreview != undefined && isPreview == "1") {
					dObj.add(id, pid, nodeName,'url', '', '' ,'', '', true, xpath, "tright");
				} else {
					dObj.add(id, pid, nodeName,'url', '', '' ,'', '', true);
				}
				parentId = id;
			}
			module_impl_loopNode(dObj, $(this).children(), parentId, xpath);
		});
	}
}

/**
 * 提交之前的动作
 * @param method
 * @return
 */
function saveBefore(method) {
	if (IfaceImplValid.save()) {
		var obj = jsPlumb.getAllConnections();
		var connInfo = obj.jsPlumb_DefaultScope;
		var connJson = [];
		if (connInfo != null) {
			for(var i = 0, len = connInfo.length; i < len; i++){
				var connRow = {};
				var sourceId =  $(connInfo[i].source[0]).attr("id");
				var targetId =  $(connInfo[i].target[0]).attr("id");
				var sourceXPath =  $(connInfo[i].source[0]).next().text();
				var targetXPath =  $(connInfo[i].target[0]).prev().text();
				connRow["sourceId"] = sourceId;
				connRow["targetId"] = targetId;
				connRow["sourceXPath"] = sourceXPath;
				connRow["targetXPath"] = targetXPath;
				connJson.push(connRow);
			}
		}
		$("textarea[name=fdImplRefData]").val(JSON.stringify(connJson));
		Com_Submit(document.tibSysCoreIfaceImplForm, method);
	} 
}

/**
 * 编辑页面_设置连线
 * @return
 */
function setMappConn() {
	var connInfo = $("textarea[name=fdImplRefData]").val();
	var connJson = eval(connInfo);
	for (var connRow in connJson) {
		var sourceEndpoints = jsPlumb.getEndpoints($("#"+ connJson[connRow].sourceId));
		var targetEndpoints = jsPlumb.getEndpoints($("#"+ connJson[connRow].targetId));
		//alert(document.getElementById(connJson[connRow].sourceId)+"---sourceEndpoints="+sourceEndpoints+"---targetEndpoints="+targetEndpoints);
		if (sourceEndpoints != null && targetEndpoints != null) {
			jsPlumb.connect({source:sourceEndpoints[0],target:targetEndpoints[0]});
		}
	}
}
 
var IfaceImplValid = {
	init : function() {
		FUN_AppendValidSign("fdName", "tibSysCoreIfaceId", "fdImplRefName");
	},
	save : function() {
		var fdName = $("input[name=fdName]").val();
		var tibSysCoreIfaceId = $("select[name=tibSysCoreIfaceId]").val();
		var fdImplRefName = $("input[name=fdImplRefName]").val();
		var fdOrderBy = $("input[name=fdOrderBy]").val();
		if (!fdName) {
			alert(TibProvider_Lang.fdName);
			return false;
		} else if(isNaN(fdOrderBy)) {
			alert(TibProvider_Lang.fdOrderBy);
			return false;
		} else if(!tibSysCoreIfaceId) {
			alert(TibProvider_Lang.tibSysCoreIfaceId);
			return false;
		} else if(!fdImplRefName) {
			alert(TibProvider_Lang.fdImplRefName);
			return false;
		} else {
			return true;
		}
	}
		
};
 
 

