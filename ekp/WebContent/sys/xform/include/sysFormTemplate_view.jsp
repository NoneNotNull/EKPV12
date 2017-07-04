<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="sysFormTemplateForm" value="${requestScope[param.formName]}" />
<c:set var="xFormTemplateForm" value="${sysFormTemplateForm.sysFormTemplateForms[param.fdKey]}" />
<c:set var="sysFormTemplateFormPrefix" value="sysFormTemplateForms.${param.fdKey}." />
<%--
ApplicationContext _ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
ISysFormCommonTemplateService commonTemplateService = (ISysFormCommonTemplateService)_ctx.getBean("sysFormCommonTemplateService");
commonTemplateService.setTemplateForm(new RequestContext(request));
--%>
<c:if test="${xFormTemplateForm.fdMode != 1}">
<c:if test="${param.useLabel != 'false'}">
<tr LKS_LabelName="<kmss:message key="${not empty param.messageKey ? param.messageKey : 'sys-xform:sysForm.tab.label'}" />" style="display:none">
	<td>
</c:if>
		<%-- 表单映射按钮 --%>
		<c:import url="/sys/xform/include/sysFormMappingBtn.jsp" charEncoding="UTF-8">
			<c:param name="fdModelId" value="${sysFormTemplateForm.fdId}" />
			<c:param name="fdModelName" value="${param.fdMainModelName}" />
			<c:param name="fdTemplateModel" value="${sysFormTemplateForm.modelClass.name}" />
			<c:param name="fdKey" value="${param.fdKey}" />
			<c:param name="fdTemplateId" value="${xFormTemplateForm.fdId}" />
			<c:param name="fdFormType" value="template" />
			<c:param name="fdModeType" value="${xFormTemplateForm.fdMode}" />
		</c:import>
		<table class="tb_normal" width="100%">
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
<c:if test="${param.useLabel != 'false'}">
	</td>
</tr>
</c:if>
</c:if>