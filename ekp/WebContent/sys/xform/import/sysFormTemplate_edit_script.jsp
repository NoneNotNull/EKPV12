<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.xform.XFormConstant"%>
<script>
Com_IncludeFile("dialog.js");
Com_Parameter.event["confirm"][Com_Parameter.event["confirm"].length] = XForm_ConfirmFormChangedEvent;

//确认表单被改动时是否存成新版本
function XForm_ConfirmFormChangedEvent(){
	var fdModeObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdMode");
	var fdModelValue = 0;
	for(var i = 0; i < fdModeObj.length; i++){
		if(fdModeObj[i].checked){
			fdModelValue = fdModeObj[i].value;
			break;
		}
	}
	if(fdModelValue == "<%=XFormConstant.TEMPLATE_DEFINE%>"){
		return XForm_ConfirmFormChangedFun();
	}
	return true;
}
<%-- 0 引用方式； 1 模板； 2 页面类型；3 已定义表单；4 自设计 --%>
function Form_ChgDisplay(key, value){
	var tbObj = document.getElementById("TB_FormTemplate_"+key);
	var loadLink = document.getElementById("A_FormTemplate_"+key);
	if(value=="<%=XFormConstant.TEMPLATE_DEFINE%>"){
		loadLink.style.display = "";
		tbObj.rows[1].style.display = "none";
		tbObj.rows[2].style.display = "none";
		tbObj.rows[3].style.display = "";
		XForm_DisplayFormRowSet();
		if ($) {
			$(tbObj).find("tr:visible *[onresize]").each(function(){
				var funStr = this.getAttribute("onresize");
				if(funStr!=null && funStr!=""){
					var tmpFunc = new Function(funStr);
					tmpFunc.call(this);
				}
			});
		}
	}else{
		tbObj.rows[1].style.display = (value=="" || value=="<%=XFormConstant.TEMPLATE_NOTUSE%>")?"none":"";
		tbObj.rows[2].style.display = (value=="" || value=="<%=XFormConstant.TEMPLATE_NOTUSE%>")?"none":"";
		loadLink.style.display = "none";
		for(var i=3; i<tbObj.rows.length; i++){
			tbObj.rows[i].style.display = "none";
		}
	}
	if (typeof XForm_Mode_Listener != 'undefined') {
		XForm_Mode_Listener(key, value);
	}
}
function Form_GetModeElements(key) {
	return document.getElementsByName('sysFormTemplateForms.'+key+'.fdMode');
}
<%-- 选取通用模板 --%>
function Form_SelectTemplate(key, callback){
	var attrs = {oldId:document.getElementById('sysFormTemplateForms.'+key+'.fdCommonTemplateId').value
		,oldName:document.getElementById('sysFormTemplateForms.'+key+'.fdCommonTemplateName').value};
	var action = null;
	if(callback){
		var idField = null;
		var nameField = null;
		action = function(rtnVal){
			if(rtnVal==null)
				return;
			var data = new KMSSData();
			data.AddBeanData('sysFormCommonTemplateTreeService&fdModelName=${sysFormTemplateForm.modelClass.name}&fdKey='+key+'&fdId='+rtnVal.data[0].id);
			<%--data.PutToField("fdDescription:fdFormContent",
			"form_sysFormTemplateForms."+key+".description:sysFormTemplateForms."+key+".fdFormContent");
			var iframe = document.getElementById("${sysFormTemplateFormPrefix}Form_IFrame").contentWindow;
			iframe.location.reload();--%>
			var html = data.GetHashMapArray()[0]['fdDesignerHtml'];
			var iframe = document.getElementById('IFrame_FormTemplate_' + key);
			iframe.contentWindow.Designer.instance.setHTML(html);
		};
	}else{
		var idField = 'sysFormTemplateForms.'+key+'.fdCommonTemplateId';
		var nameField = 'sysFormTemplateForms.'+key+'.fdCommonTemplateName';
		action = function(rtnVal) {
			if(rtnVal==null)
				return;
			var data = new KMSSData();
			data.AddBeanData('sysFormCommonTemplateTreeService&fdId='+rtnVal.data[0].id);
			var html = data.GetHashMapArray()[0]['fdDesignerHtml'];
			var iframe = document.getElementById('sysFormTemplateForms.' + key + '.fdCommonTemplateView');
			iframe.contentWindow.document.body.innerHTML = html;
		};
	}
	Dialog_Tree(false, idField, nameField, null,
		'sysFormCommonTemplateTreeService&fdModelName=${sysFormTemplateForm.modelClass.name}&fdKey='+key,
		'<bean:message bundle="sys-xform" key="sysForm.tree.title" />',
		null, action, null, null, true);
}

