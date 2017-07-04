/**
 * 配置扩展
 * 
 **/

/**
 * 属性自绘方法
 */
function _Show_Input_Text_Vadildate_Type(select) {
	//_Designer_Control_Attr_InputText_DataTypeOnchange(select.form['dataType']);
	var value = select.value;
	var hiddens = select.parentNode.getElementsByTagName('div');
	for (var i = 0; i < hiddens.length; i ++) {
		var div = hiddens[i];
		if (div.getAttribute('dateType') == value) {
			div.style.display = '';
			var inputs = div.getElementsByTagName('input');
			for (var j = 0; j < inputs.length; j ++) {
				inputs[j].disabled = false;
			}
		} else {
			div.style.display = 'none';
			var inputs = div.getElementsByTagName('input');
			for (var j = 0; j < inputs.length; j ++) {
				inputs[j].disabled = true;
			}
		}
	}
}
_Designer_Control_Attr_InputText_ValidateOptions = [
	new Option(Designer_Lang.controlInputTextValFalse, 'false'),
	new Option(Designer_Lang.controlInputTextValNumber, 'number'),
	new Option(Designer_Lang.controlInputTextValString, 'string'),
	new Option(Designer_Lang.controlInputTextValEmail, 'email')
];
function _Designer_Control_Attr_InputText_DataTypeOnchange(dataTypeSelect) {
	var validate = dataTypeSelect.form['validate'];
	var dataType = dataTypeSelect.value;
	if (dataType == 'String' && validate.options.length != 3) {
		validate.style.display = '';
		for(var i = validate.options.length - 1; i >= 0; i--) {
			validate.remove(i);
		}
		validate.options.add(_Designer_Control_Attr_InputText_ValidateOptions[0]);
		validate.options.add(_Designer_Control_Attr_InputText_ValidateOptions[2]);
		validate.options.add(_Designer_Control_Attr_InputText_ValidateOptions[3]);
		_Show_Input_Text_Vadildate_Type(validate);
	}
	else if (validate.options.length != 1) {
		for(var i = validate.options.length - 1; i >= 0; i--) {
			validate.remove(i);
		}
		validate.options.add(_Designer_Control_Attr_InputText_ValidateOptions[1]);
		validate.style.display = 'none';
		_Show_Input_Text_Vadildate_Type(validate);
	}
}

// input 校验自绘函数
function _Designer_Control_Attr_InputText_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<select name='validate' class='attr_td_select' onchange='_Show_Input_Text_Vadildate_Type(this)'";
	if (values.dataType == 'Double' || values.dataType == 'BigDecimal') {
		html += " style='width:95%;display:none;' >";
		html += "<option value='number' " + (value == 'number' ? "selected='selected'" : "") + ">"+Designer_Lang.controlInputTextValNumber+"</option>";
	} else {
		html += " style='width:95%;'>";
		html += "<option value='false' " + (value == 'false' ? "selected='selected'" : "") + ">"+Designer_Lang.controlInputTextValFalse+"</option>";
		html += "<option value='string' " + (value == 'string' ? "selected='selected'" : "") + ">"+Designer_Lang.controlInputTextValString+"</option>";
		html += "<option value='email' " + (value == 'email' ? "selected='selected'" : "") + ">"+Designer_Lang.controlInputTextValEmail+"</option>";
	}
	html += "</select>";
	// 文本长度
	var isString = (value == 'string');
	html += "<div dateType='string' "
		+ (isString ? '' : "style='display:none'") +">"+Designer_Lang.controlInputTextValMaxlengthP+"<input type='text' name='maxlength' onkeyup='_Designer_Control_Attr_InputText_Tirem(this);' value='"
		+ (values['maxlength'] ? values['maxlength'] : "") + "'"
		+ (isString ? '' : ' disabled ') + " class='inputsgl' size='3'>"+Designer_Lang.controlInputTextValMaxlengthS+"</div>";
	// 数字
	var isNumber = (value == 'number');
	html += "<div dateType='number' "
		+ (isNumber ? '' : "style='display:none'") +">"+Designer_Lang.controlInputTextValDecimal+"<input type='text' name='decimal' onkeyup='_Designer_Control_Attr_InputText_Tirem(this);' value='"
		+ (values['decimal'] ? values['decimal'] : "0") + "'"
		+ (isNumber ? '' : ' disabled ') + " class='inputsgl' size='3'>，<br>"+Designer_Lang.controlInputTextValBegin+"<input type='text' name='begin' onkeyup='_Designer_Control_Attr_InputText_Tirem(this);' value='"
		+ (values['begin'] ? values['begin'] : "") +"'"
		+ (isNumber ? '' : ' disabled ') + " class='inputsgl' size='3'>"+Designer_Lang.controlInputTextValTo+"<input type='text' name='end' onkeyup='_Designer_Control_Attr_InputText_Tirem(this);' value='"
		+ (values['end'] ? values['end'] : "") +"'"
		+ (isNumber ? '' : ' disabled ') + " class='inputsgl' size='3'>"+Designer_Lang.controlInputTextValEnd+"</div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

