<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.util.LbpmTemplateUtil" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("jquery.js");
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
<tr id="WF_TR_ID_${param.fdKey }" LKS_LabelName="<kmss:message key="${not empty param.messageKey ? param.messageKey : 'sys-lbpmservice-support:lbpmTemplate.tab.label'}" />" style="display:none">
	<td>
		<table class="tb_normal" width="100%">
			<tr>
				<td width="15%" class="td_normal_title" valign="top">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType" />
				</td>
				<td width="85%">
					<c:if test="${lbpmTemplateForm.fdType=='1'}">
						<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.default" />
					</c:if>
					<c:if test="${lbpmTemplateForm.fdType=='2'}">
						<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.other" />
					</c:if>
					<c:if test="${lbpmTemplateForm.fdType=='3'}">
						<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.define" />
					</c:if>
				</td>
			</tr>
			<c:if test="${lbpmTemplateForm.fdType!='3'}">
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdCommon"/>
				</td>
				<td>
					<c:out value="${lbpmTemplateForm.fdCommonName}" />
					<c:if test="${'true' eq lbpmTemplateForm.fdCommonIsDelete}">
						<span style="color: red">[<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdIsDelete.true" />]</span>
					</c:if>
				</td>
			</tr>
			</c:if>
			<%@ include file="/sys/lbpmservice/support/lbpm_template/lbpmTemplate_sub_view.jsp"%>
			<!-- 模板变更记录 -->
			<%@ include file="/sys/lbpmservice/support/lbpm_template_change_history/lbpmTemplateChangeHistory_list.jsp"%>
		</table>
	</td>
</tr>