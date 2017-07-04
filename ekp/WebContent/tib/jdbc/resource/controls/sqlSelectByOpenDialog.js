/**
 * 能用SQL当数据源的 弹出框选择控件
 * 
 * @author 刘声斌 date:2010-11-2
 * @version 1.0
 * 
 */

// 加入国际化
var TibJdbcDialog_lang = {};
jQuery.ajax({
	type : "GET",
	url : Com_Parameter.ContextPath + "tib/jdbc/resource/controls/sqlSelectByOpenDialog.jsp",
	dataType : "script",
	async : false
});

Designer_Config.controls['sqlSelectByOpen'] = {
		type : "sqlSelectByOpen",
		storeType : 'field',
		inherit : 'base',
		onDraw : _Designer_Control_SQLSelectByOpen_OnDraw, //绘制函数
		drawXML : _Designer_Control_SQLSelectByOpen_DrawXML, //生成数据字典
		implementDetailsTable : true, // 是否支持明细表
		attrs : { // 这个是对话框属性配置
			label : Designer_Config.attrs.label, // 内置显示文字属性
			required: {
				text: Designer_Lang.controlAttrRequired,// 这种都能直接使用 "文字" 来替代
				value: "true",
				type: 'checkbox',
				checked: false,
				show: true
			},	
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
				checked: false,
				show: true
			},
			isLoadData : {//是否默认加载列表数据
				text: TibJdbcDialog_lang.defaultLoadData,
				value: "true",
				type: 'checkbox',
				checked: false,
				show: true
			},
			businessType : {
				text: Designer_Lang.controlAddressAttrBusinessType,
				value: "sqlSelectDialog",
				type: 'hidden',
				show: true
			},
			sqlResource : {
			    text: TibJdbcDialog_lang.dataSource,
			    value: "true",
			    type:"select",
			    show: true
			    
			 },
			sqlvalue : {
				text: TibJdbcDialog_lang.sqlStatement,
				value: "",
				type: 'textarea',
				hint: TibJdbcDialog_lang.sqlvalueHint +"select * from tableName where id=:id",
				show: true,
				required: true,
				validator: [Designer_Control_Attr_Required_Validator],
				checkout: [Designer_Control_Attr_Required_Checkout]			
			},
			queryColumn : {
				text: TibJdbcDialog_lang.queryColumnText,
				value: "",
				type: 'text',
				show: true,
				required: true,
				validator: [Designer_Control_Attr_Required_Validator],
				checkout: [Designer_Control_Attr_Required_Checkout]
			},
			orderByValue : {
				text: TibJdbcDialog_lang.orderByValueText +"[a desc,b asc]",
				value: "",
				type: 'text',
				show: true
			},
			inputParamsJson : {
				text: TibJdbcDialog_lang.inputParam+"[<a href=\"JavaScript:OutputParamters('inputParams');\">"+ TibJdbcDialog_lang.gain +"</a>]",
				value: "",
				type: 'self',
				show: true,
				required: false,
				draw: _Designer_Control_SQLSelect_InputParamsJson_Self_Draw,
				checkout:Designer_SQLSelect_Control_Attr_Required_Checkout
			},
			outputParamsJson : {
				text: TibJdbcDialog_lang.writerForm +"[<a href=\"JavaScript:OutputParamters('outputParams');\" id=\"out\">"+ TibJdbcDialog_lang.gain +"</a>]",
				value: "",
				type: 'self',
				show: true,
				required: false,
				draw: _Designer_Control_SQLSelect_OutputParamsJson_Self_Draw
			},
			formula: Designer_Config.attrs.formula,
			reCalculate: Designer_Config.attrs.reCalculate
		},
		onAttrLoad : _Designer_Control_Attr_SQLSelect_OnAttrLoad,
		info : {
			name: TibJdbcDialog_lang.infoName
		},
		resizeMode : 'onlyWidth'
};

