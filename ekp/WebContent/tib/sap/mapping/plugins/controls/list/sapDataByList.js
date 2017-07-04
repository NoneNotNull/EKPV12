/**
 * list列表，调用sap数据
 * 
 * @author 邱建华 date:2013-3-11
 * @version 1.0
 * 
 */
var SapControls_Lang = {};
jQuery.ajax({
	type: "GET",
	url :Com_Parameter.ContextPath +"tib/sap/mapping/plugins/controls/common/sapControls_lang.jsp",
	dataType: "script",
	// 设置同步,待加载完成以后才往下执行
	async:false
});

Designer_Config.controls['sapDataByList'] = {
		type : "sapDataByList",
		storeType : 'field',
		inherit : 'base',
		onDraw : _Designer_Control_SapDataByList_OnDraw, //绘制函数
		drawXML : _Designer_Control_SapDataByList_DrawXML, //生成数据字典
		implementDetailsTable : true, // 是否支持明细表
		attrs : { // 这个是对话框属性配置
			label : Designer_Config.attrs.label, // 内置显示文字属性
//			required: {
//				text: Designer_Lang.controlAttrRequired,// 这种都能直接使用 "文字" 来替代
//				value: "true",
//				type: 'checkbox',
//				checked: false,
//				show: true
//				
//			},	
			width : {
				text: Designer_Lang.controlAttrWidth,
				value: "",
				type: 'text',
				show: true,
				validator: Designer_Control_Attr_Width_Validator,
				checkout: Designer_Control_Attr_Width_Checkout
			},
			multiSelect : {
				text: Designer_Lang.controlAddressAttrMultiSelect,
				value: "true",
				type: 'checkbox',
				checked: true,
				show: true
				
			},
			businessType : {
				text: Designer_Lang.controlAddressAttrBusinessType,
				value: "sapDataByList",
				type: 'hidden',
				show: true
			},
			listStyle : {
			    text: SapControls_Lang.listStyle,
			    value: "true",
			    type:"self",
			    required: false,
			    show: true,
			    draw: _Designer_Control_SapDataByList_ListStyle_Self_Draw
			},
			mappingList : {
				text: SapControls_Lang.mappingList,
				value: "true",
				type:"select",
				required: false,
				show: true,
				checkout: Designer_SapDataByList_MappingList_Control_Attr_Required_Checkout
			},
			showValue : {
			    text: SapControls_Lang.selectShowValue+"<img src='"+ Com_Parameter.StylePath 
			    	+ "icons/add.gif' alt='"+ SapControls_Lang.add +"' "
			    	+ "onclick=\"SapDataByList_AddRow('TABLE_DocList');\" style='cursor: hand'>",
			    value: "true",
			    type:"self",
			    required: false,
			    show: true,
			    draw: _Designer_Control_SapDataByList_ShowValue_Self_Draw
			},

			formula: Designer_Config.attrs.formula,
			reCalculate: Designer_Config.attrs.reCalculate
		},
		onAttrLoad : _Designer_Control_Attr_SapDataByList_OnAttrLoad,
		info : {
			name: SapControls_Lang.sapDataByList
		},
		resizeMode : 'onlyWidth'
};

Designer_Config.operations['sapDataByList'] = {
		imgIndex : 18,
		title : SapControls_Lang.sapDataByList,
		run : function (designer) {
			designer.toolBar.selectButton('sapDataByList');
		},
		type : 'cmd',
		shortcut : 'I',
		//sampleImg : 'style/img/input.bmp',
		select: true,
		cursorImg: 'style/cursor/inputText.cur'
};
// 把list选择控件增加到控件区
Designer_Config.buttons.control.push("sapDataByList");
// 把list选择控件增加到右击菜单区
Designer_Menus.add.menu['sapDataByList'] = Designer_Config.operations['sapDataByList'];

/**
 * 初始化加载
 * @param form
 * @param control
 */ 
function _Designer_Control_Attr_SapDataByList_OnAttrLoad(form,control){	
	// 初始化映射列表
	SapDataByList_GetList(this.options.values.mappingList, form._showValueJson);
	// 初始化样式
	SapDataByList_ListStyle_OnAttrLoad(this.options.values._listStyle);
};

