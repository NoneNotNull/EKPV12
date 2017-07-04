<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">
<script>
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("validation.js|plugin.js|validation.jsp|eventbus.js|xform.js", null, "js");
</script>
<html:form action="/sys/lbpmservice/support/lbpm_usage/lbpmUsage.do">
<ui:toolbar layout="sys.ui.toolbar.float">
	<ui:button text="${ lfn:message('button.save') }" styleClass="lui_toolbar_btn_gray"
		onclick="Com_Submit(document.lbpmUsageForm, 'updateDefine');" />
	<ui:button text="${ lfn:message('button.close') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();" />
</ui:toolbar>
<p class="txttitle"><bean:message bundle="sys-lbpmservice-support" key="table.lbpmUsage"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmUsage.fdUsageContent"/>
		</td><td width="85%">
			<xform:textarea property="fdUsageContent" style="width:95%;height:200px" showStatus="edit" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmUsage.fdDescription"/>
		</td><td width="85%">
			<bean:message  bundle="sys-lbpmservice-support" key="lbpmUsage.fdDescription.details.1"/><br>
			<bean:message  bundle="sys-lbpmservice-support" key="lbpmUsage.fdDescription.details.2"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="fdIsSysSetup" value="false"/>
<html:hidden property="fdCreatorId"/>
<html:hidden property="fdCreateTime"/>
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
	</template:replace>
</template:include>