function _Designer_Control_Attr_InputText_Tirem(dom) {
	dom.value = dom.value.replace(/(^\s*)|(\s*$)/g, '');
}

function _Designer_Control_Attr_Datetime_OnAttrLoad(form) {
	var select = form['defaultValue'];
	_Designer_Control_Attr_Datetime_ShowDefaultValue(select, true);
}

function _Designer_Control_Attr_Datetime_ShowDefaultValue(select, notClearSelectValue) {
	var inputDiv = select.nextSibling;
	if (select.value  == 'select') {
		inputDiv.style.display = '';
		if (!notClearSelectValue)
			inputDiv.childNodes[0].value = "";
		var selecSpan = inputDiv.childNodes[1];
		var type = select.form.businessType.value;
		if (type == 'timeDialog') {
			selecSpan.innerHTML = "<a href='#' onclick='selectTime(event,\"_selectValue\");return false;'>"+Designer_Lang.controlAttrSelect+"</a>";
		} else if (type == 'dateDialog') {
			selecSpan.innerHTML = "<a href='#' onclick='selectDate(event,\"_selectValue\");return false;'>"+Designer_Lang.controlAttrSelect+"</a>";
		} else {
			selecSpan.innerHTML = "<a href='#' onclick='selectDateTime(event,\"_selectValue\");return false;'>"+Designer_Lang.controlAttrSelect+"</a>";
		}
	} else {
		inputDiv.style.display = 'none';
	}
	var label = inputDiv.nextSibling;
	if (select.value == 'null' || select.value  == 'select') {
		label.style.display = 'none';
		label.firstChild.checked = false;
	} else {
		label.style.display = '';
	}
}

// 日期 默认值自绘函数
function _Designer_Control_Attr_Datetime_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<select name='defaultValue' class='attr_td_select' style='width:95%' onchange='_Designer_Control_Attr_Datetime_ShowDefaultValue(this)'>";
	html += "<option value='null' " + (value == 'null' ? "selected='selected'" : "") + ">"+Designer_Lang.controlDatetimeAttrDefaultValueNull+"</option>";
	html += "<option value='nowTime' " + (value == 'nowTime' ? "selected='selected'" : "") + ">"+Designer_Lang.controlDatetimeAttrDefaultValueNowTime+"</option>";
	html += "<option value='select' " + (value == 'select' ? "selected='selected'" : "") + ">"+Designer_Lang.controlDatetimeAttrDefaultValueSelect+"</option>";
	html += "</select>";
	html += "<div style='" + (value == 'select' ? "" : "display:none;");
	html += "'><input type='text' style='width:80%' class='attr_td_text' readonly name='_selectValue'";
	if (value == 'select') {
		html += " value='" + (values._selectValue != null ? values._selectValue : "") + "'";
	}
	if (values.businessType == 'timeDialog')
		html += "><span><a href='#' onclick='selectTime(event,\"_selectValue\");return false;'>"+Designer_Lang.controlAttrSelect+"</a></span>";
	else if (values.businessType == 'dateDialog')
		html += "><span><a href='#' onclick='selectDate(event,\"_selectValue\");return false;'>"+Designer_Lang.controlAttrSelect+"</a></span>";
	else
		html += "><span><a href='#' onclick='selectDateTime(event,\"_selectValue\");return false;'>"+Designer_Lang.controlAttrSelect+"</a></span>";
	html += "</div>";
	html += "<label><input type=checkbox value='true' name='reCalculate'";
	if (values.reCalculate == 'true') html += ' checked';
	html += ">"+Designer_Lang.controlAttrReCalculate+"</label><div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

