<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
function openNewMultiDoc(){
	var sourceModelName='${sourceModelName}';
	var sourceModelId='${sourceModelId}';
	var fdKey='${fdKey}';
	var targetTemplateId='${targetTemplateId}';
	var targetTemplateName='${targetTemplateName}';
	var sysModulerelationTargetId = '${sysModulerelationTargetId}';
	var targetModelName ='com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge';
	var url="";
	if(sourceModelName != '' && sourceModelId != ''){
		url+="${request.localAddr}/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&kmModulerelation_docTypeId="+targetTemplateId+"&kmModulerelation_docTypeName="+encodeURIComponent(targetTemplateName)+"&modulerelation_sourceModelName="+sourceModelName+"&modulerelation_sourceModelId="+sourceModelId+"&modulerelation_key="+fdKey+"&modulerelation_targetId="+sysModulerelationTargetId;
	}
	Com_OpenWindow(url,"_black");
}
</script>
<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do">
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.add"/>" onclick="openNewMultiDoc();">
</div>
	<%@ include file="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge_list_content.jsp"%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
