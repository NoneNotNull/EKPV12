

// notes:修改此文件必须更新jsp 片段 ,km/review 模板修改一下控件参数重新提交(目的是为了重新生成新的jsp)
// @see
// com.landray.kmss.tib.sap.mapping.plugins.controls.list.TibSapMappingListControl.doParse
// line 191
// 多控件同时存在时候必须注意方法名称,建议定义一个独立function 包裹这里的方法,每个控件有自己独立的空间

// ========================callBackGetFuncId方法
// 获取输入参数的XML模版
function SapDataByList_XmlTemplate_uniqueId(thisObj) {

	// 显示加载图片
	Control_AppendLoadImg(thisObj, 'sapListShowOnload_uniqueId' + ESAP_Index);
	// 获取XML模版
	var mappingFuncId = "_mappingFuncId";
	var data = new KMSSData();
	data.SendToBean("tibSapMappingListFuncXml&funcId=" + mappingFuncId,
			// modify by zhangtian
			function(rtn) {
		// 修正方法上下文 this的指向,用于获取当前行的
		SapDataByList_OperationXml_uniqueId.call(thisObj, rtn);
	});
}

// notes:此次方法的this被修改~需要使用this注意
function SapDataByList_OperationXml_uniqueId(rtnData) {
	var rtnDataObj = rtnData.GetHashMapArray()[0];
	var rfcName = rtnDataObj["rfcName"];
//	modify by zhangtian 如果名称为空,这个为空传递到后台会报空指针异常
	if(!rfcName){
		return ;
	}
	var fdRfcParamXmlObject = XML_CreateByContent(rtnDataObj["funcXml"]);
	var xpath = "/jco/import/field|/jco/import/structure/field";
	var importFields = XML_GetNodes(fdRfcParamXmlObject, xpath);
	// 为import传入参数赋值
	var flag = true;
	for (var i = 0; i < importFields.length; i++) {
		var fieldNode = importFields[i];
		var ekpid = EkpCommon.getString(XML_GetAttribute(fieldNode, 'ekpid'));
		// 定义并获取映射值
		var isoptional = XML_GetAttribute(fieldNode, 'isoptional');
		var ekpname = XML_GetAttribute(fieldNode, 'ekpname');
		if (ekpid == '') {
			continue;
		}
		// 传入参数为明细表
		if (ekpid.indexOf('.') != -1) {
			ekpid = 'extendDataFormInfo.value('
					+ ekpid.replace('\.', '.' + ESAP_Index + '.') + ')';
			if (document.getElementsByName(ekpid)[0] == null) {
				ekpid = ekpid.replace('.' + ESAP_Index + '.', '.0.');
			}
		}
		// 判断必填项是否有值，若必填项为空值，则在后面判断flag为false就return;
		if (isoptional == 'true' && GetXFormFieldValueById(ekpid)[0] == '') {
			alert(ekpname + " _notEmpty_lang");
			flag = false;
		}
		ESAP_EkpId[i] = ekpid;
		// 设置节点后代的文本的值
		fieldNode.text = GetXFormFieldValueById(ekpid)[0];
	}
	var inputTablesXpath = "/jco/tables/table[@isin='1']";
	var importTables = XML_GetNodes(fdRfcParamXmlObject, inputTablesXpath);
	for (var i = 0; i < importTables.length; i++) {
		var table = importTables[i];
		var records = table.childNodes;
		// 定义第一条记录
		var fields0 = records[0].childNodes;
		var tableKey = "";
		var mxTableArray = [];
		var recordObj = records[0];
		for (var j = 0; j < records.length; j++) {
			var record = records[j];
			var fields = record.childNodes;
			for (var k = 0; k < fields.length; k++) {
				var field = fields[k];
				var field0 = fields0[k];
				var ekpid = EkpCommon.getString(XML_GetAttribute(field0,
						'ekpid'));
				if (ekpid == '') {
					continue;
				}
				// 传入表格为明细表
				var firstIndex = ekpid.indexOf('.');
				if (firstIndex != -1) {
					var tableKey = 'TABLE_DL_' + ekpid.substring(0, firstIndex);
					ekpid = 'extendDataFormInfo.value('
							+ ekpid.replace('\.', '.' + j + '.') + ')';
					if (document.getElementsByName(ekpid)[0] == null) {
						// ekpid = ekpid.replace('.'+ ESAP_Index +'.', '.0.');
					}
					field.text = document.getElementsByName(ekpid)[0].value;
				} else {
					field.text = document
							.getElementsByName("extendDataFormInfo.value("
									+ ekpid + ")")[0].value;
				}
			}
		}
		var rows = document.getElementById(tableKey).rows;
		for (var m = 0; m < rows.length - 2; m++) {
			var cloneRecord = recordObj.cloneNode(true);
			var cloneFields = cloneRecord.childNodes;
			for (var n = 0; n < cloneFields.length; n++) {
				var field = cloneFields[n];
				var field0 = fields0[n];
				var ekpid = EkpCommon.getString(XML_GetAttribute(field0,
						'ekpid'));
				if (ekpid == '') {
					continue;
				}
				// 传入表格为明细表
				var firstIndex = ekpid.indexOf('.');
				if (firstIndex != -1) {
					var tableKey = 'TABLE_DL_' + ekpid.substring(0, firstIndex);
					ekpid = 'extendDataFormInfo.value('
							+ ekpid.replace('\.', '.' + m + '.') + ')';
					if (document.getElementsByName(ekpid)[0] == null) {
						// ekpid = ekpid.replace('.'+ ESAP_Index +'.', '.0.');
					}
					field.text = document.getElementsByName(ekpid)[0].value;
				} else {
					field.text = document
							.getElementsByName("extendDataFormInfo.value("
									+ ekpid + ")")[0].value;
				}
			}
			table.appendChild(cloneRecord);
		}
		// table.removeChild(table.firstChild);
	}
	// 有输入值为空
	if (!flag) {
		// 隐藏图片
		Control_RemoveLoadImg('sapListShowOnload_uniqueId' + ESAP_Index);
		document.getElementById('SapDataByList_Sign').value = '1';
		return;
	} else {
		// 把传入参数设置为disable，让其不能改变
		for (var j = 0; j < ESAP_EkpId.length; j++) {
			var ekpidObj = GetXFormFieldById(ESAP_EkpId[j]);
			if (ekpidObj[0] == null) {
				Control_RemoveLoadImg('sapListShowOnload_uniqueId' + ESAP_Index);
				document.getElementById('SapDataByList_Sign').value = '1';
			}
			ekpidObj[0].disabled = true;
		}
	}
	// 为table类型的传入参数赋值,取tabel的属性为isin为1的table,调用sapEkpFormEvent.js
	SapForm.setImportTableXml(fdRfcParamXmlObject);
	var data = new KMSSData();
	// input框的值，作为key
	var tempInputValueKey = "uniqueId_";
	for (var t = 0; t < ESAP_EkpId.length; t++) {
		var tempEkpidObj = GetXFormFieldById(ESAP_EkpId[t]);
		tempInputValueKey += ESAP_EkpId[t] + ':' + tempEkpidObj[0].value +",";
	}
	tempInputValueKey = tempInputValueKey.replace(/\'/g, "");
	// modify by zhangtian
	var that = this;
	data.SendToBean("tibSapMappingListControlBackXmlBean&xml="
					+ EkpCommon.XML2String(fdRfcParamXmlObject) +"&fdKey="+ tempInputValueKey
					+ "&showValueJson=_showValueJson", 
			function(rtn) {
				// 方法this执行再修改
				SapDataByList_Call_ExportParam_uniqueId
						.call(that, rtn, rfcName, tempInputValueKey, fdRfcParamXmlObject);
			});
}

// 设置输出参数
function SapDataByList_Call_ExportParam_uniqueId(rtnData, rfcName, fdKey, fdRfcParamXmlObject) {
	// 隐藏图片
	Control_RemoveLoadImg('sapListShowOnload_uniqueId' + ESAP_Index);
	document.getElementById('SapDataByList_Sign').value = '1';
	// 打开传入参数的只读
	for (var x = 0; x < ESAP_EkpId.length; x++) {
		var ekpidObj = GetXFormFieldById(ESAP_EkpId[x]);
		ekpidObj[0].disabled = false;
	}
	ESAP_EkpId = new Array();
	// 判断返回参数是否有值
	if (rtnData.GetHashMapArray()[0]["message"] != null) {
		alert(rtnData.GetHashMapArray()[0]["message"]);
		return false;
	}
	var exportParamXml = rtnData.GetHashMapArray()[0]["exportParamXml"];
	var showJson = "_showValueJson";
	var checkedValues = new Array();
	checkedValues = window.showModalDialog(
			Com_Parameter.ContextPath
					+ "tib/sap/mapping/plugins/controls/list/tib_sap_mapping_list_control_main/tibSapMappingListControlMain_list.jsp" 
					+ "?isMulti=_isMulti&fdKey="+ encodeURIComponent(fdKey) +"&rfcName="
					+ encodeURIComponent(rfcName) +"&showJson="+ encodeURIComponent(showJson), "_showValueJson",
			"dialogWidth=900px;dialogHeight=520px");
	// 执行赋值
	if (checkedValues != undefined && checkedValues.length > 0) {
		SapDataByList_SetValue(fdRfcParamXmlObject, checkedValues, this, exportParamXml);
	}
	return false;
}

/**
 * 为表单赋值方法
 * @param fdRfcParamXmlObject 	全部的XML数据
 * @param checkedValues 		所选的数据
 * @return
 */
function SapDataByList_SetValue(fdRfcParamXmlObject, checkedValues, thisObj, exportParamXml) {
	if (typeof SapDataByList_CallBackBefore == "function") {
		/**
		 * 调用外部JS(备注：暂时这样做，以后会改动)
		 * @thisObj					该控件的Object对象
		 * @checkedValues			所勾选的JSON数据
		 */
		 SapDataByList_CallBackBefore(thisObj, checkedValues);
	}
		
	var exportParamXmlObj = XML_CreateByContent(exportParamXml);
	var exportTables = XML_GetNodes(fdRfcParamXmlObject,
			"/jco/tables/table[@isin='0']");

	var table = exportTables[0];
	// modify by zhangtian 赋值策略
	var data = SapDataByList_parserData(table);
	var inDetail = SapDataByList_isInDetail(thisObj);

	var stg = SapDataByList_strategy();

	// 控件在明细表中单选
	if (inDetail && checkedValues.length < 2) {
		stg.dt_one.execute.call(stg, data, checkedValues, thisObj);
	}
	// 控件在明细表中多选
	else if (inDetail && checkedValues.length > 1) {
		stg.dt_more.execute.call(stg, data, checkedValues, thisObj);

	} 
	// 控件在在明细表外面
	else if (!inDetail) {
		stg.ot_info.execute.call(stg, data, checkedValues, thisObj);
	}
	
	var exportFields = XML_GetNodes(exportParamXmlObj,
			'/export/field|/export/structure/field');
	// 遍历传出参数节点
	for (var i = 0; i < exportFields.length; i++) {
		var fieldNode = exportFields[i];
		var ekpid = EkpCommon.getString(XML_GetAttribute(fieldNode, 'ekpid'));
		if (ekpid == '')
			continue;
		// 设置传出参数的值
		SetXFormFieldValueById(ekpid, fieldNode.text);
	}
	if (typeof SapDataByList_CallBackCustom == "function") {
		/**
		 * 调用外部JS(备注：暂时这样做，以后会改动)
		 * @thisObj					该控件的Object对象
		 * @checkedValues			所勾选的JSON数据
		 */
		SapDataByList_CallBackCustom(thisObj, checkedValues);
	}
	if (typeof SapDataByList_CallBackAfter == "function") {
		/**
		* 调用外部JS(备注：暂时这样做，以后会改动)
		* @thisObj					该控件的Object对象
		* @checkedValues			所勾选的JSON数据
		*/
		SapDataByList_CallBackAfter(thisObj, checkedValues);
	}
	
}

// 各种情况枚举 每种情况用自己的策略
function SapDataByList_strategy() {
	// ,免得改来改去,先写到这里
	return {
		// 控件在明细表中,单选
		// 修改当前行的数据
		dt_one : {
			/**
			 * @param {}  data 当前数据
			 * @param {}  selindex 索引数组
			 * @param {}  curElem 当前点击元素
			 */
			execute : function(data, selindex, curElem) {
				var recArray = data.records;
				// 选中目标record
				var checkedValueObj = selindex[0];
				var checkedValueJson = eval("("+ checkedValueObj +")");
				var fields = recArray[0]["fields"];
				var cfg_fields = recArray[0]["fields"];
				// NOTES:必须大写tagName
				var curTr = DocListFunc_GetParentByTagName("TR", curElem);
				for (var j = 0, j_len = fields.length; j < j_len; j++) {
					// notes:可能只有第0个才有配置信息
					if (cfg_fields[j]["ekpid"]) {
						// debugger;
						var ekpid = cfg_fields[j]["ekpid"];
						var ekpidIndex = null;
						for (var k = 0, lenK = checkedValueJson.length; k < lenK; k++) {
							if (checkedValueJson[k].value == cfg_fields[j]["name"]) {
								if (ekpidIndex = ekpid.indexOf(".") > -1) {
									var p_array = ekpid.split(".");
									var l_info = p_array[p_array.length - 1];
									$(curTr).find("[name*=" + l_info + "]")
											.val(checkedValueJson[k].td || "");
								} else {
									// 如果配置的是单值：
									// 数据替换
									SetXFormFieldValueById(ekpid, checkedValueJson[k].td);
								}
							}
						}
					}
				}
			}
		},
		// 控件在明细表，多选
		// 修改当前行数据，多选出来的增加行(怪需求)
		dt_more : {
			execute : function(data, selindex, curElem) {
				var recArray = data.records;
				// 当前表格
				var optTB = DocListFunc_GetParentByTagName("TABLE", curElem);
				// 第一行赋值
				this.dt_one.execute(data, selindex, curElem);
				// 第二行赋值
				for (var i = 1, len = selindex.length; i < len; i++) {
					var checkedValueObj = selindex[i];
					var checkedValueJson = eval("("+ checkedValueObj +")");
					var fields = recArray[0]["fields"];
					var cfg_fields = recArray[0]["fields"];
					var n_row = DocList_AddRow(optTB);
					// NOTES:必须大写tagName
					var curTr = DocListFunc_GetParentByTagName("TR", curElem);
					for (var j = 0, j_len = fields.length; j < j_len; j++) {
						// notes:可能只有第0个才有配置信息
						if (cfg_fields[j]["ekpid"]) {
							var ekpid = cfg_fields[j]["ekpid"];
							var ekpidIndex = null;
							for (var k = 0, lenK = checkedValueJson.length; k < lenK; k++) {
								if (checkedValueJson[k].value == cfg_fields[j]["name"]) {
									if (ekpidIndex = ekpid.indexOf(".") > -1) {
										var p_array = ekpid.split(".");
										var l_info = p_array[p_array.length - 1];
										$(n_row).find("[name*=" + l_info + "]")
												.val(checkedValueJson[k].td || "");
									} else {
										// 如果配置的是单值：
										// 叠加数据
										var ekpValue = GetXFormFieldValueById(ekpid)[0];
										if (ekpValue == "" || i == 0) {
											ekpValue = checkedValueJson[k].td;
										} else {
											ekpValue = ekpValue +";"+ checkedValueJson[k].td;
										}
										// 数据替换
										SetXFormFieldValueById(ekpid, ekpValue);
									}
								}
							}
						}
					}
				}
			}
		},
		// 控件在外面
		ot_info : {
			execute : function(data, selindex, curElem) {
				var recArray = data.records;
				var cfg_fields = recArray[0]["fields"];
				var opTB = null;
				// 明细表找当前表格
				for (var k = 0, k_len = cfg_fields.length; k < k_len; k++) {
					if (cfg_fields[k]["ekpid"]) {
						var ekpid = cfg_fields[k]["ekpid"];
						var ekpidIndex = null;
						if (ekpidIndex = ekpid.indexOf(".") > -1) {
							var p_array = ekpid.split(".");
							var tbKey = "TABLE_DL_" + p_array[0];
							opTB = document.getElementById(tbKey);
							break;
						} 
					}
				}
				// 检查是否为空
				if(opTB){
					// 找到最后一行判断数据是否为空
					var row=opTB.rows[opTB.rows.length-2];
					var flag=true;
					// 针对input值
					$(row).find("input").each(function(index,elem){
						//alert("$(elem).val()="+$(elem).val()+"-elem.type="+elem.type+"--tagname="+elem.tagName);
						// 如果有非空值,标记不能删除
						if($(elem).val() != "" && elem.type != "hidden" && elem.type != "button"){
							flag=flag&&false;						
						}
					});
					// add  select
					$(row).find("select").each(function(index,elem){
						// 如果有非空值,标记不能删除
						var val=$(elem).find("option:selected").val();
						if(val != ""){
							flag=flag&&false;						
						}
					});
					//add textarea
					$(row).find("textarea").each(function(index,elem){
						// 如果有非空值,标记不能删除
						var val=$(elem).text();
						if(val != "" && elem.style.display != "none;"){
							flag=flag&&false;						
						}
					});
					if(flag){
						DocList_DeleteRow(opTB.rows[opTB.rows.length-2]);
					}
				} 
				// 第二行赋值
				for (var i = 0, len = selindex.length; i < len; i++) {
					var checkedValueObj = selindex[i];
					var checkedValueJson = eval("("+ checkedValueObj +")");
					var fields = recArray[0]["fields"];
					var cfg_fields = recArray[0]["fields"];
					// 创建行
					var n_row = null;
					if (typeof(opTB)!='undefined' && opTB != null) {
						n_row = DocList_AddRow(opTB);
					}
					// NOTES:必须大写tagName
					for (var j = 0, j_len = fields.length; j < j_len; j++) {
						// notes:可能只有第0个才有配置信息
						if (cfg_fields[j]["ekpid"]) {
							var ekpid = cfg_fields[j]["ekpid"];
							var ekpidIndex = null;
							for (var k = 0, lenK = checkedValueJson.length; k < lenK; k++) {
								if (checkedValueJson[k].value == cfg_fields[j]["name"]) {
									if (ekpidIndex = ekpid.indexOf(".") > -1) {
										var p_array = ekpid.split(".");
										var l_info = p_array[p_array.length - 1];
										$(n_row).find("[name*=" + l_info + "]")
												.val(checkedValueJson[k].td || "");
									} else {
										// 如果配置的是单值：
										// 叠加数据
										var ekpValue = GetXFormFieldValueById(ekpid)[0];
										if (ekpValue == "" || i == 0) {
											ekpValue = checkedValueJson[k].td;
										} else {
											ekpValue = ekpValue +";"+ checkedValueJson[k].td;
										}
										// 数据替换
										SetXFormFieldValueById(ekpid, ekpValue);
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

// add by zhangtian
// 判断是否明细表
function SapDataByList_isInDetail(obj) {
	// 找到上级的table,可能判断会不正确
	var tb = DocListFunc_GetParentByTagName("TABLE", obj);
	if (!tb) {
		return false;
	}
	// TABLE_DL_fd_3073f7db7f065c
	var id = $(tb).attr("id");
	// doclist 的全局数组, 找到意味着在元素明细表当中
	for (var i = 0, len = DocList_Info.length; i < len; i++) {
		if (DocList_Info[i] == id) {
			return true;
		}
	}
	return false;
}

// add by zhangtian
function SapDataByList_parserData(xmlTb) {
	// 定义格式如下,把表格xml数据跟 数据格式分离，免得每次都改变赋值方案
	var parse = {};
	if (!xmlTb) {
		return parse;
	}
	var tbName = $(xmlTb).attr("name");
	// 定义表名称
	parse.tbName = tbName;
	// 取得表格的每一行
	var records = $(xmlTb).children();
	// 定义每一行
	parse.records = [];
	if (records && records.length > 0) {
		for (var i = 0, len = records.length; i < len; i++) {
			var c_record = records[i];
			var record = {
				fields : []
			};
			var fields = $(c_record).children();
			for (j = 0, j_len = fields.length; j < j_len; j++) {
				// 收集数据
				var field = fields[j];
				var f_name = $(field).attr("name");
				var f_value = field.text;
				var f_ekpid = $(field).attr("ekpid");
				if (f_ekpid && (f_ekpid.indexOf("$") == 0)
						&& (f_ekpid.lastIndexOf("$") == f_ekpid.length - 1)) {
					f_ekpid = f_ekpid.substring(1, f_ekpid.length - 1);
				}
				// 填充数据
				record.fields.push({
							name : f_name,
							value : f_value,
							ekpid : f_ekpid
						});
			}
			// add a record
			parse.records.push(record);
		}
	}
	return parse;
}


