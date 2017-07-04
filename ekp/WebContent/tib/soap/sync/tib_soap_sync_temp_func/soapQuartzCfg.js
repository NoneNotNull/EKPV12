
var CFG_INFO = {
	FD_SOAP_XML : "",
	CLASSNAME : {
		INPUT_EDIT : "inputsgl",
		INPUT_VIEW : "inputread"
	}
};

//全局变量,用来保存窗口传过来的window.dialogArguments 参数
var Args_Dialog = {};
$(document).ready(function() {
	Args_Dialog = window.dialogArguments;
	// 设置页面默认数据及样式
	initPage();
});

//设置页面默认数据及样式
function initPage() {
	// 函数
	if ("" != Args_Dialog.fdSoapMainId) {
		$("#fdSoapMainId").val(Args_Dialog.fdSoapMainId);
		$("#fdSoapMainName").val(Args_Dialog.fdSoapMainName);
	}
	if ("" != Args_Dialog.fdLastDate) {
		$("#fdLastDate").html(Args_Dialog.fdLastDate);
	}
	// xml表格加载
	if ("" != Args_Dialog.fdSoapXml) {
		loadTableXML(Args_Dialog.fdSoapXml);
	}
	if ("edit" == Args_Dialog.cfg_model) {
		$("#fdSoapMainName").addClass(CFG_INFO.CLASSNAME.INPUT_EDIT);
	} else {
		$("#fdSoapMainName").addClass(CFG_INFO.CLASSNAME.INPUT_VIEW);
	}
	//加载数据源
	if ("" != Args_Dialog.fdCompDbcpId) {
		loadDBList(Args_Dialog.fdCompDbcpId, false);
	} else {
		loadDBList("", true);
	}
	
	
}

/**
* 加载数据源
* 
* @param {} defaultValue 选中默认值,
* @param {} showSelect 是否出现请选择
*/
function loadDBList(defaultValue, showSelect) {
	$.ajax({
		type : "post",
		url : Com_Parameter.ContextPath
				+ 'tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=getDBList',
		beforeSend : function(XMLHttpRequest) {
			$.cover.show();
		},
		complete : function(XMLHttpRequest, textStatus) {
			$.cover.hide();
		},
		success : function(data) {
			// 添加数据库数据
			var options = [];
			$.each(data, function(index, item) {
				item = eval("(" + item + ")");
				options.push({
					name : item.fdName,
					val : item.compId
				});
			});
			addOptions($("#dbselect"), options, defaultValue, showSelect);
		},
		error : function() {
			alert("加载数据发生错误");
			$.cover.hide();
		},
		dataType : "json"
	});
}

/**
* 添加下拉选项
* @param {}  target 目标DOM
* @param {}  options [{name: val }] 选项
* @param {}  defaultValue 默认value
* @param {}  showSelect 是否显示请选择
* @return {} target DOM
*/
function addOptions(target, options, defaultValue, showSelect) {
	if (showSelect) {
		var option = "<option value ='' >==请选择==</option>";
		$(target).prepend(option);
	}
	for (var i = 0, len = options.length; i < len; i++) {
		var option = "<option value ='" + options[i].val + "' >"
				+ options[i].name + "</option>";
		$(target).append(option);
	}
	if (defaultValue) {
		$(target).val(defaultValue);
	} else {
		$(target).val("");
	}
	if ("view" == Args_Dialog.cfg_model) {
		$(target).attr("disabled", "true");
	}
	return target;
}

// 选择函数change事件
function soapFuncChange(bindId, bindName) {
	var bindValue = $("#"+bindId).val();
	Dialog_TreeList(false, bindId, bindName, ';',
			'tibSoapMappingFuncTreeListService&selectId=!{value}&type=cate',
			'函数分类',
			'tibSoapMappingFuncTreeListService&selectId=!{value}&type=func',
			function(rtnData) {
				var defaultValue = rtnData.GetHashMapArray()[0]["id"];
				// 加载XML方法
				loadXmlTree(bindValue, defaultValue);
			},  'tibSoapMappingFuncTreeListService&type=search&keyword=!{keyword}',
			null, null, null, '选择函数'
	);
}

