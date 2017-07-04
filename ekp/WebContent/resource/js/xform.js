/***********************************************
JS文件说明：
	此文件专为自定义标签需使用到的JS。

作者：龚健
版本：1.0 2009-7-21
***********************************************/
Com_RegisterFile("xform.js");
Com_IncludeFile("validation.js|plugin.js");
/**********************************************************
功能：checkbox的onclick
参数：
	name         ：字段名
	type         ：数据类型
	isArrayValue ：字段值是否是数组
	onValueChange: 当值发生变化时，所要调用的函数
**********************************************************/
function __cbClick(name, type, isArrayValue, onValueChange) {
	// 获得相应存储checkbox值列的div容器
	var divValue = document.getElementById("div_" + name);
	if (!divValue) return;
	// 获得相应的值列表
	var hiddenElements = '', cbElement;
	var cbElements = document.getElementsByName("_" + name);
	for (var i = cbElements.length - 1; i >= 0; i--) {
		cbElement = cbElements[i];
		if (cbElement.type.toLowerCase() == 'checkbox') {
			if (cbElement.checked) {
				hiddenElements += ';' + cbElement.value;
			} else if (type == 'boolean') {
				hiddenElements += ';false';
			}
		}
	}
	// 输出隐藏字段的HTML
	var buf = new Array(), elemList = hiddenElements.split(';');
	elemList.shift();
	var xformValue = null;
	if (isArrayValue) {
		for (var i = elemList.length - 1; i >= 0; i--) {
			buf.push('<input name="' + name + '" type="hidden" value="' + elemList[i] + '">');
		}
		xformValue = elemList;
	} else {
		xformValue = elemList.join(';');
		buf.push('<input name="' + name + '" type="hidden" value="' + xformValue + '">');
	}
	divValue.innerHTML = buf.join('');
	if (onValueChange != null) {
		onValueChange(xformValue , cbElements);
	}
};

function __getDateTimeTagBindingField(a) {
	var p = a.previousSibling;
	while (p != null && p.tagName != 'INPUT') {
		p = p.previousSibling;
	}
	return p;
}

function __getAddressTagBindingFieldId(a) {
	var p = a;
	while (p != null) {
		p = p.previousSibling;
		if (p.tagName == 'INPUT' && p.type == 'hidden')
			break;
	}
	return p;
}

function __getAddressTagBindingFieldName(a) {
	var p = a;
	while (p != null) {
		p = p.previousSibling;
		if ((p.tagName == 'INPUT' && p.type == 'text') || p.tagName == 'TEXTAREA')
			break;
	}
	return p;
}

/**********************************************************
功能：自定义表单统一值发生变化分发函数（外部不调用）
参数：
	value        ：发生值变化的控件的当前值
	domElement   ：当前发生值变化的控件Dom对象（可能是数组）
**********************************************************/
function __xformDispatch(value, domElement) {
	var i = 0, funs;
	if (typeof XFormOnValueChange == 'function') {
		XFormOnValueChange(value, domElement);
	}
	for (i = 0; i < XFormOnValueChangeFuns.length; i ++) {
		XFormOnValueChangeFuns[i](value, domElement);
	}	
//	var dom = (!(domElement instanceof String) && domElement.length > -1) ? domElement[0] : domElement;
//domElement为数组的情况，如果包含tagName属性，则dom的值为domElement，否则取数组第一个值 modify by limh 2010年11月19日
	var dom;
	if(!(domElement instanceof String)){
		if( domElement.length > -1){
			if(domElement.tagName){
				dom = domElement;
			}
			else{
				dom = domElement[0];
			}
		}
		else {
			dom = domElement;
		}
	}

	var id = dom.name;
	var e = null;
	
	for (e in __xform_changeEventByIdFuns) {
		if (id.indexOf(e) > -1) {
			funs = __xform_changeEventByIdFuns[e];
			for (i = 0; i < funs.length; i ++) {
				funs[i](value, domElement);
			}
		}
	}
	for (e in __xform_changeEventByLabelFuns) {
		if (dom.subject == e) {
			funs = __xform_changeEventByLabelFuns[e];
			for (i = 0; i < funs.length; i ++) {
				funs[i](value, domElement);
			}
		}
	}
}
// 缓存对象
var XFormOnValueChangeFuns = [];
var __xform_changeEventByIdFuns = {};
var __xform_changeEventByLabelFuns = {};
var __xform_labeObjCache = {};
var __xform_idObjCache = {};

