<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function check(){
	var money=document.getElementsByName("fdMoneyAlter")[0].value;
	var rang=document.getElementsByName("fdPersonNames")[0].value;
	
	if(money==""){
		alert("<bean:message  bundle='kms-ask' key='kmsAskMoneyAlter.alter.value.isNotInteger'/>");
		return false;
	}else if(rang==""){
		alert("<bean:message  bundle='kms-ask' key='kmsAskMoneyAlter.alterRang'/>");
		return false;
	}else if(money.match(/^[1-9]\d*$/)==null){ 
		alert("<bean:message  bundle='kms-ask' key='kmsAskMoneyAlter.alter.value.isNotInteger'/>"); 
		return false;
	}
	return true;
}
</script>
					
<html:form action="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do" onsubmit="return check()">
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do?method=edit" requestMethod="GET">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsAskMoneyAlterForm, 'update');">
	</kmss:auth>
	<c:if test="${param.config != 'true'}">
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</c:if>
</div>
<c:if test="${param.config != 'true'}">
	<p class="txttitle"><bean:message  bundle="kms-ask" key="kmsAskPost.add.knowledgeMoney"/></p>
</c:if>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskPost.add.knowledgeMoney"/>
		</td><td width="45%">
			<select name="fdType">
				<option value=""><bean:message  bundle="kms-ask" key="kmsAskMoneyAlter.alter.type.plus"/></option>
				<option value="-"><bean:message  bundle="kms-ask" key="kmsAskMoneyAlter.alter.type.minus"/></option>
			</select>
			<html:text property="fdMoneyAlter" size="12"/><span class="txtstrong">*</span>
		</td>
	</tr>
	
	<tr>		
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskMoneyAlter.alter.rang"/>
		</td><td width="45%">
			<html:hidden property="fdPersonIds"/>
			<html:text property="fdPersonNames" readonly="true"  styleClass="inputsgl" style="width:75%;"/>
			<a href="#" id="selectParentName"
                onclick="Dialog_Address(true, 'fdPersonIds', 'fdPersonNames', ';', ORG_TYPE_ORGORDEPT|ORG_TYPE_PERSON|ORG_FLAG_BUSINESSALL);">
             <bean:message key="dialog.selectOrg" /></a><span class="txtstrong">*</span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