/**
 * 绘制函数
 * @param parentNode
 * @param childNode
 */ 
function _Designer_Control_SapDataByList_OnDraw(parentNode, childNode){
	
	// 必须要做ID设置
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();	
	var domElement = _CreateDesignElement('label', this, parentNode, childNode);
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
		domElement.style.overflow = 'visible';
	}
	var htmlCode = _Designer_Control_SapDataByList_DrawByType(this.parent, this.attrs, this.options.values, this);
	domElement.innerHTML = htmlCode;
};

// 判断样式选中
function SapDataByList_ListStyle_OnAttrLoad(listStyleValue) {
	var listStyleObjs = document.getElementsByName("_listStyle");
	for (var i = 0, len = listStyleObjs.length; i < len; i++) {
		if (listStyleValue == listStyleObjs[i].value) {
			listStyleObjs[i].checked = true;
		}
	}
}

/**
 * 映射列表获值
 */
function SapDataByList_GetList(mappingListValue, showValueJson){
	var fdTemplateId = parent.document.getElementsByName("fdId")[0].value;
	// 调用Ajax
	(new KMSSData()).AddHashMap().SendToBean("tibSapMappingListBean&fdTemplateId="+
			fdTemplateId, function(rtnData){SapDataByList_BackList(rtnData, mappingListValue, showValueJson);}); 
};

/**
 * 映射列表值后回调函数 
 */ 
function SapDataByList_BackList(data, mappingListValue, showValueJson) {
	var nodesValue = data.GetHashMapArray();
	var downListObj = document.getElementsByName("mappingList")[0];
	if (downListObj == null) {
		return;
	}
	// 给下拉列表添加onchange事件
	$(downListObj).bind('change',SapDataByList_MappingListOnChange);
	downListObj.options.length = 0;
	downListObj.options.add(new Option(SapControls_Lang.select, ""));
	for ( var i = 0; i < nodesValue.length; i++) {
		downListObj.options.add(new Option(nodesValue[i]["fdName"],
				nodesValue[i]["fdId"]));
		if (mappingListValue == nodesValue[i]["fdId"]) {// 判断选中的
			downListObj.options.selectedIndex = (i + 1);
		}
	}
	SapDataByList_InitDetailTable(showValueJson);
}

function SapDataByList_InitDetailTable(showValueJson) {
	// 初始化明细表
	if(showValueJson != "undefined" && showValueJson != null && showValueJson !=""){
		//alert("showValueJson.value="+showValueJson.value);
		var showValueJson = eval('(' + showValueJson.value + ')');
		if(showValueJson.TABLE_DocList != null) {
			SapDataByList_setJsonByFuncXml(showValueJson.TABLE_DocList);
		}
	}
}

function SapDataByList_setJsonByFuncXml(tableJson) {
	var mappingListValue = document.getElementsByName("mappingList")[0].value;
	if (mappingListValue == "") {
		SapDataByList_FuncXml = null;
		return;
	}
	// 调用Ajax
	var data = new KMSSData();
	data.SendToBean("tibSapMappingListFuncXml&funcId=" + mappingListValue,
			function (rtnData){SapDataByList_setJsonDetail(rtnData, tableJson);});
}

// 初始化明细表
function SapDataByList_setJsonDetail(rtnData, tableJson) {
	for (var i = 0, lenI = tableJson.length; i < lenI; i++) {
		DocList_AddRow("TABLE_DocList");
		var rowJson = tableJson[i];
		SapDataByList_FuncXml = rtnData.GetHashMapArray()[0]["funcXml"];
		// 下拉选择框SAP
		var xmlObj = XML_CreateByContent(SapDataByList_FuncXml);
		var xpath = "/jco/tables/table[@isin='0'][@rows='0']/records/field";
		var exportFields = XML_GetNodesByPath(xmlObj, xpath);
		var lenJ = exportFields.length;
		var selectObj = document.getElementById("_sapValue"+ i);
		$(selectObj).bind('change',function(){SapDataByList_SapValueOnChange();});
		selectObj.length = lenJ;
		for (var j = 0; j < lenJ; j++) {
			 var fieldObj = exportFields[j];
			 var name = fieldObj.getAttribute("name");
			 var title = fieldObj.getAttribute("title");
			 selectObj.options[j].value = name;
			 selectObj.options[j].text = title;
			 if (rowJson.sapValue == name) {
				 selectObj.options.selectedIndex = j;
			 }
		}
		// 输入值
		document.getElementById("_sapDesc"+ i).value = rowJson.sapDesc;
	}
}

