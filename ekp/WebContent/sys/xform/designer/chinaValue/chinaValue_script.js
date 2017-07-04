/***********************************************
JS文件说明：
	此文件为大小写转换控件，生成中文数字

***********************************************/
//转换大写操作
function XForm_ChinaValueDoExecutor(value, dom){
	if (dom instanceof Array) {
		dom = dom[0];
	}
	var executor = XForm_ChinaValueGetControl(dom);
	if(executor!=null){
		executor.value = XForm_GetChinaValue(value);
	}
}

//获取大写控件
function XForm_ChinaValueGetControl(dom){
	var forms = document.forms;
	var executor=null;
	var varName = XForm_ChinaValueParseVar(dom);
	if (varName == null) {
		return executor;
	}
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			executor = elems[j];
			if (executor.name != null && executor.getAttribute && executor.getAttribute("relatedid")!=null && executor.getAttribute("relatedid").indexOf(varName) > -1) {
				if ( executor.getAttribute("isrow") == 'true' ) {
					if (XForm_ChinaValueGetTableRr(executor) === XForm_ChinaValueGetTableRr(dom)) {
						return executor;
					}
					continue;
				}
				return executor;
			}
		}
	}
	return executor;
}

//返回关联控件的ID
function XForm_ChinaValueParseVar(dom) {
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

//返回控件所在行
function XForm_ChinaValueGetTableRr(dom) {
	for (var parent = dom.parentNode; parent != null; parent = parent.parentNode) {
		if (parent.tagName == 'TR' && "true" != parent.getAttribute('data-celltr')) {
			return parent;
		}
	}
	return null;
}

//将数字转成中文大写
function XForm_GetChinaValue(value){
	var chineseValue = ""; //转换后的汉字金额   
	//数字才做转化
	if(!isNaN(value)){
		//如果大于9999999999999,提示超出可计算范围
		if(value>9999999999999 || value <-9999999999999){
			chineseValue="超出大写可计算范围";
			return chineseValue;
		}
		//如果是负数,前面加"负"字
		if(value<0){
			chineseValue="负";
			value=Math.abs(value);
		}
		var numberValue = new String(Math.round(value * 100)); //数字金额   
		var String1 ='零壹贰叁肆伍陆柒捌玖'; //汉字数字   
		var String2 =' 万仟佰拾亿仟佰拾万仟佰拾元角分'; //对应单位   
		var len = numberValue.length; //   numberValue的字符串长度   
		var Ch1; //数字的汉语读法   
		var Ch2; //数字位的汉字读法   
		var nZero = 0; //用来计算连续的零值的个数   
		var String3; //指定位置的数值   
		if (numberValue == "0") {
			chineseValue = '零元整';
			return chineseValue;
		}
		String2 = String2.substr(String2.length - len, len); //   取出对应位数的STRING2的值   
		for ( var i = 0; i < len; i++) {
			String3 = parseInt(numberValue.substr(i, 1), 10); //   取出需转换的某一位的值   
			if (i != (len - 3) && i != (len - 7) && i != (len - 11)
					&& i != (len - 15)) {
				if (String3 == 0) {
					Ch1 = "";
					Ch2 = "";
					nZero = nZero + 1;
				} else if (String3 != 0 && nZero != 0) {
					Ch1 = '零'
							+ String1.substr(String3, 1);
					Ch2 = String2.substr(i, 1);
					nZero = 0;
				} else {
					Ch1 = String1.substr(String3, 1);
					Ch2 = String2.substr(i, 1);
					nZero = 0;
				}
				//该位是万亿，亿，万，元位等关键位   
			} else { 
				if (String3 != 0 && nZero != 0) {
					Ch1 = '零'
							+ String1.substr(String3, 1);
					Ch2 = String2.substr(i, 1);
					nZero = 0;
				} else if (String3 != 0 && nZero == 0) {
					Ch1 = String1.substr(String3, 1);
					Ch2 = String2.substr(i, 1);
					nZero = 0;
				} else if (String3 == 0 && nZero >= 3) {
					Ch1 = "";
					Ch2 = "";
					nZero = nZero + 1;
				} else {
					Ch1 = "";
					Ch2 = String2.substr(i, 1);
					nZero = nZero + 1;
				}
				//如果该位是亿位或元位，则必须写上   
				if (i == (len - 11) || i == (len - 3)) {
					Ch2 = String2.substr(i, 1);
				}
			}
			chineseValue = chineseValue + Ch1 + Ch2;
		}
		var String4 =0;
		if(len>2){
			String4=parseInt(numberValue.substr(len - 2, 1), 10);
		}
		//最后一位（分）为0时，加上“整”  
		if (String3 == 0 && String4 == 0) {  
			chineseValue = chineseValue+ '整';
		}
	}
	return chineseValue;
}

//附加Change的监听事件
function XForm_ChinaValueOnLoad() {
	XFormOnValueChangeFuns.push(XForm_ChinaValueDoExecutor);
}
Com_AddEventListener(window, 'load', XForm_ChinaValueOnLoad);