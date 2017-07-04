/**
 * @author 邱建华
 * @version 1.0 2012-8-27
 * 添加自定义验证
 * 可以在在公司内部没有此种验证的情况下进行自定义验证，
 * 或者无法参与公司内部的验证方法，比如没有使用xform标签
 */

/*************************************************
 * 添加事件
 *************************************************/
var VAR_EventUtil = new Object;
//VAR_EventUtil.addEvent = function(oTarget, sEventType, funName) {
//	if (!!window.ActiveXObject || "ActiveXObject" in window) {// for ie;
//		oTarget.attachEvent("on" + sEventType, funName);
//	} else {
//		oTarget.addEventListener(sEventType, funName, false);
//	} 
//};
VAR_EventUtil.addEvent = function(oTarget, sEventType, funName) {
	if (oTarget.addEventListener) {// for DOM;
		oTarget.addEventListener(sEventType, funName, false);
	} else if (oTarget.attachEvent) {
		oTarget.attachEvent("on" + sEventType, funName);
	} else {
		oTarget["on" + sEventType] = funName;
	}
};

/************************************************************************************
 * 添加自定义验证使用此方法(注：非公司表单标签下也可以使用此验证)
 * (可以一次性验证多个不同的字段，不同的验证方式，并且支持放入正则表达式)
 * 使用方法：在页面上的onload事件上调用即可，如下(可以验证一个，或多个不同方式的)
 * FUN_AddValidates("docSubject:required&plusInt", "fdMark:picExt", 
 * 			"fdType:/^[0-9]*[1-9][0-9]*$/!只能是正整数");
 * 注：使用自定义正则表达式时，必须要加入!号分割并传入错误信息（如上面例子第3个参数）
 * 参数里面:号之前，是所要验证的字段名（id或name均可）
 * 参数里面:号之后，是消息分别代表的意思，如下描述：
 * 
 * required			-------> 验证不能为空
 * plusInt			-------> 验证只能为正整数
 * plusFloatZero	-------> 非负浮点数(正数和0)
 * picExt			-------> 验证图片扩展名，只能为(jpg|bmp|gif|png)
 * email			-------> 有效电子邮件地址
 * 
 * (验证类型待更新)
 ************************************************************************************/
function FUN_AddValidates() {
	for (var i = 0, len = arguments.length; i < len; i++) {
		var _params = arguments[i].split(":");
		var elementName = _params[0].trim();
		FUN_AppendValidSign(elementName);
		var mainNode = _$(elementName);
		// with，与闭包等同，这里不能用闭包，否则加载页面就会被执行
		with({_params:_params}){
			VAR_EventUtil.addEvent(mainNode,"blur",function _validChange(){
				FUN_SetChange(_params);
			});
		}
	}
	with({validParams:arguments}) {
		document.getElementsByTagName("form")[0].onsubmit = function () {
			var flag = true;
			var checkFlag = true;
			for (var j = 0; j < validParams.length; j++) {
				var params = validParams[j].split(":");
				checkFlag = FUN_SetChange(params);
				if (!checkFlag) 
					flag = false;
			}
			return flag;
		};
	}
	
}

/************************************************
 * 失去焦点及改变事件
 * @param params		验证属性及验证类型的拼串
 * @returns {Boolean}	返回验证是否通过
 ************************************************/
function FUN_SetChange(params) {
	var elementName = params[0].trim();
	var sign = params[1].trim();
	var flag = true;
	// 判断一个字段下是否有多个验证类型
	if (sign.indexOf("&") == -1) {
		flag = _checkedBySign(elementName,sign);
	} else {
		var signArr = sign.split("&");
		for (var i = 0; i < signArr.length; i++) {
			flag = _checkedBySign(elementName,signArr[i].trim());
			if (!flag) 
				break;
		}
	}
	return flag;
	
	/*******************************************************************
	 * 验证消息，在这里case对应页面所填写的验证类型，
	 * 如果需要添加一些验证，在这里多添加一个类似case即可。
	 * @param elementName	验证字段的name
	 * @param sign			验证类型(支持正则，但必须!号后加入错误信息)
	 * @returns {Boolean}	返回验证是否通过
	 *******************************************************************/
	function _checkedBySign(elementName,sign) {
		var flagInner = true;
		switch(sign) {
			case "required":
				var reg = /.+/gi;
				flagInner = _operateMsg(elementName, reg, Cus_Valid_Properties.required);
				break;
				
			case "plusInt":
				var reg = /^[0-9]*[1-9][0-9]*$/;
				flagInner = _operateMsg(elementName, reg, Cus_Valid_Properties.plusInt);
				break;
				
			case "plusFloatZero":
				var reg = /^[0-9]+(.[0-9]{1,})?$/;
				flagInner = _operateMsg(elementName, reg, Cus_Valid_Properties.plusFloatZero);
				break;
				
			case "picExt":
				var reg = /(.*)+\.(jpg|bmp|gif|png)$/i;
				var errorMsg = Cus_Valid_Properties.picExt +"(jpg|bmp|gif|png)";
				flagInner = _operateMsg(elementName, reg, errorMsg);
				break;
				
			case "email":
				var reg = /\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/;
				var errorMsg = Cus_Valid_Properties.email +"admin@landray.com.cn";
				flagInner = _operateMsg(elementName, reg, errorMsg);
				break;
				
			default:
				// 此处支持自定义正则表达式,如何使用请看FUN_AddValidates方法的描述
				var regError = sign.split("!");
				eval("var reg ="+regError[0]);
				flagInner = _operateMsg(elementName, reg, regError[1]);
				break;
		}
		return flagInner;
		
		/****************************************
		 * 为验证添加和移除错误消息操作
		 * @param elementName	id或name
		 * @param reg			正则表达式
		 * @param errorMsg		错误信息
		 ****************************************/
		function _operateMsg(elementName, reg, errorMsg) {
			if (!reg.test(_$(elementName).value)) {
				FUN_AppendValidMsg(elementName +"!"+ errorMsg);
				return false;
			} else {
				FUN_RemoveValidMsg(elementName);
				return true;
			}
		}
	}
}

