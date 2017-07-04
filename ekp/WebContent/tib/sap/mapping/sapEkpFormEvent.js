/**
 * 解决js 方法名称冲突问题,js方法模块分离
 * base on :
 * commonFormEvent.js
 * (setFieldCellValue
 * deleteMxRows
 * getMxId
 * getString)
 */
jQuery.ajax({
	type : "GET",
	url : Com_Parameter.ContextPath + "tib/sap/mapping/sapEkpFormEvent.jsp",
	dataType : "script",
	// 设置同步,待加载完成以后才往下执行
	async : false
});
function SapFormEvent() {

	EkpCommonFormEvent.call(this, null);
	this.verion = "1.0";
	this.modelName = "ekpsap";
	this.info = TibSapMapping_lang.info;

	this.formEventFuncXmlService = "tibCommonMappingFormEventFuncXmlService";
	this.formEventFuncBackXmlService = "tibSapMappingFormEventFuncBackXmlService";
}

//集成common模块的属性
SapFormEvent.prototype = new EkpCommonFormEvent();

SapFormEvent.prototype.setImportParam = function(rtnData, beforeAction,
		afterAction, synch) {
	if (rtnData.GetHashMapArray().length == 0){
		this.blockhide();
		return;
	}
		
	if (!rtnData.GetHashMapArray()[0]["funcXml"]) {
		this.blockhide();
		alert(TibSapMapping_lang.noReturnData);
		return;
	}

	//==============================
	if (beforeAction) {
		if ('[object Function]' == Object.prototype.toString.call(beforeAction)) {
			beforeAction.call(this, rtnData);
		}
	}
	// =============================
	var fdRfcParamXmlObject = XML_CreateByContent(rtnData.GetHashMapArray()[0]["funcXml"]);
	// 得到传入参数field
	var importFields = XML_GetNodes(fdRfcParamXmlObject,
			"/jco/import/field|/jco/import/structure/field");
	// 为import传入参数赋值
	for ( var i = 0; i < importFields.length; i++) {
		var fieldNode = importFields[i];
		var ekpid = this.getString(XML_GetAttribute(fieldNode, "ekpid"));
		if (ekpid == "")
			continue;
		var ekpValueObjs = GetXFormFieldById(ekpid);
		var ekpLen = ekpValueObjs.length;
		// 处理单选或多选情况
		if (ekpLen > 1) {
			for (var j = 0; j < ekpLen; j++) {
				if (ekpValueObjs[j].checked) {
					$(fieldNode).text(ekpValueObjs[j].value);//fieldNode.nodeValue += ekpValueObjs[j].value;
				}
			}
		} else {
			$(fieldNode).text(ekpValueObjs[0].value); //.nodeValue = ekpValueObjs[0].value;
		}
		//fieldNode.text = GetXFormFieldValueById(ekpid)[0];// 设置节点后代的文本的值
	}
	// 为table类型的传入参数赋值,取tabel的属性为isin为1的table
	this.setImportTableXml(fdRfcParamXmlObject);
	this.getBackXml(this.XML2String(fdRfcParamXmlObject), afterAction, synch);
};

// 为table类型的传入参数赋值
SapFormEvent.prototype.setImportTableXml = function(xmlObject) {
	var importTables = XML_GetNodes(xmlObject, "/jco/tables/table[@isin='1']");
	var recordClone;
	for ( var i = 0; i < importTables.length; i++) {
		var importTable = importTables[i];
		var records = $(importTable).children();
		var firstRecord = records[0];// 得到第一个节点
		// 通过第一行的相关field的ekpid信息得到对应数据
		var fieldValue = this.getFieldValue($(firstRecord).children());
		var firstRecordClone = firstRecord.cloneNode(true);// 克隆此节点
		importTable.removeChild(firstRecord);// 先删除第一个record0节点
		var importRecodsLength = fieldValue["importRecodsLength"]; 
		//======如果是明细表的话就对应上===============================
		if (importRecodsLength) {
			for ( var j = 0; j < importRecodsLength; j++) {
				recordClone = firstRecordClone.cloneNode(true);
				recordClone.setAttribute("row", j);
				var fields = $(recordClone).children();
				for ( var z = 0; z < fields.length; z++) {
					var field = fields[z];
					var value = fieldValue[XML_GetAttribute(field, "name")];
					if (value instanceof Array) {// 如果为明细表数组
						$(field).text(value[j]);
					} else {// 否则为非明细表字段
						$(field).text(value);
					}
				}
				importTable.appendChild(recordClone);
			}

		}
		//===========================================
		importTable.setAttribute("rows", importRecodsLength);
	}
};