function AttachXFormValueChangeEventById(id, fun) {
	var funs = __xform_changeEventByIdFuns[id];
	if (funs == null) {
		funs = [];
		__xform_changeEventByIdFuns[id] = funs;
	}
	funs.push(fun);
}

function AttachXFormValueChangeEventByLabel(label, fun) {
	var funs = __xform_changeEventByLabelFuns[label];
	if (funs == null) {
		funs = [];
		__xform_changeEventByLabelFuns[label] = funs;
	}
	funs.push(fun);
}

/**********************************************************
功能：自定义表单根据控件ID获取对象

参数：
	id           ：ID
	nocache      ：不用缓存
返回值：
	Dom对象数组
**********************************************************/
function GetXFormFieldById(id, nocache) {
	var forms = document.forms;
	var obj = nocache == true ? null : __xform_idObjCache[id];
	if (obj != null) return obj;
	obj = [];
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			if (elems[j].name != null && elems[j].name.indexOf(id) > -1) {
				obj.push(elems[j]);
			}
		}
	}
	__xform_idObjCache[id] = obj;
	return obj;
}
/**********************************************************
功能：自定义表单根据控件ID获取对象值

参数：
	id           ：ID
	nocache      ：不用缓存
返回值：
	值数组
**********************************************************/
function GetXFormFieldValueById(id, nocache) {
	var rtn = [];
	var objs = GetXFormFieldById(id, nocache);
	for (var i = 0; i < objs.length; i ++) {
		rtn.push(objs[i].value);
	}
	return rtn;
}

/**********************************************************
功能：自定义表单根据控件ID设置对象值
参数：
	id           ：字段的ID
	value        : 值
	nocache      ：不用缓存
**********************************************************/
function SetXFormFieldValueById(id, value, nocache) {
	var objs = GetXFormFieldById(id, nocache);
	_SetXFormFieldValue(objs, value);
}

/**********************************************************
功能：自定义表单根据显示文字获取对象
参数：
	label        ：字段的显示文字，在dom对象上是对应的subject属性
	nocache      ：不用缓存
返回值：
	Dom对象数组
**********************************************************/
function GetXFormFieldByLabel(label, nocache) {
	var forms = document.forms;
	var obj = nocache == true ? null : __xform_labeObjCache[label];
	if (obj != null) return obj;
	obj = [];
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			if (elems[j].subject == label) {
				obj.push(elems[j]);
			}
		}
	}
	__xform_labeObjCache[label] = obj;
	return obj;
}

/**********************************************************
功能：自定义表单根据显示文字获取对象值
参数：
	label        ：字段的显示文字，在dom对象上是对应的subject属性
	nocache      ：不用缓存
返回值：
	值数组
**********************************************************/
function GetXFormFieldValueByLabel(label, nocache) {
	var rtn = [];
	var objs = GetXFormFieldByLabel(label, nocache);
	for (var i = 0; i < objs.length; i ++) {
		rtn.push(objs[i].value);
	}
	return rtn;
}

/**********************************************************
功能：自定义表单根据显示文字设置对象值
参数：
	label        ：字段的显示文字，在dom对象上是对应的subject属性
	value        : 值
	nocache      ：不用缓存
**********************************************************/
function SetXFormFieldValueByLabel(label, value, nocache) {
	var objs = GetXFormFieldByLabel(label, nocache);
	_SetXFormFieldValue(objs, value);
}

function _SetXFormFieldValue(objs, value) {
	for (var i = 0; i < objs.length; i ++) {
		var obj = objs[i];
		var tagName = obj.tagName.toLowerCase();
		if (obj.type == 'text' || tagName == 'textarea' || tagName == 'select') {
			if (value instanceof Array) {
				obj.value = value.length > 1 ? value[1] : value[0];
			} else {
				obj.value = value;
			}
		}
		else if (obj.type == 'radio' && obj.value == value) {
			obj.checked = true;
		}
		else if (obj.type == 'checkbox' && (value == obj.value && value.indexOf(obj.value) > -1)) {
			obj.checked = true;
		}
		else if (obj.type == 'hidden') {
			if (value instanceof Array) {
				obj.value = value[0];
			} else {
				obj.value = value;
			}
		}
	}
}
function __GetXFormAddressFields(idField, nameField) {
	var rtn = [];
	rtn[0] = typeof(idField) == 'string' ? document.getElementsByName(idField)[0] : idField;
	rtn[1] = typeof(nameField) == 'string' ? document.getElementsByName(nameField)[0] : nameField;
	return rtn;
}
function __GetXFormAddressFieldValues(idField, nameField) {
	var rtn = [];
	var objs = __GetXFormAddressFields(idField, nameField);
	for (var i = 0; i < objs.length; i ++) {
		rtn[i] = objs[i].value;
	}
	return rtn;
}
/**
功能：地址本值变化触发函数，被封装在地址本标签中。（外部不调用）
参数：
	idField      ：地址本字段的ID属性
	nameField    ：地址本字段的NAME属性
	fn           ：onValueChange 函数
 */
