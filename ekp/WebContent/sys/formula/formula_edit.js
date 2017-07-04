var validateResult = null;
var dialogRtnValue = null;
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener.Com_Parameter.Dialog;
}

//根据变量名取ID
function getVarIdByName(varName, isFunc){
	if(isFunc){
		var funcInfo = dialogObject.formulaParameter.funcInfo;
		for(var i=0; i<funcInfo.length; i++){
			if(funcInfo[i].text==varName)
				return varName;
		}
	}else{
		var varInfo = dialogObject.formulaParameter.varInfo;
		for(var i=0; i<varInfo.length; i++){
			if(varInfo[i].label==varName)
				return varInfo[i].name;
		}
	}
}

//根据ID取变量名
function getVarNameById(varName, isFunc){
	if(isFunc){
		var funcInfo = dialogObject.formulaParameter.funcInfo;
		for(var i=0; i<funcInfo.length; i++){
			if(funcInfo[i].text==varName)
				return varName;
		}
	}else{
		var varInfo = dialogObject.formulaParameter.varInfo;
		for(var i=0; i<varInfo.length; i++){
			if(varInfo[i].name==varName)
				return varInfo[i].label;
		}
	}
}

//替换中文字符
function replaceSymbol(str){
	/*str = str.replace(/，/g, ",");
	str = str.replace(/。/g, ".");
	str = str.replace(/：/g, ":");
	str = str.replace(/；/g, ";");
	str = str.replace(/＋/g, "+");
	str = str.replace(/－/g, "-");
	str = str.replace(/×/g, "*");
	str = str.replace(/÷/g, "/");
	str = str.replace(/（/g, "(");
	str = str.replace(/）/g, ")");
	str = str.replace(/《/g, "<");
	str = str.replace(/》/g, ">");*/
	return str;
}

//获取下个变量位置的信息
function getNextInfo(script, preInfo){
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

//校验公式
function validateFormula(action){
	if(validateResult!=null){
		alert(message_wait);
		return;
	}
	if (Com_Trim(document.getElementById('expression').value) == '') {
		dialogObject.rtnData = [{name:'', id:''}];
		close();
		return true;
	}
	//转换表达式
	var scriptIn = replaceSymbol(document.getElementById('expression').value);
	var preInfo = {rightIndex:-1};
	var scriptOut = "";
	for (var nxtInfo = getNextInfo(scriptIn, preInfo); nxtInfo!=null; nxtInfo = getNextInfo(scriptIn, nxtInfo)) {
		var varId = getVarIdByName(nxtInfo.varName, nxtInfo.isFunc);
		if(varId==null){
			alert((nxtInfo.isFunc ? message_unknowfunc : message_unknowvar) + nxtInfo.varName);
			return;
		}
		scriptOut += scriptIn.substring(preInfo.rightIndex+1, nxtInfo.leftIndex) + "$" + varId + "$";
		preInfo = nxtInfo;
	}
	scriptOut += scriptIn.substring(preInfo.rightIndex+1);
	//校验两个变量并列的错误
	if(scriptOut.indexOf("$$")>-1){
		alert(message_eval_error);
		return;
	}
	//提交到后台进行校验
	var info = {};
	info["script"] = scriptOut;
	info["funcs"] = dialogObject.formulaParameter.funcs;
	info["model"] = dialogObject.formulaParameter.model;
	info["returnType"] = dialogObject.formulaParameter.returnType;
	var varInfo = dialogObject.formulaParameter.varInfo;
	for(var i=0; i<varInfo.length; i++){
		info[varInfo[i].name+".type"] = varInfo[i].type;
	}
	var data = new KMSSData();
	data.AddHashMap(info);
	data.SendToBean("sysFormulaValidate", action);
	validateResult = {name:scriptIn, id:scriptOut};
}

//校验后提示信息
function validateMessage(rtnVal){
	validateResult = null;
	alert(rtnVal.GetHashMapArray()[0].message);
}

//校验后回写公式
function writeBack(rtnVal) {
	var success = rtnVal.GetHashMapArray()[0].success;
	if(success=="1"){
		dialogObject.rtnData = [validateResult];
		close();
	}else if (success=="0"){
		if(confirm(rtnVal.GetHashMapArray()[0].confirm)){
			dialogObject.rtnData = [validateResult];
			close();
		}else{
			validateResult = null;
		}
	}else{
		validateResult = null;
		alert(rtnVal.GetHashMapArray()[0].message);
	}
}

//往公式中添加字符
function opFormula(param, space){
	var area = document.getElementById("expression");
	area.focus();
	if (space == null)
		space = '';
	insertText(area, {value:space + param + space});
}

function insertText(obj, node) {
	obj.focus();
	if (document.selection) {
		var sel = document.selection.createRange();
		sel.text = node.value;
	} else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
		var startPos = obj.selectionStart, endPos = obj.selectionEnd, cursorPos = startPos, tmpStr = obj.value;   
		obj.value = tmpStr.substring(0, startPos) + node.value + tmpStr.substring(endPos, tmpStr.length);
		cursorPos += node.value.length;
		obj.selectionStart = obj.selectionEnd = cursorPos;
	} else {
		obj.value += node.value;
	}
	if(node.summary){
		document.getElementById("expSummary").innerHTML = node.summary;
	}
}