// 得到函数执行后返回的xml
SapFormEvent.prototype.getBackXml = function(xml, action, synch) {
	var that = this;
	var data = new ERP_data();//new KMSSData();
	data.SendToBean(this.formEventFuncBackXmlService + "&xml=" + encodeURIComponent(xml), function(
			rtnData) {
		that.blockhide();
		that.setExportParam(rtnData);
		// 处理回调函数
		if (action) {
			if ('[object Function]' == Object.prototype.toString.call(action)) {
				action.call(this, rtnData);
			}
		}
	}, synch);
};
SapFormEvent.prototype.setExportParam = function(rtnData, action) {
	if (rtnData.GetHashMapArray().length == 0)
		return;
	var funcBackXml = rtnData.GetHashMapArray()[0]["funcBackXml"];
	if (funcBackXml == '0') {
		alert(TibSapMapping_lang.funcExecuteError);// 如果发生异常,则弹出提示对话框，并且不设置对应值
		return;
	}
	if (!funcBackXml) {
		alert(TibSapMapping_lang.noReturnDataHandle);
		return;
	}
	if (funcBackXml == "error") {
		alert(TibSapMapping_lang.funcExecuteProblem);
		return;
	}

	var fdRfcParamXmlObject = XML_CreateByContent(funcBackXml);
	// 得到传出参数field
	var exportFields = XML_GetNodes(fdRfcParamXmlObject,
			"/jco/export/field|/jco/export/structure/field");

	for ( var i = 0; i < exportFields.length; i++) {
		var fieldNode = exportFields[i];
		var ekpid = this.getString(XML_GetAttribute(fieldNode, "ekpid"));
		if (ekpid == "")
			continue;
		SetXFormFieldValueById(ekpid, $(fieldNode).text());// 这个既可以设定自定义表单属性的值亦可以设置主表单对应属性值
	}
	// 设置table类型的传出参数
	this.setExportTableXml(fdRfcParamXmlObject);

};

