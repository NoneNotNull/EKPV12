/**
 * (标记：代码可更优化,把重复动作合并) 基础类型配置
 */
CFG_TYPE = {
	// 配置样式
	CLASSNAME : {
		DEF_TD_TITLE_CLASSNAME : "td_normal_title",
		DEF_TABLE_CLASSNAME : "tb_normal",
		DEF_INPUT_EDIT_CLASSNAME : "inputsgl",
		DEF_INPUT_VIEW_CLASSNAME : "inputread"
	},
	// 配置dom
	DOM_CFG : {
		MAIN_TABLE : "rfcTabel"
	},
	// 配置阅读状态还是编辑状态
	MODEL : {
		MODEL_EDIT : "edit",
		MODEL_VIEW : "view"
	},
	GROUP : {
		G_DB_TABLE : 'ds_channel',
		G_TB_FIELD : 'tb_import_Field'
	}

};

//全局变量,用来保存窗口传过来的window.dialogArguments 参数
var FUNC_OBJECT = {};

//xml 中clocal 属性转换方法 {type:,id:,tbName:,timeStamp}-->type:id:tbName:timeStamp 的字符串
function Clocal2String(clocal) {

	var string = [clocal.type ? clocal.type : "", clocal.id ? clocal.id : "",
			clocal.tbName ? clocal.tbName : "",
			clocal.timeStamp ? clocal.timeStamp : ""].join(":");
	return string;
}

//xml 中clocal 属性转换方法type:id:tbName:timeStamp -->{type:,id:,tbName:,timeStamp} 的对象
function Clocal2Object(clocalString) {
	var clocal = {};
	if (!clocalString) {
		clocal["type"] = "";
		clocal["id"] = "";
		clocal["tbName"] = "";
		clocal["timeStamp"] = "";
		return clocal;
	};
	var array = clocalString.split(":");
	clocal["type"] = array[0] ? array[0] : "";
	clocal["id"] = array[1] ? array[1] : "";
	clocal["tbName"] = array[2] ? array[2] : "";
	clocal["timeStamp"] = array[3] ? array[3] : "";
	return clocal;
}

$(document).ready(function() {
	$.cover.show();
	initPage();
	$.cover.hide();
		// resetPage(CFG_TYPE.MODEL.MODEL_EDIT, "", true);
	});

/**
 * 查找xml中是否有配置clocal 
 * @return {} clocal 对象 
 */
function findClocalObject() {
	
		if (!XMLParseUtil.xmlDoc)
			return null;
			
		//var clocalNode = XMLParseUtil.getXMLRootNode().selectNodes("/jco//@clocal");
		var clocalNode = XMLParseUtil.getXMLRootNode().childNodes;
		if (clocalNode && clocalNode.length > 0) {
			for (var i = 0, len = clocalNode.length; i < len; i++) {
				if (clocalNode[i].nodeType == 1) {
					var clocalValue = clocalNode[i].getAttribute("clocal");
					if (clocalValue) {
						var clocal = Clocal2Object(clocalValue);
						return clocal;
					}
				}
			}
		}
		return null;
	}


//初始化页面
function initPage() {
	FUNC_OBJECT = window.dialogArguments;
	var defFunc = {};
	var model = FUNC_OBJECT.cfg_model
			&& FUNC_OBJECT.cfg_model == CFG_TYPE.MODEL.MODEL_EDIT
			? CFG_TYPE.MODEL.MODEL_EDIT
			: CFG_TYPE.MODEL.MODEL_VIEW;

	defFunc.id = FUNC_OBJECT.fdRfcSettingId;
	defFunc.name = FUNC_OBJECT.fdRfcSettingName;
	if (FUNC_OBJECT.fdRfcXml) {
		XMLParseUtil.parseXML(FUNC_OBJECT.fdRfcXml);
	}

	// XMLParseUtil.loadXML('test.xml');
	var clocal = findClocalObject();
	// 是否为初始状态,初始状态创建默认工具条，时间条,reset 状态仅仅更新xml模板的table
	if (true) {
		emptyMainTable(0);
		// model ,defFucn ,defdb,
		var toolsBar = createTitleTools(model, clocal ? clocal['id'] : '');
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(toolsBar);
		var timerBar = createTimeBar("最后执行时间", "timmer", 4,
				FUNC_OBJECT.fdEditorTime);
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(timerBar);
		// setInterval("timmer.innerHTML=new Date().toLocaleString()", 1000);
	}

	if (XMLParseUtil.xmlDoc) {
		//emptyMainTable(2);
		// XMLParseUtil.parseXML(xmlString);
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(createImportTable(
				"importTR", model, "传入参数"));
		// 加载默认值
		var importNodeInfo = getPartNodeInfo("import");
		var defClocal = null;
		if (importNodeInfo && !isEmptyObject(importNodeInfo)) {
			var importJs = XMLParseUtil.parseNode4Json(importNodeInfo.node);

			if (importJs && importJs["attr"] && importJs["attr"]["clocal"]) {
				defClocal = Clocal2Object(importJs["attr"]["clocal"]);
			}
		}
		var event_import = {
			data : {
				channel : "tb_import_Field",
				channelVal : 'true',
				dbId : 'dbselect',
				tableId : 'import_bar_id',
				model : model,
				defClocal : defClocal,
				isInit : true

			}
		}
//		重新为import 的内容加载下拉列表值
		reloadField(event_import);
		// tableId,channel,xpath
		writeDefVal("importTR", "tb_import_Field", "");

		createTable_IN(model, "传入表格", clocal);
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(createExportTable(
				"exportTR", model, "传出参数"));
		// 加载默认值
		var exportNodeInfo = getPartNodeInfo("export");
		var exClocal = null;
		if (exportNodeInfo && !isEmptyObject(exportNodeInfo)) {
			var exportJs = XMLParseUtil.parseNode4Json(exportNodeInfo.node);

			if (exportJs && exportJs["attr"] && exportJs["attr"]["clocal"]) {
				exClocal = Clocal2Object(exportJs["attr"]["clocal"]);
			}
		}
		var event_export = {
			data : {
				channel : "tb_export_Field",
				channelVal : 'true',
				dbId : 'dbselect',
				tableId : 'export_bar_id',
				model : model,
				defClocal : exClocal,
				isInit : true
			}
		}
		//		重新为export 的内容加载下拉列表值
		reloadField(event_export);
		// tableId,channel,xpath
		writeDefVal("exportTR", "tb_export_Field", "");
		createTable_OUT(model, "传出表格", clocal);
		writeDefTitle(defFunc, 'fdRfcSettingId', 'fdRfcSettingName');
	}
}

/**
 * 为页面上bapi函数选择按钮加载xml的默认值
 * @param {} defFunc 默认属性值 ({name:val})
 * @param {} func_Id  id绑定dom
 * @param {} func_Name  name绑定dom的
 */
function writeDefTitle(defFunc, func_Id, func_Name) {
	$("#" + func_Id).val(defFunc.id ? defFunc.id : '');
	$("#" + func_Name).val(defFunc.name ? defFunc.name : '');
}

/**
 * 创建ERROR div
 * 
 * @param {}
 *            id divID
 * @param {}
 *            text 显示文本
 * @param {}
 *            attrs 属性[{name: val:}]
 * @return {} DIV DOM
 */
function createErrorDiv(id, text, attrs) {
	var div = $("<div></div>").html(text).attr("id", id)
			.addClass("validation-advice");
	for (var i = 0, len = attrs.length; i < len; i++) {
		div.attr(attrs[i].name, attrs[i].val);
	}
	return div;
}
/**
 * 创建loading div
 * 
 * @param {}
 *            id divID
 * @param {}
 *            text 显示文本
 * @param {}
 *            attrs 属性[{name: val:}]
 * @return {} div DOM
 */
function createLoadingDiv(id, text, attrs) {

	var div = $("<div></div>").html(text).attr("id", id);
	var img = $("<img></img>");
	img.attr("alt", "等待加载...").attr(
			"src",
			Com_Parameter.ContextPath
					+ "resource/style/common/images/loading.gif");
	div.append(img);
	for (var i = 0, len = attrs.length; i < len; i++) {
		div.attr(attrs[i].name, attrs[i].val);
	}
	return div;
}

/**
 * 创建select节点 (专加载数据源)
 * 
 * @param {}
 *            id
 * @param {}
 *            options 选项 [{name: val}]
 * @param {}
 *            attrs [{name: val}]
 * @param {}
 *            event 事件 [{type:, data:{} ,fn: }]
 * @param {}
 *            defValue 选项默认值
 * @param {}
 *            showSelect 是否显示 ==请选择==
 * @param {}
 *            model edit or view 模式
 * @return {}
 */
function createSelectElementDB(id, options, attrs, events, defValue,
		showSelect, model) {
	var select = $("<select></select>").attr("id", id);
	if (options && options.length > 0) {
		// target,model, options, defValue, showSelect
		select = addOptions(select, model, options, '', false);
	}
	if (attrs && attrs.length > 0) {
		for (var i = 0, len = attrs.length; i < len; i++) {
			select = select.attr(attrs[i].name, attrs[i].val);
		}
	}
	if (events && !isEmptyObject(events)) {
		for (var j = 0, len = events.length; j < len; j++) {
			$(select).bind(events[j]["type"], events[j]["data"],
					events[j]["fn"]);
		}
	}
	// 加载数据源
	loadDBList(initDBList, [select, model, defValue, showSelect]);
	return select;
}

/**
 * 创建select节点 
 * 
 * @param {}
 *            id
 * @param {}
 *            options 选项 [{name: val}]
 * @param {}
 *            attrs [{name: val}]
 * @param {}
 *            event 事件 [{type:, data:{} ,fn: }]
 * @param {}
 *            defValue 选项默认值
 * @param {}
 *            showSelect 是否显示 ==请选择==
 * @param {}
 *            model edit or view 模式
 * @return {}
 */
function createSelectElement(id, options, attrs, events, defValue, showSelect,
		model) {
	var select = $("<select></select>").attr("id", id);;
	if (options) {
		// target,model, options, defValue, showSelect
		select = addOptions(select, model, options, defValue, showSelect);
	}
	if (attrs && attrs.length > 0) {
		for (var i = 0, len = attrs.length; i < len; i++) {
			select = select.attr(attrs[i].name, attrs[i].val);
		}
	}
	if (events && isEmptyObject(events)) {
		for (var j = 0, len = events.length; j < len; j++) {
			$(select).bind(events[j]["type"], events[j]["data"],
					events[j]["fn"]);
		}
	}
	// 加载数据源
	// loadDBList(initDBList, [select, model, defValue, showSelect]);
	return select;
}

/**
 * 创建select节点 (专加载数据库字段列表)
 * @param {} id  创建select的id
 * @param {} options 默认的options
 * @param {} attrs 创建select的属性[name:属性名,val:属性值]
 * @param {} events 绑定事件
 * @param {} defValue 默认选中值
 * @param {} showSelect 是否显示 ==选择==
 * @param {} model edit编辑模式 or view 模式
 * @return {}
 */
