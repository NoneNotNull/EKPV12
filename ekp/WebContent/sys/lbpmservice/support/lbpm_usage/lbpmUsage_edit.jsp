<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/lbpmservice/support/lbpm_usage/lbpmUsage.do">
<div id="optBarDiv">
	<c:if test="${lbpmUsageForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.lbpmUsageForm, 'update');">
	</c:if>
	<c:if test="${lbpmUsageForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.lbpmUsageForm, 'save');">
	</c:if>
</div>

<p class="txttitle"><bean:message bundle="sys-lbpmservice-support" key="table.lbpmUsage"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmUsage.fdUsageContent"/>
		</td><td width="85%">
			<xform:textarea property="fdUsageContent" style="width:95%;height:200px" />
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
<html:hidden property="fdIsSysSetup" value="true"/>
<html:hidden property="fdCreatorId"/>
<html:hidden property="fdCreateTime"/>
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>