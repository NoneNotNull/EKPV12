<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.xform.base.config.*" %>
<html:hidden property="${sysFormTemplateFormPrefix}fdDesignerHtml" />
<html:hidden property="${sysFormTemplateFormPrefix}fdMetadataXml" />
<%-- <html:hidden property="${sysFormTemplateFormPrefix}fdDisplayJsp" /> --%>
<%-- <html:hidden property="${sysFormTemplateFormPrefix}fdDisplayType" /> --%>
<%-- <html:hidden property="${sysFormTemplateFormPrefix}fdFormFileName" /> --%>
<html:hidden property="${sysFormTemplateFormPrefix}fdIsChanged" />
<html:hidden property="${sysFormTemplateFormPrefix}fdSaveAsNewEdition" />
<html:hidden property="${sysFormTemplateFormPrefix}fdIsUpTab" />
<%-- 页面类型 --%> 
<tbody style="display:none;"><%-- 目前隐藏此行显示  --%> 
<tr style="display:none;">
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-xform" key="XFormTemplate.desplayType" />
	</td>
	<td>
		<sunbor:enums property="${sysFormTemplateFormPrefix}fdDisplayType"
			enumsType="sysFormTemplate_displayType" 
			elementType="radio" 
			htmlElementProperties="onclick=XForm_DisplayFormRow(this.value);"/>
	</td>
</tr>
</tbody>
<%-- 已定义表单 --%>
<%
request.setAttribute("sysFormList", ConfigModel.getInstance().getFormPages(request.getParameter("fdMainModelName")));
%>
<tr id="XForm_${param.fdKey}_DefinedTemplateRow" style="display:none;">
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-xform" key="sysFormCommonTemplate.fdFormFileName" />
	</td>
	<td>
		<c:if test="${empty sysFormList}">
			<bean:message bundle="sys-xform" key="xform.page.noPage" />
		</c:if>
		<c:if test="${not empty sysFormList}">
		<html:select property="${sysFormTemplateFormPrefix}fdFormFileName">
			<html:options collection="sysFormList" 
				property="formFileName"
				labelProperty="label" />
		</html:select>
		</c:if>
	</td>
</tr>
<%-- 自设计 --%>
<tr id="XForm_${param.fdKey}_CustomTemplateRow" style="display:none">
	<td class="td_normal_title" colspan=4
		id="TD_FormTemplate_${param.fdKey}" ${sysFormTemplateFormResizePrefix}onresize="LoadXForm('TD_FormTemplate_${param.fdKey}');">
		<iframe id="IFrame_FormTemplate_${param.fdKey}" width="100%" height="100%" scrolling="yes" FRAMEBORDER=0></iframe>
	</td>
</tr>
<%-- 显示高级选项  --%>
<tr id="XForm_${param.fdKey}_AdminTemplateRow" style="display:none;">
	<td class="td_normal_title" colspan="2">
		<label>
			<input id="XForm_${param.fdKey}_AdminTemplateCheckbox" type="checkbox" onclick="XForm_ShowAdminItems_${param.fdKey}(this.checked);">
			<bean:message bundle="sys-xform" key="XFormTemplate.adminItems" />
		</label>
	</td>
</tr>
<%-- 表单存取定义
<tr id="XForm_${param.fdKey}_DBTemplateRow" style="display:none;">
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-xform" key="XFormTemplate.dbDefine" />
	</td>
	<td>
		<a href="javascript:void(0);" onclick="XForm_OpenDBDefine();">
			<bean:message bundle="sys-xform" key="XFormTemplate.dbDefineLink" />
		</a>
		<input type="hidden" id="entityName" value="${entityName}">
		<html:hidden styleId="${param.fdKey}_formEntityName" property="${sysFormTemplateFormPrefix}fdFormEntityName" />
	</td>
</tr>
--%>
<%
request.setAttribute("sysFormEvents", ModelEventConfig.getEvents(request.getParameter("fdMainModelName")));
%>
<%-- 表单存取事件扩充 --%>
<tr id="XForm_${param.fdKey}_EventTemplateRow" style="display:none;">
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-xform" key="XFormTemplate.eventDefine" />
	</td>
	<td>
		<html:select property="${sysFormTemplateFormPrefix}fdFormEvent" 
				styleId="extendDaoEventBean" 
				onchange="this.isChanged='true';">
			<html:option value=""><bean:message bundle="sys-xform" key="xform.event.select" /></html:option>
			<html:options collection="sysFormEvents" 
				property="daoBean"
				labelProperty="label" />
		</html:select>
		<div>
		<bean:message bundle="sys-xform" key="XFormTemplate.eventDefineHint" />
		</div>
	</td>
