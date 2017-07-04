/**
 * SOAP模版转JSON
 * @param templateXml
 * @return
 */
function SOAP_TemplateToJson(templateXml, nodeKey) {
	//alert("soapTemplateXml2="+templateXml);
	var templateIn = $(XML_CreateByContent(templateXml)).find("Input soap\\:Envelope soap\\:Body,Input soapenv\\:Envelope soapenv\\:Body").children();
	var templateOut = $(XML_CreateByContent(templateXml)).find("Output soap\\:Envelope soap\\:Body,Output soapenv\\:Envelope soapenv\\:Body").children();
	var templateJson = {};
	var tbody_in = [];
	var tbody_out = [];
	SOAP_LoopSetJson(templateIn, tbody_in, true, nodeKey);
	SOAP_LoopSetJson(templateOut, tbody_out, true, nodeKey);
	templateJson["in"] = tbody_in;
	templateJson["out"] = tbody_out;
	return templateJson;
}

/**
 * 循环遍历，获取JSON
 * @param templateObjs
 * @param tbody
 * @return
 */
function SOAP_LoopSetJson(templateObjs, tbody, isRoot, nodeKey) {
	//alert("$(templateObjs).length="+$(templateObjs).length);
	$(templateObjs).each(function(index, thisObj){
		var tagName = $(thisObj)[0].tagName;
		//alert("--tagName="+tagName+",index="+index);
		var commentStr = SOAP_GetCommentString(thisObj);
		var ctype = "", required = "", disp = "";
		// 取出注释包含的属性值
		if (null != commentStr) {
			var soap_comment = SOAP_DefalutCommentHandler(commentStr);
			//alert("ekp_comment.ctype="+ekp_comment.ctype);
			ctype = SOAP_DataTypeHandler(soap_comment, thisObj);
			required = soap_comment["required"] ? soap_comment["required"] : "";
			disp = soap_comment["disp"] ? soap_comment["disp"] : "";
			//alert("required="+required+",disp="+disp);
		}
		var tbody_tr = {"tagName" : tagName, "ctype" : ctype, "parentKey" : nodeKey,
				"required" : "false", "hasNext" : true, "root" : isRoot, "required" : required,
				"disp" : disp, "nodeKey" : nodeKey +"-"+ (index + 1)};
		var childrenObjs = $(thisObj).children();
		if ($(childrenObjs).length > 0) {
			if (undefined == tagName) {
				SOAP_LoopSetJson(childrenObjs, tbody, false, nodeKey);
				return true;
			}
			tbody.push(tbody_tr);
			SOAP_LoopSetJson(childrenObjs, tbody, false, nodeKey +"-"+ (index + 1));
		} else {
			if (undefined == tagName) {
				return true;
			}
			tbody_tr["hasNext"] = false;
			tbody.push(tbody_tr);
		}
		return true;
	});
}
 
function SOAP_GetCommentString(dom) {
	if (SOAP_HasComment(dom)) {
		var preNode = dom.previousSibling;
		// 为了兼容火狐，跳过 一个换行节点
		if (preNode.nodeType != 8) {
			preNode = preNode.previousSibling;
		} 
		return preNode.nodeValue;
	}
}

function SOAP_HasComment(dom) {
	if (dom) {
		var preNode = dom.previousSibling;
		if (preNode) {
			// 为了兼容火狐
			if (preNode.nodeType == 3) {
				preNode = preNode.previousSibling;
				if (preNode && preNode.nodeType == 8) {
					return true;
				}
			} else if (preNode.nodeType == 8) {
				return true;
			}
		}
	}
	return false;
}

function SOAP_GetCommentInfo(str, handler) {
	var result;
	if (str) {
		result = handler.apply(this, [str]);
	}
	return result;
}

/***********************************************************************
* 默认注释解析器 用于getCommentInfo
* 
* @param {}
*            str 字符串
*/
function SOAP_DefalutCommentHandler(str) {
	var def_begin = "|erp_web=";
	if (str) {
		if (str.lastIndexOf(def_begin) > 0) {
			var start = str.lastIndexOf(def_begin) + def_begin.length;
			var result = str.substring(start, str.length);
			if (result) {
				return eval('(' + result + ')');
			}
		} else{
			try{
				return eval('(' + str + ')');
			}catch(e){
				return null;
			}
		}
	}
	return null;
}

/***********************************************************************
* 获取数据类型描述
* @param {} commentObject 注析json对象
* @param {} dom xml节点
* @return {String} 类型描述
*/
function SOAP_DataTypeHandler(commentObject, dom) {
	// 有无ctype属性
	if (commentObject && commentObject["ctype"]) {
		return commentObject["ctype"];
	} else if (commentObject) {
		// 有子节点
		if (dom && $(dom).children() && $(dom).children().length > 0) {
			// 如果存在数量
			if (commentObject["maxOccurs"]) {
				if (commentObject["maxOccurs"] == "unbound"
						|| commentObject["maxOccurs"] > 1) {
					return "明细表";
				} else if (commentObject["maxOccurs"] == 1) {
					return "对象类型";
				}
			}
		} else {
			// 没有子节点的情况下
			if (commentObject["maxOccurs"]) {
				if (commentObject["maxOccurs"] == "unbound"
						|| commentObject["maxOccurs"] > 1) {
					if (commentObject["ctype"]) {
						return "多值字段(" + commentObject["ctype"] + ")";
					} else {
						return "多值字段";
					}
				} else {
					if (commentObject["ctype"]) {
						return commentObject["ctype"];
					} else {
						return "未知简单类型";
					}
				}
			}
		}
	}
	// 没有判断就
	return "";
}

