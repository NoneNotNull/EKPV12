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
	cursor: hand;
}
.smallButton {
	font-size: 14px;
	font-weight: normal;
	width: 50px;
	cursor: hand;
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
<script type="text/javascript">
Com_IncludeFile("data.js");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
var message_unknowfunc = "<bean:message bundle="sys-formula" key="validate.unknowfunc"/>";
var message_unknowvar = "<bean:message bundle="sys-formula" key="validate.unknowvar"/>";
var message_wait = "<bean:message bundle="sys-formula" key="validate.wait"/>";
var message_eval_error = "<bean:message bundle="sys-formula" key="validate.failure.evalError"/>";
</script>
<script src="<c:url value="/sys/formula/formula_edit.js"/>"></script>
</head>
<body>
<table cellpadding=0 cellspacing=0 style="height:100%; border-collapse:collapse;border: 0px #303030 solid;">
	<tr>
		<td valign="top" style="border:#303030 solid; border-width:0px 1px 0px 0px; border-collapse:collapse;">
			<iframe width=200 height=100% frameborder=0 scrolling=auto src='../common/sapMappingControlsDialog_tree.jsp'></iframe>
		</td>
		<td width="10px">&nbsp;</td>
		<td valign="center">
<div class="txttitle"><bean:message bundle="sys-formula" key="formula.title"/></div><br>
<table class="tb_normal" width="100%">
	<tr>
		<td>
			<textarea id="expression" name="expression" style="width:100%;height:160px;"></textarea>
		</td>
	</tr>
	<tr>
	  <td><table width="100%" class="tb_normal" border="0">
        <tr align="center">
          <td width="12%" class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('1');" value="1"></td>
          <td width="12%" class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('2');" value="2"></td>
          <td width="12%" class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('3');" value="3"></td>
          <td width="12%" class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('/', ' ');" value="/"></td>
          <td width="12%" class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('(');" value="("></td>
          <td width="12%" class="tdOpr"><input type="button" class="bigButton" onclick="opFormula(')', ' ');" value=")"></td>
          <td width="14%" class="tdBl"><input type="button" class="bigButton" onclick="opFormula('&&', ' ');" value="&&" title="<bean:message bundle="sys-formula" key="formula.op.and"/>"></td>
          <td width="14%" class="tdBl"><input type="button" class="bigButton" onclick="opFormula('||', ' ');" value="||" title="<bean:message bundle="sys-formula" key="formula.op.or"/>"></td>
        </tr>
        <tr align="center">
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('4');" value="4"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('5');" value="5"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('6');" value="6"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('*', ' ');" value="*"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('<', ' ');" value="&lt;"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('>', ' ');" value="&gt;"></td>
          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula('!', ' ');" value="!" title="<bean:message bundle="sys-formula" key="formula.op.not"/>"></td>
          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula('!=', ' ');" value="!=" title="<bean:message bundle="sys-formula" key="formula.op.notEq"/>"></td>
        </tr>
        <tr align="center">
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('7');" value="7"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('8');" value="8"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('9');" value="9"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('-', ' ');" value="-"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('<=', ' ');" value="&lt;="></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('>=', ' ');" value="&gt;="></td>
          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula(';', ' ');" value=";"></td>
          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula(',', ' ');" value=","></td>
        </tr>
        <tr align="center">
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('0');" value="0"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('.');" value="."></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('%', ' ');" value="%" title="<bean:message bundle="sys-formula" key="formula.op.percen"/>"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('+', ' ');" value="+"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('=', ' ');" value="=" title="<bean:message bundle="sys-formula" key="formula.op.set"/>"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('==', ' ');" value="==" title="<bean:message bundle="sys-formula" key="formula.op.eq"/>"></td>
          <td class="tdBl" colspan="2"><input type="button"  class="bigButton" style="width:100px" onclick="opFormula('.equals( )', ' ');" value="Equals" title="<bean:message bundle="sys-formula" key="formula.op.objEq"/>"></td>
        </tr>
      </table>
      </td>
    </tr>
    <tr>
		<td align=center>
			<br>
        		<input type=button value="<bean:message key="button.ok"/>" onclick="validateFormula_self(writeBack_self);">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type=button value="<bean:message bundle="sys-formula" key="button.clear"/>" 
					onclick="clearExp();">&nbsp;&nbsp;&nbsp;&nbsp;
				<!-- 
				<input type=button value="<bean:message bundle="sys-formula" key="button.check"/>" 
					onclick="validateFormula(validateMessage);">&nbsp;&nbsp;&nbsp;&nbsp;
				 -->
				<input type="button" value="<bean:message key="button.cancel"/>" onClick="window.close();">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" value="<bean:message bundle="sys-formula" key="button.help"/>" 
					onClick="Com_OpenWindow('../common/sapMappingControlsDialog_help.jsp', '_blank');">
		</td>
	</tr>
</table>		
		</td>
	</tr>
</table>
<script type="text/javascript"><!--
   function writeBack_self(rtnVal){
	   var success = rtnVal.GetHashMapArray()[0].success;
		if(success=="1"){
			dialogObject.rtnData = [validateResult];
			close();
		}else if (success=="0"){
			if(<%-- confirm(rtnVal.GetHashMapArray()[0].confirm)--%>
					true){
				dialogObject.rtnData = [validateResult];
				close();
			} else{
				validateResult = null;
			}
		}else{
			validateResult = null;
			<%--
			alert(rtnVal.GetHashMapArray()[0].message);
			--%>
		}
	   }
   function validateFormula_self(action){
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

--></script>
</body>
</html>