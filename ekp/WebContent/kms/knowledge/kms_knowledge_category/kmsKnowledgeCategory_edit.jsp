<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String fdModelName = request.getParameter("fdModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(fdModelName).getPropertyMap().keySet();
%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<kmss:windowTitle
	subjectKey="kms-knowledge:table.kmsKnowledgeCategory"
	moduleKey="kms-knowledge:table.kmKnowledge" />
<script language="JavaScript">
Com_IncludeFile("dialog.js");

//提交校验
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
	
	//知识模版必须
	var isSelectedTemplate = false;
	$("input[name=_fdTemplateType]").each(function(){
		if(this.checked){
			isSelectedTemplate = true;
		}
	});
	if(!isSelectedTemplate){
		alert('<bean:message key="kmsKnowledgeCategory.noKnowledgeTemplate" bundle="kms-knowledge"/>');
		return false;
	}
	
  	//提交前，校验类别名称唯一性
	if(checkMultidocName())
		 return true ;
	else 
		return false ;
}

function checkMultidocName(){

	var fdName=document.getElementsByName("fdName")[0].value ; 
	var fdId='${kmsKnowledgeCategoryForm.fdId}';
	var parentId='${kmsKnowledgeCategoryForm.fdParentId}'; 
	
	if(fdName != "" && fdName != null){
		var url="kmsKnowledgeCategoryCheckService&fdName="+fdName+"&fdId="+fdId+"&parentId="+parentId;
		url = Com_SetUrlParameter(url, "fdName", fdName);
		var data = new KMSSData(); 
		var isExist =data.AddBeanData(url).GetHashMapArray()[0];
	   	if(isExist["key0"]=='false'){
	   		return true;
	   	}else{
	   	    alert('<bean:message key="msg.hasExist" bundle="kms-knowledge"/>');
	   		return false;
	   	}
	}
}

$(document).ready(function(){
	var val = $("input[name=fdTemplateType]").val();
	settingTemplates(val);
});


function settingTemplates(e){

	var multidocTemplate = $("#multidoc_TemplateName");
	var wikiTemplate = $("#wiki_TemplateName");
	if(~e.indexOf("1")){
		multidocTemplate.show();
	}else{
		multidocTemplate.hide();
	}
	if(~e.indexOf("2")){
		wikiTemplate.show();
	}else{
		wikiTemplate.hide();
	}
}

