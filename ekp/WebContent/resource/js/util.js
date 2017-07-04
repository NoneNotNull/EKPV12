/**********************************************************
功能：
使用：
	
作者：吴兵
创建时间：2009-11-04
**********************************************************/
/**
 *快速取得页面元素对象，功能相当于document.getElementById()方法
*/
function $$() {
	var results = [], element;
	for (var i = 0; i < arguments.length; i++) {
		element = arguments[i];
		if (typeof element == 'string') element = document.getElementById(element);
		results.push(element);
	}
	return results.length < 2 ? results[0] : results;
}

/**
 *根据对象返回对象数组，且将null转为[]
 */
function getElementArray(el){
	if(el && el.length){
		return el;
	}
	return []||[el];
}

/**
 *获取浏览器版本
 */
Util_GetBrowser = function() {
	var userAgent = navigator.userAgent.toLowerCase();
	if (/msie/.test( userAgent ) && !/opera/.test( userAgent )) return 'msie';
	if (/mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent )) return 'mozilla';
	if (/webkit/.test( userAgent )) return 'safari';
	if (/opera/.test( userAgent )) return 'opera';
};

/**
 *获取浏览器版本变量
 */
Util_UserAgent = Util_GetBrowser();

/**
 *增加事件，与浏览器相关
 */
Util_AddEvent = function(element, eventHandle, method) {
	if(Util_UserAgent == 'msie')
		element.attachEvent("on" + eventHandle, method);
	else
		element.addEventListener(eventHandle, method, false);
};

/**
 * 获取页面元素对象值
 */
function Element_GetValue(element) {
	if (element == null) return '';

	var method = element.tagName.toLowerCase();
	var parameter = Element_Serializers[method](element);
	return parameter ? parameter[1] : '';
};

/**
 *设置页面元素值
 */
function Element_SetValue(element,value) {
	if (element == null) return '';
	value = ""||value;
	var method = element.tagName.toLowerCase();
	Element_UnSerializers[method](element,value);
};

Element_UnSerializers = {
	input: function(element,value) {
		switch (element.type.toLowerCase()) {
		case 'submit':
		case 'hidden':
		case 'password':
		case 'text':
			return Element_UnSerializers.textarea(element,value);
		case 'checkbox':
		case 'radio':
			return Element_UnSerializers.groupSelector(element,value);
		}
		return false;
	},

	groupSelector: function(element,value) {
		// 若没有name属性，则认为只有一个checkbox或radio。
		if (!element.name) return Element_UnSerializers.inputSelector(element,value);
		// 由于一组checkbox或radio是由相同的name组成，故...
		var values = value.split(";"), type = element.type.toLowerCase;
		var cbElements = document.getElementsByTagName(element.tagName);
		for (var i = cbElements.length - 1; i >= 0; i--){
			if (cbElements[i].type.toLowerCase == type
				&& cbElements[i].name == element.name){
				for(var j=0;j<values.length;j++){
					if(cbElements[i].value==values[j]){
						cbElements[i].checked = true;
						break;
					}
				}
			}
		}
	},

	inputSelector: function(element,value) {
		element.checked =(element.value==value);
	},

	textarea: function(element,value) {
		return element.value = value;
	},

	select: function(element,value) {
		return Element_UnSerializers[element.type == 'select-one' ?
		'selectOne' : 'selectMany'](element,value);
	},

	selectOne: function(element,value) {
		for(var i = 0;i<element.length;i++){
			if(element.options[i].value==value){
				element.options[i].selected = true;
				break;
			}
		}
	},

	selectMany: function(element,value) {
		var values = value.split(";");
		for (var i = 0; i < element.length; i++) {
			for(var j=0;j<values.length;j++){
				if(element.options[i].value==values[j]){
					element.options[i].selected = true;
					break;
				}
			}
		}
	}
};

Element_Serializers = {
	input: function(element) {
		switch (element.type.toLowerCase()) {
		case 'submit':
		case 'hidden':
		case 'password':
		case 'text':
			return Element_Serializers.textarea(element);
		case 'checkbox':
		case 'radio':
			return Element_Serializers.groupSelector(element);
		}
		return false;
	},

	groupSelector: function(element) {
		// 若没有name属性，则认为只有一个checkbox或radio。
		if (!element.name) return Element_Serializers.inputSelector(element);
		// 由于一组checkbox或radio是由相同的name组成，故...
		var values = [], type = element.type.toLowerCase;
		var cbElements = document.getElementsByTagName(element.tagName);
		for (var i = cbElements.length - 1; i >= 0; i--)
			if (cbElements[i].type.toLowerCase == type
				&& cbElements[i].name == element.name
				&& cbElements[i].checked)
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
		return Element_Serializers[element.type == 'select-one' ?
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

/**
 * json对象转字符串形式
 */
function json2str(o) {
	var arr = [];
    var fmt = function(s) {
		if (typeof s == 'object' && s != null) return json2str(s);
			return /^(string|number)$$/.test(typeof s) ? "'" + s + "'" : s;
    }
	if(o.length){
		for (var i in o) arr.push(fmt(o[i]));
		return '[' + arr.join(',') + ']';
	}else{
		for (var i in o) arr.push("'" + i + "':" + fmt(o[i]));
		return '{' + arr.join(',') + '}';
	}
}

/**
 *字符串形式转json对象
 */
function str2json(str) {
	return eval("("+str+")");
}

function generateID(){
	return parseInt(((new Date().getTime()+Math.random())*10000)).toString(16);
};

function Element_AbsPosition(node, stopNode) {
	var x = y = 0;
	for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
	}
	x = x + document.body.scrollLeft;
	y = y + document.body.scrollTop;
	return {'x':x, 'y':y};
};

function Element_FixPosition(element,ps) {
	var x=ps.x,y=ps.y;
	// 修正 x 轴超出问题
	var p_size = 20;
	var right_x_pos = x + element.offsetWidth;
	if (right_x_pos > document.body.offsetWidth - p_size) {
		x = document.body.offsetWidth - element.offsetWidth - p_size;
	}
	
	// 定位
	element.style.left = x ? x : 0 + 'px';
	element.style.top = y ? y : 0 + 'px';
	element.focus();
};