function _Show_Address_DefaultValue(select) {
	var inputDiv = select.nextSibling;
	var value = select.value;
	var form = select.form;
	
	select.length = 0;
	var option = new Option(Designer_Lang.controlAddressAttrDefaultValueNull, 'null');
	select.options[select.length] = option;
	if (value == 'null') option.selected = true;
	if (form._org_person.checked) {
		option = new Option(Designer_Lang.controlAddressAttrDefaultValueSelf, "ORG_TYPE_PERSON");
		select.options[select.length] = option;
		if (value == 'ORG_TYPE_PERSON') option.selected = true;
	}
	if (form._org_org.checked) {
		option = new Option(Designer_Lang.controlAddressAttrDefaultValueSelfOrg, "ORG_TYPE_ORG");
		select.options[select.length] = option;
		if (value == 'ORG_TYPE_ORG') option.selected = true;
	}
	if (form._org_dept.checked) {
		option = new Option(Designer_Lang.controlAddressAttrDefaultValueSelfDept, "ORG_TYPE_DEPT");
		select.options[select.length] = option;
		if (value == 'ORG_TYPE_DEPT') option.selected = true;
	}
	if (form._org_post.checked) {
		option = new Option(Designer_Lang.controlAddressAttrDefaultValueSelfPost, "ORG_TYPE_POST");
		select.options[select.length] = option;
		if (value == 'ORG_TYPE_POST') option.selected = true;
	}
	option = new Option(Designer_Lang.controlAddressAttrDefaultValueSelect, 'select');
	select.options[select.length] = option;
	if (value == 'select') option.selected = true;

	if (value == 'select') {
		inputDiv.style.display = '';
		var html = "";
		var orgtype = [];
		if (form._org_org.checked) {
			orgtype.push("ORG_TYPE_ORG");
		}
		if (form._org_dept.checked) {
			orgtype.push("ORG_TYPE_DEPT");
		}
		if (form._org_post.checked) {
			orgtype.push("ORG_TYPE_POST");
		}
		if (form._org_person.checked) {
			orgtype.push("ORG_TYPE_PERSON");
		}
		if (form._org_group.checked) {
			orgtype.push("ORG_TYPE_GROUP");
		}
		if (orgtype.length == 0) {
			inputDiv.innerHTML = '';
			inputDiv.style.display = 'none';
			select.options[0].selected = true;
			alert(Designer_Lang.controlAddressValAlterNotNull);
			return;
		}
		html += "<input type='hidden' name='_selectValue' value=''>";
		html += "<input type='text' style='width:80%' class='attr_td_text' readonly name='_selectName' value=''>";
		html += "<span><a href='#' onclick='Dialog_Address("+ (form.multiSelect.checked ? "true" : "false")
			+", \"_selectValue\",\"_selectName\", \";\","+ orgtype.join("|")+");return false;'>"+Designer_Lang.controlAttrSelect+"</a></span>";
		inputDiv.innerHTML = html;
	} else {
		inputDiv.innerHTML = "";
		inputDiv.style.display = 'none';
	}
}
function _Designer_Control_Attr_Address_OnAttrLoad(form) {
	if (form._org_group.checked) {
		_Designer_Control_Attr_Address_SelectGroup(form);
	}
	else if (form._org_dept.checked) {
		_Designer_Control_Attr_Address_SelectDept(form);
	}
}
function _Designer_Control_Attr_Address_SelectGroup(form) {
	form._org_person.checked = form._org_group.checked;
	form._org_person.disabled = form._org_group.checked;
	
	form._org_org.checked = form._org_group.checked;
	form._org_org.disabled = form._org_group.checked;

	form._org_dept.checked = form._org_group.checked;
	form._org_dept.disabled = form._org_group.checked;
	
	form._org_post.checked = form._org_group.checked;
	form._org_post.disabled = form._org_group.checked;
}
function _Designer_Control_Attr_Address_SelectDept(form) {
	if (form._org_dept.disabled) return;
	form._org_org.checked = form._org_dept.checked;
	form._org_org.disabled = form._org_dept.checked;
}
// 地址本属性框自绘函数
function _Designer_Control_Attr_Address_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<select name='defaultValue' class='attr_td_select' style='width:95%' onchange='_Show_Address_DefaultValue(this)'>";
	html += "<option value='null' >"+Designer_Lang.controlAddressAttrDefaultValueNull+"</option>";
	if (value) {
		if (values._org_person == 'true')
			html += "<option value='ORG_TYPE_PERSON' " + (value == 'ORG_TYPE_PERSON' ? "selected='selected'" : "") + ">"+Designer_Lang.controlAddressAttrDefaultValueSelf+"</option>";
		if (values._org_org == 'true')
			html += "<option value='ORG_TYPE_ORG' " + (value == 'ORG_TYPE_ORG' ? "selected='selected'" : "") + ">"+Designer_Lang.controlAddressAttrDefaultValueSelfOrg+"</option>";
		if (values._org_dept == 'true')
			html += "<option value='ORG_TYPE_DEPT' " + (value == 'ORG_TYPE_DEPT' ? "selected='selected'" : "") + ">"+Designer_Lang.controlAddressAttrDefaultValueSelfDept+"</option>";
		if (values._org_post == 'true')
			html += "<option value='ORG_TYPE_POST' " + (value == 'ORG_TYPE_POST' ? "selected='selected'" : "") + ">"+Designer_Lang.controlAddressAttrDefaultValueSelfPost+"</option>";
	} else {
		html += "<option value='ORG_TYPE_PERSON'>"+Designer_Lang.controlAddressAttrDefaultValueSelf+"</option>";
	}
	html += "<option value='select' " + (value == 'select' ? "selected='selected'" : "") + ">"+Designer_Lang.controlAddressAttrDefaultValueSelect+"</option>";
	html += "</select>";
	html += "<div style='" + (value == 'select' ? "" : "display:none;");
	html += "'>"
	if (value == 'select') {
		var orgType = [];
		var opts = attrs.orgType.opts;
		for (var i = 0; i < opts.length; i ++) {
			var opt = opts[i];
			if (values[opt.name] == "true") {
				orgType.push(opt.value);
			}
		}
		if (orgType.length == 0) orgType.push("ORG_TYPE_ALL");
		html += "<input type='hidden' name='_selectValue'";
		html += " value='" + (values._selectValue != null ? values._selectValue : "") + "'>";
		html += "<input type='text' style='width:80%' class='attr_td_text' readonly name='_selectName'";
		html += " value='" + (values._selectName != null ? values._selectName : "") + "'>";
		html += "<span><a href='#' onclick='Dialog_Address("+ (values.multiSelect != 'true' ? "false" : "true")
			+", \"_selectValue\",\"_selectName\", \";\","+ orgType.join("|")+");return false;'>"+Designer_Lang.controlAttrSelect+"</a></span>";
	}
	html += "</div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

