/***********************************************
JS文件说明：
	该文件是JS校验页面必选项。
	包含的对象：
		1. KMSSValidation 校验主对象
		2. Validator      校验器
		3. Elements       表单字段集
		4. Element        表单字段
		5. Reminder       提示信息对象
	规则：
		页面中需校验的字段，需添加一个名为validate的属性。此属性值为一些校验器的关键字，多个校验器以空格间隔。
		校验字段，可以添加一个名为subject的属性，此属性为字段描述名。在错误提示信息中可以用{name}来标注。
		校验字段，可以添加一个名为reminder的属性。此属性为验证错误的提示信息样式。格式：显示位置 + # + 样式。样式：***{Msg}***。
		若校验器有参数，则提示信息中以 { + 参数名 + } 来标注即可。
			比如：
				校验器   ：lengthRange(minLength,maxLength)
				校验实例 ：lengthRange(3,9)
				提示信息 ：值只能在{minLength}到{maxLength}之间
				显示信息 ：值只能在3到9之间
	使用：

作者：龚健
版本：1.0 2009-6-17
***********************************************/
Com_RegisterFile("validation.js");
/**********************************************************
功能：表单字段校验对象
参数
	form    ：表单对象
	options ：配置参数
**********************************************************/
function KMSSValidation(form, options) {
	this.options = {
		onSubmit				: true,										// 绑定onSubmit
		stopOnFirst				: false,									// 校验不通过则停止校验
		immediate				: false,									// 离开一个验证区域时立即进行验证
		focusOnError			: true,										// 校验不通过则相关字段获得焦点
		getLang					: function(validator) {return validator.error;},	// 获得相应语言下的信息(多语言)
		onElementFocus			: function(element) {},						// 指定字段获得焦点
		onElementClickFocus		: function(element) {},						// 点击校验获取检验元素焦点
		beforeFormValidate		: function(form) {return true;},			// 表单执行校验前事件，false为不校验
		afterFormValidate		: function(result, form) {return true;},	// 表单执行校验后事件
		beforeElementValidate	: function(element) {return true;},			// 字段执行校验前事件，false为不校验
		afterElementValidate	: function(result, element) {return true;},	// 字段执行校验后事件
		msgInsertPoint			: function(element) {return element;},		// 错误消息需放置对象
		msgShowWhere			: 'afterEnd',								// 错误消息显示位置
		msgShowType				: 'default',								// 错误信息提醒方式(default:缺省,alert:alert提醒方式)
		isFieldValidate			: false										// 仅仅是字段校验
	};
	this.form = form || document.forms[0];
	this.methods = {};												// 记录校验器的容器
	this.elements = new Array;												// 需校验的字段集

	// 内部函数
	this._initialize = _KMSSValidation_Initialize;					// 初始化函数
	this._bindSubmit = _KMSSValidation_BindSubmit;					// 提交时间绑定
	this._bindBlur = _KMSSValidation_BindBlur;						// 整个document的事件绑定
	this._doValidateElement = _KMSSValidation_DoValidateElement;	// 执行校验单个字段，根据单个校验器
	this._parseValidatorName = _KMSSValidation_ParseValidatorName;	// 解析校验器名

	// 外部函数
	this.getValidator = KMSSValidation_GetValidator;				// 获得相应的校验器
	this.addValidator = KMSSValidation_AddValidator;				// 添加校验器
	this.addValidators = KMSSValidation_AddValidators;				// 添加多个校验器
	this.validateElement = KMSSValidation_ValidateElement;			// 校验单个字段
	this.validate = KMSSValidation_Validate;						// 校验函数
	this.addElements = Elements_addElement;							// 追加需校验的字段
	this.removeElements = Elements_removeElement;					// 移除需校验的字段或区域
	this.resetElementsValidate = Elements_resetElementValidate;		// 重置字段或区域的校验信息

	// 初始化
	this._initialize(options);
};

/********************校验对象私有方法*********************/
function _KMSSValidation_Initialize(options) {
	// 更新配置参数
	KMSSValidation.extend(true, this.options, options || {});
	// 最基本的内置校验器
	this.addValidator('isEmpty', '', function(v) {
		return ((v == null) ||v.replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g,"")==''|| (v.length == 0));
	});
	// 常用的内置校验器
	this.addValidators(KMSSValidation.DefaultValidator);
	
	// 绑定onSubmit
	if (this.options.onSubmit && !this.options.isFieldValidate) this._bindSubmit();
	// 绑定onBlur
	if(this.options.immediate) this._bindBlur();
};