// 设置table类型的传出参数
SapFormEvent.prototype.setExportTableXml = function(xmlObject) {
	// 添加传入或传出，写入时默认为传出方式赋值，2014-8-13
	var exportTables = XML_GetNodes(xmlObject, "/jco/tables/table[@isin='0' or @isin='0;1']");
	for ( var i = 0; i < exportTables.length; i++) {
		var table = exportTables[i];
		var records = $(table).children();
		var firstRecord = records[0];
		var mxId = this.getMxId(firstRecord);// 得到明细表id
		/*
		 * 如果没有配置映射，则不进行设值操作,还有一种特殊情况，就是传出表格中的所有字段对应的是ekp中的非明细表字段
		 * 这个时候xml表中的传出表格中也应该是只有一条记录的，使用setExportTableXml_singleton
		 */
		if (mxId == undefined) {
			this.setExportTableXml_singleton(firstRecord);
			continue;
		}
		var isin = $(table).attr("isin");
		var writeType = $(table).attr("writeType");
		// 传入并传出类型，写入方式为1是更新
		if (isin == "0;1" && writeType == "1") {
			var writeKey = $(table).attr("writeKey");
			// 删除后再计算长度-（减去）标题行和基准行
			var operationRowIndex = document.getElementById(mxId).rows.length - 2;
			for ( var j = 0; j < records.length; j++) {
				var record = records[j];
				DocList_AddRow(mxId);// 增加一行
				// 为此行填充数据
				var fields = $(record).children();
				var fields0 = $(firstRecord).children(); // 只取第0行的定义
				var updateRowIndex = j + operationRowIndex;
				var valueArray = new Array();
				for ( var z = 0; z < fields.length; z++) {
					var field = fields[z];
					var field0 = fields0[z]; // 只取第0行的定义
					// 获取ekpid
					var ekpid = this.getString(XML_GetAttribute(field0, "ekpid"));
					if (ekpid == "") {
						continue;
					}
					// 找到需要更新的Key进行比较，然后取出行号，保存起来。
					if ($(field).attr("name") == writeKey) {
						var ekpidObjs = $("[name$='"+ekpid.substr(ekpid.indexOf("."))+")']");
						$(ekpidObjs).each(function(index){
							var text = $(field).text();
							if (text == $(this).val()) {
								updateRowIndex = $(this).attr("name").split(".")[2];
							}
						});
					}
					// 把需要赋的值保存起来
					valueArray.push({"ekpid" : ekpid, "text" : $(field).text()});
				}
				// 为表单元素赋值
				for (var v = 0; v < valueArray.length; v++) {
					this.setFormCellValue(valueArray[v]["text"], updateRowIndex, valueArray[v]["ekpid"]);
				}
			}
			// 删除明细表中的所有空白行
			this.deleteMxRows(mxId);
		} else {
			// 删除所有行（删除后再新增）
			this.deleteMxAllRows(mxId);
			// 删除后再计算长度-（减去）标题行和基准行
			var operationRowIndex = document.getElementById(mxId).rows.length - 2;
			// $(obj).closest("tr");
			for ( var j = 0; j < records.length; j++) {
				var record = records[j];
				DocList_AddRow(mxId);// 增加一行
				// 为此行填充数据
				var fields = $(record).children();
				var fields0 = $(firstRecord).children(); // 只取第0行的定义
				for ( var z = 0; z < fields.length; z++) {
					var field = fields[z];
					var field0 = fields0[z]; // 只取第0行的定义
					this.setFieldCellValue(field, (j + operationRowIndex), field0);// 设置field对应列单元格的值
				}
			}
		}
		
	}
};

// 设置传出table中特殊情况：就是传出表格中的所有字段对应的是ekp中的非明细表字段
SapFormEvent.prototype.setExportTableXml_singleton = function(firstRecord) {
	var fields = $(firstRecord).children();
	for ( var i = 0; i < fields.length; i++) {
		var fieldNode = fields[i];
		var ekpid = this.getString(XML_GetAttribute(fieldNode, "ekpid"));
		if (ekpid == "")
			continue;
		SetXFormFieldValueById(ekpid, $(fieldNode).text());
	}
};

// 得到初始的xml
SapFormEvent.prototype.getFuncXml = function(funcId, beforeAction, afterAction, synch) {
	var that = this;
	var data = new ERP_data(); //new KMSSData();
	that.blockShow();
	data.SendToBean(this.formEventFuncXmlService + "&funcId=" + funcId,
			function(rtnData) {
				// 先执行xml赋值
				that.setImportParam(rtnData, beforeAction, afterAction, synch);
			}, synch
	);
};

/**
 * 
 * @param {} funcId 		当前sap映射模板id,(后台SapEkpTempFuncMainAction.generateJspFile 方法自定填充 )
 * @param {} synch  		可选是否采取异步方式
 * @param {} beforeAction 	执行的获取SAP模板之前回调函数 可选
 * @param {} afterAction 	执行的获取SAP模板之后回调函数  可选
 */
function doBAPI(funcId, beforeAction, afterAction, synch) {
	var sapFormEvent = new SapFormEvent();
	//	遮罩全局控制
	sapFormEvent.blockFlag=true;
	sapFormEvent.blockInit();
	sapFormEvent.getFuncXml(funcId, beforeAction, afterAction, synch);
}