/**
 * 选取映射列表
 */ 
function SapDataByList_MappingListOnChange () {
	var mappingListValue = document.getElementsByName("mappingList")[0].value;
	if (mappingListValue == "") {
		SapDataByList_FuncXml = null;
		return;
	}
	// 调用Ajax
	var data = new KMSSData();
	data.SendToBean("tibSapMappingListFuncXml&funcId=" + mappingListValue,
			SapDataByList_CallBack_FuncXml);
}

/**
 * 获取funcXML的回调
 */ 
var SapDataByList_FuncXml;
function SapDataByList_CallBack_FuncXml(data) {
	SapDataByList_FuncXml = data.GetHashMapArray()[0]["funcXml"];
}

/**
 * 生成数据字典
 */
function _Designer_Control_SapDataByList_DrawXML() {	
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];//mutiValueSplit	
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="String" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	
	return buf.join('');
};


/**
 * list查询控件  类型HTML生成基础函数
 * @param parent
 * @param attrs
 * @param values
 * @param control
 * @returns {String}
 */ 
function _Designer_Control_SapDataByList_DrawByType(parent, attrs, values, control) {
	var htmlCode = '<input type="button" id="'+values.id+'"';
	if (values.canShow == 'false') {
		htmlCode += '" canShow="false"';
	}else {
		htmlCode += '" canShow="true"';
	}
	if (values.readOnly == 'true') {
		htmlCode += '" _readOnly="true"';
	}else {
		htmlCode += '" _readOnly="false"';
	}
	// 表单控件映射
	if(values.mappingList !=null ||  values.mappingList!=''){
      	htmlCode += " mappingList=\""+values.mappingList+"\" ";
	} 
	// 样式
	if(values._listStyle !=null ||  values._listStyle!=''){
		htmlCode += " _listStyle=\""+values._listStyle+"\" ";
	} 
	
	// 拼串明细表Json
	if(values._showValueJson!=null || values._showValueJson!=''){		
		var rtnJson = new Array();	
		rtnJson.push("{");
		// 输入参数
		rtnJson.push(SapDataByList_showValueJsonByTable("TABLE_DocList"));
		// 结束
		rtnJson.push("}");
		values._showValueJson = rtnJson.join('');		
		htmlCode += " _showValueJson=\""+values._showValueJson+"\" ";
	}

	if(values.width==null || values.width==''){
		values.width = "120";
	}
//	if (values.width.toString().indexOf('%') > -1) {
//		htmlCode += ' style="width:100%"';
//	} else {
//		htmlCode += ' style="width:'+values.width+'px"';
//	}
	htmlCode += ' style="width: 30px"';
	if (values.required == "true") {
		htmlCode += ' required="true"';
	} else {
		htmlCode += ' required="false"';
	}
	if (parent != null) {
		htmlCode += ' tableName="' + _Get_Designer_Control_TableName(parent) + '"';
	}
	if (values.description != null) {
		htmlCode += ' description="' + values.description + '"';
	}
	htmlCode += ' label="' + _Get_Designer_Control_Label(values, control) + '"';
	if (values.validate != null && values.validate != 'false') {
		htmlCode += ' dataType="' + values.validate + '"';
		if (values.validate == 'string') {
			htmlCode += ' maxlength="' + values.maxlength + '"';
			htmlCode += ' validate="{dataType:\'string\'';
			if ( values.maxlength != null &&  values.maxlength != '') {
				htmlCode += ',maxlength:' + values.maxlength;
			}
			htmlCode += '}"';
		} else if (values.validate == 'number') {
			htmlCode += ' scale="' + values.decimal + '"'; // 小数位
			htmlCode += ' beginNum="' +  values.begin + '"';
			htmlCode += ' endNum="' +  values.end + '"';
			htmlCode += ' validate="{dataType:\'number\',decimal:' + values.decimal; // 小数位
			if (values.begin != null && values.begin != '')
				htmlCode += ',begin:' + values.begin;
			if (values.end != null && values.end != '')
				htmlCode += ',end:' + values.end;
			htmlCode += '}"';
		} else if (values.validate == 'email') {
			htmlCode += ' validate="{dataType:\'email\'}"';
		}
	}
	if (values.defaultValue != null && values.defaultValue != '') {
		htmlCode += ' defaultValue="' + values.defaultValue + '"';
//		if (!attrs.businessType) {
//			htmlCode += ' value="' + values.defaultValue + '"';
//		}
	}
	htmlCode += ' value="'+ SapControls_Lang.choose +'"';
	if (attrs.businessType) {
		htmlCode += ' businessType="' + (values.businessType == null ? attrs.businessType.value : values.businessType) + '"';
		if ((values.businessType == 'dateDialog' ||  values.businessType == 'timeDialog' ||  values.businessType == 'datetimeDialog')) {
			if (values.defaultValue == 'select') {
				htmlCode += ' selectedValue="' + values._selectValue + '"';
				htmlCode += ' value="' + values._selectValue + '"';
			} else if (values.defaultValue == 'nowTime') {
				htmlCode += ' value="' + attrs.defaultValue.opts[1].text + '"';
			}
		} else if (values.businessType == "addressDialog") {
			if (values.defaultValue == 'select') {
				htmlCode += ' selectedValue="' + values._selectValue + '"';
				htmlCode += ' selectedName="' + values._selectName + '"';
				htmlCode += ' value="' + values._selectName + '"';
			} else if (values.defaultValue != 'null') {
				for (var jj = 0, l = attrs.defaultValue.opts.length; jj < l; jj ++) {
					if (attrs.defaultValue.opts[jj].value == values.defaultValue) {
						htmlCode += ' value="' + attrs.defaultValue.opts[jj].text + '"';
						break;
					}
				}
			}
		}
	}
	if (attrs.multiSelect) {
		htmlCode += ' multiSelect="' + (values.multiSelect == 'true' ? 'true' : 'false') + '"';
	}
	if (attrs.isLoadData) {
		htmlCode += ' isLoadData="' + (values.isLoadData == 'true' ? 'true' : 'false') + '"';
	}
	
	if (attrs.history) {
		htmlCode += ' history="' + (values.history == "true" ? 'true' : 'false') + '"';
	}
	htmlCode += ' readOnly >';
	
	if(values.required == 'true') {
		htmlCode += '<span class=txtstrong>*</span>';
	}
	
//	if (attrs.businessType && values.readOnly != 'true') {
//		htmlCode += '<label>&nbsp;<a>'+ SapControls_Lang.choose +'</a></label>';
//	}	
	return htmlCode;
};