function _KMSSValidation_BindSubmit() {
	var _self = this;
	var _userSubmit = this.form.onsubmit;
	//按钮type设置为submit时，此方法有效。
	this.form.onsubmit = function() {
		if (!_self.validate()) return false;
		if (_userSubmit) return _userSubmit();
	};
	//HTML标准定义的是submit方法。
	var _submitToUse = this.form.submit;
	this.form.submit = function() {
		if (!_self.validate()) return false;
		if (_submitToUse) return _submitToUse();
	};
};

function _KMSSValidation_BindBlur() {
	// 通过事件代理模式来捕获相应事件
	var _self = this, oElement = new Elements();
	// 成组的元素的校验事件，比如：radio。
	KMSSValidation.addEvent(document, 'click', function(event) {
		var _event = event || window.event, srcElement = _event.srcElement || _event.target;
		if (oElement.valiateElement(srcElement)) {
			var typeName = srcElement.type.toLowerCase();
			if (typeName == 'radio' || typeName == 'checkbox') _self.validateElement(srcElement);
		}
	}, false);
	// 普通的元素校验事件
	var blurEvent = function(event) {
		var _event = event || window.event, srcElement = _event.srcElement || _event.target;
		if (oElement.valiateElement(srcElement)) {
			var typeName = srcElement.type.toLowerCase();
			if (typeName == 'radio' || typeName == 'checkbox') return;
			_self.validateElement(srcElement);
		}
	};
	// 不同浏览器触发不同的事件
	if (KMSSValidation.getBrowser() == 'msie') {
		KMSSValidation.addEvent(document, 'focusout', blurEvent);
	} else {
		KMSSValidation.addEvent(document, 'blur', blurEvent, true);
	}
};
/**********************************************************
功能：解析校验器名
参数：
	name ：校验名
示例：
	样例：lengthRange(minLength,maxLength) 输入字符串的长度必须在minLength到maxLength之间
	解析结果：['length-range', 'minLength', 'maxLength'].
**********************************************************/
function _KMSSValidation_ParseValidatorName(name) {
	var _name = name.replace('(', ',').replace(')', '');
	return _name.split(',');
};

/**********************************************************
参数：
	oElement  ：表单字段对象
	validator ：校验器对象
**********************************************************/
function _KMSSValidation_DoValidateElement(oElement, validator) {
	var _elm = oElement.element;
	var _reminder_opt = {where: this.options.msgShowWhere, insertPoint: this.options.msgInsertPoint,clickFun:this.options.onElementClickFocus};
	var _isNotPass = oElement.isEnable() && !validator.test(oElement.getValue(), _elm);
	var _reminder = new Reminder(_elm, this.options.getLang(validator), validator.options, _reminder_opt);
	switch(this.options.msgShowType) {
	case 'alert':
		if (_isNotPass) _reminder.alert();
		break;
	default:
		(_isNotPass) ? _reminder.show() : _reminder.hide();
		break;
	}
	return !_isNotPass;
};

/**********************************************************
 * 字段参与校验,或增加字段某个校验
参数：
	element  ：表单字段对象
**********************************************************/
function Elements_addElement(element , validateName) {
	var _elements = new Elements();
	if($(element).is(":input")){
		_elements.addElementValiate(element,validateName);
		if (!_elements.valiateElement(element)) return;
		// 追加到校验的数组中
		_elements.serializeElement(element);
		this.elements.push(element);
	}else{
		var _self = this;
		$(element).find(":input").each(function(){
			_elements.addElementValiate(this,validateName);
			if (_elements.valiateElement(this)){
				_elements.serializeElement(this);
				_self.elements.push(this);
			}
		});
	}
	// 若需要立即校验，更新指定字段的相应事件
	if(this.options.immediate) this._bindBlur();
};

/**********************************************************
参数：
	element  ：字段或dom区域对象
**********************************************************/
function Elements_resetElementValidate(element){
	var _elements = new Elements();
	if($(element).is(":input")){
		var idx = $.inArray(element,this.elements);
		if(idx >-1){
			this.elements.splice(idx, 1);
		}
		_elements.resetElementValiate(element);
	}else{
		var _self = this;
		$(element).find(":input").each(function(){
			var idx = $.inArray(this,_self.elements);
			if(idx >-1){
				_self.elements.splice(idx, 1);
			}
			_elements.resetElementValiate(this);
		});
	}
};

