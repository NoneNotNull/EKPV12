<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	window.onload = function(){
		if ( document.getElementsByName('fdReason').length > 0 ){
			document.getElementsByName('fdReason')[0].focus();
		}
	};
</script>
<html:form action="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do">
<div id="optBarDiv">
	<c:if test="${kmsAskIntroduceForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsAskIntroduceForm, 'update');">
	</c:if>
	<c:if test="${kmsAskIntroduceForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsAskIntroduceForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-ask" key="table.kmsAskIntroduce"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" >
			<bean:message bundle="kms-ask" key="kmsAskIntroduce.fdReason"/>
		</td>
	</tr>
	<tr>
		<td>
			<xform:textarea property="fdReason" style="width:100%;height:80" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdKmsAskTopicId" value="${fdKmsAskTopicId} "/>
<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>