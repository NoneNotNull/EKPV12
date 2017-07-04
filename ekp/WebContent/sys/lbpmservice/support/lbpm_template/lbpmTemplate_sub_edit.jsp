<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdDescription"/>
	</td><td>
		<html:hidden property="${lbpmTemplateFormPrefix}fdModelName" value="${lbpmTemplate_ModelName}" />
		<html:hidden property="${lbpmTemplateFormPrefix}fdKey" value="${lbpmTemplate_Key}" />
		<html:hidden property="${lbpmTemplateFormPrefix}fdId" />
		<html:textarea property="${lbpmTemplateFormPrefix}fdFlowContent" style="display:none"/>
		<html:hidden property="${lbpmTemplateFormPrefix}fdIsModified" />
		<textarea name="wf_${lbpmTemplateFormPrefix}description" style="width:97%"></textarea>
	</td>
</tr>
<tr>
	<td colspan="2">
		<iframe ${_lbpm_panel_src_prefix}src="<c:url value="/sys/lbpm/flowchart/page/panel.html" />?edit=true&extend=oa&template=true&contentField=${lbpmTemplateFormPrefix}fdFlowContent&modelName=${lbpmTemplate_MainModelName}&FormFieldList=WF_FormFieldList_${lbpmTemplate_Key}"
			style="width:100%;height:500px" scrolling="no" id="${lbpmTemplateFormPrefix}WF_IFrame"></iframe>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.processOptions"/>
	</td><td>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}rejectReturn" value="true">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.rejectReturn"/>
		</label>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}recalculateHandler" value="true" 
				checked onclick="LBPM_Template_ChangeRecalculateHandler(this, '${lbpmTemplateFormPrefix}');">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.isRecalculate"/>
		</label>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.processPopedom"/>
	</td><td>
		<a href="javascript:void(0)" onclick="LBPM_Template_ChangeProcessPopedom('${lbpmTemplateFormPrefix}');">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.processPopedomModify"/>
		</a>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyOptions"/>
	</td><td id="${lbpmTemplateFormPrefix}WF_TD_notifyType">
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyType"/>
		<kmss:editNotifyType property="wf_${lbpmTemplateFormPrefix}notifyType" value="" /><span class="txtstrong">*</span>
		<br>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}notifyOnFinish" value="true" checked="checked">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyOnFinish"/>
		</label>
		<label>
			<input type="checkbox" name="wf_${lbpmTemplateFormPrefix}notifyDraftOnFinish" value="true" checked="checked">
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.notifyDraftOnFinish"/>
		</label>
		<br>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.dayOfNotifyPrivileger1"/>
		<input name="wf_${lbpmTemplateFormPrefix}dayOfNotifyPrivileger" class="inputsgl" style="text-align:center" value="0" size="3"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
		<input name="wf_${lbpmTemplateFormPrefix}hourOfNotifyPrivileger" class="inputsgl" style="text-align:center" value="0" size="3"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
		<input name="wf_${lbpmTemplateFormPrefix}minuteOfNotifyPrivileger" class="inputsgl" style="text-align:center" value="0" size="3"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.dayOfNotifyPrivileger2"/>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.privileger"/>
	</td><td>
		<input type="hidden" name="wf_${lbpmTemplateFormPrefix}privilegerIds">
		<input name="wf_${lbpmTemplateFormPrefix}privilegerNames" readonly class="inputsgl" style="width:95%">
		<a href="javascript:void(0)" onclick="Dialog_Address(true, 'wf_${lbpmTemplateFormPrefix}privilegerIds', 'wf_${lbpmTemplateFormPrefix}privilegerNames', null, ORG_TYPE_POSTORPERSON|ORG_TYPE_ROLE);">
		<bean:message key="dialog.selectOrg"/></a>
	</td>
</tr>
<script src="<c:url value="/sys/lbpm/flowchart/js/workflow.js"/>"></script>
<script>
Com_IncludeFile("jquery.js|data.js");

if(window.LBPM_Template_Prefix == null) {
	LBPM_Template_Prefix = new Array();
}
LBPM_Template_Prefix["${lbpmTemplate_Key}"] = "${lbpmTemplateFormPrefix}";

// 流程图初始内容，用于比较流程图内容是否有修改
if(window.LBPM_Template_InitFlowContent == null) {
	LBPM_Template_InitFlowContent = new Array();
}