/**********************************************************
参数：
	element  ：字段或dom区域对象
**********************************************************/
function Elements_removeElement(element , validateName){
	var _elements = new Elements();
	if($(element).is(":input")){
		var idx = $.inArray(element,this.elements);
		if(idx >-1){
			this.elements.splice(idx, 1);
		}
		_elements.cancelElementValiate(element,validateName);
	}else{
		var _self = this;
		$(element).find(":input").each(function(){
			var idx = $.inArray(this,_self.elements);
			if(idx >-1){
				_self.elements.splice(idx, 1);
			}
			_elements.cancelElementValiate(this,validateName);
		});
	}
};

/********************校验对象公用方法*********************/
function KMSSValidation_Validate() {
	// 获得需校验的字段集
	var elements = null;
	var result = true, first = null;
	if(!this.options.isFieldValidate){
		//表单校验前
		if (!this.options.beforeFormValidate(this.form))
			return result;
	}
	if(this.options.isFieldValidate){
		elements = this.elements;
	}else{
		elements = (new Elements(this.form)).getElements();
	}
	if(this.options.stopOnFirst) {
		for (var i = 0, length = elements.length; i < length; i++) {
			if (!this.validateElement(elements[i])) {
				first = elements[i];
				result = false;
				break;
			}
		}
	} else {
		for (var i = 0, length = elements.length; i < length; i++) {
			if (!this.validateElement(elements[i])) {
				if (result) {
					first = elements[i];
					result = false;
				}
			}
		}
	}
	// 校验不通过则相关字段获得焦点
	if(!result && this.options.focusOnError) this.options.onElementFocus(first);
	
	if(!this.options.isFieldValidate){
		// 表单执行校验后事件
		this.options.afterFormValidate(result, this.form, first);
	}

	return result;
};

function KMSSValidation_ValidateElement(element) {
	var result = true, validator;
	if (!element || !this.options.beforeElementValidate(element)) return result;
	
	var _elements = new Elements();
	if (!_elements.valiateElement(element)) return result;
	_elements.serializeElement(element);
	var vos = element.getAttribute("validate").split(' ');
	var oElement = new Element(element);
	for (var i = 0, length = vos.length; i < length; i++) {
		validator = this.getValidator(vos[i]);
		if (!this._doValidateElement(oElement, validator)) {
			result = false;
			break;
		}
	}
	this.options.afterElementValidate(result, element);
	return result;
};

/**********************************************************
功能：获得校验器，并初始化相关参数
参数：
	name ：校验器名
示例：
	校验器名 maxLength(length)
	实例     maxLength(3)
	结果：校验器类型为maxLength，校验器需要的参数length为3.
**********************************************************/
function KMSSValidation_GetValidator(name) {
	var _parseArray = this._parseValidatorName(name);
	// 校验器类型
	var _type = _parseArray.shift();
	// 校验器
	var _validator = this.methods[_type] ? this.methods[_type] : new Validator();
	// 获得相应参数值
	_validator.setParams(_parseArray);
	// 保证校验器的校验函数宿主为当前对象
	_validator.setParent(this);
	return _validator;
};

function KMSSValidation_AddValidator(type, error, test) {
	var _validators = {}, _parseArray = this._parseValidatorName(type);
	var _type = _parseArray.shift();
	_validators[_type] = new Validator(_type, error, test, _parseArray);
	KMSSValidation.extend(this.methods, _validators);
};

function KMSSValidation_AddValidators(validators) {
	var _validators = {}, _validator, _parseArray, _type;
	for (var type in validators) {
		_parseArray = this._parseValidatorName(type);
		_type = _parseArray.shift();
		_validator = validators[type];
		_validators[_type] = new Validator(_type, _validator.error, _validator.test, _parseArray);
	}
	KMSSValidation.extend(this.methods, _validators);
};