// ===============  属性校验器 =====================

function _Designer_Control_Attr_Checkout_AddLabel(msg, values) {
	if (values.label != null && values.label != '') msg.push(values.label, ': ');
}

function Designer_Control_Attr_Required_Validator(elem, name, attr, value, values) {
	if (value == null || value == '' || value.replace(/\r\n/g, '') == '') {
		alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValRequired,attr.text));
		elem.focus();
		return false;
	}
	return true;
}

function Designer_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if (value == null || value == '' || value.replace(/\r\n/g, '') == '') {
		_Designer_Control_Attr_Checkout_AddLabel(msg, values);
		control.options.domElement.className = 'attr_no_label';
		if (control.info.name)
			msg.push(control.info.name, ':', attr.text, Designer_Lang.controlAttrValRequired);
		else
			msg.push(attr.text, Designer_Lang.controlAttrValRequired);
		return false;
	}
	return true;
}

function Designer_Control_Attr_Label_Validator(elem, name, attr, value, values, control) {
	if (value != null && value.indexOf('.') > -1) {
		alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValLabelSpecialChar, '.'));
		return false;
	}
	var controls = [];
	_Designer_Attr_AddAll_Controls(control.owner.controls, controls);
	for (var i = 0, l = controls.length; i < l; i ++) {
		var c = controls[i];
		if (c != control && c.options.values.label) {
			if (c.options.values.label == value) {
				alert(Designer_Lang.controlAttrValLabelUnique);
				return false;
			}
		}
	}
	var designer = (new Function('return ' + elem.form.designerId))();
	var sysObj = designer._getSysObj();
	for (var i = 0, l = sysObj.length; i < l; i ++) {
		if (value == sysObj[i].label) {
			alert(Designer_Lang.controlAttrValSysLabelUnique);
			return false;
		}
	}
	return true;
}

function _Designer_Control_Attr_Label_HasCheckouted(value) {
	for (var i = this.__$__Label_CheckoutControl.length - 1; i >= 0; i--) {
		var v = this.__$__Label_CheckoutControl[i];
		if (v == value)
			return true;
	}
	return false;
}
function Designer_Control_Attr_Label_Checkout(msg, name, attr, value, values, control) {
	var controls = this.__$__All_Contorls, domElement;
	//_Designer_Attr_AddAll_Controls(control.owner.controls, controls);
	var setClassName = function(dom) {
		dom.className = (dom.className + ' attr_unique_label');
	};
	var resetClassName = function(dom) {
		dom.className = dom.className.replace(' attr_unique_label', '');
		dom.className = dom.className.replace('attr_unique_label', '');
	};
	domElement = control.options.domElement;
	if (value != null && value.indexOf('.') > -1) {
		setClassName(domElement);
		msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValLabelSpecialChar, '.'));
		return false;
	}
	for (var i = 0, l = controls.length; i < l; i ++) {
		var c = controls[i];
		if (c === control) continue;
		if (c.options.values.label) {
			if (c.options.values.label == value) {
				setClassName(domElement);
				
				if (!this.__$__Label_HasCheckouted(value)) {
					msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrChkLabelUnique,value));
					this.__$__Label_CheckoutControl.push(value);
				}
				return false;
			}
			else {
				resetClassName(domElement);
			}
		}
	}
	for (var i = 0, l = this.__$__Sys_Label_Values.length; i < l; i ++) {
		if (value == this.__$__Sys_Label_Values[i]) {
			setClassName(domElement);
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrChkSysLabelUnique,value));
			return false;
		}
		else {
			resetClassName(domElement);
		}
	}
	return true;
}

function Designer_Control_Attr_Int_Validator(elem, name, attr, value, values) {
	if (value != null && value != '' && !(/^([+]?)(\d+)$/.test(value.toString()))) {
		alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValInt,attr.text));
		return false;
	}
	return true;
}

function Designer_Control_Attr_Int_Checkout(msg, name, attr, value, values) {
	if (value != null && value != '' && !(/^([+]?)(\d+)$/.test(value.toString()))) {
		_Designer_Control_Attr_Checkout_AddLabel(msg, values);
		msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValInt,attr.text));
		return false;
	}
	return true;
}

