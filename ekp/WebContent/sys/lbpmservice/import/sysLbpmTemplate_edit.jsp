<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="lbpmContentTitle" scope="page"><kmss:message 
	key="${not empty param.messageKey ? param.messageKey : 'sys-lbpmservice-support:lbpmTemplate.tab.label'}" 
/></c:set>
<c:set var="_lbpm_panel_src_prefix" value="data-lbpm-" />
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<ui:content title="${lbpmContentTitle }" 
    expand="${param.isExpand == 'true'?'true':'false'}">
    <ui:event event="show">
		$('#WF_TR_ID_${param.fdKey }').show();
	</ui:event>
   	<table class="tb_simple" width=100%>
   	<%@ include file="/sys/lbpmservice/include/sysLbpmTemplate_edit.jsp" %>
	</table>
</ui:content>

    <ui:event event="layoutDone">
		$('iframe[data-lbpm-src]').each(function() {
			this.src = this.getAttribute('data-lbpm-src');
		});
	</ui:event>