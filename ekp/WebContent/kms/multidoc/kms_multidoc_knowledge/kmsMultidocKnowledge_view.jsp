<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<!-- 更多 -->
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
Com_IncludeFile("dialog.js");
Com_IncludeFile("jquery.js");
</script>
<script>
$(document).ready(function(){
	$("th").each( function() {
		  $(this).addClass("td_normal_title");
	      $(this).css("font-size","12")  ;   
		  $(this).css("text-align","left") ;  
		  $(this).css("font-weight", "normal");  
		}) ;
	
}) ;
</script>
<kmss:windowTitle
	subject="${kmsMultidocKnowledgeForm.docSubject}"
	moduleKey="kms-multidoc:table.kmdoc" />
<c:set
	var="sysDocBaseInfoForm"
	value="${kmsMultidocKnowledgeForm}"
	scope="request" />
<%@ include file="kmsMultidocKnowledge_script.jsp"%>
<div id="optBarDiv">
<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit > '0' }">
	<kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=edit&fdId=${param.fdId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsMultidocKnowledge.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth> 
</c:if>
<kmss:auth
	requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input
		type="button"
		value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('kmsMultidocKnowledge.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth>
<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit >= '3' }">
	<input type="button"
		value="<bean:message key="button.back" bundle="kms-multidoc"/>"
		onclick="Com_OpenWindow('kmsMultidocKnowledge.do?method=view&fdId=${param.fdId}','_self');" />
</c:if>
<input
	type="button"
	value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
	<p class="txttitle"><bean:write	name="sysDocBaseInfoForm" property="docSubject" /></p>
<center>
<table
	id="Label_Tabel"
	width=95%>
	<tr LKS_LabelName="<bean:message bundle="kms-multidoc" key="kmsMultidoc.form.tab.main.label" />">
		<td>
		<table
			class="tb_normal"
			width=100%>
			<tr>
				<td
					width="15%"
					class="td_normal_title">标题</td>
				<td
					width="85%"
					colspan="3"><bean:write
					name="sysDocBaseInfoForm"
					property="docSubject" /></td>
			</tr>
			<tr>
				<td
					class="td_normal_title"
					width="15%"><bean:message
					key="kmsMultidocKnowledge.fdTemplateName"
					bundle="kms-multidoc" /></td>
				<td width="35%"><bean:write
					name="kmsMultidocKnowledgeForm"
					property="fdDocTemplateName" /></td>
							<td
						class="td_normal_title"
						width="15%">知识编号</td>
						
					<td width="39%"><c:out value="${kmsMultidocKnowledgeForm.fdNumber}" /></td>
			</tr>
			<tr>
				<td
					width="15%"
					class="td_normal_title"><bean:message
					bundle="sys-doc"
					key="sysDocBaseInfo.docDept" /></td>
				<td width="35%"><bean:write
					name="sysDocBaseInfoForm"
					property="docDeptName" /></td>
				<td
					class="td_normal_title"
					width="15%"><bean:message
					bundle="kms-multidoc"
					key="table.kmsMultidocMainPost" /></td>
				<td><bean:write
					name="kmsMultidocKnowledgeForm"
					property="docPostsNames" /></td>
			</tr>
			<tr>
				<td
					width="15%"
					class="td_normal_title">作者</td>
				<td width="35%">
					<bean:write
						name="kmsMultidocKnowledgeForm"
						property="docAuthorName" />
					<bean:write
						name="kmsMultidocKnowledgeForm"
						property="outerAuthor" />	
				</td>
				<td
					class="td_normal_title"
					width="15%"><bean:message
					key="kmsMultidocKnowledge.docPublishTime"
					bundle="kms-multidoc" /></td>
					
				<td width="35%"><bean:write
					name="kmsMultidocKnowledgeForm"
					property="docPublishTime" /></td>
			</tr>
			<%-- 
			<tr>

				<td
					class="td_normal_title"
					width="15%"><bean:message
					bundle="kms-multidoc"
					key="table.kmsMultidocMainProperty" /></td>
				<td colspan="3"><bean:write
					name="kmsMultidocKnowledgeForm"
					property="docPropertiesNames" /></td>
			</tr>
			 --%>
		 
				<c:import url="/sys/property/include/sysProperty_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				</c:import>
				 
		 
			
			
			 
			<!-- 标签机制 -->
			<c:import url="/sys/tag/include/sysTagMain_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" /> 
			</c:import>
			<!-- 标签机制 -->
			<tr>
				<td
					class="td_normal_title"
					width=15%><bean:message
					bundle="kms-multidoc"
					key="kmsMultidocTemplate.fdStoretime" /></td>
				<td colspan="3"><bean:write
					name="kmsMultidocKnowledgeForm"
					property="docExpire" /><bean:message
					key="message.storetime"
					bundle="kms-multidoc" /><bean:message
					key="message.storetime.tip"
					bundle="kms-multidoc" /></td>
			</tr>
			<tr>
				<td
					width="11%"
					class="td_normal_title"
					valign="top">摘要</td>
				<td
					width="89%"
					colspan="3"><kmss:showText value="${sysDocBaseInfoForm.fdDescription}" /></td>
			</tr>
			<tr>
				<td
					width="11%"
					class="td_normal_title"
					valign="top">正文</td>
				<td
					width="89%"
					colspan="3">${sysDocBaseInfoForm.docContent }</td>
			</tr>
			<tr>
				<td
					width="11%"
					class="td_normal_title"
					valign="top"><bean:message
					bundle="sys-doc"
					key="sysDocBaseInfo.docAttachments" /></td>
				<td
					width="89%"
					colspan="3"><c:import
					url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formBeanName"
						value="sysDocBaseInfoForm" />
					<c:param
						name="fdKey"
						value="attachment" />
				</c:import></td>
			</tr>
			<tr>
				<td
					width="15%"
					class="td_normal_title">创建者</td>
				<td width="35%"><bean:write
					name="sysDocBaseInfoForm"
					property="docCreatorName" /></td>
				<td
					width="15%"
					class="td_normal_title">创建时间</td>
				<td width="35%"><bean:write
					name="sysDocBaseInfoForm"
					property="docCreateTime" /></td>
			</tr>
			<tr>
				<td
					width="15%"
					class="td_normal_title">最后更新者</td>
				<td width="35%"><bean:write
					name="sysDocBaseInfoForm"
					property="docAlterorName" /></td>
				<td
					width="15%"
					class="td_normal_title">最后更新时间</td>
				<td width="35%"><bean:write
					name="sysDocBaseInfoForm"
					property="docAlterTime" /></td>
			</tr>
			
		</table>
		</td>
	</tr>
	<c:import
		url="/sys/evaluation/include/sysEvaluationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmsMultidocKnowledgeForm" />
	</c:import>
	<c:import
		url="/sys/introduce/include/sysIntroduceMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmsMultidocKnowledgeForm" />
		<c:param name="fdKey" value="mainDoc" />
		<c:param name="toEssence" value="true" />
		<c:param name="toNews" value="true" />
		<c:param name="docSubject" value="${kmsMultidocKnowledgeForm.docSubject}" />
		<c:param name="docCreatorName" value="${kmsMultidocKnowledgeForm.docCreatorName}" />
	</c:import>
	 
	<c:import
		url="/sys/readlog/include/sysReadLog_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmsMultidocKnowledgeForm" />
	</c:import>
		<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocKnowledgeForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import>
	<c:import
		url="/sys/edition/include/sysEditionMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmsMultidocKnowledgeForm" />
	</c:import>
	<tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
		<c:set
			var="mainModelForm"
			value="${kmsMultidocKnowledgeForm}"
			scope="request" />
		<c:set
			var="currModelName"
			value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"
			scope="request" />
		<td><%@ include file="/sys/relation/include/sysRelationMain_view.jsp"%></td>
	</tr>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
		<table
			class="tb_normal"
			width=100%>
			<c:import
				url="/sys/right/right_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="kmsMultidocKnowledgeForm" />
				<c:param
					name="moduleModelName"
					value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
			</c:import>
		</table>
		</td>
	</tr>
	<%--bookmark--%>
	<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmsMultidocKnowledgeForm.docSubject}" />
		<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId}" />
		<c:param name="fdModelName"
			value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
	</c:import>
</table>

</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
