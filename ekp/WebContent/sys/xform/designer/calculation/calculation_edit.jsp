<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<style type="text/css">
body{margin:0px}
.bigButton {
	font-size: 18px;
	font-weight: bold;
	text-transform: capitalize;
	width: 60px;
	font-family: "Courier New", Courier, mono;
	cursor: pointer;
}
.smallButton {
	font-size: 14px;
	font-weight: normal;
	width: 50px;
	cursor: pointer;
}
.tdNumber{
	bgcolor:#FFE6E6;
}
.tdOpr{
	bgcolor:#CCFFCC;
}
.tdBl{
	bgcolor:#FFFFCC;
}
</style>
<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");

var message_unknowfunc = "<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlCalculation_validate_unknowfunc"/>";
var message_unknowvar = "<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlCalculation_validate_unknowvar"/>";
var message_wait = "<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlCalculation_validate_wait"/>";
var message_eval_error = "<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlCalculation_validate_failure_evalError"/>";

//---------
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener.Com_Parameter.Dialog;
}

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

//根据变量名取ID
function getVarIdByName(varName, isFunc){
	if(isFunc){
		var funcInfo = dialogObject.formulaParameter.funcInfo;
		for(var i=0; i<funcInfo.length; i++){
			if(funcInfo[i].text==varName)
				return funcInfo[i].fun;
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
			if(funcInfo[i].fun==varName)
				return funcInfo[i].text;
		}
	}else{
		var varInfo = dialogObject.formulaParameter.varInfo;
		for(var i=0; i<varInfo.length; i++){
			if(varInfo[i].name==varName)
				return varInfo[i].label;
		}
	}
}

function replaceSymbol(str){
	str = str.replace(/，/g, ",");
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
	str = str.replace(/》/g, ">");
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

function validateFormula() {
	if (Com_Trim(document.getElementById('expression').value) == '') {
		dialogObject.rtnData = [{name:'', id:''}];
		close();
		return true;
	}

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
	dialogObject.rtnData = [{name:scriptIn, id:scriptOut}];
	close();
}

//添加关闭事件
Com_AddEventListener(window, "beforeunload", function(){dialogObject.AfterShow();});
</script>
<%="</head>" %>
<body>

<table cellpadding=0 cellspacing=0 style="height:100%; border-collapse:collapse;border: 0px #303030 solid; width: 100%">
	<tr>
		<td valign="top" width=200 style="border:#303030 solid; border-width:0px 1px 0px 0px; border-collapse:collapse;">
			<iframe width=200 height=100% frameborder=0 scrolling=auto src='calculation_tree.jsp'></iframe>
		</td>
		<td width="10px">&nbsp;</td>
		<td width="*" valign="middle" align="center">
			<h1 class="txttitle"><kmss:message bundle="sys-xform-base" key="Designer_Lang.controlCalculation_edit_title"/></h1>
			<table class="tb_normal" width="100%">
				<tr>
					<td>
						<textarea id="expression" name="expression" style="width:100%;height:160px;"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" class="tb_normal" border="0">
					        <tr align="center">
					          <td width="12%" class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('1');" value="1"></td>
					          <td width="12%" class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('2');" value="2"></td>
					          <td width="12%" class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('3');" value="3"></td>
					          <td width="12%" class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('/', ' ');" value="/"></td>
					          <td width="12%" class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('(');" value="("></td>
					          <td width="12%" class="tdOpr"><input type="button" class="bigButton" onclick="opFormula(')', ' ');" value=")"></td>
					          <%--td width="14%" class="tdBl"><input type="button" class="bigButton" onclick="opFormula('&&', ' ');" value="&&" title="<bean:message bundle="sys-formula" key="formula.op.and"/>"></td>
					          <td width="14%" class="tdBl"><input type="button" class="bigButton" onclick="opFormula('||', ' ');" value="||" title="<bean:message bundle="sys-formula" key="formula.op.or"/>"></td--%>
					        </tr>
					        <tr align="center">
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('4');" value="4"></td>
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('5');" value="5"></td>
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('6');" value="6"></td>
					          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('*', ' ');" value="*"></td>
					          <td class="tdOpr"><%--input type="button" class="bigButton" onclick="opFormula('<', ' ');" value="&lt;"--%></td>
					          <td class="tdOpr"><%--input type="button" class="bigButton" onclick="opFormula('>', ' ');" value="&gt;"--%></td>
					          <%--td class="tdBl"><input type="button" class="bigButton" onclick="opFormula('!', ' ');" value="!" title="<bean:message bundle="sys-formula" key="formula.op.not"/>"></td>
					          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula('!=', ' ');" value="!=" title="<bean:message bundle="sys-formula" key="formula.op.notEq"/>"></td--%>
					        </tr>
					        <tr align="center">
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('7');" value="7"></td>
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('8');" value="8"></td>
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('9');" value="9"></td>
					          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('-', ' ');" value="-"></td>
					          <td class="tdOpr"><%--input type="button" class="bigButton" onclick="opFormula('<=', ' ');" value="&lt;="--%></td>
					          <td class="tdOpr"><%--input type="button" class="bigButton" onclick="opFormula('>=', ' ');" value="&gt;="--%></td>
					          <%--td class="tdBl"><input type="button" class="bigButton" onclick="opFormula(';', ' ');" value=";"></td>
					          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula(',', ' ');" value=","></td--%>
					        </tr>
					        <tr align="center">
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('0');" value="0"></td>
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('.');" value="."></td>
					          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('%', ' ');" value="%" title="<bean:message bundle="sys-formula" key="formula.op.percen"/>"></td>
					          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('+', ' ');" value="+"></td>
					          <td class="tdOpr"><%--input type="button" class="bigButton" onclick="opFormula('=', ' ');" value="=" title="<bean:message bundle="sys-formula" key="formula.op.set"/>"--%></td>
					          <td class="tdOpr"><%--input type="button" class="bigButton" onclick="opFormula('==', ' ');" value="==" title="<bean:message bundle="sys-formula" key="formula.op.eq"/>"--%></td>
					          <%--td class="tdBl" colspan="2"><input type="button"  class="bigButton" style="width:100px" onclick="opFormula('.equals( )', ' ');" value="Equals" title="<bean:message bundle="sys-formula" key="formula.op.objEq"/>"></td--%>
					        </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align=center>
						<br>
			        		<input type=button class="btnopt" value="<bean:message key="button.ok"/>" onclick="validateFormula();">
			        		&nbsp;&nbsp;&nbsp;&nbsp;
							<input type=button class="btnopt" value="<bean:message bundle="sys-formula" key="button.clear"/>" onclick="clearExp();">
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="button" class="btnopt" value="<bean:message key="button.cancel"/>" onClick="window.close();">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>

<%="</html>" %>