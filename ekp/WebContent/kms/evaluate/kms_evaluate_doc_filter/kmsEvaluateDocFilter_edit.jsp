<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="com.landray.kmss.kms.evaluate.util.KmsEvaluateUtil"%>
<html:form action="/kms/evaluate/kms_evaluate_doc_filter/kmsEvaluateDocFilter.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluateDocFilterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())if(checkDocType())Com_Submit(document.kmsEvaluateDocFilterForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluateDocFilterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())if(checkDocType())Com_Submit(document.kmsEvaluateDocFilterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())if(checkDocType())Com_Submit(document.kmsEvaluateDocFilterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocFilter"/></p>

<center>
<table class="tb_normal" width=60%>
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluatePublic.jsp"%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docCategory"/>
		</td><td width="35%">
			<input type="hidden" name="docCategoryIds" value="${kmsEvaluateDocFilterForm.docCategoryIds}"/>
			<xform:text property="docCategoryNames" style="width:70%"  required="true"/>
			<a href="javascript:void(0)"  onclick="Dialog_Tree(true,'docCategoryIds','docCategoryNames',null,'kmsLogContextCategoryTree&type=doc&docCategoryId=!{value}','<bean:message  bundle="kms-log" key="kmsLogDocContext.fdCategory" />',null,updateNotice,null,null,null,'<bean:message bundle="kms-log" key="table.kmsLogContextCategory.select" />');">
			<bean:message key="button.select" /></a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType"/>
		</td><td width="35%">
			<c:if test="${ null == kmsEvaluateDocFilterForm.docType || true == kmsEvaluateDocFilterForm.docType }">
				<xform:checkbox property="docType" value="true" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.multidoc'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.multidoc"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
			<c:if test="${ false == kmsEvaluateDocFilterForm.docType}">
				<xform:checkbox property="docType" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.multidoc'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.multidoc"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
			<c:if test="${ null == kmsEvaluateDocFilterForm.wikiType || true == kmsEvaluateDocFilterForm.wikiType }">
				<xform:checkbox property="wikiType" value="true" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.wiki'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.wiki"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
			<c:if test="${ false == kmsEvaluateDocFilterForm.wikiType}">
				<xform:checkbox property="wikiType" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.wiki'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.wiki"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.count"/>
		</td><td width="80%">
			<xform:checkbox property="docReadCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docReadCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCount"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docEvaluationCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docEvaluationCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCount"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docIntroduceCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docIntroduceCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCount"/></xform:simpleDataSource>
			</xform:checkbox>
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
<script>
function updateNotice(val){}
function checkDocType(){
	var docType = document.getElementsByName("_docType")[0];
	var wikiType = document.getElementsByName("_wikiType")[0];
	if(docType.checked==false && wikiType.checked==false){
		alert('<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.notCheck"/>');
		return false ;
	}	
	return true ;
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>