// 数据初始化
function LBPM_Template_LoadProcessData(key, prefix) {
	var content = $("textarea[name='"+prefix+"fdFlowContent']").val();
	if(content == "") {
		LBPM_Template_InitFlowContent[key] = "";
		// 设置特权人默认通知天数
		var _dayOfNotifyPrivileger = document.getElementsByName("wf_" + prefix + "dayOfNotifyPrivileger")[0];
		if(_dayOfNotifyPrivileger) {
			_dayOfNotifyPrivileger.value = "15";
		}
		// 设置默认通知方式
		new KMSSData().AddBeanData("lbpmBaseInfoService").PutToField("defaultNotifyType", "wf_" + prefix + "notifyType");
	} else {
		var processData = WorkFlow_LoadXMLData(content);
		LBPM_Template_InitFlowContent[key] = WorkFlow_BuildXMLString(processData, "process");
		if(processData.description){
			var changedText = processData.description;
			// 还原换行符
			changedText = changedText.replace(/&#xD;/g, "\r");
			changedText = changedText.replace(/&#xA;/g, "\n");
			processData.description = changedText;
		}
		WorkFlow_PutDataToField(processData, function(propertyName){
			return "wf_" + prefix + propertyName;
		});
	}
	var field = $("input[name='wf_"+prefix+"notifyType']").val();
	WorkFlow_RefreshNotifyType(prefix+"WF_TD_notifyType", field);
}
Com_AddEventListener(window, "load", function() {
	LBPM_Template_LoadProcessData("${lbpmTemplate_Key}", "${lbpmTemplateFormPrefix}");
});
// 提交校验
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
	var key = "${lbpmTemplate_Key}", prefix = "${lbpmTemplateFormPrefix}";
	if(LBPM_Template_InitFlowContent[key] == null) {
		return false;
	}
	var FlowChartObject = LBPM_Template_GetFlowChartWindow(prefix).FlowChartObject;
	if(!FlowChartObject.CheckFlow(true)) {
		// 流程图校验
		return false;
	}
	var processData = FlowChartObject.BuildFlowData();
	processData['orgAttribute'] = "privilegerIds:privilegerNames";
	WorkFlow_GetDataFromField(processData, function(fieldName) {
		if(fieldName.substring(0,3) != "wf_") {
			return null;
		}
		fieldName = fieldName.substring(3);
		var index = fieldName.lastIndexOf(".");
		if(index > -1) {
			fieldName = fieldName.substring(index+1);
		}
		return fieldName;
	}, document.getElementById("TB_LbpmTemplate_"+key));
	// 通知特权人天数必须为正整数
	if((processData.dayOfNotifyPrivileger && /\D/gi.test(processData.dayOfNotifyPrivileger))
			|| (processData.hourOfNotifyPrivileger && /\D/gi.test(processData.hourOfNotifyPrivileger))
			|| (processData.minuteOfNotifyPrivileger && /\D/gi.test(processData.minuteOfNotifyPrivileger))) {
		alert('<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.validate.dayOfNotifyPrivileger"/>');
		return false;
	}
	// 通知方式不能为空
	if(processData.notifyType != null && processData.notifyType == "") {
		alert('<bean:message key="lbpmTemplate.validate.notifyType.isNull" bundle="sys-lbpmservice-support"/>');
		return false;
	}
	//流程描述替换换行符
	if(processData.description) {
		var changedText = processData.description;
		changedText = changedText.replace(/\r/g, "&#xD;");
		changedText = changedText.replace(/\n/g, "&#xA;");
		processData.description = changedText;
	}
	// 设置流程内容
	var xml = WorkFlow_BuildXMLString(processData, "process");
	$("textarea[name='"+prefix+"fdFlowContent']").val(xml);
	// 比较流程内容是否修改
	var _fdIsModified = $("input[name='"+prefix+"fdIsModified']");
	if(LBPM_Template_InitFlowContent[key] != xml || _fdIsModified.val() == 'true') {
		_fdIsModified.val("true");
	} else {
		_fdIsModified.val("false");
	}
	return true;
};
// 流程图页面Window对象
function LBPM_Template_GetFlowChartWindow(prefix) {
	return document.getElementById(prefix+"WF_IFrame").contentWindow;
}
// 是否重新计算处理人
function LBPM_Template_ChangeRecalculateHandler(checkbox, prefix) {
	var FlowChartObject = LBPM_Template_GetFlowChartWindow(prefix).FlowChartObject;
	FlowChartObject.ProcessData.recalculateHandler = checkbox.checked ? "true" : "false";
}
// 修改流程权限
function LBPM_Template_ChangeProcessPopedom(prefix) {
	Com_EventPreventDefault();
	var chartWindow = LBPM_Template_GetFlowChartWindow(prefix);
	var width = 640;
	var height = 480;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	var parameter={FlowChartObject:chartWindow.FlowChartObject,Window:chartWindow};
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		window.showModalDialog('<c:url value="/sys/lbpm/flowchart/page/process_popedom_modify_content.html"/>', parameter, winStyle);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = parameter;
		window.open('<c:url value="/sys/lbpm/flowchart/page/process_popedom_modify_content.html"/>', "_blank", winStyle);
	}
	
}
</script>