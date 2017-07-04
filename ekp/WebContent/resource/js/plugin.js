/***********************************************
JS文件说明：
	产品构件注册。此文件全是Java产品特有功能的相关函数。
	包含的构件：
		1. KMSSValidation 校验构件

作者：龚健
版本：1.0 2009-6-23
***********************************************/

/**********************************************************
功能：表单校验相应配置函数
描述：
	$KMSSValidation						校验主函数
	$KMSSValidation_HideWarnHint		隐藏指定字段的错误提示信息
	$KMSSValidation_SetTabFocus			字段所在标签页对象获得焦点
	$KMSSValidation_OnElementFocus		使指定字段获得焦点
	$KMSSValidation_GetLang				获得校验器相应提示信息（多语言）
	$KMSSValidation_GetInsertPoint		获得显示错误信息插入的位置对象
	$KMSSValidation_GetAdvice			获得指定字段相应的错误提示信息对象
**********************************************************/
Com_RegisterFile("plugin.js");
Com_IncludeFile("jquery.js|validation.js|validation.jsp", null, "js");

function $KMSSValidation(form, options) {
	form = form || document.forms[0];
	var _validation = $GetKMSSDefaultValidation(form,options);
	// 兼容Java产品默认提交表单模式
	if (Com_Parameter.event["submit"]) {
		Com_Parameter.event["submit"].unshift(function() {
			return _validation.validate();
		});
	}
	if ($KMSSValidation.forms == null) {
		$KMSSValidation.forms = {};
	}
	if (form) {
		$KMSSValidation.forms[form.name || form] = _validation;
	}
	return _validation;
};

function $GetFormValidation(form) {
	if ($KMSSValidation.forms == null)
		return null;
	return $KMSSValidation.forms[form.name || form];
}

function $GetKMSSDefaultValidation(formObj, options) {
	var _options = options || {};
	var defaultOpt = {onSubmit: false, immediate: true, onElementFocus: $KMSSValidation_OnElementFocus, 
			onElementClickFocus: $KMSSValidation_OnElementClickFocus,getLang: $KMSSValidation_GetLang, 
			msgInsertPoint: $KMSSValidation_GetInsertPoint, msgShowWhere: 'beforeend'};
	for (var property in _options) {
		defaultOpt[property] = _options[property];
	}
	if(formObj==null){
		defaultOpt.isFieldValidate = true;
	}
	var _validation = new KMSSValidation(formObj, defaultOpt);
	_validation.addValidators($KMSSValidation.ExtValidator);
	return _validation;
}

function KMSSValidation_HideWarnHint(element) {
	var _Reminder = new Reminder(element);
	_Reminder.hide();
};

function $KMSSValidation_SetTabFocus(element,isLabelTable) {
	var _element = $(element);
	if(isLabelTable){
		var trObj = _element.parents("tr[LKS_LabelName]");
		if(trObj.length>0){
			var currLabelIndex = -1;
			if(trObj.attr("LKS_LabelIndex")!=null && trObj.attr("LKS_LabelIndex")!=''){
				 currLabelIndex = parseInt(trObj.attr("LKS_LabelIndex"));
			}
			if (currLabelIndex != -1){ 
				Doc_SetCurrentLabel('Label_Tabel', currLabelIndex);
			}
		}
	}else{
		var tabpage = _element.parents("div[data-lui-type='lui/panel!Content']");
		if(tabpage.length>0){
			var luiId = tabpage.attr("data-lui-cid");
			var contentObj = LUI(luiId);
			if(!contentObj.isShow){
				contentObj.parent.expandContent(contentObj);
			}
		}
	}
};
function $KMSSValidation_ElementFocus(element){
	try {
		element.focus();
	} catch (err) {}
	
	var posHeight = $(element).offset().top;
	var screenHeight = window.innerHeight?window.innerHeight:$(window).height();
	if(posHeight > screenHeight){
		var y = 20;
		var _adviceMsg = $KMSSValidation_GetAdvice(element);
		if (_adviceMsg) {
			y = _adviceMsg.offsetHeight > y ? _adviceMsg.offsetHeight : y;
		}
		var scrollTop =  posHeight - screenHeight/2 + y;
		$("html,body").scrollTop(scrollTop);
	}else{
		$("html,body").scrollTop(0);
	}
}
//校验不通过后直接执行
function $KMSSValidation_OnElementFocus(element) {
	$KMSSValidation_SetTabFocus(element,true);
	$KMSSValidation_ElementFocus(element);
};

//校验不通过,点击错误提示后的操作
function $KMSSValidation_OnElementClickFocus(element){
	$KMSSValidation_SetTabFocus(element);
	$KMSSValidation_ElementFocus(element);
}

function $KMSSValidation_AbsPosition(node) {
	var x = y = 0;
	for (var pNode = node; pNode != null; pNode = pNode.offsetParent) {
		x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
	}
	x = x + document.body.scrollLeft;
	y = y + document.body.scrollTop;
	return {'x':x, 'y':y};
}

function $KMSSValidation_GetLang(validator) {
	if (typeof($KMSSValidation_Lang) == 'undefined') return validator.error;
	return $KMSSValidation_Lang[validator.type] || validator.error;
};

function $KMSSValidation_GetInsertPoint(element) {
	for (var _find = element; _find && _find.tagName && _find.tagName.toLowerCase() != 'td'; _find = _find.parentNode) {};
	return (_find && _find.tagName && _find.tagName.toLowerCase() == 'td') ? _find : null;
};