</script>
<html:form
	action="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do"
	onsubmit="return validateKmsKnowledgeCategoryForm(this);">
		
	<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmsKnowledgeCategoryForm" />
	</c:import>

	<p class="txttitle"><bean:message
		bundle="kms-knowledge"
		key="table.kmsKnowledgeCategory" /></p>

	<center>
	<table
		id="Label_Tabel"
		width="95%">
		<c:set var="selectEmpty" value="true" />
		<kmss:auth
			requestURL="${param.requestURL}"
			requestMethod="Get">
			<c:set var="selectEmpty" value="false" />
		</kmss:auth>
		<!-- 类别信息  -->
		<c:import url="/kms/common/resource/ui/sysCategoryMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsKnowledgeCategoryForm" />
			<c:param name="requestURL" value="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
			<c:param name="mainModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
			<c:param name="cateTitle" value="${lfn:message('kms-knowledge:kmsKnowledgeCategory.edit.CategoryInformation')}" />
		</c:import>
		<tr LKS_LabelName="${lfn:message('kms-knowledge:kmsKnowledgeCategory.edit.docTemplate')}" > 
			<td>
			<table
				class="tb_normal"
				width=100%>
 			
	 			<tr id="multidoc_TemplateName" >
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.docTemplate"/>
					</td><td colspan="3">
						<html:hidden property="docTemplateId" /> 
						<html:text property="docTemplateName"  styleClass="inputsgl" style="width:75%" /> 
						<a href="#" onclick="Dialog_List(false, 'docTemplateId', 'docTemplateName', null, 'kmsKnowledgeDocTemplateTree&type=child', null, 'kmsKnowledgeDocTemplateTree&type=search&key=!{keyword}', null, null, '<bean:message  bundle="kms-knowledge" key="table.kmsKnowledgeDocTemplate"/>');">
						<bean:message key="dialog.selectOther" />
						</a>
					</td>
				</tr>
	 			<tr id="wiki_TemplateName">
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.wikiTemplate"/>
					</td><td colspan="3">
						<html:hidden property="wikiTemplateId" /> 
						<html:text property="wikiTemplateName"  styleClass="inputsgl" style="width:75%" /> 
						<a href="#" onclick="Dialog_List(false, 'wikiTemplateId', 'wikiTemplateName', null, 'kmsKnowledgeWikiTemplateTree&type=child', null, 'kmsKnowledgeWikiTemplateTree&type=search&key=!{keyword}', null, null, '<bean:message  bundle="kms-knowledge" key="table.kmsKnowledgeWikiTemplate"/>');">
						<bean:message key="dialog.selectOther" />
						</a>
					</td>
				</tr>
				
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagTemplate_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsKnowledgeCategoryForm" />
					<c:param name="fdKey" value="mainDoc" /> 
					<c:param name="diyTitle" value="默认关键字" /> 
				</c:import>
			</table>
			</td>
		</tr>
		
		<!-- 流程设置  -->
		<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsKnowledgeCategoryForm" />
			<c:param name="fdKey" value="mainDoc" /> 
			<c:param name="diyTitle" value="设置" /> 
		</c:import>
		
		<%--关联机制--%>
		<tr LKS_LabelName="${lfn:message('kms-knowledge:kmsKnowledgeCategory.edit.knowledgeRelationSetting') }">
		<!--  bean:message bundle="sys-relation" key="sysRelationMain.tab.label"  -->
			<c:set
				var="mainModelForm"
				value="${kmsKnowledgeCategoryForm}"
				scope="request" />
			<c:set
				var="currModelName"
				value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"
				scope="request" />
			<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
		</tr>
		<%----发布机制开始--%>
		<c:import url="/sys/news/include/sysNewsPublishCategory_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsKnowledgeCategoryForm" />
			<c:param name="fdKey" value="mainDoc" /> 
			<c:param name="messageKey"
					value="kms-knowledge:kmsKnowledgeCategory.lbl.publish" />
		</c:import>
		<%----发布机制结束--%>
		<%----权限--%>
		<tr LKS_LabelName="${lfn:message('kms-knowledge:kmsKnowledgeCategory.edit.RightSetting') }">
			<td>
			<table
				class="tb_normal" 
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsKnowledgeCategoryForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
				</c:import>
			</table>
			</td>
		</tr>
		
		<!-- 纠错流程设置  -->
		<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">  
			<c:param name="formName" value="kmsKnowledgeCategoryForm" />
			<c:param name="fdKey" value="knowledgeErrorCorrectionFlow" /> 
			<c:param name="diyTitle" value="设置" /> 
			<c:param name="messageKey"  value="kms-knowledge:kmsKnowledgeCategory.kmsCommonDocErrorCorrectionFlow" /> 
		</c:import>
		
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
</html:form>
<html:javascript
	formName="kmsKnowledgeCategoryForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
<script>
function loadExtendPropertyData(modelName) {
	var proTemplateId = $("input[name=fdSysPropTemplateId]").val();
	return new KMSSData().AddBeanData("kmsKnowledgeFormulaDictVarTree&modelName="+modelName+"&proTemplateId="+proTemplateId).GetHashMapArray();
}

var Formula_GetVarInfoByModelName_old = window.Formula_GetVarInfoByModelName;
//获取主文档和表单数据字典
function Formula_GetVarInfoByModelName(modelName) {
	if(window.loadExtendPropertyData){
		return loadExtendPropertyData(modelName);
	}else{
		return Formula_GetVarInfoByModelName_old(modelName);
	}
}

/**
 * 模版改变通知
 */
function updateNotice(val){
	if(proTemplateId && (!val.data[0] || proTemplateId!=val.data[0].id)){
		alert("模板发生变更,如果在流程公式中设置了扩展属性,请手动修改!");
	}
}
</script>