/**********************************************************
功能：内置校验器
**********************************************************/
KMSSValidation.DefaultValidator = {
	'required' : {
		error : '这是必填字段。',
		test  : function(v) {return !this.getValidator('isEmpty').test(v);}
	},
	'number' : {
		error : '请输入有效的数字。',
		test  : function(v) {return this.getValidator('isEmpty').test(v) || (!isNaN(v) && !/^\s+$/.test(v)&& /^.{1,20}$/.test(v) );}
	},
	'digits' : {
		error : '请输入数字，避免使用空格或其他字符，如点或逗号。',
		test  : function(v) {return this.getValidator('isEmpty').test(v) || !/[^\d]/.test(v);}
	},
	'alpha' : {
		error : '请输入字母（a-z）。',
		test  : function(v) {return this.getValidator('isEmpty').test(v) || /^[a-zA-Z]+$/.test(v);}
	},
	'alphanum' : {
		error : '只能输入字母（a-z）或数字（0-9），不允许有空格和其他字符。',
		test  : function(v) {return this.getValidator('isEmpty').test(v) || !/\W/.test(v);}
	},
	'date' : {
		error : '请输入有效的日期。',
		test  : function(v) {
			var res=false;
			var regDate=/^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
			var regTime=/^[0-2][\d]:[0-5][\d]$/;
			if(v)
			{
				var dateAry=v.split(/\s+/);
				
				if(dateAry.length==1)
				{
					res=regDate.test(v) || regTime.test(v);
					
				}else if(dateAry.length==2)
				{
					res=regDate.test(dateAry[0])&&regTime.test(dateAry[1]);
					
				}
			}
			return this.getValidator('isEmpty').test(v) || res;
		}
	},
	'email' : {
		error : '请输入有效电子邮件地址，例如：admin@landray.com.cn。',
		test  : function(v) {return this.getValidator('isEmpty').test(v) || /\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/.test(v);}
	},
	'url' : {
		error : '请输入有效的url地址。',
		test  : function(v) {return this.getValidator('isEmpty').test(v) || /^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i.test(v);}
	},
	'currency-dollar' : {
		error : '请输入有效的货币，例如：100.00。',
		test  : function(v) {
			// [$]1[##][,###]+[.##]
			// [$]1###+[.##]
			// [$]0.##
			// [$].##
			return this.getValidator('isEmpty').test(v) || /^\$?\-?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}\d*(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/.test(v);
		}
	},
	'maxLength(length)' : {
		error : '请输入有效长度的值，字段长度不能超过{maxLength}个字符',
		test  : function(v, e, o) {
			var length = isNaN(o['length']) ? 0 : parseInt(o['length']);
			if (length == 0 || this.getValidator('isEmpty').test(v)) return true;
			o['maxLength'] = length; //Math.floor(length/30)*20;
			var newvalue = v.replace(/[^\x00-\xff]/g, "***");
			return newvalue.length <= length;
		}
	}
};

/**********************************************************
功能：校验器
参数
	type    ：校验类型
	error   ：验证错误提示信息
	test    ：校验方法
	params  ：参数列表
	options ：临时参数
**********************************************************/
function Validator(type, error, test, params, options) {
	this.type = type;
	this.error = error;
	this.parent = this;                                      // 父对象(默认为自己)
	this.params = params || {};                              // 参数列表
	this.options = options || {};
	// 内部函数
	this._test = test ? test : function(value, element) { return true };
	// 公共函数
	this.test = Validator_Test;                              // 校验函数
	this.setParent = Validator_SetParent;                    // 设置父对象
	this.setOption = Validator_SetOption;                    // 设置单个参数
	this.setParams = Validator_SetParams;                    // 设置全部参数
};

function Validator_Test(value, element) {
	return this._test.call(this.parent, value, element, this.options);
};

function Validator_SetParent(parent) {
	this.parent = parent || this;
};

function Validator_SetOption(param, value) {
	this.options[param] = value;
};

function Validator_SetParams(values) {
	for (var i = 0, length = this.params.length; i < length; i++) {
		if (i == values.length) break;
		this.setOption(this.params[i], values[i]);
	}
};

/**********************************************************
功能：提示信息对象的构造函数
参数
	element ：表单字段
	msg     ：提示信息
	params  ：校验器相应的参数列表
	options ：临时参数
**********************************************************/
function Reminder(element, msg, params, options) {
	this.element = $(element) || null;
	this.msg = msg || '';
	this.options = {
		where			: 'afterEnd',							// 信息插入位置
		insertPoint		: function(element) {return element;},	// 获得插入对象
		layout			: '',									// 布局样式（可以在消息体外设计布局格式）
		clickFun		: function(element){}					// 提醒点击后执行函数
	};
	// 内部属性
	this._msgStyle = '';										// 消息显示样式
	this._params = params || {};
	// 内部函数
	this._initialize = _Reminder_Initialize;					// 初始化函数
	this._getAdvice = _Reminder_GetAdvice;						// 显示信息的HTML对象
	this._getLuiAdvice = _Reminder_GetLuiAdvice;				// 显示lui校验
	// 公共函数
	this.show = Reminder_Show;
	this.hide = Reminder_Hide;
	this.alert = Reminder_Alert;

	// 初始化
	this._initialize(options);
};