Designer_Config.operations['sqlSelectByOpen'] = {
		imgIndex : 18,
		title : TibJdbcDialog_lang.operationsTitle,
		run : function (designer) {
			designer.toolBar.selectButton('sqlSelectByOpen');
		},
		type : 'cmd',
		shortcut : 'Q',
		//sampleImg : 'style/img/select.jpg',
		select: true,
		cursorImg: 'style/cursor/select.cur'
};
//把sql选择控件增加到控件区 
Designer_Config.buttons.control.push("sqlSelectByOpen");
//把sql选择控件增加到右击菜单区
Designer_Menus.add.menu['sqlSelectByOpen'] = Designer_Config.operations['sqlSelectByOpen'];

/**
 判断是否有输入参数
*/
function Designer_SQLSelect_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if(values.sqlvalue != null && values.sqlvalue != ""){
		if(values.sqlvalue.indexOf(":") != -1 && (values._inputParams==null || values._inputParams=="" || values._inputParams=="{'inputParams':[]}")){
			_Designer_Control_Attr_Checkout_AddLabel(msg, values);
			control.options.domElement.className = 'attr_no_label';
			if (control.info.name)
				msg.push(control.info.name, ':', TibJdbcDialog_lang.inputParam, TibJdbcDialog_lang.needFillIn);
			else
				msg.push(TibJdbcDialog_lang.inputParam, TibJdbcDialog_lang.needFillIn);
			return false;
		}
	}	
	return true;
};


function _Designer_Control_SQLSelectByOpen_OnDraw(parentNode, childNode){
	// 必须要做ID设置
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();	
	var domElement = _CreateDesignElement('label', this, parentNode, childNode);
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
		domElement.style.overflow = 'visible';
	}
	var htmlCode = _Designer_Control_SqlSelect_DrawByType(this.parent, this.attrs, this.options.values, this);
	domElement.innerHTML = htmlCode;
	getDataResource();
	
};

/*
 根据ID获取table保存table对象
*/
function getParameterJsonByTable(id) {
	var rtnJson = new Array();
	var table = document.getElementById(id);
	if(table == null || typeof table == "undefined" ){
		return "";
	}
	for (var i = 1, length = table.rows.length; i < length; i++) {
		rtnJson.push(getParamterJsonByRow(id, table.rows[i]));
	}
	//return "\"" + id + "\":[" + rtnJson.join(",") + "]";
	return "'" + id + "':[" + rtnJson.join(",") + "]";
};

/*
 根据table的id 保存每行的数据
*/
function getParamterJsonByRow(id, trElement) {
	var rtnJson = new Array();
	rtnJson.push("{");
	// 参数名
	var nameStr = trElement.cells[0].innerText||trElement.cells[0].textContent;
	rtnJson.push("'name':'" + nameStr + "'");
	
	if (id == "inputParams") {
		// 参数类型
		rtnJson.push(",'dataType':'" + getElementsByParent(trElement.cells[1], "select")[0].value + "'");
		// 读取表单字段
		var inputArr = getElementsByParent(trElement.cells[2], "input");
		rtnJson.push(",'idField':'" + inputArr[0].value + "'");
		rtnJson.push(",'nameField':'" + inputArr[1].value + "'");
	} else {
		// 是否使用
		var isUsing = getElementsByParent(trElement.cells[1], "input")[0].checked ? "true" : "false";
		rtnJson.push(",'isUse':'" + isUsing + "'");
		// 读取表单字段
		var inputArr = getElementsByParent(trElement.cells[2], "input");
		rtnJson.push(",'idField':'" + inputArr[0].value + "'");
		rtnJson.push(",'nameField':'" + inputArr[1].value + "'");
	}	
	// 结束
	rtnJson.push("}");	
	return rtnJson.join('');
};