function Form_ShowCommonTemplatePreview(key) {
	var id = document.getElementById('sysFormTemplateForms.'+key+'.fdCommonTemplateId');
	if (id != null && id.value != '') {
		var data = new KMSSData();
		data.AddBeanData('sysFormCommonTemplateTreeService&fdId=' + id.value);
		var html = data.GetHashMapArray()[0]['fdDesignerHtml'];
		var iframe = document.getElementById('${sysFormTemplateFormPrefix}fdCommonTemplateView');
		iframe.contentWindow.document.body.innerHTML = html;
	}
}

Com_AddEventListener(window, "load", function(){
	Form_ChgDisplay("${param.fdKey}", Form_getModeValue("${param.fdKey}"));
	Form_ShowCommonTemplatePreview("${param.fdKey}");
});

Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = Form_TemplateValidate_${param.fdKey};
function Form_TemplateValidate_${param.fdKey}(){
	var typeVe = Form_getModeValue("${param.fdKey}");
	var commonTemplateEl = document.getElementById('${sysFormTemplateFormPrefix}fdCommonTemplateId');
	if(!commonTemplateEl){
		commonTemplateEl = document.getElementsByName('${sysFormTemplateFormPrefix}fdCommonTemplateId')[0];
	}
	if(typeVe=="<%=XFormConstant.TEMPLATE_OTHER%>"
		&& commonTemplateEl.value==""){
		alert("<bean:message bundle="sys-xform" key="sysFormTemplate.fdCommonName" /><bean:message bundle="sys-xform" key="validate.isNull" />");
		return false;
	}
	return true;
}

function Form_getModeValue(key){
	var typeEl = document.getElementsByName('sysFormTemplateForms.'+key+'.fdMode');
	var typeVe = "";
	for(var i=0;i<typeEl.length;i++){
		if(typeEl[i].checked){
			typeVe = typeEl[i].value;
			break;
		}
	}
	return typeVe;
}

function XForm_loadXFormCustomXML(){
	var fdMetadataXmlObj = document.getElementById("${sysFormTemplateFormPrefix}fdMetadataXml");
	var customIframe = window.frames['IFrame_FormTemplate_${param.fdKey}'];
	if(customIframe.Designer != null && customIframe.Designer.instance != null){
		fdMetadataXmlObj.value = customIframe.Designer.instance.getXML();
	}
}
<%-- 
=====================================
 数据字典加载相关
===================================== 
--%>
var _xform_MainModelName = '${param.fdMainModelName}';

function XForm_Util_GetRadioValue(objs) {
	for(var i = 0; i < objs.length; i++){
		if(objs[i].checked){
			return objs[i].value;
		}
	}
	return null;
}

function XForm_Util_UnitArray(array, sysArray, extArray) {
	<%-- // 合并 --%>
	array = array.concat(sysArray);
	if (extArray != null) {
		array = array.concat(extArray);
	}
	<%-- // 结果 --%>
	return array;
}