function Designer_Control_Attr_Number_Validator(elem, name, attr, value, values) {
	if (value != null && value != '' && !(/^[-|+]?\d+[.\d]*$/.test(value.toString()))) {
		alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumber,attr.text));
		elem.focus();
		return false;
	}
	return true;
}

function Designer_Control_Attr_Number_Checkout(msg, name, attr, value, values) {
	if (value != null && value != '' && !(/^[-|+]?\d+[.\d]*$/.test(value.toString()))) {
		_Designer_Control_Attr_Checkout_AddLabel(msg, values);
		msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumber,attr.text));
		return false;
	}
	return true;
}

function Designer_InputText_NumberValue_Validator(elem, name, attr, value, values) {
	if (values.decimal != null) {
		var d = parseInt(values.decimal);
		if (d == 0 && value != null && value.indexOf('.') >= 0) {
			alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValDecimal,attr.text));
			elem.focus();
			return false;
		}
		if (d > 0 && value != null) {
			var index = value.indexOf('.');
			if (index >= 0) {
				var sub = value.substring(index + 1);
				if (sub.length > d) {
					alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValDecimalSize,attr.text,d));
					elem.focus();
					return false;
				}
			}
		}
		if (values.begin != null && values.begin != '' && values.end != null && values.end != '') {
			if (parseFloat(values.begin) >= parseFloat(values.end)) {
				alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumRange,values.begin,values.end));
				elem.focus();
				return false;
			}
		}
	}
	return true;
}

function Designer_InputText_NumberValue_Checkout(msg, name, attr, value, values) {
	var result = true;
	if (values.decimal != null) {
		var d = parseInt(values.decimal);
		if (d == 0 && value != null && value.indexOf('.') >= 0) {
			_Designer_Control_Attr_Checkout_AddLabel(msg, values);
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValDecimal,attr.text));
			result = false;
		}
		if (d > 0 && value != null) {
			var index = value.indexOf('.');
			if (index >= 0) {
				var sub = value.substring(index + 1);
				if (sub.length > d) {
					_Designer_Control_Attr_Checkout_AddLabel(msg, values);
					msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValDecimalSize,attr.text,d));
					result = false;
				}
			}
		}
		if (values.begin != null && values.begin != '' && values.end != null && values.end != '') {
			if (parseFloat(values.begin) >= parseFloat(values.end)) {
				_Designer_Control_Attr_Checkout_AddLabel(msg, values);
				msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumRange,values.begin,values.end));
				result = false;
			}
		}
	}
	return result;
}

function Designer_InputText_DefaultValue_Validator(elem, name, attr, value, values) {
	if (value == null || value == '') return true;
	if (values.formula != '' && values.formula != null) return true;
	if (values.validate == 'string') {
		if (values.maxlength != '') {
			var max = parseInt(values.maxlength);
			if (value.length > max) {
				alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValStrLen,attr.text,max));
				elem.focus();
				return false;
			}
		}
	} else if (values.validate == 'number') {
		if (values.decimal != null) {
			var d = parseInt(values.decimal);
			if (d == 0) {
				if (!(/^([+-]?)(\d+)$/.test(value.toString()))) {
					alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValInteger,attr.text));
					elem.focus();
					return false;
				}
			} else {
				if (!(/^[-]?\d+[.\d]*$/.test(value.toString()))) {
					alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumber,attr.text));
					elem.focus();
					return false;
				}
				var index = value.indexOf('.');
				if (index >= 0) {
					var sub = value.substring(index + 1);
					if (sub.length > d) {
						alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValDecimalSize,attr.text,d));
						elem.focus();
						return false;
					}
				}
			}
			if (values.begin != null && values.begin != '' && !(parseFloat(values.begin) <= parseFloat(value))) {
				alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValMoreThan,attr.text,values.begin));
				elem.focus();
				return false;
			} else if (values.end != null && values.end != '' && !(parseFloat(value) <= parseFloat(values.end))) {
				alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValLessThan,attr.text,values.end));
				elem.focus();
				return false;
			}
		}
	} else if (values.validate == 'email') {
		var result = /[a-za-z0-9_.]{0,}@[a-za-z0-9_]{1,}.[a-za-z0-9_]{1,}/.test(value);
		if (!result) {
			alert(Designer_Lang.GetMessage(Designer_Lang.controlInputTextValDefValueEmail,value));
			elem.focus();
		}
		return result;
	}
	return true;
}