/******************************************
 * 添加验证标识*的方法
 * (参数为你所要验证的字段名,可以放入多个)
 ******************************************/ 
function FUN_AppendValidSign() {
	for (var i = 0, len = arguments.length; i < len; i++) {
		var mainNode = _$(arguments[i]);
		var spanNode = document.createElement("span");
		spanNode.className = "txtstrong";
		spanNode.innerHTML = "*";
		var currentNode = _getNodeTD(mainNode.parentNode);
		currentNode.appendChild(spanNode);
	}
}

/***********************************************************************
 * 追加错误信息的方法，参数有两种格式
 * 1.直接传入不限个数的id
 * 2.id!msg，(id后面跟错误信息)
 * 调用方式如下：(可同时追加多个参数,也可以一个，下面样例给了两个参数)
 * FUN_AppendValidMsg("fdName!格式不对","fdMark!不能有敏感字符");
 ************************************************************************/
function FUN_AppendValidMsg() {
	for ( var i = 0, len = arguments.length; i < len; i++) {
		var elementName = arguments[i];
		// 追加最大的span节点
		var spanNode = document.createElement("span");
		spanNode.className = "txtstrong";
		// 添加div节点，再在div节点下嵌入table
		var divNode = document.createElement("div");
		divNode.className = "validation-advice";
		// 表格(一行两列)
		var table = document.createElement("table");
		 table.className="validation-table";
		var tr = table.insertRow(-1);
		var tdSign = tr.insertCell(-1);
		tdSign.className = "validation-advice-img";
		tdSign.innerHTML = "<DIV class='lui_icon_s lui_icon_s_icon_validator'></DIV>&nbsp;&nbsp;";//Cus_Valid_Properties.sign +"&nbsp;&nbsp;";
		var tdMsg = tr.insertCell(-1);
		tdMsg.className = "validation-advice-msg";
		// 如果没有找到!直接是id或name，否则是 (id!msg)或(name!msg)
		var mainNode = null;
		if (elementName.indexOf("!") != -1) {
			var params = elementName.split("!");
			elementName = params[0];
			spanNode.id = elementName.concat("MsgId");
			mainNode = _$(elementName);
			tdMsg.innerHTML = "<font color='red'>"+ _getInfoName(mainNode) +"</font>&nbsp;"+ params[1];
		}
		FUN_RemoveValidMsg(elementName);
		// 一层层加入节点
		divNode.appendChild(table);
		spanNode.appendChild(divNode);
		var currentNode = _getNodeTD(mainNode.parentNode);
		currentNode.appendChild(spanNode);
	}
	// 获取字段名称
	function _getInfoName(mainNode) {
		var currentNode = _getNodeTD(mainNode.parentNode);
		var preNode = get_previousSibling(currentNode);
		var infoName;

		if(navigator.userAgent.indexOf("MSIE")>0){
			infoName= preNode.innerText;
		}else{
			infoName = preNode.textContent;
		}
		
		
		return infoName;
	}
}

/*******************************************
 * 删除错误信息节点
 * (参数为你所要验证的字段名,可以放入多个)
 ******************************************/
function FUN_RemoveValidMsg() {
	for (var i = 0, len = arguments.length; i < len; i++) {
		var spanNode = document.getElementById(arguments[i]+"MsgId");
		if (spanNode != undefined)
			spanNode.parentNode.removeChild(spanNode);
	}
}

/******************
 * 寻找为TD的父节点
 ******************/
function _getNodeTD(currentNode) {
	while (currentNode.tagName.toUpperCase() != "TD") {
		currentNode = currentNode.parentNode;
	}
	return currentNode;
}

/**
 * 简写获取对象(通过name和id均可)
 * @param element
 * @returns
 */
function _$(element){
	var nameObj = document.getElementsByName(element)[0];
	var idObj = document.getElementById(element);
	return idObj == undefined ? nameObj : idObj;
}

/****************
 * 去除前后空格
 * @returns
 ****************/
String.prototype.trim = function(){
	return this.replace(/^\s+|\s+$/g, ''); 
};

/********************
 * 添加正在加载图片
 ********************/
function FUN_AppendLoadImg(elementName) {
	var loadImgNode = document.createElement("img");
	loadImgNode.id = elementName.concat("ImgIdMsgId");
	loadImgNode.src = Com_Parameter.ResPath+"style/common/images/loading.gif";
	var currentNode = _getNodeTD(_$(elementName).parentNode);
	currentNode.appendChild(loadImgNode);
}

/**
 * 移除正在加载图片
 * @param elementName
 */
function FUN_RemoveLoadImg(elementName) {
	FUN_RemoveValidMsg(elementName.concat("ImgId"));
}


 /**
  * 获取当前节点的前一个节点
  */
 
  function get_previousSibling(node){  
	      var x = node.previousSibling;  
	      if(!x) return null;  
	      while (x && x.nodeType != 1){  
	          x = x.previousSibling;  
	      }  
	      return x;  
	 } 