function createSelectElementField(id, options, attrs, events, defValue,
		showSelect, model) {
	var select = $("<select></select>").attr("id", id);
	if (options && options.length > 0) {
		// target,model, options, defValue, showSelect
		select = addOptions(select, model, options, defValue, false);
	}
	if (attrs && attrs.length > 0) {
		for (var i = 0, len = attrs.length; i < len; i++) {
			select = select.attr(attrs[i].name, attrs[i].val);
		}
	}
	if (events && isEmptyObject(events)) {
		for (var j = 0, len = events.length; j < len; j++) {
			$(select).bind(events[j]["type"], events[j]["data"],
					events[j]["fn"]);
		}
	}
	// dbElemId,tableElemId,afterLoad, args
//	追加options
	loadFieldList(dbElemId, tableElemId, initField, [select, model, defValue,
					showSelect]);
	return select;
}

/**
 * 重置页面,(从新加载xml数据的时候,页面重新构造)
 * @param {} model  模式
 * @param {} xmlString xml数据
 * @param {} isInit 是否为第一次执行
 */
function resetPage(model, xmlString, isInit) {
	// 加载xml数据
	// 是否为初始状态,初始状态创建默认工具条，时间条,reset 状态仅仅更新xml模板的table
	if (isInit) {
		emptyMainTable(0);
		// model ,defFucn ,defdb,
		var toolsBar = createTitleTools(model, "", "");
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(toolsBar);
		var timerBar = createTimeBar("本地时间", "timmer", 4, "");
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(timerBar);
		setInterval("timmer.innerHTML=new Date().toLocaleString()", 1000);
	}
	emptyMainTable(2);
	if (xmlString) {
		XMLParseUtil.parseXML(xmlString);
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(createImportTable(
				"importTR", model, "传入参数"));
		createTable_IN(model, "传入表格");
		$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(createExportTable(
				"exportTR", model, "传出参数"));
		createTable_OUT(model, "传出表格");
	}

}
/**
 * 清空页面上主的table 
 * @param {} emptyIndex 要清空的起始行
 */
function emptyMainTable(emptyIndex) {
	// $("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE)
	var mainTable = document.getElementById(CFG_TYPE.DOM_CFG.MAIN_TABLE);
	while (mainTable.rows.length > emptyIndex) {
		$(mainTable.rows[mainTable.rows.length - 1]).remove();
	}
}

/**
 * 联动操作,数据源更改,channel 频道的数据都从新加载
 * @param {}
 *            event {data：{channel： channel：val}}
 */
function channelEvent(event) {
	
	var inputchannelElems = $("input[" + event.data.channel + "='"
			+ event.data.channelVal + "']");
	for (var i = 0, len = inputchannelElems.length; i < len; i++) {
		$(inputchannelElems[i]).val("");
	}

}

/**
 * 重新加载传入参数，传入表格下拉框数据 
 * channel 为dom 的伪属性名称 channelVal：伪属性值 数据源id tableId表名 , defClocal默认值
 * 通过jq查找出带有channel 的值 匹配channelVal的值 的dom
 * @param {} event {data:{channel:,channelVal:,dbId:,tableId ,defClocal:}}
 */
function reloadField(event) {
	var selectchannelElems = $("select[" + event.data.channel + "='"
			+ event.data.channelVal + "']");
	// loadFieldList(event.data.channel.dbId,event.data.channel.tableId);
	var db = $("#" + event.data.dbId).val();
	var tableElem = $("#" + event.data.tableId).val();
	
	var flag = event.data.isInit;// 标记是否init
	if (event.data.defClocal) {
		if (event.data.defClocal.id) {
			db = event.data.defClocal.id;
			$.ajaxSetup({
						async : false
					});// 当需要加载默认值的时候需要设置同步，后面需要加载节点
		}
	}
	if (db && tableElem && selectchannelElems.length > 0) {
		var data = {
			dbId : db,
			table : tableElem
		};
		$
				.post(
						Com_Parameter.ContextPath
								+ 'tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=getFieldList',
						{
							data : JSON.stringify(data)
						}, function(data) {
							var options = [];
							if (data["MSG"]) {

							} else {
								$.each(data, function(index, item) {
											item = eval("(" + item + ")");
											options.push({
														name : item.fieldName
																+ "("
																+ item.dataType
																+ ")",
														val : item.fieldName
													});
										});
							}
							for (var i = 0, len = selectchannelElems.length; i < len; i++) {
								// target, model, options, defValue, showSelect
								$(selectchannelElems[i]).empty();
								addOptions(selectchannelElems[i],
										event.data.model, [{
													name : '固定值',
													val : ''
												}, {
													name : '最后更新时间',
													val : '最后更新时间'
												}, {
													name : '当前执行时间',
													val : '当前执行时间'
												}], null, false);
								addOptions(selectchannelElems[i],
										event.data.model, options, null, false);
								$(selectchannelElems[i]).val("");
								var xpath = $(selectchannelElems[i])
										.attr('xpath');
								var writeElem = document.getElementById(xpath
										+ "_id");
								if (writeElem) {
									var def = '';
									if (flag) {
										def = writeElem.value;
									}
									writeElem.value = def;
									writeElem.style.display = "block";
								}
							}
						}, 'json');
	} else {
		for (var i = 0, len = selectchannelElems.length; i < len; i++) {
			// target, model, options, defValue, showSelect
			$(selectchannelElems[i]).empty();
			addOptions(selectchannelElems[i], event.data.model, [{
								name : '固定值',
								val : ''
							}, {
								name : '最后更新时间',
								val : '最后更新时间'
							}, {
								name : '当前执行时间',
								val : '当前执行时间'
							}], null, false);
			// addOptions(selectchannelElems[i],CFG_TYPE.MODEL.MODEL_EDIT,options,null,false);
			$(selectchannelElems[i]).val("");
			var xpath = $(selectchannelElems[i]).attr('xpath');
			var writeElem = document.getElementById(xpath + "_id");
			if (writeElem) {
				var def = '';
				if (flag) {
					def = writeElem.value;
				}
				writeElem.value = def;
				writeElem.style.display = "block";
			}
			// $(selectchannelElems[i]).val("");
		}
	}
	$.ajaxSetup({
				async : true
			});
}

/**
 * 重新加载传出参数，传出表格下拉框数据 
 * channel 为dom 的伪属性名称 channelVal：伪属性值 数据源id tableId表名 , defClocal默认值
 * 通过jq查找出带有channel 的值 匹配channelVal的值 的dom
 * @param {} event {data:{channel:,channelVal:,dbId:,tableId ,defClocal:}}
 */
function reloadField_out(event) {
	var selectchannelElems = $("select[" + event.data.channel + "='"
			+ event.data.channelVal + "']");
	// loadFieldList(event.data.channel.dbId,event.data.channel.tableId);
	var db = $("#" + event.data.dbId).val();
	var tableElem = $("#" + event.data.tableId).val();
	

	if (event.data.defClocal) {
		if (event.data.defClocal.id) {
			db = event.data.defClocal.id;
			$.ajaxSetup({
						async : false
					});
		}
	}
	if (db && tableElem && selectchannelElems.length > 0) {
		var data = {
			dbId : db,
			table : tableElem
		};
		$
				.post(
						Com_Parameter.ContextPath
								+ 'tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=getFieldList',
						{
							// async: false,//设置同步
							data : JSON.stringify(data)
						}, function(data) {
							var options = [];
							if (data["MSG"]) {

							} else {
								$.each(data, function(index, item) {
											item = eval("(" + item + ")");
											options.push({
														name : item.fieldName
																+ "("
																+ item.dataType
																+ ")",
														val : item.fieldName
													});
										});
							}
							for (var i = 0, len = selectchannelElems.length; i < len; i++) {
								// target, model, options, defValue, showSelect
								$(selectchannelElems[i]).empty();
								addOptions(selectchannelElems[i],
										event.data.model, [{
													name : '==请选择==',
													val : ''
												}, {
													name : '当前执行时间',
													val : '当前执行时间'
												}], null, false);
								addOptions(selectchannelElems[i],
										event.data.model, options, null, false);
								$(selectchannelElems[i]).val("");
								// $(selectchannelElems[i]).val("");
							}
						}, 'json');
	} else {
		for (var i = 0, len = selectchannelElems.length; i < len; i++) {
			// target, model, options, defValue, showSelect
			$(selectchannelElems[i]).empty();
			addOptions(selectchannelElems[i], event.data.model, [{
								name : '==请选择==',
								val : ''
							}, {
								name : '当前执行时间',
								val : '当前执行时间'
							}], null, false);
			// addOptions(selectchannelElems[i],CFG_TYPE.MODEL.MODEL_EDIT,options,null,false);
			$(selectchannelElems[i]).val("");
			// $(selectchannelElems[i]).val("");
		}
	}
	$.ajaxSetup({
				async : true
			});
}

/**
 * 创建工具条 数据源选择&&function选择
 * 
 * @param {}
 *            model edit or view
 * @return {} tr包住的工具栏
 */
function createTitleTools(model, defDBid) {
	var toolsTR = $("<TR></TR>");

	var toolsFuncTD = $("<TD></TD>");
	toolsFuncTD.attr("colSpan", "1");
	toolsFuncTD.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	var toolsFuncLabel = $("<label></label>").html("函数名称");
	toolsFuncTD.append(toolsFuncLabel);

	var toolsFuncTD_elem = $("<TD></TD>");
	toolsFuncTD_elem.attr("colSpan", "1");
	var toolsFuncElement = createDragElement("fdRfcSettingId",
			"fdRfcSettingName", '', '', model);
	// .addClass(CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	toolsFuncTD_elem.append(toolsFuncElement);
	toolsFuncTD_elem.append(createLoadingDiv("tools_func_load", "加载中,请等待", [{
						name : "style",
						val : "display:none"
					}]));
	toolsFuncTD_elem.append(createErrorDiv("tools_func_load", "加载数据错误", [{
						name : "style",
						val : "display:none"
					}]));

	var toolsDSTD = $("<TD></TD>");
	toolsDSTD.attr("colSpan", "1");

	toolsDSTD.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	var toolsDSLabel = $("<label></label>").html("数据源");
	toolsDSTD.append(toolsDSLabel);

	var toolsDSTD_elem = $("<TD></TD>").css('word-break', 'break-all');
	toolsDSTD_elem.attr("colSpan", "1");
	// id, options, attrs, event, defValue, showSelect,model
	var toolsDSElement = createSelectElementDB("dbselect", null, null, [{
						type : "change",
						data : {
							channel : 'ds_channel',
							channelVal : 'true'
						},
						fn : channelEvent
					}], defDBid, true, model);
	toolsDSTD_elem.append(toolsDSElement);
	// id, text, attrs
	toolsDSTD_elem.append(createLoadingDiv("tools_ds_load", "加载中,请等待", [{
						name : "style",
						val : "display:none"
					}]));
	toolsDSTD_elem.append(createErrorDiv("tools_ds_load", "加载数据错误", [{
						name : "style",
						val : "display:none"
					}]));

	toolsTR.append(toolsFuncTD).append(toolsFuncTD_elem).append(toolsDSTD)
			.append(toolsDSTD_elem);
	return toolsTR;
}

/**
 * 同步方式下拉条构造
 * @param {} model 
 * @param {} selectId 构造下拉框的id
 * @param {} defVal 默认值
 * @param {} curNode xml节点
 * @param {} xpath xml节点位置
 * @param {} defstamp 默认时间戳
 * @param {} def_del 默认删除配置的公式
 * @param {} table 所在的表的jquery对象
 * @return {}
 */