function _Designer_Control_SQLSelectByOpen_DrawXML() {	
	var values = this.options.values;
	var buf = [];//mutiValueSplit	
	buf.push('<extendSimpleProperty ');
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
	
	buf.push('<extendSimpleProperty ');
	buf.push('name="', values.id+'_name', '" ');
	buf.push('label="', values.label +'_name', '" ');
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




// sql查询控件  类型HTML生成基础函数
function _Designer_Control_SqlSelect_DrawByType(parent, attrs, values, control) {
	
	var htmlCode = '<input id="'+values.id+'" class="' + (values.canShow=='false'?'inputhidden':'inputsgl');
	if (values.canShow == 'false') {
		htmlCode += '" canShow="false"';
	}else {
		htmlCode += '" canShow="true"';
	}
	if (!values.type) {
		htmlCode += '" type="sqlSelectByOpen"';
	}
	if (values.readOnly == 'true') {
		htmlCode += '" _readOnly="true"';
	}else {
		htmlCode += '" _readOnly="false"';
	}
	if(values.sqlResource !=null ||  values.sqlResource!=''){/*加数据源 修改的*/
	    
      	htmlCode += " sqlResource=\""+values.sqlResource+"\" ";
      	
	} 
		
	
	if(values.sqlvalue!=null || values.sqlvalue!=''){		
		htmlCode += " sqlvalue=\""+values.sqlvalue+"\" ";
	}
	if(values.queryColumn!=null || values.queryColumn!=''){		
		htmlCode += " queryColumn=\""+values.queryColumn+"\" ";
	}
	if(values.orderByValue!=null || values.orderByValue!=''){		
		htmlCode += " orderByValue=\""+values.orderByValue+"\" ";
	}
	if(values._inputParams!=null || values._inputParams!=''){		
		var rtnJson = new Array();			
		rtnJson.push("{");
		// 输入参数
		var inputP = getParameterJsonByTable("inputParams");
		rtnJson.push(inputP);
		// 结束
		rtnJson.push("}");
		if (inputP != "") {
			values._inputParams = rtnJson.join('');		
		} 
		htmlCode += " inputParams=\""+values._inputParams+"\" ";
	} 
	if(values._outputParams!=null || values._outputParams!=''){
		var rtnJson = new Array();			
		rtnJson.push("{");
		var outputP = getParameterJsonByTable("outputParams");
		// 输出参数
		rtnJson.push(outputP);
		rtnJson.push("}");
		if (outputP != "") {
			values._outputParams = rtnJson.join('');
		}
		htmlCode += " outputParams=\""+values._outputParams+"\" ";	
	}
	
	if(values.width==null || values.width==''){
		values.width = "120";
	}
	if (values.width.toString().indexOf('%') > -1) {
		htmlCode += ' style="width:100%"';
	} else {
		htmlCode += ' style="width:'+values.width+'px"';
	}
	if (values.required == "true") {
		//htmlCode += ' required="true"';
		htmlCode += ' _required="true"';
	} else {
		//htmlCode += ' required="false"';
		htmlCode += ' _required="false"';
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
		if (!attrs.businessType) {
			htmlCode += ' value="' + values.defaultValue + '"';
		}
	}
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
	
	if (attrs.businessType && values.readOnly != 'true') {
		htmlCode += '<label>&nbsp;<a>'+ TibJdbcDialog_lang.select +'</a></label>';
	}	
	return htmlCode;
};

function _Designer_Control_Attr_SQLSelect_OnAttrLoad(form,control){	
	if(form._inputParams != "undefined" && form._inputParams != null && form._inputParams !="" && form._inputParams.value !=""){
		var inputParamsJson = eval('(' + form._inputParams.value + ')');
		if(inputParamsJson.inputParams != null)
			OutputParamters("inputParams", inputParamsJson.inputParams);
	}
	if(form._outputParams != "undefined" && form._outputParams != null && form._outputParams !="" && form._outputParams.value !=""){
		var outputParamsJson = eval('(' + form._outputParams.value + ')');		
		if(outputParamsJson.outputParams != null)
			OutputParamters("outputParams", outputParamsJson.outputParams);
	}
};

// 输入参数   自绘函数
function _Designer_Control_SQLSelect_InputParamsJson_Self_Draw(name, attr, value, form, attrs, values) {
     getDataResource(values.sqlResource);//初始化数据源
    // checkSqlResoruce(values.sqlResource);//判断选中的数据源
	var html = "<table id=\"inputParams\" width=\"100%\" class=\"tb_normal\">";
		html+="<tr align=\"center\">";
		html+="<td width=\"25%\">"+ TibJdbcDialog_lang.paramName +"</td>";
		html+="<td width=\"25%\">"+ TibJdbcDialog_lang.type +"</td>";
		html+="<td>"+ TibJdbcDialog_lang.formField +"</td>";
		html+="</tr>";
		html+="</table>";	
	html += "<input type='hidden' name='_inputParams' ";	
	html += " value=\"" + (values._inputParams != "undefined" && values._inputParams != null ? values._inputParams : "") + "\">";	
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};



// 输出参数   自绘函数
function _Designer_Control_SQLSelect_OutputParamsJson_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<table id=\"outputParams\" width=\"100%\" class=\"tb_normal\">";
		html+="<tr align=\"center\">";
		html+="<td width=\"25%\">"+ TibJdbcDialog_lang.name +"</td>";
		html+="<td width=\"25%\">"+ TibJdbcDialog_lang.isUse +"</td>";
		html+="<td>"+ TibJdbcDialog_lang.formField +"</td>";
		html+="</tr>";
		html+="</table>";
	html += "<input type='hidden' name='_outputParams' ";
	html += " value=\"" + (values._outputParams != "undefined" && values._outputParams != null ? values._outputParams : "") + "\">";	
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};