function _Reminder_Initialize(options) {
	// 更新配置参数
	KMSSValidation.extend(true, this.options, options || {});
	// 获得字段显示配置
	var _reminder = '';
	if (this.element) {
		_reminder = this.element.attr("reminder") || '';
	}
	var _arrReminder = _reminder.split('#');
	this._msgStyle = _arrReminder[1] || '';
	// 更新相应配置
	this.options.where = _arrReminder[0] || this.options.where;
	// 设置缺省显示样式
	if (this.options.layout == '') {
		aHtml =  '<table class="validation-table"><tr><td>';
		aHtml += '<div class="lui_icon_s lui_icon_s_icon_validator"></div></td>';
		aHtml += '<td class="validation-advice-msg">{ShowMsg}</td></tr></table>';
		this.options.layout = aHtml;
	}
};

function _Reminder_GetAdvice(innerHtml , create) {
	var _element = this.element;
	if (_element.length < 1) return null;
	var _adviceID = 'advice-' + _element.attr(KMSSValidation.ValidateConfig.attribute);
	var advice = $('#'+_adviceID);
	if(advice.length < 1 ){
		if(create){
			var aHtml = '<div class="validation-advice" id="' + _adviceID + '" _Reminder="true" />';
			var insertObject = this.options.insertPoint(_element.get(0));
			if (insertObject) {
				advice = $(KMSSValidation.insertHtml(this.options.where, insertObject, aHtml)).addClass('validation-advice');
				advice.append(innerHtml);
			}
		}
	}else{
		advice.html('');
		advice.append(innerHtml);
	}
	return advice;
};

function _Reminder_GetLuiAdvice(innerHtml , create){
	var _self = this; 
	var _element = this.element;
	if (_element.length < 1) return null;
	var _adviceID = 'lui-advice-' + _element.attr(KMSSValidation.ValidateConfig.attribute);
	var $luiVal = $("#lui_validate_message");
	if($luiVal.length >0){
		var rtnAdvice = $luiVal.find("#"+_adviceID);
		if(rtnAdvice.length<1){
			if(create){
				rtnAdvice = $("<div class='lui_validate'></div>").attr("id",_adviceID).click(function(){
					if(_self.options && _self.options.clickFun)
						_self.options.clickFun(_element.get(0));
				});
				if(innerHtml!=null && innerHtml!=''){
					rtnAdvice.append(innerHtml);
				}
				$luiVal.append(rtnAdvice);
			}
		}else{
			rtnAdvice.html('');
			rtnAdvice.html(innerHtml);
		}
		return rtnAdvice;
	}
	return null;
}
function Reminder_Show() {
	// 按照设置的样式更新提示信息
	if (/\{Msg\}/ig.test(this._msgStyle))
		this.msg = this.msgStyle.replace(/\{Msg\}/ig, this.msg);
	// 替换{name}为字段描述名
	var _subject = this.element.attr('subject') || '';
	this.msg = this.msg.replace(/\{name\}/ig, "<span class=\"validation-advice-title\">"+_subject+"</span>");
	// 替换相应参数
	var rep = new RegExp(), pValue, pType;
	for (var param in this._params) {
		pValue = this._params[param];
		// 类型不是对象或不是未定义，则匹配参数
		pType = typeof(pValue);
		if (pType != 'object' && pType != 'function' && pType != 'undefined') {
			rep.compile('\\{' + param + '\\}', 'ig');
			this.msg = this.msg.replace(rep, pValue);
		}
	}
	var outPutHtml = this.options.layout.replace(/\{ShowMsg\}/ig, this.msg);
	//跟随提示
	var advice = this._getAdvice(outPutHtml,true);
	advice.show();
	//新ui顶端提示
	if(!(this.element.is(':visible'))){
		var luiAdvice = this._getLuiAdvice(outPutHtml,true);
		if(luiAdvice!=null) {
			luiAdvice.show();
			$("html,body").scrollTop(0);
		}
	}
};

function Reminder_Hide() {
	var advice = this._getAdvice();
	if (advice.length >0) {
		// 隐藏提示信息
		if(advice.is(':visible')){
			advice.hide();
		}
	}
	//新ui隐藏处理
	var luiAdvice = this._getLuiAdvice();
	if(luiAdvice!=null && (luiAdvice.is(':visible'))){
		luiAdvice.hide();
	}
};