function XForm_getXFormDesignerObj_${param.fdKey}() {
	var obj = [];
	
	<%-- // 1 加载系统字典 --%>
	var sysObj = _XForm_GetSysDictObj(_xform_MainModelName);
	var extObj = null;
	
	<%-- // 2 判断是否启用表单 --%>
	var modeObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdMode");
	var modeValue = XForm_Util_GetRadioValue(modeObj);
	
	if (modeValue == '1') { return sysObj; }
	
	if (modeValue == '2') { // 加载通用模板
		var tempIdObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdCommonTemplateId");
		if (tempIdObj.length > 0 && tempIdObj[0].value != '') {
			extObj = _XForm_GetCommonExtDictObj(tempIdObj[0].value);
			return XForm_Util_UnitArray(obj, sysObj, extObj);
		}
		return sysObj;
	}
	
	<%-- //if (modeValue == '3') {} // 自定义情况下 --%>
	
	<%-- // 3 判断页面类型 --%>
	var fdTypeObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdDisplayType");
	var fdTypeValue = XForm_Util_GetRadioValue(fdTypeObj);
	
	if (fdTypeValue == '1') {
		var exitFileObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdFormFileName")[0];
		var exitFileValue = exitFileObj.value;
		if (exitFileValue == '') {
			return sysObj;
		}
		extObj = _XForm_GetExitFileDictObj(exitFileValue);
		return XForm_Util_UnitArray(obj, sysObj, extObj);
	}
	
	<%-- //if (fdTypeValue == '2') {} // 数据类型 --%>
	var customIframe = window.frames['IFrame_FormTemplate_${param.fdKey}'];
	if (customIframe.Designer && customIframe.Designer.instance && customIframe.Designer.instance.hasInitialized) {
		var designer = customIframe.Designer.instance;
		extObj = designer.getObj();
	} else {
		extObj = _XForm_GetTempExtDictObj('${xFormTemplateForm.fdId}');
	}
	return XForm_Util_UnitArray(obj, sysObj, extObj);
}

function _XForm_GetTempExtDictObj(tempId) {
	return new KMSSData().AddBeanData("sysFormDictVarTree&tempType=template&tempId="+tempId).GetHashMapArray();
}
function _XForm_GetCommonExtDictObj(tempId) {
	return new KMSSData().AddBeanData("sysFormDictVarTree&tempType=common&tempId="+tempId).GetHashMapArray();
}
function _XForm_GetExitFileDictObj(fileName) {
	return new KMSSData().AddBeanData("sysFormDictVarTree&tempType=file&fileName="+fileName).GetHashMapArray();
}
function _XForm_GetSysDictObj(modelName){
	return Formula_GetVarInfoByModelName(modelName);
}
function _XForm_GetSysDictObj_${param.fdKey}() {
	return _XForm_GetSysDictObj(_xform_MainModelName);
}

function XForm_OnLabelSwitch_${param.fdKey}() {
	var customIframe = window.frames['IFrame_FormTemplate_${param.fdKey}'];
	if (customIframe.Designer && customIframe.Designer.instance && customIframe.Designer.instance.hasInitialized) {
		customIframe.Designer.instance.fireListener('designerBlur');
	}
}

// 设置获取流程节点函数
Com_AddEventListener(window, 'load', function () {
	if (window.WorkFlow_getWfNodes_${param.fdKey} != null) {
		var iframe = document.getElementById('IFrame_FormTemplate_${param.fdKey}');
		if (iframe) {
			Com_AddEventListener(iframe, 'load', function () {
				iframe.contentWindow.XForm_GetWfAuditNodes = WorkFlow_getWfNodes_${param.fdKey};
			});
		}
	}
	var table = document.getElementById("TB_FormTemplate_${param.fdKey}").parentNode;
	while((table!=null) && (table.tagName!="TABLE")){
		table = table.parentNode;
	}
	if(table!=null && window.Doc_AddLabelSwitchEvent){
		Doc_AddLabelSwitchEvent(table, "XForm_OnLabelSwitch_${param.fdKey}");
	}
});
</script>