/**
* 重新加载xml数据触发方法
* @param {} rfcDomId
* @param {} def
*/
function loadXmlTree(bindValue, defaultValue) {
   	if (defaultValue != bindValue) {
   		$.cover.show();
   		var data = new KMSSData();
   		data.SendToBean("tibSoapMappingFuncXmlService&fdSoapMainId=" + defaultValue,
   				loadTable);
	} else if(defaultValue != "") {
	    if(confirm("检测到当前函数与选择函数一致,是否重新加载数据")){
		    $.cover.show();
		    var data = new KMSSData();
		    data.SendToBean("tibSoapMappingFuncXmlService&fdSoapMainId=" + defaultValue,
				   loadTable);
	    }
	} 
}

/**
* 根据xml返回值重新加载页面
* @param {} rtnData
*/
function loadTable(rtnData) {
	if (rtnData.GetHashMapArray().length == 0) {
		$.cover.hide();
		return;	
	}
	if (rtnData.GetHashMapArray()[1]["MSG"] != "SUCCESS") {
		$.cover.hide();
		return;
	}
	var fdSoapXml = rtnData.GetHashMapArray()[0]["funcXml"];
	if(!fdSoapXml){ return ; }
	// 清空表格
	emptyData(); 
	// 加载表格
	loadTableXML(fdSoapXml);
	$.cover.hide();
}

