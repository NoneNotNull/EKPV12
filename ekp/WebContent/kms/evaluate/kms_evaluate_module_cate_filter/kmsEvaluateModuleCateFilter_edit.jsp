<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<html:form action="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluateModuleCateFilterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())if(checkDocType())Com_Submit(document.kmsEvaluateModuleCateFilterForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluateModuleCateFilterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())if(checkDocType())Com_Submit(document.kmsEvaluateModuleCateFilterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())if(checkDocType())Com_Submit(document.kmsEvaluateModuleCateFilterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateModuleCateFilter"/></p>

<center>
<table class="tb_normal" width=60%>
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluatePublic.jsp"%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docCategory"/>
		</td><td width="35%">
			<input type="hidden" name="docCategoryIds" value="${kmsEvaluateModuleCateFilterForm.docCategoryIds }"/>
			<xform:text property="docCategoryNames" style="width:70%" value="${kmsEvaluateModuleCateFilterForm.docCategoryNames }" required="true"/>
			<a href="javascript:void(0)"  onclick="Dialog_Tree(true,'docCategoryIds','docCategoryNames',null,'kmsLogContextCategoryTree&type=doc&docCategoryId=!{value}','<bean:message  bundle="kms-log" key="kmsLogDocContext.fdCategory" />',null,updateNotice,null,null,null,'<bean:message bundle="kms-log" key="table.kmsLogContextCategory.select" />');">
		<bean:message key="button.select" /></a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType"/>
		</td><td width="35%">
			<c:if test="${ null == kmsEvaluateModuleCateFilterForm.docType || true == kmsEvaluateModuleCateFilterForm.docType }">
				<xform:checkbox property="docType" value="true" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.multidoc'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.multidoc"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
			<c:if test="${ false == kmsEvaluateModuleCateFilterForm.docType}">
				<xform:checkbox property="docType"  subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.multidoc'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.multidoc"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
			<c:if test="${ null == kmsEvaluateModuleCateFilterForm.wikiType || true == kmsEvaluateModuleCateFilterForm.wikiType }">
				<xform:checkbox property="wikiType" value="true" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.knowledgeType.wiki'/>" >
					<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType.wiki"/></xform:simpleDataSource>
				</xform:checkbox>
			</c:if>
			<c:if test="${false == kmsEvaluateModuleCateFilterForm.wikiType}">
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
			<xform:checkbox property="docAddCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docAddCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docAddCount"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docUpdateCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docUpdateCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docUpdateCount"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docDeleteCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docDeleteCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docDeleteCount"/></xform:simpleDataSource>
			</xform:checkbox>
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