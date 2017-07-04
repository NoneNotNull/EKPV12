<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_ask_c_filter/kmsEvaluateAskCFilter.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluateAskCFilterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluateAskCFilterForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluateAskCFilterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluateAskCFilterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluateAskCFilterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateAskCFilter"/></p>

<center>
<table class="tb_normal" width=60%>
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluatePublic.jsp"%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docCategory"/>
		</td><td width="35%">
			<input type="hidden" name="docCategoryIds" value="${kmsEvaluateAskCFilterForm.docCategoryIds }"/>
			<xform:text property="docCategoryNames" style="width:70%" value="${kmsEvaluateAskCFilterForm.docCategoryNames }" required="true"/>
			<a href="javascript:void(0)"  onclick="Dialog_Tree(true,'docCategoryIds','docCategoryNames',null,'kmsLogContextCategoryTree&type=ask&docCategoryId=!{value}','<bean:message  bundle="kms-log" key="kmsLogDocContext.fdCategory" />',null,null,null,null,null,'<bean:message bundle="kms-log" key="table.kmsLogContextCategory.select" />');">
		<bean:message key="button.select" /></a>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>