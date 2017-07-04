<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.util.LbpmTemplateUtil" %>
<%@ include file="/resource/jsp/common.jsp" %>
<script>
Com_IncludeFile("jquery.js|dialog.js|formula.js");
</script>
<c:set var="lbpmTemplateForm" value="${requestScope[param.formName].sysWfTemplateForms[param.fdKey]}" />
<c:set var="lbpmTemplateFormPrefix" value="sysWfTemplateForms.${param.fdKey}." />
<c:set var="lbpmTemplate_ModelName" value="${requestScope[param.formName].modelClass.name}" />
<c:set var="lbpmTemplate_Key" value="${param.fdKey}" />
<%
	pageContext.setAttribute("lbpmTemplate_MainModelName",
			LbpmTemplateUtil.getMainModelName(
					(String)pageContext.getAttribute("lbpmTemplate_ModelName"),
					(String)pageContext.getAttribute("lbpmTemplate_Key")));
%>
<tr id="WF_TR_ID_${lbpmTemplate_Key}" style="display:none"
	LKS_LabelName="<kmss:message key="${not empty param.messageKey ? param.messageKey : 'sys-lbpmservice-support:lbpmTemplate.tab.label'}" />">
	<td>
		<table class="tb_normal" width="100%" id="TB_LbpmTemplate_${lbpmTemplate_Key}">
			<tr>
				<td width="15%" class="td_normal_title" valign="top">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType" />
				</td>
				<td width="85%">
					<xform:radio property="${lbpmTemplateFormPrefix}fdType"
						onValueChange="LBPM_Template_TypeChg(value, '${lbpmTemplate_Key}', '${lbpmTemplateFormPrefix}', true);" showStatus="edit">
						<xform:enumsDataSource enumsType="lbpmTemplate_fdType"></xform:enumsDataSource>
					</xform:radio>
					<a href="javascript:void(0)" id="A_LbpmTemplate_${lbpmTemplate_Key}" class="com_btn_link"
						onclick="LBPM_Template_Select('${lbpmTemplate_Key}', '${lbpmTemplateFormPrefix}', true);">
						<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.define.fromTemplate" />
					</a>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-lbpmservice-support" key="table.lbpmTemplate"/>
				</td>
				<td>
					<xform:dialog propertyId="${lbpmTemplateFormPrefix}fdCommonId" propertyName="${lbpmTemplateFormPrefix}fdCommonName" showStatus="edit" style="width:97%">
						LBPM_Template_Select('${lbpmTemplate_Key}', '${lbpmTemplateFormPrefix}');
					</xform:dialog>
				</td>
			</tr>
			<%@ include file="/sys/lbpmservice/support/lbpm_template/lbpmTemplate_sub_edit.jsp"%>
		</table>
	</td>
</tr>
<script>
if(window.LBPM_Template_Type == null) {
	LBPM_Template_Type = new Array();
}
LBPM_Template_Type["${lbpmTemplate_Key}"] = "${lbpmTemplateForm.fdType}";
// 切换引用方式
function LBPM_Template_TypeChg(value, key, prefix, isClick) {
	var tbObj = $("#TB_LbpmTemplate_"+key);
	if(value == "3") {
		// 自定义
		$("#A_LbpmTemplate_"+key).show();
		tbObj.find("tr:eq(1)").hide();
		tbObj.find("tr:gt(1)").show();
	} else {
		$("#A_LbpmTemplate_"+key).hide();
		if(value == "" || value =="1") {
			tbObj.find("tr:eq(1)").hide();
		} else {
			if(isClick) {
				$("input[name='"+prefix+"fdCommonId']").attr("value", "");
				$("input[name='"+prefix+"fdCommonName']").attr("value", "");
			}
			tbObj.find("tr:eq(1)").show();
		}
		tbObj.find("tr:gt(1)").hide();
	}
}
Com_AddEventListener(window, "load", function() {
	var key = "${lbpmTemplate_Key}", prefix = "${lbpmTemplateFormPrefix}";
	LBPM_Template_TypeChg("${lbpmTemplateForm.fdType}", key, prefix, false);
	// 添加标签切换事件
	var table = document.getElementById("WF_TR_ID_"+key);
	while((table != null) && (table.tagName.toLowerCase() != "table")){
		table = table.parentNode;
	}
	if(table != null && window.Doc_AddLabelSwitchEvent){
		Doc_AddLabelSwitchEvent(table, "LBPM_Template_OnLabelSwitch_"+key);
	}
});
//选择模板
function LBPM_Template_Select(key, prefix, callback) {
	var idField = null, nameField = null, action = null;
	if(callback) {
		action = function(rtnVal) {
			if(rtnVal == null) {
				return;
			}
			var data = new KMSSData();
			data.AddBeanData('lbpmTemplateService&fdId='+rtnVal.data[0].id);
			data.PutToField("fdFlowContent", prefix+"fdFlowContent");
			var iframe = document.getElementById(prefix+"WF_IFrame").contentWindow;
			iframe.location.reload();
			LBPM_Template_LoadProcessData(key, prefix);
		};
	} else {
		idField = prefix+'fdCommonId';
		nameField = prefix+'fdCommonName';
	}
	var typeVe = $("input[name='"+prefix+"fdType']:checked").val();
	Dialog_Tree(false, idField, nameField, null,
		'lbpmTemplateService&fdModelName=${lbpmTemplate_ModelName}&fdKey='+key+'&fdType='+typeVe,
		'<bean:message bundle="sys-lbpmservice-support" key="table.lbpmTemplate.common" />',
		null, action, null, null, true);
}