// 加载xml数据
function loadTableXML(fdSoapXml) {
	CFG_INFO.FD_SOAP_XML = fdSoapXml;
    var soapXmlDom = XMLParseUtil.parseXML(fdSoapXml);
    loadTableXML_build(soapXmlDom,"tib_sys_soap_input","erp_query_template",getInputSchema(),"Input");
    loadTableXML_build(soapXmlDom,"tib_sys_soap_output","erp_query_outtemplate",getOutputSchema(),"Output");
    loadTableXML_build(soapXmlDom,"tib_sys_soap_falut","erp_query_faulttemplate",getFaultSchema(),"Fault");
    
    $(".erp_template").treeTable({
		initialState: "expanded"
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
function loadTableXML_build(dom, renderElement, templateId, schema, tagName){
	var renderDom = $(dom).find(tagName);
	// 组装schema
	ERP_parser.parseDom2Json(renderDom, schema, "erp-node");
	var template = $("#"+ templateId).html();
	if(!template){
		return ;
	}
	var in_html = Mustache.render(template, schema);
	$("#"+renderElement).append($(in_html));
	// 编辑下给同步方式赋值
	var syncTypes = $("select[name$=_syncType]");
	$.each(syncTypes, function(n, syncType){
		var nodeKey = $(syncType).attr("nodeKey");
		var commentValue = $(syncType).attr("commentValue");
		if (commentValue != "") {
			$(syncType).val(commentValue);
			syncTypeChange(commentValue, nodeKey);
		}
	});
	// 编辑下加载时间戳
	var syncType_dateObjs = $("select[name$=_syncType_date]");
	$.each(syncType_dateObjs, function(n, syncType_dateObj){
		var nodeKey = $(syncType_dateObj).attr("nodeKey");
		var commentValue = $(syncType_dateObj).attr("commentValue");
		// 获取映射值
		var options = getMappingValue(nodeKey);
		$(syncType_dateObj).empty();
		addOptions(syncType_dateObj, options, commentValue, true);
	});
	// 编辑下给删除条件赋值
	var fdDelConditionNames = $("input[name$=_fdDelConditionName]");
	$.each(fdDelConditionNames, function(n, fdDelConditionName){
		var commentValue = $(fdDelConditionName).attr("commentValue");
		$(fdDelConditionName).val(XMLParseUtil.decodeHtml(commentValue));
	});
	// 编辑下同步表
	var fdSyncTables = $("input[name$='_fdSyncTable']");
	$.each(fdSyncTables, function(n, fdSyncTable){
		var nodeKey = $(fdSyncTable).attr("nodeKey");
		var commentValue = $(fdSyncTable).attr("commentValue");
		if (commentValue != "") {
			$(fdSyncTable).val(commentValue);
			syncTableChange_back_loadColumn(commentValue, Args_Dialog.fdCompDbcpId, nodeKey);
		}
	});
	// 编辑下给渲染表格下拉列表框赋值
	var inputSelectObjs = $("select[name$='_inputSelect']");
	$.each(inputSelectObjs, function(n, obj){
		var commentValue = $(obj).attr("commentValue");
		if ("" != commentValue) {
			$(obj).val(commentValue);
		}
	});
	
}

// 获取映射值
function getMappingValue(nodeKey) {
	var selectMappingObjs = $("select[name$='_mappingValue'][name^='"+ nodeKey +"-']");
	var options = [];
	// 明细表包含明细表的标识
	var flagKey = "";
	for (var i = 0, len = selectMappingObjs.length; i < len; i++) {
		var nodeKey = $(selectMappingObjs[i]).attr("nodeKey");
		if (flagKey != "" && nodeKey.indexOf(flagKey) > -1) {
			continue;
		}
		if ($(selectMappingObjs[i]).attr("isMore") == "true") {
			flagKey = nodeKey;
			continue;
		}
		var option = {};
		var nodeName = $(selectMappingObjs[i]).attr("nodeName");
		option.name = nodeName;
		option.val = nodeName;
		options.push(option);
	}
	return options;
}

// 删除条件公式定义器click事件
function conditionImgClick(bindId, bindName, nodeKey){
	// 获取映射值
	var options = getMappingValue(nodeKey);
	var dialog = new KMSSDialog();
	dialog.formulaParameter = {
		varInfo : parseVarInfo(options),
		returnType : "Object"
	};
	dialog.BindingField(bindId, bindName);
	dialog.URL = Com_Parameter.ContextPath
			+ "tib/common/resource/plugins/quartz_dialog_edit.jsp";
	dialog.Show(850, 550);
}

/**
* 适应公式定义器校验 {name:val:} -->{name: label ：text：}
* 
* @param {}
*            varInfo
*/
function parseVarInfo(varInfo) {
	var parseRtn = [];
	if (varInfo) {
		for (var i = 0, len = varInfo.length; i < len; i++) {
			parseRtn.push({
						name : varInfo[i]["val"],
						label : varInfo[i]["val"],
						text : varInfo[i]["name"],
						type : "String"
					});
		}
	}
	return parseRtn;
}

// 选择同步方式change事件
function syncTypeChange(value, nodeKey) {
	if ("3" == value) {
		$("#"+ nodeKey +"_syncType_date").show();
		$("#"+ nodeKey +"_fdDelConditionName").val("");
		$("#"+ nodeKey +"_delConditionSpan").hide();
	} else if ("5" == value) {
		$("#"+ nodeKey +"_delConditionSpan").show();
		$("#"+ nodeKey +"_syncType_date").val("");
		$("#"+ nodeKey +"_syncType_date").hide();
	} else {
		$("#"+ nodeKey +"_syncType_date").val("");
		$("#"+ nodeKey +"_syncType_date").hide();
		$("#"+ nodeKey +"_fdDelConditionName").val("");
		$("#"+ nodeKey +"_delConditionSpan").hide();
	}
}

// 选择同步表change事件
function syncTableChange(bindId, bindName, nodeKey) {
	var fdSoapMainName = $("#fdSoapMainName").val();
	var dbId = $("#dbselect").val();
	 if("" == fdSoapMainName) {
		alert("请先选择函数名称！");
		return ;
	} else if("" == dbId) {
		alert("请先选择数据源！");
		return ;
	}
	Dialog_List(false, bindId, bindName, ";", "tibSoapSyncLoadDBTableService&dbId="
			+ dbId, function(rtnData) {syncTableChange_back(rtnData, dbId, nodeKey); }, 
			"tibSoapSyncLoadDBTableService&keyword=!{keyword}&dbId="+ dbId, null, null, "选择数据库表");
}

function syncTableChange_back(rtnData, dbId, nodeKey) {
	var tableName = rtnData.GetHashMapArray()[0]["name"];
	// 加载数据库表的列字段出来
	syncTableChange_back_loadColumn(tableName, dbId, nodeKey);
}

// 加载数据库表的列字段出来（新增和编辑都可调用）
function syncTableChange_back_loadColumn(tableName, dbId, nodeKey) {
	var selectMappingObjs = $("select[name$='_mappingValue'][name^='"+ nodeKey +"']");
	var data = {
		dbId : dbId,
		table : tableName
	};
	$.post(Com_Parameter.ContextPath + 'tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do?method=getFieldList',
		{data : JSON.stringify(data)}, 
		function(data) {
			var options = [];// {name:"当前执行时间", val:"1"}
			var options_column = [];
			if (data["MSG"]) {
				alert("加载出错！");
				return;
			} else {
				$.each(data, function(index, item) {
					item = eval("(" + item + ")");
					options_column.push({
						name : item.fieldName
								+ "("
								+ item.dataType
								+ ")",
						val : item.fieldName
					});
					options.push({
						name : item.fieldName
								+ "("
								+ item.dataType
								+ ")",
						val : item.fieldName
					});
				});
			}
			for (var i = 0, len = selectMappingObjs.length; i < len; i++) {
				// if ($(selectMappingObjs[i]).attr("name") != nodeKey +"_mappingValue" 
				//	 	&& $(selectMappingObjs[i]).attr("isMore") == "true") {
				// 		continue;
				// }
				var defaultValue = $(selectMappingObjs[i]).attr("commentValue");
				$(selectMappingObjs[i]).empty();
				if ($(selectMappingObjs[i]).attr("name").indexOf("_key") > -1
						|| $(selectMappingObjs[i]).attr("name").indexOf("_generateFdId") > -1) {
					addOptions(selectMappingObjs[i], options_column, defaultValue, true);
				} else {
					addOptions(selectMappingObjs[i], options, defaultValue, true);
				}
			}
		}, 'json'
	);
}

// 传入参数映射值change时间
function inputSelectChange(thisValue, nodeKey) {
	if ("1" == thisValue) {
		$("#"+ nodeKey +"_inputText").show();
	} else {
		$("#"+ nodeKey +"_inputText").hide();
	}
}


function getInputSchema(){

	var m_info_in = {
		info : {
			caption : "",
			thead : [{th : "传入参数"}, 
					{th : "数据类型"}, 
					{th : "数量"}, 
					{th : "映射字段"},
					{th : "备注"}
					],
			tbody : []
		}
	};
	return m_info_in;
}

function getOutputSchema(){
	var m_info_out = {
		info : {
			caption : "",
			thead : [{th : "输出参数"}, 
			        {th : "数据类型"}, 
					{th : "数量"}, 
					{th : "映射字段"},
					{th : "备注"}
					],
			tbody : []
		}
	};
	return m_info_out;
}

function getFaultSchema(){
	var m_info_out = {
		info : {
			caption : "",
			thead : [{th : "错误参数"}, 
			        {th : "数据类型"}, 
					{th : "数量"}, 
					{th : "映射字段"},
					{th : "备注"}
					],
			tbody : []
		}
	};
	return m_info_out;
}

// 清空数据
function emptyData(){
	$("#tib_sys_soap_input").empty();	
	$("#tib_sys_soap_output").empty();	
	$("#tib_sys_soap_falut").empty();	
}

// 提交定时任务配置的信息
function submitSoapQuartzCfg() {
	if (!CFG_INFO.FD_SOAP_XML || "" == $("#fdSoapMainName").val()) {
		alert("请选择函数名称！");
		return ;
	}
	var syncTypeObjs = $("select[name$='_syncType']");
	var flag = true;
	$.each(syncTypeObjs, function(index, obj) {
		if ($(obj).val() != "" && $(obj).val() != 2) {
			var nodeKey = $(obj).attr("nodeKey");
			var keyColumn = $("#"+ nodeKey +"_key_mappingValue").val();
			if ("" == keyColumn) {
				alert("非全量同步必须选择Key");
				flag = false;
				return;
			}
		}
	});
	if (flag) {
		var targetDom = ERP_parser.parseXml(CFG_INFO.FD_SOAP_XML);
		var key_elem_in = $("#tib_sys_soap_input").find("*[nodeKey]"); 
		var key_elem_out = $("#tib_sys_soap_output").find("*[nodeKey]"); 
		var key_elem_fault = $("#tib_sys_soap_falut").find("*[nodeKey]"); 
		tibSoapSyncResetComment(key_elem_in, targetDom, "Input");
		tibSoapSyncResetComment(key_elem_out, targetDom, "Output");
		tibSoapSyncResetComment(key_elem_fault, targetDom, "Fault");
		CFG_INFO.FD_SOAP_XML = targetDom.xml;
		// 设置弹出窗口参数值
		setArgs_Dialog();
		window.close();
	}
} 

function tibSoapSyncResetComment(elements,targetDom,targetName) {
	var m_dom = $(targetDom).find(targetName);
	$(elements).each(function(index, element){
		var nodeKey = $(element).attr("nodeKey");
		var commentName = $(element).attr("commentName");
		if (!nodeKey) {
			return ;
		}
		var node = ERP_parser.getTargetNodeByKey(nodeKey, null, m_dom, "erp-node-");
		// 获取注析代码
		var comment_str = ERP_parser.getCommentString(node);
		// 注析代码修改成对象
		var comment_info = ERP_parser.getCommentInfo(comment_str,
						ERP_parser.defalutCommentHandler);
		// 如果原来没有comment
		if(!comment_info){
			comment_info = {};
		}
		var type = $(element).attr("type");
		// 增加查看同步数据表信息clocal
		if ("fdSyncTable" == commentName) {
			var clocal = "2:"+ $("select[name='dbselect']").val() +":"+ $(element).val();
			$(node).attr("clocal", clocal);
		}
		// 增加注释属性
		if ("radio" == type) {
			comment_info[commentName] = $(element).prop("checked") ? "checked" : "";
		} else if ("fdDelConditionName" == commentName){
			comment_info[commentName] = Com_HtmlEscape($(element).val());
		} else {
			comment_info[commentName] = $(element).val();
		}
		// 设置注释代码
		ERP_parser.setNodeComment(node, comment_info);
	});
}

//设置弹出窗口参数值
function setArgs_Dialog() {
	Args_Dialog.fdSoapXml = CFG_INFO.FD_SOAP_XML;
	Args_Dialog.fdSoapMainId = $("#fdSoapMainId").val();
	Args_Dialog.fdSoapMainName = $("#fdSoapMainName").val();
	Args_Dialog.fdCompDbcpId = $("#dbselect").val();
	Args_Dialog.fdCompDbcpName = $("#dbselect").find("option:selected").text();
	var fdSyncTables = $("input[name$=_fdSyncTable]");
	var fdSyncTableXpath = new Array();
	$.each(fdSyncTables, function(n, fdSyncTable){
		var fdSyncTableVal = $(fdSyncTable).val();
		if (fdSyncTableVal != "") {
			fdSyncTableXpath.push($(fdSyncTable).attr("xpath"));
		}
	});
	Args_Dialog.fdSyncTableXpath = fdSyncTableXpath.join(",");
}