function $KMSSValidation_GetAdvice(element) {
	if (element == null) return null;
	var _adviceID = 'advice-' + element.getAttribute(KMSSValidation.ValidateConfig.attribute);
	return document.getElementById(_adviceID);
};

$KMSSValidation.ExtValidator = {
	'range(min,max)' : {
		error : '输入值必须是大于等于 {min},小于等于 {max}。',
		test : function(v, e, o) {
			if (this.getValidator('isEmpty').test(v)) return true;
			if ((!isNaN(v) && !/^\s+$/.test(v))) {
				var min = isNaN(o['min']) ? 0 : parseFloat(o['min']);
				var max = isNaN(o['max']) ? 0 : parseFloat(o['max']);
				var value = parseFloat(v);
				return (min <= value && value <= max);
			}
			return false;
		}
	},
	'max(num)' : {
		error : '输入值必须小于等于 {num}。',
		test : function(v, e, o) {
			if (this.getValidator('isEmpty').test(v)) return true;
			if ((!isNaN(v) && !/^\s+$/.test(v))) {
				var num = isNaN(o['num']) ? 0 : parseFloat(o['num']);
				var value = parseFloat(v);
				return (value <= num);
			}
			return false;
		}
	},
	'min(num)' : {
		error : '输入值必须大于等于 {num}。',
		test : function(v, e, o) {
			if (this.getValidator('isEmpty').test(v)) return true;
			if ((!isNaN(v) && !/^\s+$/.test(v))) {
				var num = isNaN(o['num']) ? 0 : parseFloat(o['num']);
				var value = parseFloat(v);
				return (value >= num);
			}
			return false;
		}
	},
	'scaleLength(num)' : {
		error : '输入值小数位必须小于等于 {num}。',
		test : function(v, e, o) {
			if (this.getValidator('isEmpty').test(v)) return true;
			if ((!isNaN(v) && !/^\s+$/.test(v))) {
				v = parseFloat(v).toString();
				var lasIndex = v.lastIndexOf('.');
				if (lasIndex < 0) return true;
				var num = isNaN(o['num']) ? 0 : parseInt(o['num']);
				var value = v.substr(lasIndex + 1).length;
				return (value <= num);
			}
			return false;
		}
	},
	'before':{
		error : '请选择当前时间之前的日期。',
		test : function(v,e,o){
			if (this.getValidator('isEmpty').test(v)) return true;
			var today = new Date();
			today.setSeconds(0, 0);
			var temDate = null;
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']!='zh-cn'){
				temDate = Date.parse(v);
			}else{
				var arr = v.split(/[^0-9]/);
				temDate = new Date(parseInt(arr[0],10),parseInt(arr[1],10)-1,parseInt(arr[2],10),arr[3]==null?0:parseInt(arr[3],10),
						arr[4]==null?0:parseInt(arr[4],10),arr[5]==null?0:parseInt(arr[5],10),arr[6]==null?0:parseInt(arr[6],10),
						arr[7]==null?0:parseInt(arr[7],10)).getTime();
			}
			if(temDate <= today.getTime())
				return true;
			return false;
		}
	},
	'after':{
		error : '请选择当前时间之后的日期。',
		test : function(v,e,o){
			if (this.getValidator('isEmpty').test(v)) return true;
			var today = new Date();
			today.setSeconds(0, 0);
			var temDate = null;
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']!='zh-cn'){
				temDate = Date.parse(v);
			}else{
				var arr = v.split(/[^0-9]/);
				temDate = new Date(parseInt(arr[0],10),parseInt(arr[1],10)-1,parseInt(arr[2],10),arr[3]==null?0:parseInt(arr[3],10),
								arr[4]==null?0:parseInt(arr[4],10),arr[5]==null?0:parseInt(arr[5],10),arr[6]==null?0:parseInt(arr[6],10),
								arr[7]==null?0:parseInt(arr[7],10)).getTime();
			}
			if(temDate >= today.getTime())
				return true;
			return false;
		}	
	},
	'__date' : {
		error : '请输入有效的日期。',
		test  : function(v) {
			var res=false;
			//格式:yyyy-MM-dd
			var regDate = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']!='zh-cn'){
				//格式:MM/dd/yyyy
				regDate = /^(((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-9])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})$/;
			}
			if(v){
				res=regDate.test(v);
			}
			return this.getValidator('isEmpty').test(v) || res;
		}
	},
	'__datetime' : {
		error : '请输入有效的日期时间。',
		test  : function(v) {
			var res=false;
			var regDate=/^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']!='zh-cn'){
				regDate = /^(((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-9])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})$/;
			}
			var regTime=/^[0-2][\d]:[0-5][\d]$/;
			if(v)
			{
				var dateAry=v.split(/\s+/);
				if(dateAry.length==2){
					res = regDate.test(dateAry[0])&&regTime.test(dateAry[1]);
				}
			}
			return this.getValidator('isEmpty').test(v) || res;
		}
	},
	'__time': {
		error : '请输入有效的时间。',
		test  : function(v) {
			var res=false;
			var regTime=/^[0-2][\d]:[0-5][\d]$/;
			if(v)
			{
				res= regTime.test(v);
					
			}
			return this.getValidator('isEmpty').test(v) || res;
		}
	}
}