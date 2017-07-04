<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.xform.base.config.*" %>

<c:set var="sysFormTemplateForm" value="${requestScope[param.formName]}" />
<c:set var="xFormTemplateForm" value="${sysFormTemplateForm.sysFormTemplateForms[param.fdKey]}" />
<c:set var="sysFormTemplateFormPrefix" value="sysFormTemplateForms.${param.fdKey}." />
<c:set var="sysFormTemplateFormResizePrefix" value="_" />

<c:set var="sysFormContentTitle" scope="page"><kmss:message 
	key="${not empty param.messageKey ? param.messageKey : 'sys-xform:sysForm.tab.label'}" 
/></c:set>

<ui:content title="${sysFormContentTitle }" expand="${not empty param.isExpand ? param.isExpand : 'false'}">
    <ui:event event="show">
		//$('#SYS_XFORM_TR_ID_${param.fdKey }').show();
		this.element.find("*[${sysFormTemplateFormResizePrefix}onresize]").each(function(){
			var funStr = this.getAttribute("${sysFormTemplateFormResizePrefix}onresize");
			if(funStr!=null && funStr!=""){
				var tmpFunc = new Function(funStr);
				tmpFunc.call();
			}
		});
	</ui:event>
   	<table class="tb_normal" width=100%>
   	
	<c:import url="/sys/xform/import/sysFormMappingBtn.jsp" charEncoding="UTF-8">
		<c:param name="fdModelId" value="${sysFormTemplateForm.fdId}" />
		<c:param name="fdModelName" value="${param.fdMainModelName}" />
		<c:param name="fdTemplateModel" value="${sysFormTemplateForm.modelClass.name}" />
		<c:param name="fdKey" value="${param.fdKey}" />
		<c:param name="fdTemplateId" value="${xFormTemplateForm.fdId}" />
		<c:param name="fdFormType" value="template" />
		<c:param name="fdModeType" value="${xFormTemplateForm.fdMode}" />
	</c:import>
	
			<tr>
				<td width="15%" class="td_normal_title" valign="top">
					<bean:message bundle="sys-xform" key="sysFormTemplate.fdMode" />
				</td>
				<td width="85%">
					<sunbor:enumsShow value="${xFormTemplateForm.fdMode}" enumsType="sysFormTemplate_fdMode" />
				</td>
			</tr>
			<c:if test="${xFormTemplateForm.fdMode == 2}">
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-xform" key="sysFormTemplate.fdCommonName"/>
				</td>
				<td>
					<c:out value="${xFormTemplateForm.fdCommonTemplateName}" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<iframe width="100%" height="500" FRAMEBORDER=0 id="${sysFormTemplateFormPrefix}fdCommonTemplateView"
					src="<c:url value="/sys/xform/designer/designPreview.jsp"/>"></iframe>
					<script>
					Com_IncludeFile("data.js");
					function Form_ShowCommonTemplatePreview() {
						var data = new KMSSData();
						data.AddBeanData('sysFormCommonTemplateTreeService&fdId=${xFormTemplateForm.fdCommonTemplateId}');
						var html = data.GetHashMapArray()[0]['fdDesignerHtml'];
						var iframe = document.getElementById('${sysFormTemplateFormPrefix}fdCommonTemplateView');
						iframe.contentWindow.document.body.innerHTML = html;
					}
					Com_AddEventListener(window, "load", Form_ShowCommonTemplatePreview);
					</script>
				</td>
			</tr>
			</c:if>
			<c:if test="${xFormTemplateForm.fdMode == 3}">
			<%@ include file="/sys/xform/base/sysFormTemplateDisplay_view.jsp"%>
			</c:if>
	
	</table>
</ui:content>