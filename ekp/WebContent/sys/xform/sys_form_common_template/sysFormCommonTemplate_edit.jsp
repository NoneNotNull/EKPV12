<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<c:set var="sysFormTemplateFormPrefix" value="" />
<c:set var="entityName" value="${param.fdMainModelName}_${sysFormCommonTemplateForm.fdId}" />
<kmss:windowTitle 
	moduleKey="sys-xform:xform.title" 
	subjectKey="sys-xform:tree.xform.def" 
	subject="${sysFormCommonTemplateForm.fdName}" />
<html:form
	action="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do"
	onsubmit="return validateSysFormCommonTemplateForm(this);">
	<html:hidden property="fdId" />
	<div id="optBarDiv">
	<c:if test="${sysFormCommonTemplateForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysFormCommonTemplateForm, 'update');">
	</c:if>
	<c:if test="${sysFormCommonTemplateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysFormCommonTemplateForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysFormCommonTemplateForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle">
		<bean:message bundle="sys-xform" key="table.sysFormCommonTemplate" />
	</p>

	<center>
	<c:if test="${sysFormCommonTemplateForm.method_GET=='add'}">
		<html:hidden property="fdModelName" value="${param.fdModelName }" />
		<html:hidden property="fdKey" value="${param.fdKey }" />
	</c:if>
	<c:if test="${sysFormCommonTemplateForm.method_GET=='edit'}">
		<html:hidden property="fdModelName" />
		<html:hidden property="fdKey" />
	</c:if>
	<table class="tb_normal" width=95% id="TB_FormTemplate_${param.fdKey}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-xform" key="sysFormCommonTemplate.fdName" />
			</td>
			<td>
				<html:text property="${sysFormTemplateFormPrefix}fdName" style="width:95%" />
				<span class="txtstrong">*</span>
			</td>
		</tr>
		<%@ include file="/sys/xform/base/sysFormTemplateDisplay_edit.jsp"%>
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script language="JavaScript">
Com_IncludeFile("dialog.js");
Com_Parameter.event["confirm"][Com_Parameter.event["confirm"].length] = XForm_ConfirmFormChangedEvent;

function XForm_ConfirmFormChangedEvent() {
	return XForm_ConfirmFormChangedFun();
}
Com_AddEventListener(window, "load", function() {
	XForm_DisplayFormRowSet();
	LoadXForm(document.getElementById('TD_FormTemplate_${param.fdKey}'));
});

if (window.$) {
		$("tr:visible *[onresize]").each(function(){
			var funStr = this.getAttribute("onresize");
			if(funStr!=null && funStr!=""){
				var tmpFunc = new Function(funStr);
				tmpFunc.call(this);
			}
		});
}
<%-- 
=====================================
 数据字典加载相关
===================================== 
--%>
var _xform_MainModelName = '${param.fdMainModelName}';

function _XForm_GetSysDictObj(modelName){
	return Formula_GetVarInfoByModelName(modelName);
}
function _XForm_GetSysDictObj_${param.fdKey}() {
	return _XForm_GetSysDictObj(_xform_MainModelName);
}
</script>
<html:javascript formName="sysFormCommonTemplateForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
