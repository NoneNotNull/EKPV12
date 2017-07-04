<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("data.js|dialog.js|jquery.js");
	Com_IncludeFile("tag.js","${KMSS_Parameter_ContextPath}sys/tag/resource/js/","js",true);
</script>
<c:set var="tag_MainForm" value="${requestScope[param.formName]}"/>
<c:set var="sysTagMainForm" value="${tag_MainForm.sysTagMainForm}"/>
<c:set var="tag_modelName" value="${tag_MainForm.modelClass.name}"/>
<Script type="text/javascript">
	var tag_params = {
			"model":"edit",
			"fdQueryCondition":"${param.fdQueryCondition}",
			"tag_msg1":"<bean:message bundle='sys-tag' key='sysTagMain.message.1'/>",
			"tag_msg2":"<bean:message bundle='sys-tag' key='sysTagMain.message.2'/>",
			"tree_title":"<bean:message key='sysTagTag.tree' bundle='sys-tag'/>"
			};
	if(window.tag_opt==null){
		window.tag_opt = new TagOpt('${tag_modelName}','${sysTagMainForm.fdModelId}','${param.fdKey}',tag_params);
	}
	Com_AddEventListener(window,'load',function(){
			window.tag_opt.onload(); 
		});
</script>
<tr>
	<html:hidden property="sysTagMainForm.fdId"/> 
	<html:hidden property="sysTagMainForm.fdKey" value="${param.fdKey}"/>
	<html:hidden property="sysTagMainForm.fdModelName"/>
	<html:hidden property="sysTagMainForm.fdModelId"/> 
	<html:hidden property="sysTagMainForm.fdQueryCondition"/> 
	<td class="td_normal_title" width=15% nowrap>
		<bean:message bundle="sys-tag" key="table.sysTagTags"/>
	</td>
	<td colspan="3">
		<input type="hidden" name="sysTagMainForm.fdTagIds" value="${sysTagMainForm.fdTagNames}"/>
		<div class="inputselectsgl"  style="width:98%">
			<div class="input">
				<html:text property="sysTagMainForm.fdTagNames" styleClass=""/>
			</div>
			<div class="selectitem" id="tag_selectItem">
			</div>
		</div>
		<div class="tag_prompt_area" id="id_application_div">
            <p><bean:message bundle="sys-tag" key="sysTagMain.message.0"/></p>
            <p id="hot_id"><bean:message bundle="sys-tag" key="sysTagMain.message.1"/></p>
            <p id="used_id"><bean:message bundle="sys-tag" key="sysTagMain.message.2"/></p>
        </div>
	</td>	
</tr>

