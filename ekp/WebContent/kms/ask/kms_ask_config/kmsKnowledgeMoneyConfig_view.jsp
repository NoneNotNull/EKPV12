<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<div id="optBarDiv">
		<%-- 
		<kmss:auth requestURL="/kms/ask/kms_ask_config/kmsKnowledgeMoneyConfig.do?method=edit" requestMethod="GET">
		--%>
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmsKnowledgeMoneyConfig.do?method=edit','_self');">
		<%-- 
		</kmss:auth>
		--%>
</div>
<center>
<table class="tb_normal" width=95%>
		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsKnowledgeMoneyConfig.fdInitMoney"/> 
		</td>
		<td colspan=2>
			<bean:write name="kmsKnowledgeMoneyConfigForm" property="fdInitMoney"/>
		</td> 
	</tr>
 
</table>
<%-----添加初始化货币 说明 modify by zhouchao-----%>
<br>
<font color="red" ><bean:message  bundle="kms-ask" key="kmsKnowledgeMoneyConfig.fdInitMoney.describe"/></font> 
</br>
</center>

<%@ include file="/resource/jsp/view_down.jsp"%>