function createSynMethod(model, selectId, defVal, curNode, xpath,
       defstamp,def_del,table) {
	var synTR = $("<TR></TR>");
	var td = $("<TD></TD>");
//	显示的文字
	var label = $("<label>同步方式</label>");
	td.append(label);
	// id, options, attrs, events, defValue, showSelect,model
//	下拉选项
	var select = createSelectElement(selectId, [{
						name : '增量',
						val : '1'
					}, {
						name : '全量',
						val : '2'
					}, {
						name : '增量(时间戳)',
						val : '3'
					}, {
						name : '增量(插入前删除)',
						val : '4'
					}, {
						name : '增量(条件删除)',
						val : '5'
					}], [{
						name : 'attrName',
						val : 'sendType'
					}, {
						name : 'xpath',
						val : xpath
					}], null, defVal, true, model);

	var s_td = $("<TD></TD>");
	s_td.append(select);

	var th_td = $("<TD></TD>").attr("colSpan", 4);
	// id, options, attrs, events, defValue, showSelect,model
//	选择时间戳显示的下拉值
	var th_select = createSelectElement(selectId + "_fieldList",
			getFieldValues(curNode), [{
						name : 'attrName',
						val : 'timestamp_ekp'
					}, {
						name : 'xpath',
						val : xpath
					}], null, defstamp, true, model);

//	选择删除显示的公式配置
	var th_del_div = $("<div></div>")
			.attr("id", selectId + "_delCondition_div");
	var th_del = $("<input type='text'>")
			.attr("id", selectId + "_delCondition").attr("attrName",
					"del_condition").attr("xpath", xpath)
			.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
					? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
					: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME).attr("size",
					"80").attr("value", def_del ? def_del : '');
	var formulaInfo = {
		bindId : selectId + "_delCondition",
		bindName : "",
		varInfo : getFieldValues(curNode)
	};
	var th_del_click = $("<img style='cursor:hand' alt='公式定义' src='"
			+ Com_Parameter.ContextPath
			+ "resource/style/default/icons/edit.gif'></img>");
	if (model == CFG_TYPE.MODEL.MODEL_EDIT) {
		$(th_del_click).bind('click', {
					bindId : selectId + "_delCondition",
					bindName : "",
					varInfo : getFieldValues(curNode)
				}, formula_dialog);
	}

	var th_del_help = $("<img style='cursor:hand' alt='帮助' src='"
			+ Com_Parameter.ContextPath
			+ "resource/style/default/tag/help.gif' onclick='Com_OpenWindow(\"tibSapSyncHelp.jsp\",\"_blank\")' ></img>");
	// var th_del_help = $("<button></button").attr("title", "帮助")
	// .addClass("panel_help").attr("onclick",
	// "Com_OpenWindow(\" \",\"_blank\" )");
	$(select).bind('propertychange', {
				parentId : selectId,
				tableId:$(table).attr("id")
			}, bindSynMethod);

	th_del_div.append(th_del);
	th_del_div.append(th_del_click);
	th_del_div.append(th_del_help);

	
	if ($(select).val() == '3') {
		th_select.css("display", "");
		th_del_div.css("display", "none");
	} else if ($(select).val() == '5') {
		th_select.css("display", "none");
		th_del_div.css("display", "");
	} else {
		th_select.css("display", "none");
		th_del_div.css("display", "none");
	}
	

	th_td.append(th_select);
	th_td.append(th_del_div);

	synTR.append(td).append(s_td).append(th_td);
	// synTR.append(td);
	return synTR;
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
/**
 * 公式定义器弹出框
 * @param {} events {data:{bindId:绑定的id,bindName：绑定的名字,varInfo:公式定义弹出框树的值}}
 */
function formula_dialog(events) {
	var bindId = events.data["bindId"];
	var bindName = events.data["bindName"];
	var varInfo = parseVarInfo(events.data["varInfo"]);
	var dialog = new KMSSDialog();
	dialog.formulaParameter = {
		varInfo : varInfo,
		returnType : "Object"
	};
	dialog.BindingField(bindId, bindId);
	dialog.URL = Com_Parameter.ContextPath
			+ "tib/common/resource/plugins/quartz_dialog_edit.jsp";
	dialog.Show(800, 550);
}
/**
 * 同步方式变化，页面需要的变化
 * @param {} event
 */
function bindSynMethod(event) {
	var parentId = event.data.parentId;
	var tableId= event.data.tableId;
	if (!parentId)
		return;
	var table=null;
	if(tableId){
	 table=document.getElementById(tableId);	
	}	
	var parent = $("#" + parentId);
	var control_elem = $("#" + parentId + "_fieldList");
	var control_del = $("#" + parentId + "_delCondition_div");
	var control_data = $("#" + parentId + "_delCondition");
	if (parent.val() && parent.val() == '3') {
		control_elem.val("");
		control_elem.css("display", "block");
		control_data.val("");
		control_del.val("");
		control_del.css("display", "none");

	} else if (parent.val() && parent.val() == '5') {
		control_elem.val("");
		control_elem.css("display", "none");
		// control_del.val("");
		// control_data.val("");
		control_del.css("display", "block");
	} else {
		control_elem.val("");
		control_elem.css("display", "none");
		control_data.val("");
		control_del.val("");
		control_del.css("display", "none");
	}
	
	if(parent.val() && (parent.val() == '4'||parent.val() == '5')){
	if(table){
		table.rows[2].cells[table.rows[2].cells.length-1].innerHTML="<label>KEY</label>";
		}
	}
	else if(parent.val() =='2'){
	table.rows[2].cells[table.rows[2].cells.length-1].innerHTML="<label></label>";
	}
	else{
		if(table){
	table.rows[2].cells[table.rows[2].cells.length-1].innerHTML="<label>主键</label>";
		}
	}
	
	
	
}

/**
 * 找出当前节点下的所有field标签的node,并且返回对应的name 跟title属性数组
 * @param {} node
 * @return {} [{name:node的name值-node的title值  val:node的name值 }]
 */
function getFieldValues(node) {
	
	var fields = $(node).find("field");//node.selectNodes("//export/structure");
	
	var options = [];

	for (var i = 0, len = fields.length; i < len; i++) {
		var val = {};
		// node, parentXpath, index,defAttrs 得出的xpath是不准确的,只要数据
		var nodeJs = XMLParseUtil.parseNode4Json(fields[i], "", i, null);
		val.name = nodeJs["attr"]["title"] + "-(" + nodeJs["attr"]["name"]
				+ ")";
		val.val = nodeJs["attr"]["name"];
		options.push(val);
	}
	return options;
}
/**
 * 一键校验
 * @param {} tableId 校验的table
 * @param {} channel 校验的频道,找出这个频道的所有下拉框更改
 * @param {} xpath 校验的xml节点 ，table 所在位置（暂时没有使用）
 */
function onKeyMatch(tableId, channel, xpath) {
	var elemList = $("#" + tableId + " select[" + channel + "='true']");
	$(elemList).each(function(index, item) {
				var value = '';
				if ($(item).attr("xpath")) {
					var node = XMLParseUtil.selectSingleNode($(item).attr("xpath"));
					if (node[0] != undefined) {
						node = node[0];
					}
					if (node) {
						var value = XMLParseUtil
								.getAttrByName(node, "name", '');
					}
				}
				for (var i = 0, len = item.options.length; i < len; i++) {
					if (item.options[i].value == value) {
						item.options[i].selected = true;
						var xpath = $(item).attr("xpath");
						var resInput = document.getElementById(xpath + "_id");
						if (resInput && value) {
							resInput.style.display = "none";
						} else if (resInput && !value) {
							resInput.style.display = "block";
						}
						return;
					}
				}
			});
}

/**
 * 回写默认值
 * @param {} tableId 
 * @param {} channel
 * @param {} xpath
 */
function writeDefVal(tableId, channel, xpath) {
	var elemList = $("#" + tableId + " select[" + channel + "='true']");
	$(elemList).each(function(index, item) {
				var value = '';
				
				if ($(item).attr("xpath")) {
					var node =XMLParseUtil.selectSingleNode($(item).attr("xpath"));
			
					if (node[0] != undefined) {
						node = node[0];
					}
					
					if (node) {
						var value = XMLParseUtil.getAttrByName(node, "ekpid",
								'');
					}
				}
				for (var i = 0, len = item.options.length; i < len; i++) {
					if (item.options[i].value == value) {
						item.options[i].selected = true;
						var xpath = $(item).attr("xpath");
						var resInput = document.getElementById(xpath + "_id");
						if (resInput && value) {
							resInput.style.display = "none";
						} else if (resInput && !value) {
							resInput.style.display = "block";
						}
						return;
					}
				}
			});
}
/**
 * 创建时间栏
 * @param {} text
 * @param {} timmerId
 * @param {} colspan
 * @param {} value
 * @return {}
 */
function createTimeBar(text, timmerId, colspan, value) {
	var timeBarTR = $("<TR></TR>");
	var timeBarTD = $("<TD></TD>").html(["<label style='float:left'>", text,
			"&nbsp&nbsp</label>"].join(""));
	timeBarTD.attr("colSpan", colspan ? colspan + '' : "1");
	timeBarTD.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	var timer = $("<div></div").attr("id", timmerId);
	timeBarTR.append(timeBarTD.append(timer));
	timer.css("float", "left");
	// eval(timmerId+".innerHTML=new Date().toLocaleString()"
	timer.html(value ? value : '');
	return timeBarTR;
}

/**
 * 创建import 标签的table
 * @param {} id
 * @param {} model
 * @param {} param_text
 */
