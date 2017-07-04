/***********************************************
JS文件说明：
	此文件为自定义表单计算控件，前端计算JS

作者：傅游翔
版本：1.0 2010-5-31
***********************************************/
function XForm_CalculationExecuteExpression(expression, isRow, dom) {
	if (expression == '' || expression == null) {
		return '';
	}
	var scriptIn = expression;
	var preInfo = {rightIndex:-1};
	var scriptOut = "";
	for (var nxtInfo = XForm_CalculationFindNextInfo(scriptIn, preInfo); nxtInfo!=null; nxtInfo = XForm_CalculationFindNextInfo(scriptIn, nxtInfo)) {
		var varId = nxtInfo.isFunc ? nxtInfo.varName : XForm_CalculationGetVarValueById(nxtInfo.varName, isRow, dom); // 后续需要考虑公式的处理
		if (varId == null) {
			return '';
		}
		scriptOut += scriptIn.substring(preInfo.rightIndex+1, nxtInfo.leftIndex) + varId;
		preInfo = nxtInfo;
	}
	scriptOut += scriptIn.substring(preInfo.rightIndex+1);

	var result = (new Function('return (' + scriptOut + ');'))();
	if (result != null && result != '' && !isNaN(result)) { // 修复运算错误
		var c = result.toString();
		if (/\.\d*999999/.test(c) || /\.\d*0000000/.test(c)) {
			var _m = Math.pow(10, 6);
			result = Math.round(parseFloat(result)*_m)/_m;//result.toFixed(6);
		}
	}
	return result;
}
function XForm_CalculationFindNextInfo(script, preInfo) {
	var rtnVal = {};
	rtnVal.leftIndex = script.indexOf("$", preInfo==null?0:preInfo.rightIndex+1);
	if(rtnVal.leftIndex==-1)
		return null;
	rtnVal.rightIndex = script.indexOf("$", rtnVal.leftIndex+1);
	if(rtnVal.rightIndex==-1)
		return null;
	rtnVal.varName = script.substring(rtnVal.leftIndex + 1, rtnVal.rightIndex);
	rtnVal.isFunc = script.charAt(rtnVal.rightIndex+1)=="(";
	return rtnVal;
}
function XForm_CalculationParseDate(value, mode) {
	var rtn, array;
	if (mode) {
		array = value.split('-');
		return array;
	} else {
		rtn = [];
		array = value.split('/');
		rtn[0] = array[2];
		rtn[1] = array[0];
		rtn[2] = array[1];
	}
	return rtn;
}
function XForm_CalculationParseTime(value) {
	return value.split(':');
}
function XForm_CalculationConverVarValue(value) {
	if (value == '' || value == null) {
		return NaN;
	}
	var isTime = /(\d:)/g.test(value);
	var isDate1 = /^\d{4}-\d{2}-\d{2}/.test(value);
	var isDate2 = /^\d{2}\/\d{2}\/\d{4}/.test(value);
	var d,t;
	if (isTime && (isDate1 || isDate2)) {
		var tmp = value.split(/ +/);
		d = XForm_CalculationParseDate(tmp[0], isDate1);
		t = XForm_CalculationParseTime(tmp[1]);
		return (new Date(d[0], parseFloat(d[1]) - 1, d[2], t[0], t[1], [2])).getTime();
	}
	if (isTime) {
		t = XForm_CalculationParseTime(tmp[1]);
		return (parseFloat(t[0]) * 60 * 60 + parseFloat(t[1]) * 60 + parseFloat(t[2]));
	}
	if ((isDate1 || isDate2)) {
		d = XForm_CalculationParseDate(value, isDate1);
		return (new Date(d[0], parseFloat(d[1]) - 1, d[2])).getTime();
	}
	return parseFloat(value);
}
function XForm_CalculationGetVarValueById(fieldId, isRow, dom) {
	var i = fieldId.lastIndexOf('.');
	if (i > -1) {
		fieldId = fieldId.substring(i + 1, fieldId.length);
	} else {
		isRow = false;
	}
	var _objs = GetXFormFieldById(fieldId, true), objs = [];
	// 目前假设全是input text
	for (var k = 0; k < _objs.length; k ++) {
		if (_objs[k].type == 'radio' || _objs[k].type == 'checkbox') {
			if (_objs[k].checked) objs.push(_objs[k]);
			continue;
		}
		objs.push(_objs[k]);
	}
	var sum = '', num, n, sameTr, tr;
	if (isRow) {
		tr = XForm_CalculationGetTableRr(dom);
		for (n = 0; n < objs.length; n ++) {
			sameTr = XForm_CalculationGetTableRr(objs[n]);
			if (sameTr === tr) {
				num = XForm_CalculationConverVarValue(objs[n].value);
				if (isNaN(num)) return null;
				return num;
			}
		}
	} else {
		if (objs.length == 0) {
			return '';
		}
		if (objs.length == 1) {
			return XForm_CalculationConverVarValue(objs[0].value);
		}
		for (n = 0; n < objs.length; n ++) {
			num = XForm_CalculationConverVarValue(objs[n].value);
			//if (isNaN(num)) num = '0';
			sum = sum + ',' + num;
		}
		if (sum.length < 1) return '[]';
		return '[' + sum.substring(1,sum.length) + ']';
	}
	return '';
}
function XForm_CalculationIsDetailTableRr(dom) {
	if (dom.tagName == 'TR' && "true" != dom.getAttribute('data-celltr')) {
		for (var parent = dom.parentNode; parent != null; parent = parent.parentNode) {
			if (parent.tagName == 'TABLE') {
				return (/^TABLE_DL_/.test(parent.id));
			}
		}
		return true;
	}
	return false;
}
function XForm_CalculationGetTableRr(dom) {
	for (var parent = dom.parentNode; parent != null; parent = parent.parentNode) {
		if (XForm_CalculationIsDetailTableRr(parent)) {
			return parent;
		}
	}
	return null;
}
function XForm_CalculationGetAllContral(dom) {
	var forms = document.forms;
	var objs = [], executor;
	var varName = XForm_CalculationParseVar(dom);
	if (varName == null) {return objs;}
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			executor = elems[j];
			if (executor.name != null && executor.getAttribute && executor.getAttribute("calculation") == 'true') {
				if (varName != null) {
					if (executor.getAttribute("expression").indexOf(varName) > 0) {
						if ( executor.getAttribute("isRow") == 'true' && varName.indexOf('.') > 0) {
							if (XForm_CalculationGetTableRr(executor) === XForm_CalculationGetTableRr(dom)) {
								objs.push(elems[j]);
							}
							continue;
						}
						objs.push(elems[j]);
					}
					continue;
				}
			}
		}
	}
	return objs;
}
function XForm_CalculationGetAllAutoContrals() {
	var forms = document.forms;
	var objs = [], executor;
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			executor = elems[j];
			if (executor.name != null && executor.getAttribute && executor.getAttribute("calculation") == 'true' && executor.getAttribute("autoCalculate") == 'true') {
				if (executor.getAttribute("isRow") == 'true') {
					continue;
				}
				objs.push(elems[j]);
			}
		}
	}
	return objs;
}
function XForm_CalculationParseVar(dom) {
	if (dom.name == '' || dom.name == null) {
		return null;
	}
	var name = dom.name.toString();
	var sIndex = name.indexOf('value(');
	if (sIndex < 0) {
		sIndex = 0;
	}
	var eIndex = name.lastIndexOf(')');
	name = name.substring(sIndex + 6, eIndex);
	var dIndex = name.lastIndexOf('.');
	if (dIndex > -1) {
		name = name.substring(dIndex + 1, name.length);
	}
	return name;
}
function XForm_CalculationTryExecute(executor) {
	try {
		value = XForm_CalculationExecuteExpression(executor.getAttribute("expression"), executor.getAttribute("isRow") == 'true', executor);
		if (value == null || isNaN(value)) executor.value = '';
		else {
			if (executor.getAttribute("scale") != null && executor.getAttribute("scale") != '') {
				var scale = parseInt(executor.getAttribute("scale"));
				if (!isNaN(scale)) {
					value = XForm_CalculationRound(value, scale);
				}
			}
			executor.value = value;
		}
		__xformDispatch(value, executor);
	} catch(e) {
		if (window.console) {
			console.info("js:" + e.description + "\n" + executor.getAttribute("expression") + "\n" + e);
		}
	}
}
function XForm_CalculationRound(a, b) {
	return (Math.round( a * Math.pow(10, b) ) / Math.pow(10, b));
}
function XForm_CalculationDoExecutor(value, dom) {
	if (dom instanceof Array) {
		dom = dom[0];
	}
	var executors = XForm_CalculationGetAllContral(dom), executor;
	for (var i = 0; i < executors.length; i ++) {
		if (executors[i].getAttribute("autoCalculate") == 'true')
			XForm_CalculationTryExecute(executors[i]);
	}
}
function XForm_CalculationDoExecutorAll() {
	var executors = XForm_CalculationGetAllAutoContrals();
	for (var i = 0; i < executors.length; i ++) {
		XForm_CalculationTryExecute(executors[i]);
	}
}
function XForm_CalculationDoAction(btn) {
	var parent = btn.parentNode;
	var inputs = parent.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i ++) {
		if (inputs[i].name != null && inputs[i].getAttribute && inputs[i].getAttribute("calculation") == 'true') {
			XForm_CalculationTryExecute(inputs[i]);
			break;
		}
	}
}
function XForm_CalculationOnLoad() {
	XFormOnValueChangeFuns.push(XForm_CalculationDoExecutor);
}
Com_AddEventListener(window, 'load', XForm_CalculationOnLoad);
//浮点数相加的函数，防止出现 一个长串小数  作者 曹映辉 #日期 2013年11月22日
function accAdd(num1,num2){ 
    var r1,r2,m; 
    try{ 
        r1 = num1.toString().split(".")[1].length; 
    }catch(e){ 
        r1 = 0; 
    } 
    try{ 
        r2=num2.toString().split(".")[1].length; 
    }catch(e){ 
        r2=0; 
    } 
    m=Math.pow(10,Math.max(r1,r2)); 
    return Math.round(num1*m+num2*m)/m; 
} 
// 公式
function XForm_CalculatioFuns_Sum() {
	var array = (arguments.length > 1 || !(arguments[0] instanceof Array)) ? arguments : arguments[0];
	var sun = 0, num;
	for (var i = 0; i < array.length; i ++) {
		num = parseFloat(array[i]);
		if (isNaN(num)) num = 0;
		sun = accAdd(sun,num);
	}
	return sun;
}
function XForm_CalculatioFuns_Count() {
	var array = (arguments.length > 1 || !(arguments[0] instanceof Array)) ? arguments : arguments[0];
	var sun = 0;
	for (var i = 0; i < array.length; i ++) {
		if (array[i] != null && array[i] != '' && !isNaN(array[i])) {
			sun ++;
		}
	}
	return sun;
}
function XForm_CalculatioFuns_Avg() {
	var array = (arguments.length > 1 || !(arguments[0] instanceof Array)) ? arguments : arguments[0];
	var sun = 0, num, count = 0;
	for (var i = 0; i < array.length; i ++) {
		num = parseFloat(array[i]);
		if (isNaN(num)) {
			continue;
		}
		sun = accAdd(sun,num);
		count ++;
	}
	return (sun / count);
}
function XForm_CalculatioFuns_DefaultValue(value, def) {
	if (value == null || isNaN(value)) {
		return def;
	}
	return value;
}