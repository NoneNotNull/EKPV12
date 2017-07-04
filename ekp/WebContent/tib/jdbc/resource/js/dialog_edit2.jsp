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
<script src="<c:url value="/sys/formula/formula_edit.js"/>"></script>
<script type="text/javascript">
Com_IncludeFile("data.js");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
var message_unknowfunc = '<bean:message bundle="tib-jdbc" key="validate.unknowfunc"/>';
var message_unknowvar = '<bean:message bundle="tib-jdbc" key="validate.unknowvar"/>';
var message_wait = '<bean:message bundle="tib-jdbc" key="validate.wait"/>';
var message_eval_error = '<bean:message bundle="tib-jdbc" key="validate.failure.evalError"/>';
</script>
</head>
<body>
<table cellpadding=0 cellspacing=0 style="height:100%; border-collapse:collapse;border: 0px #303030 solid;">
	<tr>
		<td width="30%" valign="top" style="border:#303030 solid; border-width:0px 1px 0px 0px; border-collapse:collapse;">
			<iframe width="100%" height=100% frameborder=0 scrolling=auto src='dialog_tree.jsp'></iframe>
		</td>
		<td width="5%">&nbsp;</td>
		<td valign="center" width="65%">
<div class="txttitle"><bean:message bundle="tib-jdbc" key="config.title"/></div><br>
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
          <td width="14%" class="tdBl"><input type="button" class="bigButton" onclick="opFormula('&&', ' ');" value="&&" title="<bean:message bundle="tib-jdbc" key="formula.op.and"/>"></td>
          <td width="14%" class="tdBl"><input type="button" class="bigButton" onclick="opFormula('||', ' ');" value="||" title="<bean:message bundle="tib-jdbc" key="formula.op.or"/>"></td>
        </tr>
        <tr align="center">
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('4');" value="4"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('5');" value="5"></td>
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('6');" value="6"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('*', ' ');" value="*"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('<', ' ');" value="&lt;"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('>', ' ');" value="&gt;"></td>
          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula('!', ' ');" value="!" title="<bean:message bundle="tib-jdbc" key="formula.op.not"/>"></td>
          <td class="tdBl"><input type="button" class="bigButton" onclick="opFormula('!=', ' ');" value="!=" title="<bean:message bundle="tib-jdbc" key="formula.op.notEq"/>"></td>
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
          <td class="tdNumber"><input type="button" class="bigButton" onclick="opFormula('%', ' ');" value="%" title="<bean:message bundle="tib-jdbc" key="formula.op.percen"/>"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('+', ' ');" value="+"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('=', ' ');" value="=" title="<bean:message bundle="tib-jdbc" key="formula.op.set"/>"></td>
          <td class="tdOpr"><input type="button" class="bigButton" onclick="opFormula('==', ' ');" value="==" title="<bean:message bundle="tib-jdbc" key="formula.op.eq"/>"></td>
          <td class="tdBl" colspan="2"><input type="button"  class="bigButton" style="width:100px" onclick="opFormula('.equals( )', ' ');" value="Equals" title="<bean:message bundle="tib-jdbc" key="formula.op.objEq"/>"></td>
        </tr>
      </table>
      </td>
    </tr>
    <tr>
		<td align=center>
			<br>
        		<input type=button value="<bean:message key="button.ok"/>" onclick="getFilterConditon();">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type=button value="<bean:message bundle="tib-jdbc" key="button.clear"/>" 
					onclick="clearExp();">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type=button value="<bean:message bundle="tib-jdbc" key="button.check"/>" 
					onclick="tibjdbc_validateFormula(validateMessage);">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" value="<bean:message key="button.cancel"/>" onClick="window.close();">&nbsp;&nbsp;&nbsp;&nbsp;
				<!--input type="button" value="<bean:message bundle="tib-jdbc" key="button.help"/>" 
					onClick="Com_OpenWindow('formula_help.jsp', '_blank');"-->
		</td>
	</tr>
</table>		
		</td>
	</tr>
</table>
<script  type="text/javascript">
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener.Com_Parameter.Dialog;
}

//收集输入的过滤
function getFilterConditon(){
	var filterCondition = document.getElementById('expression').value;
	if (filterCondition == '') {
		dialogObject.rtnData = [{name:'', id:''}];
	}else{
	    dialogObject.rtnData = [{id:'filterCondition',name:filterCondition}];
	}
	close();
}

// 验证
function tibjdbc_validateFormula() {
	var dbId = top.dialogArguments.formulaParameter.dbId;
	var sourceSql = top.dialogArguments.formulaParameter.sourceSql;
	var filterCondition = document.getElementById('expression').value;
	if (filterCondition != "") {
		sourceSql = "select * from ("+ sourceSql +") as queryDelTab where "+ filterCondition;
	}
	var data = new KMSSData();
	data.SendToBean("tibJdbcDeleteValidateBean&dbId="+ dbId +"&sourceSql="+sourceSql, tibjdbc_validateCall);
}

function tibjdbc_validateCall(rtnData) {
	var rtnObj = rtnData.GetHashMapArray()[0];
	var result = rtnObj["result"];
	if ("false" == result) {
		var errorStr = rtnObj["errorStr"];
		alert("删除条件校验错误，请改正，错误信息为："+ errorStr);
	} else {
		alert("校验通过");
	}
}


</script>
</body>
</html>