<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<html:form action="/kms/ask/kms_ask_config/kmsKnowledgeMoneyConfig.do" onsubmit="return validateKmsKnowledgeMoneyConfigForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsKnowledgeMoneyConfigForm, 'update');">
</div>
<center>
<table class="tb_normal" width=95%>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsKnowledgeMoneyConfig.fdInitMoney"/>
		</td><td colspan=3>
			<html:text property="fdInitMoney" size="5"/><span class="txtstrong">*</span>
		</td>
	</tr>
	
</table>
<%-----添加初始化货币 说明 modify by zhouchao-----%>
<br>
<font color="red" ><bean:message  bundle="kms-ask" key="kmsKnowledgeMoneyConfig.fdInitMoney.describe"/></font> 
</br>
</center>
<html:hidden property="method_GET"/>
</html:form>

<html:javascript formName="kmsKnowledgeMoneyConfigForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>

<%@ include file="/resource/jsp/edit_down.jsp"%>