function createImportTable(id, model, param_text) {
	// 取数据
	var importNodeInfo = getPartNodeInfo("import");
	if (!importNodeInfo || isEmptyObject(importNodeInfo))
		return;
	
	var trElem = $("<TR></TR>");
	var tdElem = $("<TD></TD>").attr("colSpan", 7);
	var table = $("<table></table")
			.addClass(CFG_TYPE.CLASSNAME.DEF_TABLE_CLASSNAME);
	table.attr("width", "100%");

	var table_tr = $("<TR></TR>");
	table.attr("id", id);
	// 加入表格首行
	var firstTD = $("<td></td").html(param_text)
			.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	var count = countNodeNum(importNodeInfo.node);

	firstTD.attr("width", "50px").attr("rowSpan", count + 2);
	table_tr.append(firstTD);
//	屏蔽传入参数选择数据库功能
	table_tr.append(createTableBar(importNodeInfo.xpath + "_choice", model, [{
						name : "colSpan",
						val : '1'
					}]).attr("width", "150px"));

	var barTD = $("<TD></TD>");
	barTD.attr("colSpan", 5);
	// model,bindId,bindElem,dataSourceId,groupAttrs,events
	var importJs = XMLParseUtil.parseNode4Json(importNodeInfo.node);
	var defClocal = null;
	if (importJs && importJs["attr"] && importJs["attr"]["clocal"]) {
		defClocal = Clocal2Object(importJs["attr"]["clocal"]);
	}
	var simpleBar = createSimpleTools(model, "import_bar_id",
			"import_bar_name", "dbselect", [{
						name : "ds_channel",
						val : "true"
					}, {
						name : 'xpath',
						val : '/jco/import'
					}, {
						name : 'attrName',
						val : 'clocal'
					}], [{
						type : 'propertychange input',
						data : {
							channel : "tb_import_Field",
							channelVal : 'true',
							dbId : 'dbselect',
							tableId : 'import_bar_id',
							model : model
						},
						fn : reloadField
					}], defClocal);
	barTD.append(simpleBar);
	table_tr.append(barTD);
	//屏蔽传入参数选择数据库功能
	table_tr.css("display","none");
	
	table.append(table_tr);
	
	
	//输入参数    表头
	var titleAttr = [{
				html : "<label>参数类型</label>"
			}, {
				html : "<label>字段名称</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>字段说明</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>映射字段</label><img style='cursor:hand' alt='一键匹配' onclick='onKeyMatch(\""
						+ id
						+ "\",\"tb_import_Field\",\""
						+ importNodeInfo.xpath
						+ "\" )' src='"
						+ Com_Parameter.StylePath
						+ "calendar/finish.gif'></img>",
				attrs : [{
							name : "colSpan",
							val : "2"
						}]
			}, {
				html : "<label>映射备注</label>"
			}]
			
	table_title_tr = createTitleTR(model, titleAttr);
	table.append(table_title_tr);
	var stru = 0;// 标记结构体个数
	var children = XMLParseUtil.getChildren(importNodeInfo.node);
	// 没有子节点隐藏当前表格
	if (children.length <= 0) {
		trElem.css("display", "none");
	}
	

	for (var i = 0, len = children.length; i < len; i++) {
		var node = children[i];
		// var nodeJs=XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath,i);
		// var field_tr=createImportField(model,nodeJs);
		
		if (node.nodeName == "structure") {
			// model,node,parentTable,xpath,index
			table = createImportStructure(model, node, table,
					importNodeInfo.xpath, stru);
			stru++;
		} else if (node.nodeName == "field") {
		
			var nodeJs = XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath, i);
			var field_tr = createImportField(model, nodeJs, {
						name : CFG_TYPE.GROUP.G_TB_FIELD,
						val : 'true'
					});
			table.append(field_tr);
		}
	}

	tdElem.append(table);
	trElem.append(tdElem);
	// table.append($("<TR></TR>").append(createTableBar(CFG_TYPE.MODEL.MODEL_EDIT)));
	// table.append();
	// var parentTR=$("<TR></TR>").append($("<TD></TD>").append(table));
	return trElem;
}

/**
 * 创建传出参数export 标签
 * @param {} id
 * @param {} model
 * @param {} param_text
 */
function createExportTable(id, model, param_text) {
	// 取数据
	var importNodeInfo = getPartNodeInfo("export");
	// importNodeInfo.xpath="/jco/export";
	if (!importNodeInfo || isEmptyObject(importNodeInfo))
		return;
	var trElem = $("<TR></TR>");
	var tdElem = $("<TD></TD>").attr("colSpan", 7);
	var table = $("<table></table")
			.addClass(CFG_TYPE.CLASSNAME.DEF_TABLE_CLASSNAME);
	table.attr("width", "100%");

	var table_tr = $("<TR></TR>");
	table.attr("id", id);
	// 加入表格首行
	var firstTD = $("<td></td").html(param_text)
			.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	var count = countNodeNum(importNodeInfo.node);

	firstTD.attr("width", "50px").attr("rowSpan", count + 3);
	table_tr.append(firstTD);
	table_tr.append(createTableBar(importNodeInfo.xpath + "_choice", model, [{
						name : "colSpan",
						val : '1'
					}]).attr("width", "150px"));

	var barTD = $("<TD></TD>");
	barTD.attr("colSpan", 5);

	var importJs = XMLParseUtil.parseNode4Json(importNodeInfo.node);
	var defClocal = null;
	if (importJs && importJs["attr"] && importJs["attr"]["clocal"]) {
		defClocal = Clocal2Object(importJs["attr"]["clocal"]);
	}

	// model,bindId,bindElem,dataSourceId,groupAttrs,events
	var simpleBar = createSimpleTools(model, "export_bar_id",
			"export_bar_name", "dbselect", [{
						name : "ds_channel",
						val : "true"
					}, {
						name : 'xpath',
						val : '/jco/export'
					}, {
						name : 'attrName',
						val : 'clocal'
					}

			], [{
						type : 'propertychange input',
						data : {
							channel : "tb_export_Field",
							channelVal : 'true',
							dbId : 'dbselect',
							tableId : 'export_bar_id',
							model : model
						},
						fn : reloadField_out
					}], defClocal)
	barTD.append(simpleBar);
	table_tr.append(barTD);
    //屏蔽传出参数表格选择
	table_tr.css("display","none");
	table.append(table_tr)
	// model,selectId,defVal
	table.append(createSynMethod(model, id + "_method", importJs["attr"]
					&& importJs["attr"]["sendType"]
					? importJs["attr"]["sendType"]
					: '', importNodeInfo.node, '/jco/export', importJs["attr"]
					&& importJs["attr"]["timestamp_ekp"]
					? importJs["attr"]["timestamp_ekp"]
					: '', importJs["attr"] && importJs["attr"]["del_condition"]
					? XMLParseUtil
							.decodeHtml(importJs["attr"]["del_condition"])
					: '',table));

	var checkField=importJs["attr"]
					&& importJs["attr"]["sendType"]&&(importJs["attr"]["sendType"]=='4'||importJs["attr"]["sendType"]=='5')?"KEY":importJs["attr"]
					&& importJs["attr"]["sendType"]&&importJs["attr"]["sendType"]=='2'?"":"主键";				
	// 表头
	var titleAttr = [{
				html : "<label>参数类型</label>"
			}, {
				html : "<label>字段名称</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>字段说明</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>映射字段</label><img style='cursor:hand' alt='一键匹配' onclick='onKeyMatch(\""
						+ id
						+ "\",\"tb_export_Field\",\""
						+ importNodeInfo.xpath
						+ "\" )' src='"
						+ Com_Parameter.StylePath
						+ "calendar/finish.gif'></img>",
				attrs : [{
							name : "colSpan",
							val : "1"
						}]
			}, {
				html : "<label>映射备注</label>"
			}, {
				html : "<label>"+checkField+"</label>"
			}];
	table_title_tr = createTitleTR(model, titleAttr);
	table.append(table_title_tr);
	var stru = 0;// 标记结构体个数
	var children = XMLParseUtil.getChildren(importNodeInfo.node);
	if (children.length <= 0) {
		trElem.css("display", "none");
	}
	for (var i = 0, len = children.length; i < len; i++) {
		var node = children[i];
		// var nodeJs=XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath,i);
		// var field_tr=createImportField(model,nodeJs);
		if (node.nodeName == "structure") {
			// model,node,parentTable,xpath,index
			table = createExStructure(model, node, table, importNodeInfo.xpath,
					stru);
			stru++;
		} else if (node.nodeName == "field") {
			var nodeJs = XMLParseUtil.parseNode4Json(node,
					importNodeInfo.xpath, i);
			var field_tr = createExField(model, nodeJs, {
						name : "tb_export_Field",
						val : 'true'
					});
			table.append(field_tr);
		}
	}

	tdElem.append(table);
	trElem.append(tdElem);
	// table.append($("<TR></TR>").append(createTableBar(CFG_TYPE.MODEL.MODEL_EDIT)));
	// table.append();
	// var parentTR=$("<TR></TR>").append($("<TD></TD>").append(table));
	return trElem;

}

/**
 * 创建xml中所有传入表格
 * @param {} model
 * @param {} param_text
 * @param {} defClocal
 */
function createTable_IN(model, param_text, defClocal) {
	 
	// 取数据
	var tableNodeInfo = getPartNodeInfo("tables");
	var tables = tableNodeInfo.node;// .node[0];//tables集合
	// var tables_in =tables.selectNodes("./table[@isin='1']");
	if(tables.childNodes.length==0){
		return ;
	}
	var all_table = $(tables).find("table");//tables.selectNodes("./tables");
	for (var k = 0, k_len = all_table.length; k < k_len; k++) {
		var tableNode = all_table[k];
		var tableNodeJs = XMLParseUtil.parseNode4Json(tableNode,
				tableNodeInfo.xpath, k, null);
		if (tableNodeJs["attr"]["isin"] && tableNodeJs["attr"]["isin"] == '1') {
			var xpath = XMLParseUtil.addXpath(tableNodeInfo.xpath,
					tableNode.nodeName, k);
			// var table_TR = $("<TR></TR>");
			table_TR = createSingleTable(tableNode, tableNodeInfo.xpath, model,
					param_text, k);
			// table_TR.append(resultTB);
			$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(table_TR);

			var event = {
				data : {
					channel : "tb" + k + "_channel",
					channelVal : 'true',
					dbId : 'dbselect',
					tableId : "table" + k + "_bar_id",
					model : model,
					defClocal : defClocal,
					isInit : true

				}
			}
			reloadField(event);
			// tableId,channel,xpath
			writeDefVal("table" + k + "_table", "tb" + k + "_channel", xpath);

		}
	}
}

/**
 * 创建xml中所有传出表格
 * @param {} model
 * @param {} param_text
 * @param {} defClocal
 */
function createTable_OUT(model, param_text, defClocal) {
	// 取数据
	var tableNodeInfo = getPartNodeInfo("tables");
	var tables = tableNodeInfo.node;// .node[0];//tables集合
	// var tables_in =tables.selectNodes("./table[@isin='1']");
	var all_table = $(tables).find("table");//tables.selectNodes("./table");
	for (var k = 0, k_len = all_table.length; k < k_len; k++) {
		var tableNode = all_table[k];
		var tableNodeJs = XMLParseUtil.parseNode4Json(tableNode,
				tableNodeInfo.xpath, k, null);
		if (tableNodeJs["attr"]["isin"] && tableNodeJs["attr"]["isin"] == '0') {
			var xpath = XMLParseUtil.addXpath(tableNodeInfo.xpath,
					tableNode.nodeName, k);
			table_TR = createSingleTable_OUT(tableNode, tableNodeInfo.xpath,
					model, param_text, k);
			$("#" + CFG_TYPE.DOM_CFG.MAIN_TABLE).append(table_TR);

			var event = {
				data : {
					channel : "tb" + k + "_channel",
					channelVal : 'true',
					dbId : 'dbselect',
					tableId : "table" + k + "_bar_id",
					model : model,
					defClocal : defClocal,
					isInit : true

				}
			}
			reloadField_out(event);
			// var tableJs = XMLParseUtil.parseNode4Json(tableNode, xpath, k,
			// null);
			// tableId,channel,xpath
			writeDefVal("table" + k + "_table", "tb" + k + "_channel", xpath);

		}
	}
}

/**
 * 计算node 节点下有多少个field节点，为了计算表格第一行的rowSpan 行数
 * @param {} node
 * @return {}
 */
function countItem(node) {
	return  $(node).find("field").length;//node.selectNodes(".//field").length;
}

/**
 * 创建单个传出表格
 * @param {} tableNode xml节点
 * @param {} parentXpath 父节点xml位置
 * @param {} model
 * @param {} param_text 第一行对这个表格的显示描述
 * @param {} index 构造xpath 当前节点处于第几个table
 * @return {}
 */