function Reminder_Alert() {
	// 按照设置的样式更新提示信息
	if (/\{Msg\}/ig.test(this._msgStyle))
		this.msg = this._msgStyle.replace(/\{Msg\}/ig, this.msg);
	// 替换{name}为字段描述名
	var _subject = '';
	if (this.element) {
		_subject = this.element.getAttribute('subject') || ''; 
	}
	this.msg = this.msg.replace(/\{name\}/ig, _subject);
	// 替换相应参数
	var rep = new RegExp(), pValue, pType;
	for (var param in this._params) {
		pValue = this._params[param];
		// 类型不是对象或不是未定义，则匹配参数
		pType = typeof(pValue);
		if (pType != 'object' && pType != 'function' && pType != 'undefined') {
			rep.compile('\\{' + param + '\\}', 'ig');
			this.msg = this.msg.replace(rep, pValue);
		}
	}
	alert(this.msg);
};

/**********************************************************
功能：表单字段集类的构造函数
参数
	formObject ：可选
**********************************************************/
function Elements(formObject) {
	if(formObject!=null)
		this.form = formObject;
	// 内部函数
	this._isValidate = _Elements_IsValidate;				// 检测是否有配置校验属性
	this._checkRules = _Elements_CheckRules;				// 检测特殊的规则
	// 公共函数
	this.getElements = Elements_GetElements;				// 获得表单有配置校验的所有字段
	this.valiateElement = Elements_ValiateElement;			// 校验指定字段是否符合校验规则
	this.serializeElement = Elements_SerializeElement;		// 序列化校验对象，一般在验证Dom元素符合校验规则后加上序列信息
	this.getSerializeInfo = Elements_GetSerializeInfo;		// 获取校验序列化信息
	this.cancelElementValiate = Elements_CancelElementValiate;	// 取消设置校验
	this.addElementValiate = Elements_AddElementValiate;	// 重新设置校验
	this.resetElementValiate = Elements_ResetElementValiate;	// 重新设置校验
	this.hasAttribute = Elements_HasAttribute;
	
};

function _Elements_IsValidate(element) {
	return element.getAttribute('validate') && element.getAttribute('validate') != '';
};

function _Elements_CheckRules(element) {
	// 若是一组同名的字段，则只校验最后一个字段。比如：radio字段
	var tag = element.type.toLowerCase();
	if ((tag == 'radio' || tag == 'checkbox') && element.name) {
		var group = document.getElementsByName(element.name);
		for (var i = group.length - 1; i >= 0; i--) {
			if (group[i].type && group[i].type.toLowerCase() == tag) return group[i] == element;
		}
	}
	return true;
};

function Elements_GetElements() {
	var elements = new Array();
	if(this.form!=null){
		var _self = this; 
		$(this.form).find("[validate]:input").each(function(){
			if(_self._isValidate(this)){
				elements.push(this);
				//_self.serializeElement(this);
			}
		});
	}
    return elements;
};

function Elements_ValiateElement(element) {
	if (!element || !element.tagName) return false;
	var tag = element.tagName.toLowerCase();
	// 校验是否是字段类型，如div这些对象就不是校验对象
	if (!Element.Serializers[tag]) return false;
	//对象被删除的情况
	var name = element.name;
	if(name!=null && name!=""){
		var target = document.getElementsByName(name);
		if(target==null || target.length<1) return false;
	}
	//作者 曹映辉 #日期 2013年11月29日 明显表模板行中设置必填数据时，模板行字段不需要校验 
	if($(element).parents("tr[KMSS_IsReferRow='1']").length>0 || (name && name.indexOf("!{index}")>=0)) return false;
	
	var id = element.id;
	if(id!=null && id!=""){
		var target = document.getElementById(id);
		if(target==null) return false;
	}
	// 是否有符合校验规则
	if(this._isValidate(element)){
		//this.serializeElement(element);
		return true;
	}
	return false;
};