</tr>
<%@include file="template_script.jsp" %>
<script type="text/javascript">Com_IncludeFile("docutil.js|security.js|dialog.js|formula.js");</script>
<script>
function LoadXForm(dom) {
	XForm_Loading_Show();
	Doc_LoadFrame(dom, '<c:url value="/sys/xform/designer/designPanel.jsp?fdKey=" />${param.fdKey}&fdModelName=${sysFormTemplateForm.modelClass.name}&sysFormTemplateFormPrefix=${sysFormTemplateFormPrefix}');
	var frame = document.getElementById('IFrame_FormTemplate_${param.fdKey}');
	Com_AddEventListener(frame, 'load', XForm_Loading_Hide);
}
function XForm_DisplayFormRowSet() {
	var radios = document.getElementsByName("${sysFormTemplateFormPrefix}fdDisplayType");
	for (var i = radios.length - 1; i >= 0; i --) {
		if (radios[i].checked) {
			XForm_DisplayFormRow(radios[i].value);
		}
	}
}
function XForm_ShowAdminItems_${param.fdKey}(show) {
	<%-- var dbTemplateRow = document.getElementById("XForm_${param.fdKey}_DBTemplateRow"); --%>
	var eventTemplateRow = document.getElementById("XForm_${param.fdKey}_EventTemplateRow");
	if (show) {
		<%-- dbTemplateRow.style.display = ""; --%>
		eventTemplateRow.style.display = "";
	} else {
		<%-- dbTemplateRow.style.display = "none"; --%>
		eventTemplateRow.style.display = "none";
	}
}
function XForm_callResizeFun(dom) {
	$(dom).find("*[${sysFormTemplateFormResizePrefix}onresize]").each(function(){
		if (!$(this).is(':visible'))
			return;
		var funStr = this.getAttribute("${sysFormTemplateFormResizePrefix}onresize");
		if(funStr!=null && funStr!=""){
			var tmpFunc = new Function(funStr);
			tmpFunc.call();
		}
	});
}
function XForm_DisplayFormRow(type){
	var definedTemplateRow = document.getElementById("XForm_${param.fdKey}_DefinedTemplateRow");
	var customTemplateRow = document.getElementById("XForm_${param.fdKey}_CustomTemplateRow");
	var adminTemplateRow = document.getElementById("XForm_${param.fdKey}_AdminTemplateRow");
	var adminCheckbox = document.getElementById("XForm_${param.fdKey}_AdminTemplateCheckbox");
	if(type=='1'){
		definedTemplateRow.style.display = "";
		var select = definedTemplateRow.getElementsByTagName('select');
		if (select.length > 0) {select[0].disabled = false;}
		customTemplateRow.style.display = "none";
		adminTemplateRow.style.display = "none";
		XForm_ShowAdminItems(false);
		adminCheckbox.checked = false;
	}else{
		definedTemplateRow.style.display = "none";
		var select = definedTemplateRow.getElementsByTagName('select');
		if (select.length > 0) {select[0].disabled = true;}
		customTemplateRow.style.display = "";
		adminTemplateRow.style.display = "";
	}

	XForm_callResizeFun(customTemplateRow);
	XForm_callResizeFun(adminTemplateRow);
	
	var diplayType = document.getElementsByName('${sysFormTemplateFormPrefix}fdDisplayType');
	var select = definedTemplateRow.getElementsByTagName('select');
	if (select.length == 0) {
		for (var i = 0; i < diplayType.length; i ++) {
			if (diplayType[i].value == '1') {
				diplayType[i].disabled = true;
				return;
			}
		}
	}
}