// 拼串JSON
function SapDataByList_showValueJsonByTable(id) {
	var rtnJson = new Array();
	var table = document.getElementById(id);
	if(table == null || typeof table == "undefined" ){
		return "";
	}
	for (var i = 1, length = table.rows.length; i < length; i++) {
		rtnJson.push(SapDataByList_ShowValueJsonByRow(id, table.rows[i]));
	}
	//return "\"" + id + "\":[" + rtnJson.join(",") + "]";
	return "'" + id + "':[" + rtnJson.join(",") + "]";
}

function SapDataByList_ShowValueJsonByRow(id, trElement) {
	var selectValue = SapDataByList_GetElementsByParent(trElement.cells[0], "select")[0];
	var rtnJson = new Array();
	rtnJson.push("{");
	if (selectValue != null && selectValue != undefined) {
		// SAP
		rtnJson.push("'sapValue':'" + selectValue.value + "'");
		// 读取表单字段
		var sapDescValue = SapDataByList_GetElementsByParent(trElement.cells[0], "input")[0].value;
		rtnJson.push(",'sapDesc':'" + sapDescValue + "'");
		// 结束
	}
	rtnJson.push("}");	
	return rtnJson.join('');
}

function SapDataByList_GetElementsByParent(oParent, tagName) {
	var rtnResult = new Array(), child;
	for (var i = 0, length = oParent.childNodes.length; i < length; i++) {
		child = oParent.childNodes[i];
		if (child.tagName && child.tagName.toLowerCase() == tagName)
			rtnResult.push(child);
	}
	return rtnResult;
};

