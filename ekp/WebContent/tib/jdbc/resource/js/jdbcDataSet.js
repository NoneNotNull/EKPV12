$(function(){
	sqlPreview();
});
/**
 * 预览SQL语句得出的结果
 * @return
 */
function sqlPreview() {
	var fdData = $("textarea[name='fdData']").val();
	if (fdData != "") {
		// 编辑下的用法
		var fdDataObj = $.parseJSON(fdData);
		sqlPreview_extract(fdDataObj["in"], fdDataObj["out"]);
	} else {
		// 点抽取结构的用法
		var fdDataSource = $("select[name='fdDataSource']").val();
		var fdSqlExpression = $("textarea[name='fdSqlExpression']").val();
		if ("" == fdSqlExpression) {
			return;
		}
		if ("" == fdDataSource || ""){
			alert("请填写数据源或SQL语句!");
			return;
		}
		$.blockUI.defaults.overlayCSS.opacity='.3';
		$.blockUI({message:"<h3>正在努力加载数据...</h3>"});
		var data = new KMSSData();
		data.SendToBean("tibJdbcDataSetParamBean&fdDataSource="+ fdDataSource +
				"&fdSqlExpression="+ fdSqlExpression, 
				function(rtnData){sqlPreview_back(rtnData, fdSqlExpression);});
	}
}

function sqlPreview_back(rtnData, fdSqlExpression) {
	var outObjs = rtnData.GetHashMapArray();
	$.unblockUI();
	if (outObjs[0]["error"]) {
		alert("数据源连接出错，错误信息为："+ outObjs[0]["error"]);
		return;
	}
	var tbody_in = getInputParamtersBySQL(fdSqlExpression, outObjs);
	var tbody_out = [];
	for (var i = 0; i < outObjs.length; i++) {
		var columnObj = {};
		var outObj = outObjs[i];
		if ("true" == outObj.isOut) {
			columnObj["tagName"] = outObj.tagName;
			columnObj["ctype"] = outObj.ctype;
			columnObj["length"] = outObj.length;
			tbody_out.push(columnObj);
		}
	}
	sqlPreview_extract(tbody_in, tbody_out);
}

/**
 * 预览抽取结构
 * @param rtnData
 * @param fdSqlExpression
 * @return
 */
function sqlPreview_extract(tbody_in, tbody_out) {
	var info_in = {
		info : {
			caption : "",
			thead : [{th : "传入参数"}, 
					{th : "数据类型"},
					{th : "是否必填"}
					],
			tbody : tbody_in
		}
	};
	var info_out = {
		info : {
			caption : "",
			thead : [{th : "传出参数(列名)"}, 
			         {th : "数据类型"},
			         {th : "显示顺序"}
			],
			tbody : tbody_out
		}
	};
	$("#jdbc_data_set_in").empty();
	$("#jdbc_data_set_out").empty();
	loadTableXML_build("jdbc_data_set_in", "jdbc_data_set_template_in", info_in);
	loadTableXML_build("jdbc_data_set_out", "jdbc_data_set_template_out", info_out);
	// 存数据结构到表单字段
	var tibObj = {"in" : tbody_in, "out" : tbody_out};
	$("textarea[name='fdData']").text(JSON.stringify(tibObj));
	// 初始化顺序字段
	var dispObjs = $("select[name='disp']");
	var len = $(dispObjs).length;
	var optionArray = new Array();
	optionArray.push("<option value=''>=请选择=</option>");
	for (var i = 1; i <= len; i++) {
		if (i == 1) {
			optionArray.push("<option value='1'>1(显示值)</option>");
		} else if (i == 2) {
			optionArray.push("<option value='2'>2(实际值)</option>");
		} else if (i == 3) {
			optionArray.push("<option value='3'>3(描述值)</option>");
		} else {
			optionArray.push("<option value='"+ i +"'>"+ i +"</option>");
		}
	}
	$(dispObjs).html(optionArray);
	$("select[name='disp'][defaultValue!='']").each(function(){
		var defaultValue = $(this).attr("defaultValue");
		$(this).val(defaultValue);
	});
}

/**
* 重新勾画xml
* @param {} dom
* @param {} renderElement
* @param {} templateId
* @param {} schema
* @param {} tagName
*/
function loadTableXML_build(renderElement, templateId, infoObj){
	var template = $("#"+ templateId).html();
	if(!template){
		return ;
	}
	var htmlObj = Mustache.render(template, infoObj);
	$("#"+renderElement).append($(htmlObj));
}

//根据SQL语句，获得输入参数
function getInputParamtersBySQL(fdSqlExpression, outObjs) {
	// 查找相应的参数
	var rtnArr = fdSqlExpression.match(/\s(\S+)\s*:\s*(\S+)(\s|$)/g);
	if (rtnArr == null) return null;
	var rtnResult = new Array();
	for (var i = 0, alength = rtnArr.length; i < alength; i++) {
		var columnArr = rtnArr[i].split(":"); 
		var columnObj = {};
		for (var j = 0; j < outObjs.length; j++) {
			var outObj = outObjs[j];
			var columnName = columnArr[0].trim().replace(/=/g, "").replace(/>/g, "")
				.replace(/</g, "");
			if (outObj.tagName == columnName) {
				columnObj["columnName"] = outObj.tagName;
				columnObj["tagName"] = columnArr[1].trim();
				columnObj["ctype"] = outObj.ctype;
				columnObj["length"] = outObj.length;
			}
		}
		rtnResult.push(columnObj);
	}
	return (rtnResult.length == 0) ? null : rtnResult;
};

function fdSqlExpression_change() {
	$("#jdbc_data_set_in").empty();
	$("#jdbc_data_set_out").empty();
	$("textarea[name='fdData']").empty();
}

/**
 * 提交之前的操作
 * @return
 */
function before_submit(method) {
	var fdData = $("textarea[name='fdData']").text();
	if (fdData == "") {
		alert("请抽取结构！");
		return;
	}
	// 保存值，（必填、显示顺序）
	var requiredObj = {};
	$("input[name='required']").each(function(i){
		requiredObj[$(this).attr("tagName")] = $(this).prop("checked") ? "checked" : "";
	});
	var dispObj = {};
	$("select[name='disp']").each(function(i){
		dispObj[$(this).attr("tagName")] = $(this).val();
	});
	var fdDataJson = JSON.parse($("textarea[name='fdData']").text());
	var fdDataInJson = fdDataJson["in"];
	for (var i = 0; i < fdDataInJson.length; i++) {
		fdDataInJson[i]["required"]=requiredObj[fdDataInJson[i].tagName];
	}
	var fdDataOutJson = fdDataJson["out"];
	for (var i = 0; i < fdDataOutJson.length; i++) {
		fdDataOutJson[i]["disp"]=dispObj[fdDataOutJson[i].tagName];
	}
	$("textarea[name='fdData']").text(JSON.stringify(fdDataJson));
	Com_Submit(document.tibJdbcDataSetForm, method);
}