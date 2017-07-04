<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript"
	src="/ekp/resource/ckeditor/ckeditor.js">
</script>
<script type="text/javascript"
	src="${LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/js/editorCategory.js">
</script>
<html:form action="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do">
<script >
// 提交表单
function commitMethod(method, saveDraft){
	var a = document.getElementById("docErrorReasonSpan");
	var docDescription = document.getElementsByName("docDescription")[0].value ;
	docDescription = docDescription.replace(/(^\s*)|(\s*$)/g,'');
	if(docDescription.length==0){
		alert('<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.fdCorrectionOpinions.reason"/>'+"!");
		return false ;
	}
	if (editor){
		editor.destroy();
	}
	document.getElementsByName("docErrorReason")[0].value = document.getElementById("docErrorReasonSpan").innerHTML ;
	var docStatus = document.getElementsByName("docStatus")[0];
	if (saveDraft != null && saveDraft == 'true'){
		docStatus.value = "10";
	} else {
		docStatus.value = "20";
	}
	Com_Submit(document.kmsCommonDocErrorCorrectionForm, method);
}
//打开文档
function openMainWindow(){
	Com_OpenWindow("<c:url value='${url}'/>");
}
var editor ;
function openDocErrorReason(){
	var docErrorReasonSpan = document.getElementById("docErrorReasonSpan") ;
	var cke_docErrorReasonSpan =  document.getElementById("cke_docErrorReasonSpan");
	if(cke_docErrorReasonSpan == null){
		editor = CKEDITOR.replace(docErrorReasonSpan, {"toolbar":"Wiki","toolbarStartupExpanded":false,"toolbarCanCollapse":true});
		editor.on('refreshCategory',function(){
			CKEDITOR_EXTEND.ckeditorCategoryChange(editor, true);
		});
	}else{
		if (editor){
			editor.destroy();
		}
	}
}
</script>
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>" onclick="commitMethod ('save');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsCommonDocErrorCorrectionFlow"/></p>

<center>
<table id="Label_Tabel" width=95%>
<tr>
<td>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.docSubject"/>
		</td><td width="85%" colspan="3">
		<div style="cursor:hand" onclick="openMainWindow()"><U> ${ kmsCommonDocErrorCorrectionForm.docSubject} </U></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.dept"/>
		</td><td width="85%" colspan="3">
			${kmsCommonDocErrorCorrectionForm.docDeptName }
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%  colspan="4">
			<div style="line-height: 30px;">
				<img alt="请描述纠错原因" src="../resource/img/err.jpg" /><SPAN style="padding-bottom: 12px;height:30px"><bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.fdCorrectionOpinions.reason"/></SPAN><br/>
			</div>
			<xform:textarea property="docDescription" style="width:98%" showStatus="edit" />&nbsp;&nbsp;<span style="color: red;">*</span>
			<br/><br/>
			<a href="javascript:void(0);" onclick="openDocErrorReason();" style="color:blue;"><bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.fdCorrectionOpinions.error.reason"/></a>
			<br/><br/>
			<span id="docErrorReasonSpan"></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.docCreator"/>
		</td><td width="35%">
			${kmsCommonDocErrorCorrectionForm.docCreatorName}
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.docCreateTime"/>
		</td><td width="35%">
			${kmsCommonDocErrorCorrectionForm.docCreateTime }
		</td>
	</tr>
	</table>
	<br/><br/>
	<c:import url="/sys/lbpmservice/common/process_edit.jsp"
				charEncoding="UTF-8"> 
		<c:param name="formName" value="kmsCommonDocErrorCorrectionForm" />
		<c:param name="fdKey" value="knowledgeErrorCorrectionFlow" />
	</c:import>
	</td>
	</tr>
	<%-- 以下代码为嵌入流程标签的代码
	<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp"
		charEncoding="UTF-8"> 
		<c:param name="formName" value="kmsKnowledgeErrorCorrectionForm" />
		<c:param name="fdKey" value="knowledgeErrorCorrectionFlow" />
	</c:import> --%>
	<%-- 以上代码为嵌入流程标签的代码 --%>

</table>

</center>
<html:hidden property="fdId" /> 
<html:hidden property="fdModelId" />
<html:hidden property="docSubject"/> 
<html:hidden property="docStatus" />
<html:hidden property="docCreateTime" />
<html:hidden property="docCreatorId" />
<html:hidden property="docCreatorName" />
<html:hidden property="docErrorReason"/>
<html:hidden property="fdType"/>
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>