function Elements_SerializeElement(element){
	var serializeInfo = element.getAttribute(KMSSValidation.ValidateConfig.attribute);
	if(serializeInfo!=null && serializeInfo!="")
		return;
	var serialize = this.getSerializeInfo(element);
	if(serialize!=null && serialize!=''){
		element.setAttribute(KMSSValidation.ValidateConfig.attribute,serialize);
	}else{
		element.setAttribute(KMSSValidation.ValidateConfig.attribute,
				KMSSValidation.ValidateConfig.prefix + (KMSSValidation.ValidateConfig.index++));
	}
}
//取消指定的校验
function Elements_CancelElementValiate(element ,validateName){
	//element.removeAttribute(KMSSValidation.ValidateConfig.attribute);
	var validate = element.getAttribute('validate');
	if(validate != null && $.trim(validate) != ''){
		if(validateName == null){
			element.removeAttribute('validate');
		}else{
			var validates = validate.split(" ");
			var idx = $.inArray(validateName.toLowerCase(),validates);
			if(idx > -1){
				validates.splice(idx, 1);
				var tmpVal = validates.join(' ');
				if($.trim(tmpVal) == ''){
					element.removeAttribute('validate');
				}else{
					element.setAttribute('validate',tmpVal);
				}
			}
		}
		if(!this.hasAttribute(element,'_validate'))
			element.setAttribute('_validate',validate);
	}
}
function Elements_HasAttribute(eleObj,attrName){
	var hasAttr = false;
	if(eleObj.hasAttribute){
		hasAttr = eleObj.hasAttribute(attrName);
	}else{
		if(eleObj.getAttributeNode){
			hasAttr = eleObj.getAttributeNode(attrName)!=null;
		}else{
			hasAttr = eleObj.getAttribute(attrName)!=null;
		}
	}
	return hasAttr;
}

function Elements_AddElementValiate(element , validateName){
	var validate = element.getAttribute('validate');
	if(validate != null && $.trim(validate) != ''){
		var validates = validate.split(" ");
		if(validateName){
			var idx = $.inArray(validateName.toLowerCase(),validates);
			if(idx == -1){
				validates.push(validateName);
				element.setAttribute('validate',validates.join(' '));
			}
		}
	}else{
		 if(validateName)
			 element.setAttribute('validate',validateName);
	}
}
function Elements_ResetElementValiate(element){
	var validate = element.getAttribute('_validate');
	element.removeAttribute('_validate');
	if(validate != null && $.trim(validate) != ''){
	    element.setAttribute('validate',validate);
	}
}

function Elements_GetSerializeInfo(element){
	var tag = element.type.toLowerCase();
	var info = null;
	if ((tag == 'radio' || tag == 'checkbox') && element.name){
		var group = document.getElementsByName(element.name);
		if(group.length>1){
			for ( var i = 0; i < group.length; i++) {
				info = group[i].getAttribute(KMSSValidation.ValidateConfig.attribute);
				if(info!=null && info!='' && group[i] != element){
					break;
				}
			}
		}
	}
	return info;
}
/**********************************************************
功能：表单字段类的构造函数
参数
	object ： 字段对象
**********************************************************/
function Element(object) {
	this.element = object || null;
	// 公用函数
	this.isEnable = Element_IsEnable;                        // 字段是否有效
	this.isVisible = Element_IsVisible;                      // 字段是否可见
	this.getValue = Element_GetValue;                        // 获得字段值
};

function Element_IsEnable() {
	if (this.element == null) return false;
	return !(this.element.type == 'hidden' || this.element.disabled) ;//&& this.isVisible();
};

function Element_IsVisible() {
	// 检测是否包含在隐藏容器中
	for (var pElement = this.element; pElement && pElement.tagName.toLowerCase() != 'body'; pElement = pElement.parentNode)
		if (pElement.style.display == 'none') return false;

	return true;
};

function Element_GetValue() {
	if (this.element == null) return '';

	var method = this.element.tagName.toLowerCase();
	var parameter = Element.Serializers[method](this.element);
	return parameter ? parameter[1] : '';
};

//=============================以下函数为内部函数，普通模块请勿调用==============================
Element.Serializers = {
	input: function(element) {
		switch (element.type.toLowerCase()) {
		case 'submit':
		case 'hidden':
		case 'password':
		case 'text':
			return Element.Serializers.textarea(element);
		case 'checkbox':
		case 'radio':
			return Element.Serializers.groupSelector(element);
		}
		return false;
	},

	groupSelector: function(element) {
		// 若没有name属性，则认为只有一个checkbox或radio。
		if (!element.name) return Element.Serializers.inputSelector(element);
		// 由于一组checkbox或radio是由相同的name组成，故...
		var values = [], type = element.type.toLowerCase;
		var cbElements = document.getElementsByName(element.name);
		for (var i = cbElements.length - 1; i >= 0; i--)
			if (cbElements[i].type.toLowerCase == type && cbElements[i].checked)
				values.push(cbElements[i].value);
		return [element.name, values.join(';')];
	},

	inputSelector: function(element) {
		if (element.checked)
			return [element.name, element.value];
	},

	textarea: function(element) {
		return [element.name, element.value];
	},

	select: function(element) {
		return Element.Serializers[element.type == 'select-one' ?
		'selectOne' : 'selectMany'](element);
	},

	selectOne: function(element) {
		var value = '', opt, index = element.selectedIndex;
		if (index >= 0) {
			opt = element.options[index];
			value = (opt.value == null) ? opt.text : opt.value;
		}
		return [element.name, value];
	},

	selectMany: function(element) {
		var value = [];
		for (var i = 0; i < element.length; i++) {
			var opt = element.options[i];
			if (opt.selected)
				value.push((opt.value == null) ? opt.text : opt.value);
		}
		return [element.name, value];
	}
};
//=============================以上函数为内部函数，普通模块请勿调用==============================