/**
* 保存前存数据操作
* @param templateStr
* @param nodeKey
* @param fdDataName
* @return
*/
function SOAP_Submit(elementInId, elementOutId, templateXml, nodeKey, fdDataName) {
	var templateXmlObj = XML_CreateByContent(templateXml);
	var templateIn = $(templateXmlObj).find("Input soap\\:Envelope soap\\:Body,Input soapenv\\:Envelope soapenv\\:Body").children();
	var templateOut = $(templateXmlObj).find("Output soap\\:Envelope soap\\:Body,Output soapenv\\:Envelope soapenv\\:Body").children();
	SOAP_ResetComment($("#"+ elementInId).find("*[nodeKey]"), templateIn, nodeKey, fdDataName);
	SOAP_ResetComment($("#"+ elementOutId).find("*[nodeKey]"), templateOut, nodeKey, fdDataName);
	$("textarea[name='"+ fdDataName +"']").text(TibUtil.XML2String(templateXmlObj).replace(/(\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029))/g, ""));
}

function SOAP_ResetComment(elements, templateObj, nodeKey, fdDataName) {
	$(elements).each(function(index, element){
		var curNodeKey = $(element).attr("nodeKey");
		var commentName = $(element).attr("commentName");
		if (!curNodeKey) {
			return;
		}
		var node = getTargetNodeByKey(curNodeKey, null, templateObj, nodeKey);
		// 获取注析代码
		var comment_str = getCommentString(node);
		// 注析代码修改成对象
		var comment_info = getCommentInfo(comment_str, defalutCommentHandler);
		// 如果原来没有comment
		if(!comment_info){
			comment_info = {};
		}
		var type = $(element).attr("type");
		// 增加注释属性
		if ("checkbox" == type) {
			comment_info[commentName] = $(element).prop("checked") ? "checked" : "";
		} else {
			comment_info[commentName] = $(element).val();
		}
		// 设置注释代码
		setNodeComment(node, comment_info);
	});
}

function getCommentString(dom) {
	if (hasComment(dom)) {
		var preNode = dom.previousSibling;
		// 为了兼容火狐，跳过 一个换行节点
		if (preNode.nodeType != 8) {
			preNode = preNode.previousSibling;
		} 
		return preNode.nodeValue;
	}
}

function hasComment(dom) {
	if (dom) {
		var preNode = dom.previousSibling;
		if (preNode) {
			// 为了兼容火狐
			if (preNode.nodeType == 3) {
				preNode = preNode.previousSibling;
				if (preNode && preNode.nodeType == 8) {
					return true;
				}
			} else if (preNode.nodeType == 8) {
				return true;
			}
		}
	}
	return false;
}

function getCommentInfo(str, handler) {
	var result;
	if (str) {
		result = handler.apply(this, [str]);
	}
	return result;
}

/***********************************************************************
* 默认注释解析器 用于getCommentInfo
* @param {}
*            str 字符串
*/
function defalutCommentHandler(str) {
	var def_begin = "|erp_web=";
	if (str) {
		if (str.lastIndexOf(def_begin) > 0) {
			var start = str.lastIndexOf(def_begin) + def_begin.length;
			var result = str.substring(start, str.length);
			if (result) {
				return eval('(' + result + ')');
			}
		} else{
			try{
				return eval('(' + str + ')');
			}catch(e){
				return null;
			}
		}
	}
	return null;
}

function setNodeComment(node, commentObject) {
	if (!commentObject) {
		return;
	}

	if (hasComment(node)) {
		// 获得当前node 的字符
		var comment_str = getCommentString(node);
		var comment_info = getCommentInfo(comment_str,
				defalutCommentHandler);
		var comment_sum = mergeInfo(comment_info, commentObject);
		var str = JSON.stringify(comment_sum);
		var preNode = node.previousSibling;
		var preStr = "";
		if (comment_str.lastIndexOf("|erp_web=") >= 0) {
			var l_index = comment_str.lastIndexOf("|erp_web=");
			preStr = comment_str.substring(0, l_index
							+ "|erp_web=".length);
		} else {
			preStr = comment_str == null ? "|erp_web=" : comment_str +"|erp_web=";
		}
		var all = preStr + str;
		setNodeText(preNode, all);
	} else {
		var curDocument=node.ownerDocument;
		var str = JSON.stringify(commentObject);
		var comment=curDocument.createComment(str);
		$(comment).insertBefore($(node));
	}
}

function mergeInfo(source, extend) {
	if (!source||!(typeof source == 'object')) {
		source = extend;
	}
	if (!extend||!(typeof extend == 'object')) {
		extend = source;
		return source;
	}
	if (typeof source == 'object' && typeof extend == 'object') {
		for (var p in extend) {
			source[p] = extend[p];
		}
	}
	return source;
}

function setNodeText(node, text) {
	 if (!!window.ActiveXObject || "ActiveXObject" in window) {
		 node.text = text || "";
	 } else{
		 node.textContent =text ||"";
	 }
	return node;
}