// 输出参数
function OutputParamters(id, params) {
	// 删除存在的参数行
	var table = document.getElementById(id);
	for (var i = table.rows.length - 1; i > 0; i--)
		table.deleteRow(i);
	// 获取相应参数集
	var _params = params || null;
	if (_params == null) {
		//PrevDataHistory[id].sql = Com_Trim(document.getElementById("sqlvalue").value);
		switch(id) {
			case 'inputParams':
				_params = getInputParamtersBySQL();
				break;
			case 'outputParams':
				//PrevDataHistory[id].dbConnect = document.getElementById("dbConnect").value;
				getOutParamtersBySQL();
				// 由于采用了异步获取，则退出
				return;
		}
		if (_params == null) {
			alert(TibJdbcDialog_lang.sqlNotSetParam);
			return;
		}
		//PrevDataHistory[id].params = _params;
	}
	// 生成新的参数行
	var trElement, paramObject;
	for (var i = 0, length = _params.length; i < length; i++) {
		// 转成对象模式
		var type = typeof(_params[i]);
		if (type == 'string') {
			paramObject = {name:_params[i], dataType:'', isUse:'false', idField:'', nameField:''};
		} else if (type == 'object') {
			paramObject = _params[i];
		} else {
			continue;
		}	
		
		// 新建一行
		trElement = table.insertRow(-1);
		trElement.setAttribute('align', 'center');
		// 参数名
		createTextElement(trElement, paramObject.name);
		
		if (id == "inputParams") {
			// 参数类型
			createSelectElement(trElement, getDataTypeOptions(), paramObject.dataType);
			// 读取表单字段
			createReadOnlyElement(trElement, 
				paramObject.idField + '|' + paramObject.nameField,
				'openExpressionEditor(this);');
		} else {
			// 是否使用
			createCheckboxElement(trElement, (paramObject.isUse == 'true'));
			// 写入表单字段
			//createSelectElement(trElement, transFormFieldList(), paramObject.idField, paramObject.nameField);
			// 读取表单字段
			createReadOnlyElement(trElement,paramObject.idField + '|' + paramObject.nameField,'openExpressionEditor(this);');
		}
	}
};

function transFormFieldList() {
	var rtnResult = new Array();
	var fieldList = parent.FlowChartObject.FormFieldList;
	if (!fieldList) return rtnResult;
	// 转换成option支持的格式
	for (var i = 0, length = fieldList.length; i < length; i++) {
		rtnResult.push({value:fieldList[i].name, name:fieldList[i].label});
	}
	return rtnResult;
};


