<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdDescription"/>
	</td><td>
		<span id="wf_${lbpmTemplateFormPrefix}description" name="wf_${lbpmTemplateFormPrefix}description"></span>
		<textarea name="${lbpmTemplateFormPrefix}fdFlowContent" style="display:none"><c:out value="${lbpmTemplateForm.fdFlowContent}"/></textarea>
	</td>
</tr>
<tr>
	<td colspan="2" id="WF_IF_${lbpmTemplateFormPrefix}Chart" onresize="LBPM_Template_LoadWFIFrame_${lbpmTemplate_Key}('${lbpmTemplateFormPrefix}');">
		<iframe width="100%" height="100%" scrolling="no" id="${lbpmTemplateFormPrefix}WF_IFrame"></iframe>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.processOptions"/>
	</td><td>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}rejectReturn" value="true" disabled>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.rejectReturn"/>
		</label>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}recalculateHandler" value="true" disabled>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.isRecalculate"/>
		</label>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyOptions"/>
	</td><td id="${lbpmTemplateFormPrefix}WF_TD_notifyType">
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyType"/>
		<kmss:showNotifyType value="" />
		<br>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}notifyOnFinish" value="true" disabled>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyOnFinish"/>			
		</label>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}notifyDraftOnFinish" value="true" disabled>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyDraftOnFinish"/>			
		</label>
		<br>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.dayOfNotifyPrivileger1"/>
		<input name="wf_${lbpmTemplateFormPrefix}dayOfNotifyPrivileger" class="inputread" style="text-align:center" value="0" size="3"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
		<input name="wf_${lbpmTemplateFormPrefix}hourOfNotifyPrivileger" class="inputread" style="text-align:center" value="0" size="3"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
		<input name="wf_${lbpmTemplateFormPrefix}minuteOfNotifyPrivileger" class="inputread" style="text-align:center" value="0" size="3"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.dayOfNotifyPrivileger2"/>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.privileger"/>
	</td><td>
		<span id="wf_${lbpmTemplateFormPrefix}privilegerNames" name="wf_${lbpmTemplateFormPrefix}privilegerNames"></span>
	</td>
</tr>
<script src="<c:url value="/sys/lbpm/flowchart/js/workflow.js"/>"></script>
<script>
Com_IncludeFile("jquery.js|data.js|docutil.js|doclist.js");

if(window.LBPM_Template_Prefix == null) {
	LBPM_Template_Prefix = new Array();
}
LBPM_Template_Prefix["${lbpmTemplate_Key}"] = "${lbpmTemplateFormPrefix}";

function LBPM_Template_LoadProcessData(key, prefix) {
	if(prefix == "") {
		LBPM_Template_LoadWFIFrame_${lbpmTemplate_Key}(prefix);
	}
	var content = document.getElementsByName(prefix + "fdFlowContent")[0].value;
	if(content != ""){
		var processData = WorkFlow_LoadXMLData(content);
		if(processData.description){
			var changedText = processData.description;
			// 还原换行符
			changedText = changedText.replace(/&#xD;/g, "\r");
			changedText = changedText.replace(/&#xA;/g, "\n");
			processData.description = changedText;
		}
		WorkFlow_PutDataToField(processData, function(propertyName){
			return "wf_"+prefix+propertyName;
		});
		WorkFlow_RefreshNotifyType(prefix+"WF_TD_notifyType", processData.notifyType);
	}
}
function LBPM_Template_LoadWFIFrame_${lbpmTemplate_Key}(prefix) {
	Doc_LoadFrame('WF_IF_'+prefix+'Chart', '<c:url value="/sys/lbpm/flowchart/page/panel.html" />?edit=false&extend=oa&template=true'
			+'&contentField='+prefix+'fdFlowContent&modelName=${lbpmTemplate_MainModelName}');
}
Com_AddEventListener(window, "load", function() {
	LBPM_Template_LoadProcessData("${lbpmTemplate_Key}", "${lbpmTemplateFormPrefix}");
});
</script>