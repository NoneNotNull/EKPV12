<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<script type="text/javascript">
function checkAndSubmit(form,method){
objs = document.getElementsByTagName("input");
	for(var i=0;i<objs.length;i++){
		if(objs[i].type=="text" && objs[i].name!="value(fdSpecialNames)") {
		    var value=objs[i].value;
		    value=trim(value);
			if(!isDigit(value)){
				alert("<bean:message bundle='kms-integral' key='kmsIntegralRule.attnFloat'/>");
				return;
			}
			objs[i].value=value;
		}
	}
Com_Submit(document.kmsIntegralConfigForm,'update');
}

function trim(s){
	var patrn=/\s/g;
	s=s.replace(patrn,"");
	return s;
}
function isDigit(s)
{
	patrn=/^[-]?[0-9]*[.]?[0-9]*$/;
	if (!patrn.exec(s)) return false;
	return true;
}


</script>
<html:form  action="/kms/integral/kms_integral_rule/kmsIntegralConifg.do" method="POST">
<div id="optBarDiv">
	
		<input type=button value="<bean:message key="button.update"/>"
			onclick="checkAndSubmit(document.kmsIntegralConfigForm,'update');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="kms-integral" key="kmsIntegralRule.title"/></p>
<center>
<table class="tb_normal" width=95%>
    <tr>
		<td class="td_normal_title" colspan="2" style="font-weight:bold;color:#484848">
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.docRule"/>
		</td>
	</tr>
	<tr>
		<td width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.fdDocComment"/>
		</td>
		<td>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.evaluationA"/>
			<html:text property="value(evaluation0)" style="width:100px"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.evaluationB"/>
			<html:text property="value(evaluation1)" style="width:100px"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.evaluationC"/>
			<html:text property="value(evaluation2)" style="width:100px"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.evaluationD"/>
			<html:text property="value(evaluation3)" style="width:100px"/><br>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.evaluationE"/>
			<html:text property="value(evaluation4)" style="width:100px"/>
		</td>
	</tr>
	<tr>
		<td width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.docCommendSet"/>
		</td>
		<td>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.introductionA"/>
			<html:text property="value(introduce0)" style="width:100px"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.introductionB"/>
			<html:text property="value(introduce1)" style="width:100px"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.introductionC"/>
			<html:text property="value(introduce2)" style="width:100px"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="2" style="font-weight:bold;color:#484848">
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.title"/>
		</td>
	</tr>	
	<tr>
		<td width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.set"/>
		</td>
		<td>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.read"/>
			<html:text property="value(correctReadCount)" style="width:50px;padding-left:20px;"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.suffix"/><br/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.evaluation"/>
			<html:text property="value(correctEvaluationCount)" style="width:50px;padding-left:20px;"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.suffix"/><br/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.introduce"/>
			<html:text property="value(correctIntroduceCount)" style="width:50px;padding-left:20px;"/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.suffix"/><br/>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.correct.rule.msg"/>
		</td>
	</tr>			
    <tr>
		<td class="td_normal_title" colspan="2" style="font-weight:bold;color:#484848">
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.specialPerson"/>
		</td>
	</tr>	
	<tr>
		<td width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.set"/>
		</td>
		<td>
			<html:hidden property="value(fdSpecialIds)"/>
			<html:textarea property="value(fdSpecialNames)" readonly="true" style="width:80%" />
			<a href="#" onclick="Dialog_Address(true, 'value(fdSpecialIds)', 'value(fdSpecialNames)', ';',ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOther"/>
			</a><br>
			<bean:message  bundle="kms-integral" key="kmsIntegralRule.specialPersonDescription"/>
		</td>
	</tr>			
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