//确认表单被改动时是否存成新版本
function XForm_ConfirmFormChangedFun(){
	var isClone = "${requestScope['isCloneAction']}";
	var fdTypeObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdDisplayType");
	var fdTypeValue = "0";
	for(var i = 0; i < fdTypeObj.length; i++){
		if(fdTypeObj[i].checked){
			fdTypeValue = fdTypeObj[i].value;
			break;
		}
	}
	if(fdTypeValue == "2"){
		var fdDesignerHtmlObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdDesignerHtml")[0];
		var fdMetadataXmlObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdMetadataXml")[0];
		var customIframe = window.frames['IFrame_FormTemplate_${param.fdKey}'];
		var fdDesignerHtml = null;
		var fdIsChanged = false;
		var eventChanged = ("true" == document.getElementById('extendDaoEventBean').isChanged);
		if(customIframe.Designer != null && customIframe.Designer.instance != null){
			if(!customIframe.Designer.instance.checkoutAll()){
				//表单绘制数据不合法，不允许提交
				return false;
			}
			fdDesignerHtml = customIframe.Designer.instance.getHTML();
		}
		//确认是否更新为新的版本
		var fdIsChangedObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdIsChanged")[0];
		//是否提升
		var fdIsUpTabObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdIsUpTab")[0];
		
	 	var fdSaveAsNewEditionObj = document.getElementsByName("${sysFormTemplateFormPrefix}fdSaveAsNewEdition")[0];
		if(fdDesignerHtmlObj.value == null || fdDesignerHtmlObj.value == ''){
			fdSaveAsNewEditionObj.value = "true";
			fdIsChanged = true;
		}
		else if (isClone == 'true') {
			fdIsChanged = true;
		}
		else if(customIframe.Designer != null && (customIframe.Designer.instance.isChanged || eventChanged) ){
			/*
			*增加数据字典变化默认选择新保存为新版本，数据字典未变化默认选择保存为当前版本的功能
			*@作者：曹映辉 @日期：2012年6月4日 
			*/
			var filterXml=function(str){
				if(!str){
					return "";
				}
				//将xml中连续两个以上的空格 替换为 一个
				str=str.replace(/\s{2,}/g," ");
				//将xml中label 属性去除。（数据字典中label属性的改变不列如入默认作为新模版的条件）
				str=str.replace(/\s+label=\s*[\S]+\s*/gi," ");
				return str;
			}
			
			//false:默认保存为原版本，ture：默认保存为新版本
			var isDefualtNew=false;
			var newXML = customIframe.Designer.instance.getXML();
			var oldXML =fdMetadataXmlObj.value;
			if(oldXML&&newXML){
				if(filterXml(oldXML) != filterXml(newXML)){
					isDefualtNew=true;
				}
			}
			fdIsChanged = true;
			//版本不同，确认是否存为新版本
			var flag = Dialog_PopupWindow('<c:url value="/resource/jsp/frame.jsp" />?url=' + encodeURIComponent('<c:url value="/sys/xform/include/sysFormConfirm.jsp?isDefualtNew='+isDefualtNew+'" />'), 400, 230);
			if (flag.submit == false) return false;
			if(flag.isNew == true) {
				fdSaveAsNewEditionObj.value = "true";
			}
		}
		else if(customIframe.Designer && fdIsUpTabObj.value!=customIframe.Designer.instance.isUpTab){
			fdIsChanged = true;
		}
		if (fdIsChanged) {
			//修改表单内容被修改的处理，由于clone的加入，须判断有无加载自定义表单页面，而不是简单的作为已修改表单内容处理 modify by limh 2010年10月21日	
			if(customIframe.Designer){
				fdIsChangedObj.value = "true";
				fdDesignerHtmlObj.value = fdDesignerHtml;
				fdMetadataXmlObj.value = customIframe.Designer.instance.getXML();
				fdIsUpTabObj.value=customIframe.Designer.instance.isUpTab;
			}
		}
	}

	//BASE64处理脚本内容	
	fdDesignerHtmlObj.value = base64Encode(fdDesignerHtmlObj.value);
	 
	return true;
}
<%-- 存储对话框
function XForm_OpenDBDefine() {
	var customIframe = window.frames['IFrame_FormTemplate_${param.fdKey}'];
	var objs = customIframe.Designer.instance.getObj(false, true);
	var rtn = Dialog_PopupWindow('<c:url value="/sys/xform/db/form_frame.html" />', 600, 700, 
		XForm_InitForDBDefine(document.getElementById('${param.fdKey}_formEntityName').value, objs));
	XForm_SaveDBDefine(rtn);
}
function XForm_InitForDBDefine(entityName, objs) {
	var params = {Window : window};
	params.lang = {
			"Number" : "数字",
			"Double" : "数字",
			"Double[]" : "数字",
			"String" : "字符",
			"String[]" : "字符",
			"Date" : "日期",
			"len" : "长度",
			"com.landray.kmss.sys.organization.model.SysOrgElement" : "组织架构",
			"com.landray.kmss.sys.organization.model.SysOrgElement[]" : "组织架构",
			"RTF" : "大文本",
			"Array" : "多值",
			"Single" : "单值",
			"Object" : "表"
		};
	params.controls = objs;
	params.config = {
			entityName : entityName,
			fields : {},
			modelName : _xform_MainModelName,
			key : '${param.fdKey}'
		};
	return params;
}
function XForm_SaveDBDefine() {
	
}
 --%>
</script>