/**
 * 判断列表不能为空
 * @param msg
 * @param name
 * @param attr
 * @param value
 * @param values
 * @param control
 * @returns {Boolean}
 */ 
function Designer_SapDataByList_MappingList_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if (values.mappingList ==null || values.mappingList == "") {
		msg.push(SapControls_Lang.mappingTip, SapControls_Lang.mustSelect);
		return false;
	}
	return true;
}

//样式   自绘函数
function _Designer_Control_SapDataByList_ListStyle_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<input type='radio' name='_listStyle' id='_listStyle' value='1' checked/>"+ SapControls_Lang.button;	
		html += "<input type='radio' name='_listStyle' id='_listStyle' value='2' />"+ SapControls_Lang.text;
		html += "<input type='radio' name='_listStyle' id='_listStyle' value='3' />"+ SapControls_Lang.icon;
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};

//显示值   自绘函数
function _Designer_Control_SapDataByList_ShowValue_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<table id='TABLE_DocList' class='tb_normal' width='99%'>";
	html += "<tr style='display:none'><td></td></tr>";
 	// 基准行
 	html += "<tr KMSS_IsReferRow='1' style='display:none'>";
 	html += "<td><select name='_sapValue' id='_sapValue!{index}' style='width=30%;'><option value=''>"+ SapControls_Lang.select +"</option></select>";
 	html += "<input type='text' name='_sapDesc' class='inputsgl'  id='_sapDesc!{index}' style='width: 60px;' value=''/>";
 	// 移动
 	html += "<img src='"+ Com_Parameter.StylePath +"icons/up.gif' alt='up' ";
 	html +=	"onclick=\"Designer_AttrPanel.showButtons(document.getElementById('_sapDesc!{index}'));List_DocList_MoveRow(-1);\" style='cursor: hand'/>";
 	html +=	"<img src='"+ Com_Parameter.StylePath +"icons/down.gif' alt='down' ";
 	html +=	"onclick=\"Designer_AttrPanel.showButtons(document.getElementById('_sapDesc!{index}'));List_DocList_MoveRow(1);\" style='cursor: hand'/>";
 	html += "<img src='"+ Com_Parameter.StylePath +"icons/delete.gif' alt='del' ";
 	html += "onclick=\"Designer_AttrPanel.showButtons(document.getElementById('_sapDesc!{index}'));List_DocList_DeleteRow();\" style='cursor: hand'/>";
 	html += "</td></tr>";
 	html += "</table>";
 	html += "<input type='hidden' name='_showValueJson' id='_showValueJson' " +
 			"value=\"" + (values._showValueJson != "undefined" && values._showValueJson != null ? values._showValueJson : "") + "\" />";
 	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};

// 添加一行映射输出参数
function SapDataByList_AddRow(tableId) {
	 if (!SapDataByList_Checked_MappingList()) {
		 return;
	 }
	 DocList_AddRow(tableId);
	 var rows = document.getElementById("TABLE_DocList").rows;
	 var index = rows.length - 2;
	 var xmlObj = XML_CreateByContent(SapDataByList_FuncXml);
	 var xpath = "/jco/tables/table[@isin='0'][@rows='0']/records/field";
	 var exportFields = XML_GetNodesByPath(xmlObj, xpath);
	 var len = exportFields.length;
	 var sapValueObj = document.getElementById("_sapValue"+ index);
	 sapValueObj.length = len + 1;
	 sapValueObj.options[0].value = "";
	 sapValueObj.options[0].text = SapControls_Lang.select;
	 $(sapValueObj).bind('change',function(){SapDataByList_SapValueOnChange(index);});
	 for (var i = 0; i < len; i++) {
		 var fieldObj = exportFields[i];
		 var name = fieldObj.getAttribute("name");
		 var title = fieldObj.getAttribute("title");
		 sapValueObj.options[i + 1].value = name;
		 sapValueObj.options[i + 1].text = title;
	 }
	
}

