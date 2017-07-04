<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" />
<script>
Com_IncludeFile("dialog.js");
</script>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message  bundle="sys-property" key="table.sysPropertyTemplate.select"/>
	</td><td colspan="3">
		<html:hidden property="fdSysPropTemplateId" />
		<html:text property="fdSysPropTemplateName" readonly="true" style="width:85%" styleClass="inputsgl" />
		<a href="javascript:void(0)"
			onclick="Dialog_Tree(false,'fdSysPropTemplateId','fdSysPropTemplateName',null,'sysPropertyTemplateListService&fdParentId=!{value}&fdModelName=${param.mainModelName}','<bean:message bundle="sys-property" key="table.sysPropertyTemplate" />',null,null,null,null,null,'<bean:message bundle="sys-property" key="table.sysPropertyTemplate.select" />');">
		<bean:message key="button.select" /></a>
	</td>
</tr>