function Designer_InputText_DefaultValue_Checkout(msg, name, attr, value, values) {
	if (value == null || value == '') return true;
	if (values.formula != '' && values.formula != null) return true;
	var result = true;
	if (values.validate == 'string') {
		if (values.maxlength != '') {
			var max = parseInt(values.maxlength);
			if (value.length > max) {
				_Designer_Control_Attr_Checkout_AddLabel(msg, values);
				msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValStrLen,attr.text,max));
				result = false;
			}
		}
	} else if (values.validate == 'number') {
		if (values.decimal != null) {
			var d = parseInt(values.decimal);
			if (d == 0) {
				if (!(/^([+-]?)(\d+)$/.test(value.toString()))) {
					_Designer_Control_Attr_Checkout_AddLabel(msg, values);
					msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValInteger,attr.text));
					result = false;
				}
			} else {
				if (!(/^[+-]?\d+[.\d]*$/.test(value.toString()))) {
					_Designer_Control_Attr_Checkout_AddLabel(msg, values);
					msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumber,attr.text));
					result = false;
				}
				var index = value.indexOf('.');
				if (index >= 0) {
					var sub = value.substring(index + 1);
					if (sub.length > d) {
						_Designer_Control_Attr_Checkout_AddLabel(msg, values);
						msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValDecimalSize,attr.text,d));
						result = false;
					}
				}
			}
			if (values.begin != null && values.begin != '' && !(parseFloat(values.begin) <= parseFloat(value))) {
				_Designer_Control_Attr_Checkout_AddLabel(msg, values);
				msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValMoreThan,attr.text,values.begin));
				result = false;
			} else if (values.end != null && values.end != '' && !(parseFloat(value) <= parseFloat(values.end))) {
				_Designer_Control_Attr_Checkout_AddLabel(msg, values);
				msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValLessThan,attr.text,values.end));
				result = false;
			}
		}
	} else if (values.validate == 'email') {
		var r = /[a-za-z0-9_.]{0,}@[a-za-z0-9_]{1,}.[a-za-z0-9_]{1,}/.test(value);
		if (!r) {
			_Designer_Control_Attr_Checkout_AddLabel(msg, values);
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlInputTextChkEmail,attr.text, value));
			result = false;
		}
	}
	return result;
}

// 初始值为单值时
function Designer_Items_DefaultValue_Validator(elem, name, attr, value, values) {
	if (value == '' || (values.formula != null && values.formula != '')) return true;
	var itemStr = values.items;
	var items = [];
	if(itemStr.indexOf("\r\n")>-1){
		items = itemStr.split("\r\n");
	}else{
		items = itemStr.split("\n");
	}
	for (var i = 0; i < items.length; i ++) {
		if(items[i]=="")
			continue;
		var index = items[i].lastIndexOf("|");
		var _value = (index == -1) ? items[i] : items[i].substring(index+1);
		if (value == _value) return true;
	}
	alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValItemsDefaultValue,value));
	elem.focus();
	return false;
}
function Designer_Items_DefaultValue_Checkout(msg, name, attr, value, values) {
	if (value == '' || (values.formula != null && values.formula != '')) return true;
	if (values.items == null) return true;
	var itemStr = values.items;
	var items = [];
	if(itemStr.indexOf("\r\n")>-1){
		items = itemStr.split("\r\n");
	}else{
		items = itemStr.split("\n");
	}
	for (var i = 0; i < items.length; i ++) {
		if(items[i]=="")
			continue;
		var index = items[i].lastIndexOf("|");
		var _value = (index == -1) ? items[i] : items[i].substring(index+1);
		if (value == _value) return true;
	}
	_Designer_Control_Attr_Checkout_AddLabel(msg, values);
	msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValItemsDefaultValue,value));
	return false;
}

// 初始值可以为多值时
function Designer_Items_DefaultValues_Validator(elem, name, attr, value, values) {
	if (value == '' || (values.formula != null && values.formula != '')) return true;
	var itemStr = values.items;
	var items = [];
	if(itemStr.indexOf("\r\n")>-1){
		items = itemStr.split("\r\n");
	}else{
		items = itemStr.split("\n");
	}
	var vals = value.split(";");
	for (var s = 0; s < vals.length; s ++) {
		var has = false;
		for (var i = 0; i < items.length; i ++) {
			if(items[i]=="")
				continue;
			var index = items[i].lastIndexOf("|");
			var _value = (index == -1) ? items[i] : items[i].substring(index+1);
			if (vals[s] == _value) {
				has = true;
				break;
			}
		}
		if (!has) {
			alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValItemsDefaultValue,value));
			elem.focus();
			return false;
		}
	}
	return true;
}

function Designer_Items_DefaultValues_Checkout(msg, name, attr, value, values) {
	if (value == '' || (values.formula != null && values.formula != '')) return true;
	if (values.items == null) return true;
	var itemStr = values.items;
	var items = [];
	if(itemStr.indexOf("\r\n")>-1){
		items = itemStr.split("\r\n");
	}else{
		items = itemStr.split("\n");
	}
	var vals = value.split(";");
	for (var s = 0; s < vals.length; s ++) {
		var has = false;
		for (var i = 0; i < items.length; i ++) {
			if(items[i]=="")
				continue;
			var index = items[i].lastIndexOf("|");
			var _value = (index == -1) ? items[i] : items[i].substring(index+1);
			if (vals[s] == _value) {
				has = true;
				break;
			}
		}
		if (!has) {
			_Designer_Control_Attr_Checkout_AddLabel(msg, values);
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValItemsDefaultValue,value));
			return false;
		}
	}
	return true;
}