function SapDataByList_SapValueOnChange(index) {
//	var currentTR = DocListFunc_GetParentByTagName('TR');
//	var index = currentTR.rowIndex;
	//alert("index="+index);
	if (index == null) {
		var currentTR = DocListFunc_GetParentByTagName('TR');
		index = currentTR.rowIndex - 1;
	}
	var sapValueObj = document.getElementById("_sapValue"+ index); 
	for (var i = 0; i < sapValueObj.length; i++) {
		if (sapValueObj.options[i].selected) {
			document.getElementById("_sapDesc"+ index).value = sapValueObj.options[i].text;
		}
	}
	
}

/**
* 判断是否选择映射模版
* @param rfcId
* @return
*/
function SapDataByList_Checked_MappingList() {
	var mappingList = document.getElementsByName("mappingList")[0].value;
	if (mappingList == "") {
		alert(SapControls_Lang.pleaseChooseMappingList);
		return false;
	}
	return true;
}

/***********************************************
功能：删除行
参数：
	optTR：
		可选，操作行对象，默认取当前操作的当前行
***********************************************/
function List_DocList_DeleteRow(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	optTB.deleteRow(rowIndex);
	
	
	tbInfo.lastIndex--;
	for(var i = rowIndex; i<tbInfo.lastIndex; i++)
		List_DocListFunc_RefreshIndex(tbInfo, i);
}

function List_DocListFunc_RefreshIndex(tbInfo, index){
	for (var n = 0; n < tbInfo.cells.length; n ++) {
		if (tbInfo.cells[n].isIndex) {
			tbInfo.DOMElement.rows[index].cells[n].innerHTML = index;
		}
	}
	List_DocListFunc_RefreshFieldIndex(tbInfo, index, "INPUT");
	List_DocListFunc_RefreshFieldIndex(tbInfo, index, "SELECT");
	List_DocListFunc_RefreshFieldIndex(tbInfo, index, "IMG");
}

function List_DocListFunc_RefreshFieldIndex(tbInfo, index, tagName){
	var optTR = tbInfo.DOMElement.rows[index];
	var fields = optTR.getElementsByTagName(tagName);
	for(var i=0; i<fields.length; i++){
		var fieldId = fields[i].id.replace(/\d+/g, "!{index}");
		fieldId = fieldId.replace(/!\{index\}/g, index - 1);
		if(Com_Parameter.IE)
			fields[i].outerHTML = fields[i].outerHTML.replace("id=" + fields[i].id, "id="+fieldId);
		else
			fields[i].id = fieldId;
		var clickNodeValue = fields[i].attributes["onclick"].nodeValue;
		// 排除移动按钮
		if (clickNodeValue != null && clickNodeValue.indexOf("List_DocList_MoveRow") == -1) {
			var clickStrValue = clickNodeValue.replace(/\d+/g, "!{index}");
			clickStrValue = clickStrValue.replace(/!\{index\}/g, index - 1);
			fields[i].outerHTML = fields[i].outerHTML.replace("onclick=\"" + clickNodeValue, "onclick=\""+ clickStrValue);
		}
		if (fields[i].name == "_sapValue") {
			$(fields[i]).bind('change',function(){SapDataByList_SapValueOnChange(index - 1);});
		}
	}
}

/***********************************************
功能：移动行
参数：
	direct：
		必选，1：下移动，-1上移动
	optTR：
		可选，操作行对象，默认取当前操作的当前行
***********************************************/
function List_DocList_MoveRow(direct, optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	var tagIndex = rowIndex + direct;
	if(direct==1){
		if(tagIndex>=tbInfo.lastIndex)
			return;
		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[tagIndex], optTB.rows[rowIndex]);
	}else{
		if(tagIndex<tbInfo.firstIndex)
			return;
		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[rowIndex], optTB.rows[tagIndex]);
	}
	List_DocListFunc_RefreshIndex(tbInfo, rowIndex);
	List_DocListFunc_RefreshIndex(tbInfo, tagIndex);
}