function createSingleTable_OUT(tableNode, parentXpath, model, param_text, index) {
	// var i =index;
	var table_TR = $("<TR></TR>");
	var tableTD = $("<TD></TD>").attr("colSpan", 7);
	var table = $("<table></table")
			.addClass(CFG_TYPE.CLASSNAME.DEF_TABLE_CLASSNAME);
	table.attr("width", "100%");

	var table_tr = $("<TR></TR>");
	table.attr("id", "table" + index + "_table");
	// 加入表格首行
	// node, parentXpath, index,defAttrs
	var tableJs = XMLParseUtil.parseNode4Json(tableNode, parentXpath, index,
			null);

	var defClocal = null;
	if (tableJs && tableJs["attr"] && tableJs["attr"]["clocal"]) {
		defClocal = Clocal2Object(tableJs["attr"]["clocal"]);
	}

	var firstTD = $("<td></td").html(param_text + "<br>"
			+ tableJs["attr"]["name"])
			.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	// var count= countNodeNum(importNodeInfo.node[0]);

	firstTD.attr("style", "word-break:break-all").attr("width", "50px").attr(
			"rowSpan", countItem(tableNode) + 3);// count+2);
	table_tr.append(firstTD);
	table_tr.append(createTableBar("table" + index + "_choice", model, [{
						name : "colSpan",
						val : '1'
					}]).attr("width", "150px"));
	var barTD = $("<TD></TD>");
	barTD.attr("colSpan", 5);
	// model,bindId,bindElem,dataSourceId,groupAttrs,events
	var simpleBar = createSimpleTools(model, "table" + index + "_bar_id",
			"table" + index + "_bar_name", "dbselect", [{
						name : "ds_channel",
						val : "true"
					}, {
						name : 'xpath',
						val : tableJs.xpath
					}, {
						name : 'attrName',
						val : 'clocal'
					}], [{
						type : 'propertychange input',
						data : {
							channel : "tb" + index + "_channel",
							channelVal : 'true',
							dbId : 'dbselect',
							tableId : "table" + index + "_bar_id",
							model : model
						},
						fn : reloadField_out
					}], defClocal);
	barTD.append(simpleBar);
	table_tr.append(barTD);

	var checkField=tableJs["attr"]&&tableJs["attr"]["sendType"]&&(tableJs["attr"]["sendType"]=='4'||tableJs["attr"]["sendType"]=='5')?"KEY":tableJs["attr"]&&tableJs["attr"]["sendType"]&&tableJs["attr"]["sendType"]=='2'?"":"主键";
	// 表头
	var titleAttr = [{
				html : "<label>参数类型</label>"
			}, {
				html : "<label>字段名称</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>字段说明</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>映射字段</label><img style='cursor:hand' alt='一键匹配' onclick='onKeyMatch(\""
						+ "table"
						+ index
						+ "_table"
						+ "\",\""
						+ "tb"
						+ index
						+ "_channel"
						+ "\",\""
						+ tableJs.xpath
						+ "\" )' src='"
						+ Com_Parameter.StylePath
						+ "calendar/finish.gif'></img>",
				attrs : [{
							name : "colSpan",
							val : "1"
						}]
			}, {
				html : "<label>映射备注</label>"
			}, {
				html : "<label>"+checkField+"</label>"
			}];
	table.append(table_tr)
	table.append(createSynMethod(model, "table" + index + "_method",
			tableJs["attr"]["sendType"] ? tableJs["attr"]["sendType"] : '',
			tableNode, tableJs.xpath, tableJs["attr"]["timestamp_ekp"]
					? tableJs["attr"]["timestamp_ekp"]
					: '', tableJs["attr"]["del_condition"] ? XMLParseUtil
					.decodeHtml(tableJs["attr"]["del_condition"]) : '',table));

	table_title_tr = createTitleTR(model, titleAttr);
	table.append(table_title_tr);

	var children = XMLParseUtil.getChildren(tableNode, "records");

	if (children.length <= 0) {
		table_TR.css("display", "none");
	}

	for (var i = 0, len = children.length; i < len; i++) {
		// xpath, nodeName, index
		var basePath = XMLParseUtil.addXpath(tableJs.xpath,
				children[i].nodeName, i);
		var recordChild = children[i].childNodes;
		for (var j = 0, r_len = recordChild.length; j < r_len; j++) {
			var nodeJs = XMLParseUtil.parseNode4Json(recordChild[j], basePath,
					j);
			var field_tr = createExportField(model, nodeJs, {
						name : "tb" + index + "_channel",
						val : 'true'
					});
			table.append(field_tr);
		}
		// var node =children[i];
		// // var
		// nodeJs=XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath,i);
		// //var field_tr=createImportField(model,nodeJs);
		// if(node.nodeName=="structure"){
		// //model,node,parentTable,xpath,index
		// table
		// =createImportStructure(model,node,table,importNodeInfo.xpath,stru);
		// stru++;
		// }
		// else if (node.nodeName=="field"){
		// var nodeJs=XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath,i);
		// var field_tr=createImportField(model,nodeJs);
		// table.append(field_tr);
		// }
	}
	tableTD.append(table);
	table_TR.append(tableTD);
	return table_TR;
}

/**
 * 创建单个传入表格
 * @param {} tableNode xml节点
 * @param {} parentXpath 父节点xml位置
 * @param {} model
 * @param {} param_text 第一行对这个表格的显示描述
 * @param {} index 构造xpath 当前节点处于第几个table
 * @return {}
 */
function createSingleTable(tableNode, parentXpath, model, param_text, index) {
	// var i =index;
	var table_TR = $("<TR></TR>");
	var tableTD = $("<TD></TD>").attr("colSpan", 7);
	var table = $("<table></table")
			.addClass(CFG_TYPE.CLASSNAME.DEF_TABLE_CLASSNAME);
	table.attr("width", "100%");

	var table_tr = $("<TR></TR>");
	table.attr("id", "table" + index + "_table");
	// 加入表格首行
	// node, parentXpath, index,defAttrs
	var tableJs = XMLParseUtil.parseNode4Json(tableNode, parentXpath, index,
			null);

	var defClocal = null;
	if (tableJs && tableJs["attr"] && tableJs["attr"]["clocal"]) {
		defClocal = Clocal2Object(tableJs["attr"]["clocal"]);
	}

	var firstTD = $("<td></td").html(param_text + "<br>"
			+ tableJs["attr"]["name"])
			.addClass(CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
	// var count= countNodeNum(importNodeInfo.node[0]);

	firstTD.attr("style", "word-break:break-all").attr("width", "50px").attr(
			"rowSpan", countItem(tableNode) + 2);// count+2);
	table_tr.append(firstTD);
	table_tr.append(createTableBar("table" + index + "_choice", model, [{
						name : "colSpan",
						val : '1'
					}]).attr("width", "150px"));
	var barTD = $("<TD></TD>");
	barTD.attr("colSpan", 5);
	// model,bindId,bindElem,dataSourceId,groupAttrs,events
	var simpleBar = createSimpleTools(model, "table" + index + "_bar_id",
			"table" + index + "_bar_name", "dbselect", [{
						name : "ds_channel",
						val : "true"
					}, {
						name : 'xpath',
						val : tableJs.xpath
					}, {
						name : 'attrName',
						val : 'clocal'
					}], [{
						type : 'propertychange input',
						data : {
							channel : "tb" + index + "_channel",
							channelVal : 'true',
							dbId : 'dbselect',
							tableId : "table" + index + "_bar_id",
							model : model
						},
						fn : reloadField
					}], defClocal);
	barTD.append(simpleBar);
	table_tr.append(barTD);

	// 表头
	var titleAttr = [{
				html : "<label>参数类型</label>"
			}, {
				html : "<label>字段名称</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>字段说明</label>",
				attrs : [{
							name : "width",
							val : "150px"
						}]
			}, {
				html : "<label>映射字段</label><img style='cursor:hand' alt='一键匹配' onclick='onKeyMatch(\""
						+ "table"
						+ index
						+ "_table"
						+ "\",\""
						+ "tb"
						+ index
						+ "_channel"
						+ "\",\""
						+ tableJs.xpath
						+ "\" )' src='"
						+ Com_Parameter.StylePath
						+ "calendar/finish.gif'></img>",
				attrs : [{
							name : "colSpan",
							val : "2"
						}]
			}, {
				html : "<label>映射备注</label>"
			}];

	table.append(table_tr)
	table_title_tr = createTitleTR(model, titleAttr);
	table.append(table_title_tr);

	var children = XMLParseUtil.getChildren(tableNode, "records");
	if (children.length <= 0) {
		table_TR.css("display", "none");
	}

	for (var i = 0, len = children.length; i < len; i++) {
		// xpath, nodeName, index
		var basePath = XMLParseUtil.addXpath(tableJs.xpath,
				children[i].nodeName, i);
		var recordChild = children[i].childNodes;
		for (var j = 0, r_len = recordChild.length; j < r_len; j++) {
			var nodeJs = XMLParseUtil.parseNode4Json(recordChild[j], basePath,
					j);
			var field_tr = createImportField(model, nodeJs, {
						name : "tb" + index + "_channel",
						val : 'true'
					});
			table.append(field_tr);
		}

		// var node =children[i];
		// // var
		// nodeJs=XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath,i);
		// //var field_tr=createImportField(model,nodeJs);
		// if(node.nodeName=="structure"){
		// //model,node,parentTable,xpath,index
		// table
		// =createImportStructure(model,node,table,importNodeInfo.xpath,stru);
		// stru++;
		// }
		// else if (node.nodeName=="field"){
		// var nodeJs=XMLParseUtil.parseNode4Json(node,importNodeInfo.xpath,i);
		// var field_tr=createImportField(model,nodeJs);
		// table.append(field_tr);
		// }
	}
	tableTD.append(table);
	table_TR.append(tableTD);
	return table_TR;
}

/**
 * 创建传出参数的每一fileld 节点的tr
 * @param {} model
 * @param {} nodeJs xml节点转化的json数据
 * @param {} channel
 * @return {}
 */
function createExportField(model, nodeJs, channel) {
	var importTR = $("<TR></TR>");
	var typeField = $("<td></td>").html("<label>字段<label/>");
	var nameField = $("<td></td>").html("<label>" + nodeJs["attr"]["name"]
			+ "<label/>");
	var desField = $("<td></td>").html("<label>" + nodeJs["attr"]["title"]
			+ "<label/>");
	desField.attr("style", "word-break:break-all");
	var selectElem = createSelectElement(nodeJs.xpath + "_select", [{
						name : '==请选择==',
						val : ''
					}, {
						name : '当前执行时间',
						val : '当前执行时间'
					}],/* 加入field组 */[{
						name : channel.name,
						val : channel.val
					}], null, nodeJs["attr"]["ekpid"], false, model);
	selectElem.attr("attrName", "ekpid").attr("xpath", nodeJs.xpath);
	// $(selectElem).bind("change",{xpath:nodeJs.xpath},reloadTDField);
	var selectField = $("<td></td>").append(selectElem);// html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	// var
	// bindField=$("<td></td>");//.html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	// var bindFieldContext=$("<input
	// type='text'>").attr('xpath',nodeJs.xpath).attr("attrName",'text').attr('id',nodeJs.xpath+"_id");;
	// bindFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
	// ? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
	// : CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	// bindField.append(bindFieldContext);
	var mappingFieldContext = $("<input type='text'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'ekpname').attr('id',
			nodeJs.xpath + "_map").attr("value",
			nodeJs["attr"]["ekpname"] ? nodeJs["attr"]["ekpname"] : '');
	mappingFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var mappingField = $("<td></td>").append(mappingFieldContext);

	var keyFieldContext = $("<input type='checkbox'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'dbiskey').attr('id',
			nodeJs.xpath + "_key");
	if (nodeJs["attr"]["dbiskey"] == '1' || nodeJs["attr"]["dbiskey"] == 'true') {
		keyFieldContext.attr("checked", "true");
	}
	if (model == CFG_TYPE.MODEL.MODEL_VIEW) {
		keyFieldContext.attr("disabled", true);
	}
	//   
	//   
	// keyFieldContext.attr("disabled",model == CFG_TYPE.MODEL.MODEL_VIEW
	// ? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
	// : CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var keyField = $("<td></td>").append(keyFieldContext);
	importTR.append(typeField).append(nameField).append(desField)
			.append(selectField).append(mappingField).append(keyField);
	return importTR;
}

/**
 * 计算传入参数，传出参数表格的行数 这里要统计structure，跟统计table的行数不一样
 * @param {} node
 * @return {}
 */

function countNodeNum(node) {
	var f_len = XMLParseUtil.getChildren(node, "field").length;
	var strus = XMLParseUtil.getChildren(node, "structure")
	for (var i = 0, len = strus.length; i < len; i++) {
		f_len += strus[i].childNodes.length;
	}
	return f_len;
}
/**
 * 创建传出参数的每一fileld 节点的tr
 * @param {} model
 * @param {} nodeJs xml节点转化的json数据
 * @param {} channel
 * @return {}
 */
function createExField(model, nodeJs, channel) {
	var importTR = $("<TR></TR>");
	var typeField = $("<td></td>").html("<label>字段<label/>");
	var nameField = $("<td></td>").html("<label>" + nodeJs["attr"]["name"]
			+ "<label/>");
	var desField = $("<td></td>").html("<label>" + nodeJs["attr"]["title"]
			+ "<label/>");
	desField.attr("style", "word-break:break-all");
	desField.attr("width", "150px");
	var selectElem = createSelectElement(nodeJs.xpath + "_select", [{
						name : '==请选择==',
						val : ''
					}, {
						name : '最后更新时间',
						val : '最后更新时间'
					}, {
						name : '当前执行时间',
						val : '当前执行时间'
					}],/* 加入field组 */[{
						name : channel.name,
						val : channel.val
					}], nodeJs["attr"]["ekpid"], '', false, model);
	selectElem.attr("attrName", "ekpid").attr("xpath", nodeJs.xpath);
	$(selectElem).bind("change", {
				xpath : nodeJs.xpath
			}, reloadTDField);
	var selectField = $("<td></td>").append(selectElem);// html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	// var
	// bindField=$("<td></td>");//.html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	// var bindFieldContext=$("<input
	// type='text'>").attr('xpath',nodeJs.xpath).attr("attrName",'text').attr('id',nodeJs.xpath+"_id");;
	// bindFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
	// ? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
	// : CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	// bindField.append(bindFieldContext);
	var mappingFieldContext = $("<input type='text'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'ekpname').attr('id',
			nodeJs.xpath + "_map").attr("value",
			nodeJs["attr"]["ekpname"] ? nodeJs["attr"]["ekpname"] : '');
	mappingFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var mappingField = $("<td></td>").append(mappingFieldContext);

	var keyFieldContext = $("<input type='checkbox'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'dbiskey').attr('id',
			nodeJs.xpath + "_key");
	if (nodeJs["attr"]["dbiskey"] == '1' || nodeJs["attr"]["dbiskey"] == 'true') {
		keyFieldContext.attr("checked", "true");
	}

	// mappingFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
	// ? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
	// : CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	if (model == CFG_TYPE.MODEL.MODEL_VIEW) {
		keyFieldContext.attr('disabled', true);
	}
	var keyField = $("<td></td>").append(keyFieldContext);

	importTR.append(typeField).append(nameField).append(desField)
			.append(selectField).append(mappingField).append(keyField);
	return importTR;
}
/**
 * 创建传入参数的每一fileld 节点的tr
 * @param {} model
 * @param {} nodeJs xml节点转化的json数据
 * @param {} channel
 * @return {}
 */