//公式输入框控制代码
var focusIndex = 0;
function getCaret() {
	var txb = document.getElementById("expression");
	if (document.selection) {
		var pos = 0;
		var s = txb.scrollTop;
		var r = document.selection.createRange();
		var t = txb.createTextRange();
		t.collapse(true);
		t.select();
		var j = document.selection.createRange();
		r.setEndPoint("StartToStart",j);
		var str = r.text;
		var re = new RegExp("[\\r\\n]","g");
		str = str.replace(re,"");
		pos = str.length;
		r.collapse(false);
		r.select();
		txb.scrollTop = s;
		focusIndex = pos;
	} else if (typeof txb.selectionStart === 'number' && typeof txb.selectionEnd === 'number') {
		focusIndex = txb.selectionEnd;
	} else {
		focusIndex = txb.value.length;
	}
}

function setCaret() {
	var txb = document.getElementById("expression");
	if (document.selection) {
		var r = txb.createTextRange();
		r.collapse(true);
		r.moveStart('character', focusIndex);
		r.select();
	} else if (typeof txb.selectionStart === 'number' && typeof txb.selectionEnd === 'number') {
		txb.selectionStart = txb.selectionEnd = focusIndex;
	} else {
		
	}
}

function clearExp() {
	document.getElementById('expression').value = '';
}

//初始化代码
window.onload = function(){
	var field = document.getElementById("expression");
	if(typeof window.ActiveXObject!="undefined") {
		field.onbeforedeactivate = getCaret;
	} else {
		field.onblur = getCaret;
	}
	
	var scriptInfo = dialogObject.valueData.GetHashMapArray()[0];
	var scriptIn = scriptInfo ? scriptInfo.id : "";
	var scriptDis = scriptInfo ? scriptInfo.name : "";
	var preInfo = {rightIndex:-1};
	var scriptOut = "";
	var errorFunc = "";
	var errorVar = "";
	var nxtInfoDis = getNextInfo(scriptDis);
	for (var nxtInfo = getNextInfo(scriptIn, preInfo); nxtInfo!=null; nxtInfo = getNextInfo(scriptIn, nxtInfo)) {
		var varName = getVarNameById(nxtInfo.varName, nxtInfo.isFunc);
		if(varName==null){
			varName = nxtInfoDis.varName;
			if(nxtInfo.isFunc){
				errorFunc += "; " + varName;
			}else{
				errorVar += "; " + varName;
			}
		}
		scriptOut += scriptIn.substring(preInfo.rightIndex+1, nxtInfo.leftIndex) + "$" + varName + "$";
		preInfo = nxtInfo;
		nxtInfoDis = getNextInfo(scriptDis, nxtInfoDis);
	}
	scriptOut += scriptIn.substring(preInfo.rightIndex+1);
	field.value = scriptOut;
	var message = "";
	if(errorVar!=""){
		message = message_unknowvar + errorVar.substring(2);
	}
	if(errorFunc!=""){
		if(message!="")
			message += "\r\n";
		message += 	message_unknowfunc + errorFunc.substring(2);
	}
	if(message!="")
		alert(message);
};

//添加关闭事件
Com_AddEventListener(window, "beforeunload", function(){dialogObject.AfterShow();});