function __CallXFormAddressOnValueChange(idField, nameField, fn) {
	var rtn = [];
	var objs = __GetXFormAddressFields(idField, nameField);
	for (var i = 0; i < objs.length; i ++) {
		rtn[i] = objs[i].value;
	}
	// 修正IE某些情况下，显示问题。在自定义表单中，可能会出现选择丢失情况。
	for (var i = 0; i < objs.length; i ++) {
		if(objs[i].style.display == ''){
			objs[i].style.display = 'none';
			objs[i].style.display = '';
		}
	}
	if (fn) {fn(rtn, objs);}
	if (objs[1].getAttribute('validate') == null || objs[1].getAttribute('validate') == '') return;
	__XFormOnValueChangeValidateField(objs[1]);
}
/**
功能：日期值变化触发函数，被封装在日期标签中。（外部不调用）
参数：
	calendar     ：日期对象
	fn           ：onValueChange 函数
 */
function __CallXFormDateTimeOnValueChange(calendar, fn) {
	if (fn) {fn(calendar.FieldObject.value, calendar.FieldObject);}
	var field = calendar.FieldObject;
	if (field.getAttribute('validate') == null || field.getAttribute('validate') == '') return;
	__XFormOnValueChangeValidateField(field);
}
function __XFormOnValueChangeValidateField(field) {
	if (window.xform_validation != null) {
		xform_validation.validateElement(field);
		return;
	}
	var defaultOpt = {
		onSubmit: false,
		immediate: false, 
		onElementFocus: $KMSSValidation_OnElementFocus, 
		getLang: $KMSSValidation_GetLang, 
		msgInsertPoint: $KMSSValidation_GetInsertPoint, 
		msgShowWhere: 'beforeend'
	};
	new KMSSValidation(field.form, defaultOpt).validateElement(field);
}
//解决动态表单动态添加或删除后交校验问题
function XFom_RestValidationElements() {/*
	if (window.xform_validation == null)
		xform_validation = $KMSSValidation();
	xform_validation._initialize(xform_validation.options);*/
	// 新增计算控件触发重新计算问题,--低性能
	if (window.XForm_CalculationDoExecutorAll)
		XForm_CalculationDoExecutorAll();
}

/**
 * 获取明细表中通行的表单域
 * @param dom
 * @param id
 * @return
 */
function GetXFormSameRowFieldById(dom, id) {
	var rtn = [], i, nm, name;
	var fs = GetXFormFieldById(id, true);
	if (dom.name != null && dom.name != '' && dom.name.indexOf('.') > -1) {
		name = dom.name;
		name = name.substring(0, name.lastIndexOf('.'));
		for (i = 0; i < fs.length; i ++) {
			nm = fs[i].name;
			nm = nm.substring(0, nm.lastIndexOf('.'));
			if (nm == name) {
				rtn.push(fs[i]);
			}
		}
	}
	return rtn;
}
/**
 * 获取当前事件对象
 * @param obj  默认不传改参数 这去当前触发事件的对象
 * @param owner 指定需要搜索的包含改事件触发对象的 标签 如 表格行 “tr”
 * @param event 事件对象，可为null，主要用于递归调用，避免多浏览器时死循环
 * @return
 * 例子：获取明细表 事件触发行指定控件
 * //var tr= GetDomOwnerDomTag("tr");
 * // $(tr).find("[name*=fd_2fd4aab4a4bf42]").val("设置该域的值");
 *  这里事件触发对象必须和设置值对象在同一行
 */
function GetDomOwnerDomTag(owner,obj,event)
{
   if(typeof(owner)=="object" && owner.tagName){
	   owner= owner.tagName;
   }
   //调用系统公共获取事件对象的方法，兼容多浏览器
   if(event==null)
	   event =Com_GetEventObject();
   if(!obj)
   {
	   obj = event.target ? event.target : event.srcElement;
   }
   if(typeof(obj)=="string")
   {
	   obj = document.getElementById(obj);
   }
   if(obj.tagName.toLowerCase() == owner.toLowerCase())
   {
	   return obj;
   }
   else
   {
       return GetDomOwnerDomTag(owner,obj.parentNode,event);
   }
 }
