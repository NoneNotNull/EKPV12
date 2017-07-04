<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.util.LbpmTemplateUtil" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js|formula.js");
</script>
<c:set var="lbpmTemplateFormPrefix" value="" />
<c:set var="lbpmTemplate_ModelName" value="${lbpmTemplateForm.fdModelName}" />
<c:set var="lbpmTemplate_Key" value="${lbpmTemplateForm.fdKey}" />
<%
	pageContext.setAttribute("lbpmTemplate_MainModelName",
			LbpmTemplateUtil.getMainModelName(
					(String)pageContext.getAttribute("lbpmTemplate_ModelName"),
					(String)pageContext.getAttribute("lbpmTemplate_Key")));
%>
<script>
var WF_FormFieldList_${lbpmTemplate_Key} = Formula_GetVarInfoByModelName("${lbpmTemplate_ModelName}");
</script>
<html:form action="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do">
<div id="optBarDiv">
	<c:if test="${lbpmTemplateForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.lbpmTemplateForm, 'update');">
	</c:if>
	<c:if test="${lbpmTemplateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.lbpmTemplateForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.lbpmTemplateForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-lbpmservice-support" key="table.lbpmTemplate"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdName"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdIsDefault"/>
		</td><td width="85%" colspan="3">
			<xform:checkbox property="fdIsDefault">
				<xform:simpleDataSource value="true"><bean:message key="message.yes"/></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
	<%@ include file="/sys/lbpmservice/support/lbpm_template/lbpmTemplate_sub_edit.jsp"%>
</table>
</center>
<html:hidden property="fdIsCommon" />
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
	Com_AddEventListener(window, "load", function() {
		var flowChartObject = document.getElementById("${lbpmTemplateFormPrefix}WF_IFrame").contentWindow.FlowChartObject;
		if(flowChartObject) {
			flowChartObject.FormFieldList = Formula_GetVarInfoByModelName("${lbpmTemplate_MainModelName}");
		}
	});
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>