/**********************************************************
描述：
	以下所有函数为校验器公用函数。
功能：
	extend            : 复制对象

	addEvent          : 追加事件
		  参数: 
			  element     : 源对象
			  eventHandle : 源对象的事件句柄，比如click
			  method      : 绑定的方法句柄
			  useCapture  : 是否捕获
		  示例:
		      function ceshi(event, p1, p2){};
			  addEvent(element, 'click', ceshi);
			  
	getBrowser		  : 获取浏览器版本

	insertHtml        : 插入HTML
		  参数: 
			  where   : 插入位置。包括beforeBegin,beforeEnd,afterBegin,afterEnd。
			  el      : 用于参照插入位置的html元素对象
			  html    : 要插入的html代码
**********************************************************/
KMSSValidation.extend = function() {
	var target = arguments[0] || {}, i = 1, length = arguments.length, deep = false, options;
	if ( target.constructor == Boolean ) {
		deep = target;
		target = arguments[1] || {};
		i = 2;
	}
	if ( typeof target != "object" && typeof target != "function" ) target = {};
	if ( length == i ) {
		target = this;
		--i;
	}

	for ( ; i < length; i++ )
		if ( (options = arguments[ i ]) != null )
			for ( var name in options ) {
				var src = target[ name ], copy = options[ name ];
				if ( target === copy ) continue;
				if ( deep && copy && typeof copy == "object" && !copy.nodeType )
					target[ name ] = KMSSValidation.extend( deep, src || ( copy.length != null ? [ ] : { } ), copy );
				else if ( copy !== undefined )
					target[ name ] = copy;
			}
	return target;
};

KMSSValidation.addEvent = function(element, eventHandle, method, useCapture) {
	if(element.attachEvent) {
		element.attachEvent("on" + eventHandle, method);
	} else if (element.addEventListener) {
		element.addEventListener(eventHandle, method, useCapture);
	}
};

KMSSValidation.ValidateConfig = {
		"attribute" : "__validate_serial",
		"prefix" : "_validate_",
		"index": 1 
};

KMSSValidation.getBrowser = function() {
	var userAgent = navigator.userAgent.toLowerCase();
	if (/msie/.test( userAgent ) && !/opera/.test( userAgent )) return 'msie';
	if (/mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent )) return 'mozilla';
	if (/webkit/.test( userAgent )) return 'safari';
	if (/opera/.test( userAgent )) return 'opera';
	return 'msie';
};

KMSSValidation.insertHtml = function(where, el, html) {
	where = where.toLowerCase();
	if(el.insertAdjacentHTML){
		switch(where){
		case "beforebegin":
			el.insertAdjacentHTML('BeforeBegin', html);
			return el.previousSibling;
		case "afterbegin":
			el.insertAdjacentHTML('AfterBegin', html);
			return el.firstChild;
		case "beforeend":
			el.insertAdjacentHTML('BeforeEnd', html);
			return el.lastChild;
		case "afterend":
			el.insertAdjacentHTML('AfterEnd', html);
			return el.nextSibling;
		}
	} else {
		var frag;
		var range = el.ownerDocument.createRange();
		switch(where){
		case "beforebegin":
			range.setStartBefore(el);
			frag = range.createContextualFragment(html);
			el.parentNode.insertBefore(frag, el);
			return el.previousSibling;
		case "afterbegin":
			if(el.firstChild){
				range.setStartBefore(el.firstChild);
				frag = range.createContextualFragment(html);
				el.insertBefore(frag, el.firstChild);
			} else {
				el.innerHTML = html;
			}
			return el.firstChild;
		case "beforeend":
			if(el.lastChild){
				range.setStartAfter(el.lastChild);
				frag = range.createContextualFragment(html);
				el.appendChild(frag);
			} else {
				el.innerHTML = html;
			}
			return el.lastChild;
		case "afterend":
			range.setStartAfter(el);
			frag = range.createContextualFragment(html);
			el.parentNode.insertBefore(frag, el.nextSibling);
			return el.nextSibling;
		}
	}
};