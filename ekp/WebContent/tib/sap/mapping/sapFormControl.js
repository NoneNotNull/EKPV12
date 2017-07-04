/**
 * SAP模版转JSON
 * @param templateXml
 * @return
 */
function SAP_TemplateToJson(templateXml, nodeKey) {
	//alert("templateXml="+templateXml);
	var templateIn = $(XML_CreateByContent(templateXml)).find("import,table[isin='1']");
	var templateOut = $(XML_CreateByContent(templateXml)).find("export,table[isin='0']");
	var templateJson = {};
	var tbody_in = [];
	var tbody_out = [];
	SAP_LoopSetJson(templateIn, tbody_in, true, nodeKey);
	SAP_LoopSetJson(templateOut, tbody_out, true, nodeKey);
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
function SAP_LoopSetJson(templateObjs, tbody, isRoot, nodeKey) {
	$(templateObjs).each(function(index, thisObj){
//		var curIsin = $(thisObj).attr("isin");
//		if (curIsin && curIsin != isin) {
//			return true;
//		}
		var tagName = $(thisObj).attr("name");
		//alert("--tagName="+tagName+",index="+index);
		var ctype = $(thisObj).attr("ctype");
		var isoptional = $(thisObj).attr("isoptional");
		var disp = $(thisObj).attr("disp") ? $(thisObj).attr("disp") : "";
		var tbody_tr = {"tagName" : tagName, "ctype" : ctype, "parentKey" : nodeKey,
				"required" : isoptional == "true" ? "checked" : "",
				"disp" : disp, "hasNext" : true, "root" : isRoot, "nodeKey" : nodeKey +"-"+ (index + 1)};
//		var curNodeKey = nodeKey;
//		if (!isRoot) {
//			curNodeKey = nodeKey +"-"+ (index + 1);
//			tbody_tr["nodeKey"] = curNodeKey;
//		}
		var childrenObjs = $(thisObj).children();
		if ($(childrenObjs).length > 0) {
			if (undefined == tagName) {
				SAP_LoopSetJson(childrenObjs, tbody, false, nodeKey +"-"+ (index + 1));
				return true;
			}
			tbody.push(tbody_tr);
			SAP_LoopSetJson(childrenObjs, tbody, false, nodeKey +"-"+ (index + 1));
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
 
/**
 * 保存前存数据操作
 * @param templateStr
 * @param nodeKey
 * @param fdDataName
 * @return
 */
function SAP_Submit(elementInId, elementOutId, templateXml, nodeKey, fdDataName) {
// 	var tbody_in = templateJson["in"];
// 	for (var i = 0; i < tbody_in.length; i++) {
// 		var curInNodeKey = tbody_in[i]["nodeKey"];
// 		var isRequired = $("#"+ inDivId +" input[nodeKey='"+ curInNodeKey +"']").prop("checked");
// 		tbody_in[i]["required"] = isRequired ? "checked" : "";
// 	}
// 	var tbody_out = templateJson["out"];
// 	for (var j = 0; j < tbody_out.length; j++) {
// 		var curOutNodeKey = tbody_out[j]["nodeKey"];
// 		var disp = $("#"+ outDivId +" select[nodeKey='"+ curOutNodeKey +"']").val();
// 		tbody_out[j]["disp"] = disp;
// 	}
// 	$("textarea[name='"+ fdDataName +"']").text(JSON.stringify(templateJson));
 	var templateXmlObj = XML_CreateByContent(templateXml);
 	var templateIn = $(templateXmlObj).find("import,table[isin='1']");
	var templateOut = $(templateXmlObj).find("export,table[isin='0']");
	SAP_ResetAttr($("#"+ elementInId).find("*[nodeKey]"), templateIn, nodeKey, fdDataName);
	SAP_ResetAttr($("#"+ elementOutId).find("*[nodeKey]"), templateOut, nodeKey, fdDataName);
	$("textarea[name='"+ fdDataName +"']").text(TibUtil.XML2String(templateXmlObj).replace(/(\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029))/g, ""));
}
 
function SAP_ResetAttr(elements, templateObj, nodeKey, fdDataName) {
	$(elements).each(function(index, element){
		var curNodeKey = $(element).attr("nodeKey");
		var commentName = $(element).attr("commentName");
		if (!curNodeKey) {
			return;
		}
		var node = getTargetNodeByKey(curNodeKey, null, templateObj, nodeKey);
		var type = $(element).attr("type");
		// 增加注释属性
		if ("checkbox" == type) {
			$(node).attr("isoptional", $(element).prop("checked") ? "true" : "false");
		} else {
			$(node).attr(commentName, $(element).val());
		}
	});
}

  