/**
 * JDBC模版转JSON
 * @param templateStr
 * @return
 */
function JDBC_TemplateToJson(templateStr, nodeKey) {
	//alert("templateStr="+templateStr);
	var templateJson = $.parseJSON(templateStr);
	var tbody_in = templateJson["in"];
	for (var i = 0; i < tbody_in.length; i++) {
		tbody_in[i]["parentKey"] = nodeKey;
		tbody_in[i]["nodeKey"] = nodeKey +"-"+ (i + 1);
		tbody_in[i]["hasNext"] = false;
		tbody_in[i]["root"] = false;
		tbody_in[i]["required"] = tbody_in[i]["required"] ? tbody_in[i]["required"] : "";
	}
	var tbody_out = templateJson["out"];
	for (var j = 0; j < tbody_out.length; j++) {
		tbody_out[j]["parentKey"] = nodeKey;
		tbody_out[j]["nodeKey"] = nodeKey +"-"+ (j + 1);
		tbody_out[j]["hasNext"] = false;
		tbody_out[j]["root"] = false;
		tbody_out[j]["disp"] = tbody_out[j]["disp"] ? tbody_out[j]["disp"] : "";
	}
	TIB_TemplateXml = JSON.stringify(templateJson);
	return templateJson;
}

/**
 * 保存前存数据操作
 * @param templateStr
 * @param nodeKey
 * @param fdDataName
 * @return
 */
function JDBC_Submit(elementInId, elementOutId, templateJson, nodeKey, fdDataName) {
	var templateJsonObj = $.parseJSON(templateJson);
	var tbody_in = templateJsonObj["in"];
	for (var i = 0; i < tbody_in.length; i++) {
		var curInNodeKey = tbody_in[i]["nodeKey"];
		var isRequired = $("#"+ elementInId +" input[nodeKey='"+ curInNodeKey +"']").prop("checked");
		tbody_in[i]["required"] = isRequired ? "checked" : "";
	}
	var tbody_out = templateJsonObj["out"];
	for (var j = 0; j < tbody_out.length; j++) {
		var curOutNodeKey = tbody_out[j]["nodeKey"];
		var disp = $("#"+ elementOutId +" select[nodeKey='"+ curOutNodeKey +"']").val();
		tbody_out[j]["disp"] = disp;
	}
	$("textarea[name='"+ fdDataName +"']").text(JSON.stringify(templateJsonObj));
}