function Designer_Items_NumberType_Validator(elem, name, attr, value, values) {
	if (values.dataType == 'Double' || values.dataType == 'BigDecimal') {
		var itemStr = value;
		var items = [];
		if(itemStr.indexOf("\r\n")>-1){
			items = itemStr.split("\r\n");
		}else{
			items = itemStr.split("\n");
		}
		for (var i=0; i<items.length; i++) {
			if(items[i]=="") continue;
			var iValue = items[i].substring(items[i].lastIndexOf("|") + 1);
			if (!(/^[+-]?\d+[.\d]*$/.test(iValue.toString()))) {
				alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumValue,attr.text));
				elem.focus();
				return false;
			}
		}
	}
	return true;
}

function Designer_Items_NumberType_Checkout(msg, name, attr, value, values) {
	if (values.dataType == 'Double' || values.dataType == 'BigDecimal') {
		var itemStr = value;
		var items = [];
		if(itemStr.indexOf("\r\n")>-1){
			items = itemStr.split("\r\n");
		}else{
			items = itemStr.split("\n");
		}
		for (var i=0; i<items.length; i++) {
			if(items[i]=="") continue;
			var iValue = items[i].substring(items[i].lastIndexOf("|") + 1);
			if (!(/^[+-]?\d+[.\d]*$/.test(iValue.toString()))) {
				_Designer_Control_Attr_Checkout_AddLabel(msg, values);
				msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNumValue,attr.text));
				return false;
			}
		}
	}
	return true;
}

function Designer_Datetime_DefaultValue_Validator(elem, name, attr, value, values) {
	if (value == 'select') {
		var datetimeInput = elem.form['_selectValue'];
		if (datetimeInput.value == null || datetimeInput.value == '') {
			alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNotNull,elem.options[elem.selectedIndex].text));
			datetimeInput.focus();
			return false;
		}
	}
	return true;
}

function Designer_Datetime_DefaultValue_Checkout(msg, name, attr, value, values) {
	if (value == 'select') {
		var datetimeValue = values['_selectValue'];
		if (datetimeValue == null || datetimeValue == '') {
			_Designer_Control_Attr_Checkout_AddLabel(msg, values);
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNotNull,attr.text));
			return false;
		}
	}
	return true;
}

function Designer_Address_DefaultValue_Validator(elem, name, attr, value, values) {
	if (value == 'select') {
		var addressInput = elem.form['_selectName'];
		if (addressInput.value == null || addressInput.value == '') {
			alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNotNull,elem.options[elem.selectedIndex].text));
			addressInput.focus();
			return false;
		}
	}
	return true;
}

function Designer_Address_DefaultValue_Checkout(msg, name, attr, value, values) {
	if (value == 'select') {
		var datetimeValue = values['_selectValue'];
		if (datetimeValue == null || datetimeValue == '') {
			_Designer_Control_Attr_Checkout_AddLabel(msg, values);
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValNotNull,attr.text));
			return false;
		}
	}
	return true;
}

function Designer_Address_OrgType_Validator(elem, name, attr, value, values) {
	var form = elem.form;
	if (!(form._org_org.checked || form._org_dept.checked || form._org_post.checked || form._org_person.checked || form._org_group.checked)) {
		alert(Designer_Lang.controlAddressValAlterNotNull);
		return false;
	}
	return true;
}

function Designer_Address_OrgType_Checkout(msg, name, attr, value, values) {
	if (!(values._org_org == 'true' || values._org_dept == 'true' || values._org_post == 'true' || values._org_person == 'true' || values._org_group == 'true')) {
		_Designer_Control_Attr_Checkout_AddLabel(msg, values);
		msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAddressChkAlterNotNull,attr.text));
		return false;
	}
	return true;
}

function Designer_Attr_Id_ValidateValid(id, control, controls) {
	if (id == null || id == '') return false;

	for (var i = 0, l = controls.length; i < l; i ++) {
		var c = controls[i];
		if (c === control) {
			continue;
		}
		if (id == c.options.values.id) {
			return false;
		}
	}
	return true;
}

function Designer_Attr_Id_ValidateCheck(control, controls) {
	var values = control.options.values;
	if (values.id == null || values.id == '') return true;
	
	for (var i = 0, l = controls.length; i < l; i ++) {
		var c = controls[i];
		if (c === control) {
			continue;
		}
		if (values.id == c.options.values.id) {
			return false;
		}
	}
	return true;
}