function createImportField(model, nodeJs, channel) {

	var importTR = $("<TR></TR>");
	var typeField = $("<td></td>").html("<label>字段<label/>");
	var nameField = $("<td></td>").html("<label>" + nodeJs["attr"]["name"]+ "<label/>");
	var desField = $("<td></td>").html("<label>" + nodeJs["attr"]["title"]+ "<label/>");

	var selectElem = createSelectElement(nodeJs.xpath + "_select", [{
						name : '固定值',
						val : ''
					}, {
						name : '最后更新时间',
						val : '最后更新时间'
					}, {
						name : '当前执行时间',
						val : '当前执行时间'
					}],/* 加入field组 */[{
						name : channel.name,
						val : channel.val
					}], '', nodeJs["attr"]["ekpid"], false, model);
	selectElem.attr("attrName", "ekpid").attr("xpath", nodeJs.xpath);
	$(selectElem).bind("change", {
				xpath : nodeJs.xpath
			}, reloadTDField);
	var selectField = $("<td></td>").attr('colSpan', 2);// html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	selectField.append(selectElem);
	// var bindField = $("<td></td>");//
	// .html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	/*
	var bindFieldContext = $("<input type='text'>").attr('xpath', nodeJs.xpath)
			.attr("attrName", 'text').attr('id', nodeJs.xpath + "_id").attr(
					"value", nodeJs.nodeValue);
					*/
	
	var bindFieldContext =$("<input>",{type:'text'});
	    $(bindFieldContext).attr('xpath', nodeJs.xpath);
	    $(bindFieldContext).attr('attrName', 'text');
	    $(bindFieldContext).attr('id', nodeJs.xpath + "_id");
	    $(bindFieldContext).attr('value', nodeJs.nodeValue);
    
	bindFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	// bindField.append(bindFieldContext);

	selectField.append("<br>").append(bindFieldContext);
	/*var mappingFieldContext = $("<input type='text'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'ekpname').attr('id',
			nodeJs.xpath + "_map");
	mappingFieldContext.val(nodeJs["attr"]["ekpname"]
	                                       ? nodeJs["attr"]["ekpname"]
	                                                        : '');
			*/
	var mappingFieldContext =$("<input>",{type:'text'});
    $(mappingFieldContext).attr('xpath', nodeJs.xpath);
    $(mappingFieldContext).attr('attrName','ekpname');
    $(mappingFieldContext).attr('id', nodeJs.xpath + "_map");
    $(mappingFieldContext).attr('xpath', nodeJs.xpath);
    var nodeVal=nodeJs["attr"]["ekpname"] ? nodeJs["attr"]["ekpname"]: '';
    $(mappingFieldContext).val(nodeVal);
    
	mappingFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var mappingField = $("<td></td>").append(mappingFieldContext);
	importTR.append(typeField).append(nameField).append(desField)
			.append(selectField)/* append(bindField) */.append(mappingField);

	return importTR;
}

/**
 * 传入参数结构体
 * @param {} model
 * @param {} node
 * @param {} parentTable
 * @param {} xpath
 * @param {} index
 * @return {}
 */
function createImportStructure(model, node, parentTable, xpath, index) {
	var strNodeJs = XMLParseUtil.parseNode4Json(node, xpath, index);
	var firstStrTD = $("<TD></TD>").html("<label>结构体："
			+ strNodeJs["attr"]["name"] + "</label>")
	var chidren = XMLParseUtil.getChildren(node);
	if (chidren.length > 0) {
		firstStrTD.attr("rowSpan", chidren.length);
		for (var i = 0, len = chidren.length; i < len; i++) {
			var node = chidren[i];
			var nodejs = XMLParseUtil.parseNode4Json(node, strNodeJs["xpath"],
					i);
			if (i == 0) {
				parentTable.append(createStructreTR(model, nodejs, firstStrTD));
			} else {
				parentTable.append(createStructreTR(model, nodejs));
			}
		}
	}
	return parentTable;
}

/**
 *传出参数结构体 
 * @param {} model
 * @param {} node
 * @param {} parentTable
 * @param {} xpath
 * @param {} index
 * @return {}
 */
function createExStructure(model, node, parentTable, xpath, index) {
	var strNodeJs = XMLParseUtil.parseNode4Json(node, xpath, index);
	var firstStrTD = $("<TD></TD>").html("<label>结构体："
			+ strNodeJs["attr"]["name"] + "</label>")
	var chidren = XMLParseUtil.getChildren(node);
	if (chidren.length > 0) {
		firstStrTD.attr("rowSpan", chidren.length);
		for (var i = 0, len = chidren.length; i < len; i++) {
			var node = chidren[i];
			var nodejs = XMLParseUtil.parseNode4Json(node, strNodeJs["xpath"],
					i);
			if (i == 0) {
				parentTable
						.append(createStructreExTR(model, nodejs, firstStrTD));
			} else {
				parentTable.append(createStructreExTR(model, nodejs));
			}
		}
	}
	return parentTable;
}

/**
 * 结构体的从新加载
 * @param {} event
 */
function reloadTDField(event) {
	var xpath = event.data.xpath;
	var selectElem = document.getElementById(xpath + "_select");// $("#"+xpath+"_select");
	var inputElem = document.getElementById(xpath + "_id");// $("#"+xpath+"_id");
	if (selectElem && inputElem) {

		if (!selectElem.value) {
			inputElem.style.display = 'block';
		} else {
			inputElem.style.display = 'none';
		}
		inputElem.value = selectElem.value;
	}

}

/**
 * 创建传入参数结构体
 * @param {} model
 * @param {} nodeJs
 * @param {} firstTD
 * @return {}
 */
function createStructreTR(model, nodeJs, firstTD) {

	var structTR = $("<TR></TR>");

	var nameField = $("<td></td>").html("<label>" + nodeJs["attr"]["name"]
			+ "<label/>");
	var desField = $("<td></td>").html("<label>" + nodeJs["attr"]["title"]
			+ "<label/>");

	var selectElem = createSelectElement(nodeJs.xpath + "_select", [{
						name : '固定值',
						val : ''
					}, {
						name : '最后更新时间',
						val : '最后更新时间'
					}, {
						name : '当前执行时间',
						val : '当前执行时间'
					}],/* 加入field组 */[{
						name : CFG_TYPE.GROUP.G_TB_FIELD,
						val : 'true'
					}], nodeJs["attr"]["ekpid"], '', false, model);
	selectElem.attr("attrName", "ekpid").attr("xpath", nodeJs.xpath);
	$(selectElem).bind("propertychange", {
				xpath : nodeJs.xpath
			}, reloadTDField);
	// var selectField = $("<td></td>").append(selectElem);//
	// html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	var selectField = $("<td></td>");// .html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	selectField.append(selectElem);
	var bindFieldContext = $("<input type='text'>").attr('xpath', nodeJs.xpath)
			.attr("attrName", 'text').attr('id', nodeJs.xpath + "_id").attr(
					"value", nodeJs.nodeValue ? nodeJs.nodeValue : '');
	if (!$(selectElem).val()) {
		bindFieldContext.css("display", "block");
	}
	if (bindFieldContext.val()) {
		bindFieldContext.css("display", "block");
	}

	bindFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);

	selectField.append(bindFieldContext);

	var mappingFieldContext = $("<input type='text'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'ekpname').attr('id',
			nodeJs.xpath + "_map");;
	mappingFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var mappingField = $("<td></td>").append(mappingFieldContext);
	if (firstTD) {
		structTR.append(firstTD);
	}
	structTR.append(nameField);
	structTR.append(desField);
	structTR.append(selectField);
	// structTR.append(bindField.append(bindFieldContext));
	structTR.append(mappingField);

	return structTR;
}