//提交校验
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
	var prefix = "${lbpmTemplateFormPrefix}";
	var typeVe = $("input[name='"+prefix+"fdType']:checked").val();
	if(typeVe == "2") {
		// 引用其他模板
		if($("input[name='"+prefix+"fdCommonId']").val() == "") {
			alert('<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdCommon.validate.isNull" />');
			return false;
		}
	} else {
		$("input[name='"+prefix+"fdCommonId']").attr("value", "");
		$("input[name='"+prefix+"fdCommonName']").attr("value", "");
	}
	if(LBPM_Template_Type["${lbpmTemplate_Key}"] != typeVe) {
		// 引用方式发生改变，标记流程定义需要修改
		$("input[name='"+prefix+"fdIsModified']").attr("value", "true");
	}
	return true;
}

//标签切换时加载公式信息
function LBPM_Template_OnLabelSwitch_${lbpmTemplate_Key}(tableName, index) {
	var trs = document.getElementById(tableName).rows;
	if(trs[index].id!="WF_TR_ID_${lbpmTemplate_Key}")
		return;
	var LBPM_Template_FormFieldList = null;
	if(window.XForm_getXFormDesignerObj_${lbpmTemplate_Key}) {
		LBPM_Template_FormFieldList = XForm_getXFormDesignerObj_${lbpmTemplate_Key}();
	} else {
		LBPM_Template_FormFieldList = Formula_GetVarInfoByModelName("${lbpmTemplate_MainModelName}");
	}
	document.getElementById("${lbpmTemplateFormPrefix}WF_IFrame").contentWindow.FlowChartObject.FormFieldList = LBPM_Template_FormFieldList;
}

// 对外提供流程节点
function LBPM_Template_getNodes${lbpmTemplate_Key}() {
	var typeVe = $("input[name='${lbpmTemplateFormPrefix}fdType']:checked").val();
	if(typeVe == "3") {// 自定义
		var FlowChartObject = document.getElementById("${lbpmTemplateFormPrefix}WF_IFrame").contentWindow.FlowChartObject;
		return LBPM_Template_getNodes(FlowChartObject.BuildFlowData());
	} else if (typeVe == "2") {// 其它
		var commonId = $("input[name='${lbpmTemplateFormPrefix}fdCommonId']").val();
		if (commonId == '') {
			return [];
		}
		var rtn = [];
		var data = new KMSSData();
		var url = "<c:url value='/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do'/>?method=findNodes&tempId=";
		data.SendToUrl(url + commonTemplateEl.value, function(rq){
			var xml = rq.responseText;
			if (xml.indexOf('<error>') > -1) {
				alert(xml);
				rtn = [];
			} else {
				rtn = LBPM_Template_getNodes(WorkFlow_LoadXMLData(xml));
			}
		}, false);
		return rtn;
	} else if (typeVe == "1") {// 取默认
		var rtn = [];
		var data = new KMSSData();
		var url = "<c:url value='/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do'/>?method=findNodes&modelName=${lbpmTemplate_ModelName}&key=${lbpmTemplate_Key}";
		data.SendToUrl(url, function(rq){
			var xml = rq.responseText;
			if (xml.indexOf('<error>') > -1) {
				alert(xml);
				rtn = [];
			} else {
				rtn = LBPM_Template_getNodes(WorkFlow_LoadXMLData(xml));
			}
		}, false);
		return rtn;
	}
}
function LBPM_Template_getNodes(processData) {
	var nodes = [];
	for(var i=0; i<processData.nodes.length; i++) {
		var n = processData.nodes[i];
		var desc = lbpm.nodedescs[lbpm.nodeDescMap[n.XMLNODENAME]];
		if (desc.isHandler(n)) {
			nodes.push({value:n.id,name:n.name,type:n.XMLNODENAME});
		}
	}
	return nodes;
}

// 兼容旧流程
var WorkFlow_getWfNodes_${lbpmTemplate_Key} = LBPM_Template_getNodes${lbpmTemplate_Key};

<c:import url="/sys/lbpm/flowchart/page/plugin_descs_loader.jsp" charEncoding="UTF-8">
	<c:param name="modelName">${lbpmTemplate_MainModelName}</c:param>
</c:import>
</script>