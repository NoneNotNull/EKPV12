<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do">
<script >
// 提交表单
function commitMethod(method, saveDraft){
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
	var fdId = '${kmsCommonDocErrorCorrectionForm.fdModelId}';
	Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=view&fdId='+fdId);
}
</script>
<div id="optBarDiv">
	<c:if test="${kmsCommonDocErrorCorrectionForm.docStatus!='30'}">
		<input type=button value="<bean:message key="button.update"/>" onclick="commitMethod ('save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsCommonDocErrorCorrectionFlow"/></p>

<center>
<table id="Label_Tabel" width=95%>
<tr LKS_LabelName="<bean:message bundle='kms-common'  key='table.kmsCommonDocErrorCorrectionFlow' />">
<td>
<table class="tb_normal" width=95%>
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
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.fdCorrectionOpinions"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="docDescription" style="width:85%" showStatus="view" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonDocErrorCorrection.fdCorrectionOpinions.error.reason"/>
		</td><td width="85%" colspan="3">
			${ kmsCommonDocErrorCorrectionForm.docErrorReason}
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
	</c:import>--%>
	<%-- 以上代码为嵌入流程标签的代码 --%>

</table>

</center>
<html:hidden property="fdId" /> 
<html:hidden property="fdModelId" /> 
<html:hidden property="docStatus" />
<html:hidden property="docCreateTime" />
<html:hidden property="docCreatorId" />
<html:hidden property="docCreatorName" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>