// 根据SQL语句，获得输出参数
function getOutParamtersBySQL() {
	var sqlvalue = document.getElementById("sqlvalue").value;
	var sqlResource= "";
	 if(document.getElementById("sqlResource")!=null){
	   sqlResource = document.getElementById("sqlResource").value;
	
	}
	if(sqlvalue == null || sqlvalue == "" || sqlvalue.replace(/(^\s*)|(\s*$)/g,'').length == 0){
		alert(TibJdbcDialog_lang.pleaseFillInSql);
		return;
	}	
	// 显示载入状态
	var outHref = document.getElementById('out');
	outHref.innerHTML = '<img src="' + Com_Parameter.ContextPath + 'resource/style/common/images/loading.gif">';
	outHref.removeAttribute('href');
	// 调用Ajax
	(new KMSSData()).AddHashMap({sqlvalue:sqlvalue,sqlResource:sqlResource}).SendToBean("tibJdbcFormSQLSelectDBServiceImp", doActionInOutParamters);
};

function doActionInOutParamters(rtnData) {
	var rtnResult = new Array();
	var nodesValue = rtnData.GetHashMapArray();
	
	for(var i = 0, length = nodesValue.length; i < length; i++) {
		rtnResult.push({name:nodesValue[i]['column'], dataType:'', isUse:'false', idField:'', nameField:''});
	}	
	// 恢复原始状态
	var outHref = document.getElementById("out");
	outHref.innerHTML = TibJdbcDialog_lang.gain;
	outHref.setAttribute('href', 'JavaScript:OutputParamters(\'outputParams\');');
	// 若返回值不为空，则是SQL或数据库链接不正确
	var error = nodesValue[0]['error'];
		
	switch (error) {
		case '':
			OutputParamters('outputParams', rtnResult);
			alert(TibJdbcDialog_lang.pleaseCheckUp);
			break;
		case 'connect db error':
			alert(LangNodeObject.robot_RDB_NoDbConnect);	
			break;
		case 'execute sql error':
			alert(LangNodeObject.robot_RDB_SQLError);
			break;		
	}
	 
	if(rtnResult !=null && rtnResult.length !=0){
		OutputParamters('outputParams', rtnResult);
	}
};

function openExpressionEditor(owner) {
	var idField, nameField;
	var arrElement = getElementsByParent(owner.parentNode, "input");
	if (arrElement.length < 2) return;
	if (arrElement[0].style.display == 'none') {
		idField = arrElement[0];
		nameField = arrElement[1];
	} else {
		idField = arrElement[1];
		nameField = arrElement[0];
	}
	// 获取相应配置的数据类型
	var dataTypeElement = getElementsByParent(owner.parentNode.parentNode.cells[1], "select")[0];
	if(dataTypeElement){
		// 调用公式定义器
		Formula_Dialog(idField, nameField, Designer.instance.getObj(true), dataTypeElement.value, null, null);
	}else{
		Formula_Dialog(idField, nameField, Designer.instance.getObj(true), "", null, null);
	}
};

// 根据SQL语句，获得输入参数
function getInputParamtersBySQL() {
	var objSQL = document.getElementById("sqlvalue");
	if (!objSQL) return null;
	// 查找相应的参数
	var rtnArr = objSQL.value.match(/:[^\s=)<>,]+/ig);
	if (rtnArr == null) return null;
	// 修剪相同的值，并剔除冒号
	var rtnResult = new Array(), find;
	for (var i = 0, alength = rtnArr.length; i < alength; i++) {
		find = false;
		for (var j = 0, rlength = rtnResult.length; j < rlength; j++) {
			if ((":" + rtnResult[j]) == rtnArr[i]) {
				find = true;
				break;
			}
		}
		if (!find) rtnResult.push(rtnArr[i].substr(1));
	}
	return (rtnResult.length == 0) ? null : rtnResult;
};

function getElementsByParent(oParent, tagName) {
	var rtnResult = new Array(), child;
	for (var i = 0, length = oParent.childNodes.length; i < length; i++) {
		child = oParent.childNodes[i];
		if (child.tagName && child.tagName.toLowerCase() == tagName)
			rtnResult.push(child);
	}
	return rtnResult;
};

