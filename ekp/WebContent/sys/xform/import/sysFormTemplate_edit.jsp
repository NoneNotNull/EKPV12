<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="sysFormTemplateForm" value="${requestScope[param.formName]}" />
<c:set var="xFormTemplateForm" value="${sysFormTemplateForm.sysFormTemplateForms[param.fdKey]}" />
<c:set var="sysFormTemplateFormPrefix" value="sysFormTemplateForms.${param.fdKey}." />
<c:set var="entityName" value="${param.fdMainModelName}_${sysFormTemplateForm.fdId}" />

<c:set var="sysFormContentTitle" scope="page"><kmss:message 
	key="${not empty param.messageKey ? param.messageKey : 'sys-xform:sysForm.tab.label'}" 
/></c:set>

<c:set var="sysFormTemplateFormResizePrefix" value="_" />

<ui:content title="${sysFormContentTitle }" 
    expand="${param.isExpand == 'true'?'true':'false'}">
    <ui:event event="show">
		this.element.find("*[${sysFormTemplateFormResizePrefix}onresize]").each(function(){
			if (!$(this).is(':visible'))
				return;
			var funStr = this.getAttribute("${sysFormTemplateFormResizePrefix}onresize");
			if(funStr!=null && funStr!=""){
				var tmpFunc = new Function(funStr);
				tmpFunc.call();
			}
		});
	</ui:event>
   	<%@ include file="/sys/xform/import/sysFormTemplate_edit_script.jsp" %>
   	<table class="tb_normal" width="100%"  id="TB_FormTemplate_${param.fdKey}">
   		<%-- 引用方式 --%>
			<tr>
				<td width="15%" class="td_normal_title" valign="top">
					<bean:message bundle="sys-xform" key="sysFormTemplate.fdMode" />
				</td>
				<td width="85%">
					<sunbor:enums property="${sysFormTemplateFormPrefix}fdMode" enumsType="sysFormTemplate_fdMode"
						htmlElementProperties="onClick=Form_ChgDisplay('${param.fdKey}',this.value);" elementType="radio" />
					<%-- //从模板加载 未实现 --%>
					<a href="#" id="A_FormTemplate_${param.fdKey}"
						onclick="Form_SelectTemplate('${param.fdKey}', true);">
						<bean:message bundle="sys-xform" key="sysFormTemplate.from.button" />
					</a>
				</td>
			</tr>
			<%-- 模板 --%>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-xform" key="sysFormTemplate.fdCommonName"/>
				</td><td>
					<html:text property="${sysFormTemplateFormPrefix}fdCommonTemplateName" style="width:90%"/>
					<html:hidden property="${sysFormTemplateFormPrefix}fdCommonTemplateId" />
					<span class="txtstrong">*</span>&nbsp;&nbsp;&nbsp;<a
						href="#"
						onclick="Form_SelectTemplate('${param.fdKey}');"><bean:message
						key="dialog.selectOther" /></a>					
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<iframe width="100%" height="500" FRAMEBORDER=0 id="${sysFormTemplateFormPrefix}fdCommonTemplateView"
					src="<c:url value="/sys/xform/designer/designPreview.jsp"/>"></iframe>
				</td>
			</tr>
			<%@ include file="/sys/xform/base/sysFormTemplateDisplay_edit.jsp"%>
	</table>
</ui:content>