/**
 * 创建传出参数结构体
 * @param {} model
 * @param {} nodeJs
 * @param {} firstTD
 * @return {}
 */
function createStructreExTR(model, nodeJs, firstTD) {

	var structTR = $("<TR></TR>");

	var nameField = $("<td></td>").html("<label>" + nodeJs["attr"]["name"]
			+ "<label/>");
	var desField = $("<td></td>").html("<label>" + nodeJs["attr"]["title"]
			+ "<label/>");
	desField.attr("style", "word-break:break-all");

	var selectElem = createSelectElement(nodeJs.xpath + "_select", [{
						name : '==请选择==',
						val : ''
					}, {
						name : '最后更新时间',
						val : '最后更新时间'
					}, {
						name : '当前执行时间',
						val : '当前执行时间'
					}],/* 加入field组 */[{
						name : CFG_TYPE.GROUP.G_TB_FIELD,
						val : 'true'
					}], nodeJs["attr"]["ekpid"], '', false, model);
	selectElem.attr("attrName", "ekpid").attr("xpath", nodeJs.xpath);
	$(selectElem).bind("propertychange", {
				xpath : nodeJs.xpath
			}, reloadTDField);
	var selectField = $("<td></td>").append(selectElem);// html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	// var
	// bindField=$("<td></td>");//.html("<label>"+nodeJs["attr"]["title"]+"<label/>");
	// var bindFieldContext=$("<input
	// type='text'>").attr('xpath',nodeJs.xpath).attr("attrName",'text').attr('id',nodeJs.xpath+"_id").attr("value",nodeJs.nodeValue?nodeJs.nodeValue:'').attr("display","none");
	// if($(selectElem).val()){
	// bindFieldContext.attr("display","block");
	// }
	// if(bindFieldContext.val()){
	// bindFieldContext.attr("display","block");
	// }
	//    
	// bindFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
	// ? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
	// : CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var mappingFieldContext = $("<input type='text'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'ekpname').attr('id',
			nodeJs.xpath + "_map").attr("value",
			nodeJs["attr"]["ekpname"] ? nodeJs["attr"]["ekpname"] : '');
	mappingFieldContext.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
			? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
			: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var mappingField = $("<td></td>").append(mappingFieldContext);
	var keyFieldContext = $("<input type='checkbox'>").attr('xpath',
			nodeJs.xpath).attr("attrName", 'dbiskey').attr('id',
			nodeJs.xpath + "_key");
	if (nodeJs["attr"]["dbiskey"] == '1' || nodeJs["attr"]["dbiskey"] == 'true') {
		keyFieldContext.attr("checked", "true");
	}
	if (model == CFG_TYPE.MODEL.MODEL_VIEW) {
		keyFieldContext.attr("disabled", true);
	}
	var keyField = $("<td></td>").append(keyFieldContext);

	if (firstTD) {
		structTR.append(firstTD);
	}
	structTR.append(nameField);
	structTR.append(desField);
	structTR.append(selectField);
	// structTR.append(bindField.append(bindFieldContext));
	structTR.append(mappingField);
	structTR.append(keyField);

	return structTR;
}

/**
 * 根据配置信息创建表头
 * @param {}
 *            model
 * @param {}
 *            TDAttrs [{html: className: attrs:[{name: val:}]}]
 */
function createTitleTR(model, TDAttrs) {
	var titleTR = $("<TR></TR>");
	for (var i = 0, len = TDAttrs.length; i < len; i++) {
		var td = $("<TD></TD>");
		td.html(TDAttrs[i]["html"] ? TDAttrs[i]["html"] : "");
		td.addClass(TDAttrs[i]["className"]
				? TDAttrs[i]["className"]
				: CFG_TYPE.CLASSNAME.DEF_TD_TITLE_CLASSNAME);
		if (TDAttrs[i]["attrs"]) {
			for (var j = 0, j_len = TDAttrs[i]["attrs"].length; j < j_len; j++) {
				td
						.attr(TDAttrs[i]["attrs"][j].name,
								TDAttrs[i]["attrs"][j].val);
			}
		}
		titleTR.append(td);
	}
	return titleTR;
}

/**
 * 创建数据库表格选择框
 * @param {}
 *            model
 * @param {}
 *            bindId
 * @param {}
 *            bindElem
 * @param {}
 *            dataSourceId
 * @param {}
 *            groupAttrs
 * @param {}
 *            events //只绑定一个值
 * @return {}
 */
function createSimpleTools(model, bindId, bindElem, dataSourceId, groupAttrs,
		events, defClocal) {

	var parentDiv = $("<div></div>");
	var idElem = $("<input type='hidden' readOnly='true' >").attr("id", bindId)
			.attr("name", bindId).addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
					? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
					: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	var nameElem = $("<input type='text' readOnly='true' >").attr("id",
			bindElem).attr("name", bindElem).attr("size", '40')
			.addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
					? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
					: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME);
	if (defClocal) {
		idElem.attr("value", defClocal["tbName"] ? defClocal["tbName"] : '');
		nameElem.attr("value", defClocal["tbName"] ? defClocal["tbName"] : '');
	}

	if (groupAttrs && groupAttrs.length > 0) {
		for (var i = 0, len = groupAttrs.length; i < len; i++) {
			idElem.attr(groupAttrs[i].name, groupAttrs[i].val);
			nameElem.attr(groupAttrs[i].name, groupAttrs[i].val);
		}
	}
	var eventElem = $("<img></img>").attr("style", "cursor:hand")
			.attr("alt", "【获取】").attr("src",
			Com_Parameter.ContextPath
					+ "resource/style/common/images/small_search.png");
	// 处理不兼容火狐（以回调形式实现）
	if (events && !isEmptyObject(events)) {
		for (var j = 0, len = events.length; j < len; j++) {
			var eventType = events[j]["type"];
			$(idElem).bind(eventType, events[j]["data"],
					events[j]["fn"]);
		}
	}
	
	if (model == CFG_TYPE.MODEL.MODEL_EDIT) {
		eventElem.bind("click", {
					id : bindId,
					name : bindElem,
					dsId : dataSourceId
				}, function(event) {
					// 处理不兼容火狐（增加参数） 
					loadTableNameTree(event.data.dsId, event.data.id,
							event.data.name, events[0]["fn"], events[0]);
				});
	}
	parentDiv.append(idElem).append(nameElem).append(eventElem);
	return parentDiv;
}

/**
 * 创建sql 语句 选择框(暂时没有做)
 */
function createSQLTools() {

}

/**
 * 创建查询选择模式，通过sql语句还是简单查询
 * @param {} id
 * @param {} model
 * @param {} attrs
 * @return {}
 */
function createTableBar(id, model, attrs) {
	var tdbar = $("<TD></TD>");
	for (var i = 0, len = attrs.length; i < len; i++) {
		tdbar.attr(attrs[i]["name"], attrs[i]["val"]);
	}
	// id, options, attrs, events, defValue, showSelect,model
	var select = createSelectElement(id, [{
						name : '普通查询',
						val : 'simple'
					}], null, null, 'simple', false, model);
	tdbar.append(select);

	return tdbar;
}

/**
 * 获取父亲节点信息
 * @param {} partNodeName
 */
function getPartNodeInfo(partNodeName) {
	var partInfo = {}
	if (!XMLParseUtil.xmlDoc)
		return;
	var rootNode = XMLParseUtil.getXMLRootNode();
	var xpath = XMLParseUtil.addXpath("", rootNode.nodeName);
	var partNode = XMLParseUtil.getChildren(rootNode, partNodeName)[0];
	partInfo.xpath = XMLParseUtil.addXpath(xpath, partNode.nodeName);
	partInfo.node = partNode;
	return partInfo;
}

/**
 * 函数选择框
 * @param {}
 *            id
 * @param {}
 *            name
 * @param {}
 *            model
 */
function createDragElement(id, name, defId, defName, model) {
		// fdRfcSettingId fdRfcSettingName
	var parentDiv = $("<div></div>");
	var idElem = $("<input type='hidden' readOnly='true' >").attr("id", id)
			.attr("name", id).addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
					? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
					: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME).attr(
					"value", defId ? defId : "");

	var nameElem = $("<input type='text' readOnly='true' >").attr("id", name)
			.attr("name", name).addClass(model == CFG_TYPE.MODEL.MODEL_VIEW
					? CFG_TYPE.CLASSNAME.DEF_INPUT_VIEW_CLASSNAME
					: CFG_TYPE.CLASSNAME.DEF_INPUT_EDIT_CLASSNAME).attr(
					"value", defName ? defName : "");;
	var eventElem = $("<img></img>").attr("style", "cursor:hand").attr("alt",
			"选择函数").attr(
			"src",
			Com_Parameter.ContextPath
					+ "resource/style/common/images/small_search.png");
	if (model == CFG_TYPE.MODEL.MODEL_EDIT) {
		eventElem.bind("click", {
					id : id,
					name : name
				}, function(event) {
					var def = $("#" + id).val();
					loadCategoryTree(event.data.id, event.data.name,
							loadXmlMethod, [event.data.id, def]);
				});
	}
	parentDiv.append(idElem).append(nameElem).append(eventElem);
	return parentDiv;
}

/**
 * 工具方法，判断对象是否为空对象
 * @param {} obj
 * @return {Boolean}
 */
function isEmptyObject(obj) {
	for (var name in obj) {
		return false;
	}
	return true;

}

/**
 * 重新加载xml数据触发方法
 * @param {} rfcDomId
 * @param {} def
 */
function loadXmlMethod(rfcDomId, def) {
	var val = document.getElementById(rfcDomId).value;
	if (def != val) {
		$.cover.show();
		var data = new KMSSData();
		data.SendToBean("tibSapMappingFuncXmlService&fdRfcSettingId=" + val,
				resetTable);
	}else
	{
	   if(confirm("检测到当前函数与选择函数一致,是否重新加载数据")){
	     $.cover.show();
		var data = new KMSSData();
		data.SendToBean("tibSapMappingFuncXmlService&fdRfcSettingId=" + val,
				resetTable);
	   }
	
	
	}
	
	
}
/**
 * 根据xml返回值重新加载页面
 * @param {} rtnData
 */