/* 创建Select的Dom对象
 参数:
		trElement  : 表格中tr对象
		options    : 选项列表数组，规则：[{value:'',name:''}]
		checkValue : 选中值
		checkName  : 选中文本
*/
function createSelectElement(trElement, options, checkValue, checkName) {
	var rtnResult = new Array();
	if (options == null || options.length == 0) {
		var value = checkValue || '', name = checkName || '';
		if (name != '')	rtnResult.push('<option value="' + value + '" selected>' + name + '</option>');
	} else {
		for (var i = 0, length = options.length; i < length; i++) {
			var option = options[i], value = option.value || option.name;
			rtnResult.push('<option value="' + value + '"');
			if (value == checkValue) rtnResult.push(' selected');
			rtnResult.push('>' + option.name + '</option>');
		}
	}
	// 输出Dom对象
	var tdElement = trElement.insertCell(-1);
	tdElement.innerHTML = '<select>' + rtnResult.join('') + '</select>';
};

/* 创建文本的Dom对象
 参数:
		trElement : 表格中tr对象
		value     : 文本值
*/
function createTextElement(trElement, value) {
	var tdElement = trElement.insertCell(-1);
	tdElement.innerHTML = value || '';
};

/* 创建input只读的Dom对象
 参数:
		trElement    : 表格中tr对象
		valueAndName : 值对，规则：value|name(输出2个input) 或 name(输出1个input)
		selectJs     : 选择使用的js代码，若没有此参数则不显示
*/
function createReadOnlyElement(trElement, valueAndName, selectJs) {
	var rtnResult = new Array(), _valueAndName = valueAndName || '';
	var valueList = _valueAndName.split('|'), name = _valueAndName;
	if (valueList.length > 1) {
		rtnResult.push('<input style="display:none"');
		rtnResult.push(' value="' + (valueList[0] || '') + '"');
		rtnResult.push('>');
		name = valueList[1];
	}
	// 输出显示部分
	rtnResult.push('<input class="inputsgl" style="width:100%" readonly value="' + name + '">');
	// 输出选择部分
	if (selectJs) {
		var _js = (selectJs == '') ? '' : selectJs;
		rtnResult.push(' <a href="JavaScript:void(0);" onclick="' + _js + '">'+ TibJdbcDialog_lang.select +'</a>');
	}
	var tdElement = trElement.insertCell(-1);
	tdElement.innerHTML = rtnResult.join('');
};



/* 创建checkbox的Dom对象，此只有一个选项并且为布尔值
 参数:
		trElement    : 表格中tr对象
		booleanValue : 选中值，boolean类型
*/
function createCheckboxElement(trElement, booleanValue) {
	var tdElement = trElement.insertCell(-1);
	tdElement.innerHTML = '<input type="checkbox"' + (booleanValue ? ' checked' : '') + ' />';
};

function getDataTypeOptions() {
	var rtnArray = new Array();
	rtnArray.push({value:'String', name:TibJdbcDialog_lang.string});
	rtnArray.push({value:'DateTime', name:TibJdbcDialog_lang.date});
	rtnArray.push({value:'Double', name:TibJdbcDialog_lang.number});
	return rtnArray;
};

/**
   获取数据源
*/
var checkValue;
function getDataResource(checkValue){
this.checkValue =checkValue;
	// 调用Ajax
	(new KMSSData()).AddHashMap().SendToBean("tibJdbcFromTemplateDataRresourcesImp", doActionInOutResource);  
};

function doActionInOutResource(data){
   var nodesValue = data.GetHashMapArray(); 
   var res = document.getElementsByName("sqlResource")[0];
   if(res==null)return;
   res.options.length=0;
   res.options.add(new Option(TibJdbcDialog_lang.currentSys,''));
   for(var i = 0;i <  nodesValue.length; i++) {
		res.options.add(new Option(nodesValue[i]["fdName"],nodesValue[i]["fdId"]));
		if(this.checkValue==nodesValue[i]["fdId"]){//判断选中的
	          res.options.selectedIndex=(i+1);
	    }
	}
	  
	
};


 