function Designer_Attr_ALL_Checkout() {
	if((this.isUpTab=='true' || this.isUpTab==true)&&this.builder.controls.length>1){
		//'提升多标签必须设置为根容器，该控件外或同级不能包含任何其他控件';
		alert(Designer_Lang.GetMessage(Designer_Lang.controlMutiTab_msg_error_position));
		
		return false;
	}
	
	var msg = [];
	var result = true;
	var controls = [];
	_Designer_Attr_AddAll_Controls(this.builder.controls, controls);
	
	this.__$__Label_CheckoutControl = [];
	this.__$__Label_HasCheckouted = _Designer_Control_Attr_Label_HasCheckouted;
	this.__$__Sys_Label_Values = [];
	this.__$__All_Contorls = controls;
	
	var sysObj = this._getSysObj(); // 未合并前，需要将系统字典加载进来
	for (var i = 0, l = sysObj.length; i < l; i ++) {
		this.__$__Sys_Label_Values.push(sysObj[i].label);
	}
	for (var i = 0, l = controls.length; i < l; i ++) {
		var control = controls[i];
		if (!Designer_Attr_Id_ValidateCheck(control, controls)) {
			result = false;
			msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrValChkId,control.options.values.label) + '\n');
		}
		var attrs = control.attrs;
		if (attrs == null) continue;
		for (var name in attrs) {
			var attr = attrs[name];
			if (attr.checkout) {
				if (!(attr.checkout instanceof Array)) attr.checkout = [ attr.checkout ];
				for (var ii = 0, ll = attr.checkout.length; ii < ll; ii ++) {
					if (!attr.checkout[ii].call(this, msg, name, attr, control.options.values[name], control.options.values, control)) {
						result = false;
						if (msg[msg.length -1] != '\n')
							msg.push('\n');
					}
				}
			}
		}
	}
	if (msg.length > 0) {
		alert(msg.join(''));
	}
	//存在基本属性布局面板,必选字段校验 作者 曹映辉 #日期 2014年11月26日
	if(this.fieldPanel&&_FieldsDictVarInfoByModelName&&this.builder.controls.length>0){
		//所有界面上的基本属性布局控件
		var layoutControls=[];
		for (var j = 0;j< controls.length; j ++) {
			var control = controls[j];
			if("fieldlaylout"==control.type){
				layoutControls.push(control);				
			}
		}
		var noChooseFields=[];
		for(var i=0;i<_FieldsDictVarInfoByModelName.length;i++){
			var dict=_FieldsDictVarInfoByModelName[i];
			//必填的字段才需要判断
			if("true"==dict.required){
				var hasIn=false;
				for (var j = 0;j< layoutControls.length; j ++) {
					var control = layoutControls[j];
					if(dict.name==control.options.values.fieldIds){
						hasIn=true;
						break;
					}
				}
				if(!hasIn){
					noChooseFields.push(dict.label);
				}
			}
			
		}
		if(noChooseFields.length>0){
			alert("基本属性布局字段("+noChooseFields.join(",")+")必须被选择");
			return false;
		}
		
	}
	return result;
}

function _Designer_Attr_AddAll_Controls(controls, array) {
	for (var i = 0, l = controls.length; i < l; i ++) {
		array.push(controls[i]);
		_Designer_Attr_AddAll_Controls(controls[i].children, array);
	}
}

function Designer_Control_Attr_Width_Validator(elem, name, attr, value, values) {
	if (value != null && value != '' && !(/^([+]?)(\d+)([%]?)$/.test(value.toString()))) {
		alert(Designer_Lang.controlAttrValWidth);
		return false;
	}
	return true;
}

function Designer_Control_Attr_Width_Checkout(msg, name, attr, value, values) {
	if (value != null && value != '' && !(/^([+]?)(\d+)([%]?)$/.test(value.toString()))) {
		msg.push(Designer_Lang.GetMessage(Designer_Lang.controlAttrChkWidth,attr.text));
		return false;
	}
	return true;
}

// =========== 数据转换器 ============
function Designer_Control_Attr_HtmlEscapeConvertor(name, attr, value, values) {
	return Designer.HtmlEscape(value);
}
function Designer_Control_Attr_HtmlQuotEscapeConvertor(name, attr, value, values) {
	return Designer.HtmlEscape(value).replace(/'/g, '&#39;');
}
function Designer_Control_Attr_ItemsTrimConvertor(name, attr, value, values) {
	value = Com_Trim(value);
	value = Designer_Control_Attr_HtmlQuotEscapeConvertor(name, attr, value, values);
	var itemStr = value;
	var items = [];
	if(itemStr.indexOf("\r\n")>-1){
		items = itemStr.split("\r\n");
	}else{
		items = itemStr.split("\n");
	}
	var newValue = [];
	for (var i = 0; i < items.length; i ++) {
		newValue.push(Com_Trim(items[i]));
	}
	return newValue.join('\r\n');
}