function resetTable(rtnData) {
	if (rtnData.GetHashMapArray().length == 0) {
		resetPage(CFG_TYPE.MODEL.MODEL_EDIT, '', false);
		$.cover.hide();
		return;	
	}
	if (rtnData.GetHashMapArray()[1]["MSG"] != "SUCCESS") {
		resetPage(CFG_TYPE.MODEL.MODEL_EDIT, '', false);
		$.cover.hide();
		return;
	}
	var fdRfcXml = rtnData.GetHashMapArray()[0]["funcXml"];
	resetPage(CFG_TYPE.MODEL.MODEL_EDIT, fdRfcXml, false);
	$.cover.hide();
}

/**
 * 联动方法,根据参数隐藏or显示dom
 * @param {} divId
 * @param {} text
 * @param {} type
 */
function toggleDiv(divId, text, type) {
	var div = $("#" + divId);
	div.html(text);
	if (type == "show") {
		div.show("slow");
	} else if (type == "hide") {
		div.hide("slow");
	}

}
/**
 * 加载数据下拉列表
 * @param {} dbElemId
 * @param {} tableElemId
 * @param {} afterLoad
 * @param {} args
 */
function loadFieldList(dbElemId, tableElemId, afterLoad, args) {
	var db = $("#" + dbElemId).val();
	var tableElem = $("#" + tableElemId).val();
	if (!db) {
		// toggleDiv(dbElemId+"_errDiv","没有选择数据源","show");
		return;
	}
	if (!tableElem) {
		// toggleDiv(tableElemId+"_errDiv","没有填写table","show");
		return;
	}
	$.ajax({
		data : {
			table : tableElem,
			dbId : db
		},
		type : "post",
		url : Com_Parameter.ContextPath
				+ 'tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=getFieldList',
		beforeSend : function(XMLHttpRequest) {
			$.cover.show();
		},
		complete : function(XMLHttpRequest, textStatus) {
			$.cover.hide();
		},
		success : function(data, textStatus) {
			args.push(data);
			args.push(textStatus);
			afterLoad.apply(this, args);
		},
		error : function() {
			alert("加载数据发生错误");
			$.cover.hide();
		},
		dataType : "json"
	})

}
/**
 * 加载bapi函数分类
 * @param {} bindId
 * @param {} bindName
 * @param {} callbackFunc
 * @param {} callbackArgs
 */
function loadCategoryTree(bindId, bindName, callbackFunc, callbackArgs) {
	// fdRfcSettingId fdRfcSettingName
	Dialog_TreeList(false, bindId, bindName, ';',
			'tibSapMappingFuncTreeListService&selectId=!{value}&type=cate',
			'函数分类',
			'tibSapMappingFuncTreeListService&selectId=!{value}&type=func',
			function() {
				callbackFunc.apply(this, callbackArgs);
				// loadXmlMethod(bindId);
		}, 'tibSapMappingFuncTreeListService&type=search&keyword=!{keyword}', null,
			null, null, '选择函数');
}
/**
 * 
 * @param {} dbId
 * @param {} bindId
 * @param {} bindName
 */
function loadTableNameTree(dbId, bindId, bindName, backFunc, eventData) {
	
	if (!$("#" + dbId).val()) {
		alert("请填写数据源");
	} else {
		// mulSelect, idField, nameField, splitStr, dataBean, action,
		// searchBean, isMulField, notNull, winTitle
		// 处理不兼容火狐（增加参数） 
		Dialog_List(false, bindId, bindName, ";", "tibSapSyncLoadDBTableService&dbId="
						+ $("#" + dbId).val(), 
						function(){backFunc.call(this, eventData);}, 
						"tibSapSyncLoadDBTableService&keyword=!{keyword}&dbId="+$("#" + dbId).val(), null, null, "选择数据库表");
						
						
						
	}
}

/**
 * 加载数据源
 * 
 * @param {}
 *            afterLoad 加载后回调函数,
 * @param {}
 *            args 回调函数参数,并且在后面追加2个参数 data集合&&textStatus回调状态
 */
function loadDBList(afterLoad, args) {
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
		success : function(data, textStatus) {
			args.push(data);
			args.push(textStatus);
			afterLoad.apply(this, args);
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
 * 
 * @param {}
 *            target 目标DOM
 * @param {}
 *            model edit or view
 * @param {}
 *            options [{name: val }] 选项
 * @param {}
 *            defValue 默认value
 * @param {}
 *            showSelect 是否显示请选择
 * @return {} target DOM
 */
function addOptions(target, model, options, defValue, showSelect) {
	
	if (showSelect) {
		var option = "<option value ='' >==请选择==</option>";
		$(target).prepend(option);
	}
	var flag = false;
	for (var i = 0, len = options.length; i < len; i++) {
		var option = "<option value ='" + options[i].val + "' >"
				+ options[i].name + "</option>";

		$(target).append(option);
	}
	if (defValue) {
		$(target).val(defValue);
		// $(target).find("option:value='"+defValue?defValue:''+"'").attr("selected","true");
		// alert(defValue+"-"+flag);
		// var defOption = "<option selected=true value ='"+defValue+"'
		// >"+defValue+"</option>";
		// $(target).append(defOption);
	} else {
		$(target).val("");
	}
	if (model == CFG_TYPE.MODEL.MODEL_VIEW) {
		$(target).attr("disabled", "true");
	}

	return target;
}
/**
 * 加载数据库下拉列表
 * @param {} target
 * @param {} model
 * @param {} defVal
 * @param {} showSelect
 * @param {} data
 * @param {} textStatus
 */
function initDBList(target, model, defVal, showSelect, data, textStatus) {
	var options = [];
	$.each(data, function(index, item) {
				item = eval("(" + item + ")");
				options.push({
							name : item.fdName,
							val : item.compId
						});
			});

	addOptions($(target), model, options, defVal, showSelect);
}

/**
 * 加载数据库字段列表下拉
 * @param {} target
 * @param {} model
 * @param {} defVal
 * @param {} showSelect
 * @param {} data
 * @param {} textStatus
 */
function initField(target, model, defVal, showSelect, data, textStatus) {
	var options = [];
	$.each(data, function(index, item) {
				item = eval("(" + item + ")");
				options.push({
							name : item.fieldName + "(" + item.dataType + ")",
							val : item.fieldName
						});
			});
	addOptions($(target), model, options, defVal, showSelect);
}

/**
 * 清空目标
 * @param {} target
 * @param {} options
 * @param {} defValue
 */
function resetOption(target, options, defValue) {
	$(target).empty();
}

/**
 * 提交数据
 */
function submitFunc() {
	var model = FUNC_OBJECT.cfg_model
			&& FUNC_OBJECT.cfg_model == CFG_TYPE.MODEL.MODEL_EDIT
			? CFG_TYPE.MODEL.MODEL_EDIT
			: CFG_TYPE.MODEL.MODEL_VIEW;
	if (model == CFG_TYPE.MODEL.MODEL_VIEW) {
		window.close();
	} else {
		var inputElements = $("input[attrName]");
		var selectElements = $("select[attrName]");
		if (!XMLParseUtil.xmlDoc) {
			return
		};
		inputElements.each(function(index, item) {
					var xpath = $(item).attr("xpath");
					var attr = $(item).attr("attrName");
					doUpdate(attr, xpath, item);
				});
		var flag=true;		
		selectElements.each(function(index, item) {
					var xpath = $(item).attr("xpath");
					var attr = $(item).attr("attrName");
					var rs=doUpdate(attr, xpath, item);
					if(!rs.flag){
					  alert("检测到:"+rs.name[0]+"这个表需要勾选主键或者KEY,请处理~!");
					 flag=false;
					 return false;
					}
				});
		FUNC_OBJECT.fdRfcXml =  XML2String(XMLParseUtil.xmlDoc);//XMLParseUtil.xmlDoc.xml;
		FUNC_OBJECT.fdRfcSettingId = $("#fdRfcSettingId").val();
		FUNC_OBJECT.fdRfcSettingName = $("#fdRfcSettingName").val();
		if(!flag){
		}else{
		window.close();
		}
	}
}

/**
 * 更新
 * @param {} attr 
 * @param {} xpath
 * @param {} jqItem
 * @return {}
 */
function doUpdate(attr, xpath, jqItem) {
	var flagTable={name:[],flag:true};
	if (xpath && attr) {
		var value = $(jqItem).val();
		var node = XMLParseUtil.selectSingleNode(xpath);
		if (node[0] != undefined) {
			node = node[0];
		}
		
		switch (attr) {
			case "text" :
				node.text = value;
				break;
			case "ekpid" :
				XMLParseUtil.setNodeAttrs(node, {
							name : 'ekpid',
							val : value
						});
				break;
			case "ekpname" :
				XMLParseUtil.setNodeAttrs(node, {
							name : 'ekpname',
							val : value
						});
				break;
			case "dbiskey" :
				var val = $(jqItem).prop("checked") == true ? "1" : "0";
				XMLParseUtil.setNodeAttrs(node, {
							name : 'dbiskey',
							val : val
						});
				break;
			case "clocal" :
				var clocal = {};
				clocal.type = 1;
				clocal.tbName = value;
				clocal.id = $("#dbselect").val();
				var clocalString = Clocal2String(clocal);
				XMLParseUtil.setNodeAttrs(node, {
							name : 'clocal',
							val : clocalString
						});
				break;
			case "timestamp_ekp" :
				XMLParseUtil.setNodeAttrs(node, {
							name : 'timestamp_ekp',
							val : value
						});
				break;
			case "sendType" :
				if (value == '1' || value == '3' || value == '4'
						|| value == '5') {
                    if(!hasKey(node)){
	                    flag=false;
	                    flagTable["name"].push(XMLParseUtil.getAttrByName(node,"name",""));
	                    flagTable["flag"]=false;
                    }
				}

				XMLParseUtil.setNodeAttrs(node, {
							name : 'sendType',
							val : value
						});
				break;
			case "del_condition" :
				value = Com_HtmlEscape(Com_Trim(value));
				XMLParseUtil.setNodeAttrs(node, {
							name : 'del_condition',
							val : value
						});
				break;
			default :
				break;
		}
	}
//	if(!flag){
//	 return flag;
//	}
//	return node;
	return flagTable;
}

/**
 * 是否存在dbiskey
 * @param {} node
 * @return {Boolean}
 */
function hasKey(node) {
	var fields = $(node).find("field");//node.selectNodes(".//field");
	for (var i = 0, len = fields.length; i < len; i++) {
		var val = {};
		// node, parentXpath, index,defAttrs 得出的xpath是不准确的,只要数据
		var nodeJs = XMLParseUtil.parseNode4Json(fields[i], "", i, null);
		// val.name = nodeJs["attr"]["title"] + "-(" + nodeJs["attr"]["name"]
		// + ")";
		// val.val = nodeJs["attr"]["name"];
		// options.push(val);
		var keyVal = nodeJs["attr"]["dbiskey"];
		if (keyVal) {
			if (keyVal == '1' || keyVal == 'true') {
				return true;
			}
		}
	}
	return false;
}

 /**
 * XML对象转字符串 
 * @param xmlObject
 * @returns
 */
 function XML2String(xmlObject) {
 	// for IE
 	if (window.ActiveXObject) {
 		return xmlObject.xml;
 	} else {
 		// for other browsers
 		return (new XMLSerializer()).serializeToString(xmlObject);
 	}
 } 

