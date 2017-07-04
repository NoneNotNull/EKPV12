<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/lbpmservice/support/lbpm_operations/lbpmOperations.do">
<div id="optBarDiv">
	<c:if test="${lbpmOperationsForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.lbpmOperationsForm, 'update');">
	</c:if>
	<c:if test="${lbpmOperationsForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.lbpmOperationsForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.lbpmOperationsForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-lbpmservice-support" key="table.lbpmOperations"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOperName"/>
		</td><td width="35%">
			<xform:text property="fdOperName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOperType"/>
		</td><td width="35%">
			<xform:text property="fdOperType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOperator"/>
		</td><td width="35%">
			<xform:select property="fdOperatorId">
				<xform:beanDataSource serviceBean="lbpmOperMainService" selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>