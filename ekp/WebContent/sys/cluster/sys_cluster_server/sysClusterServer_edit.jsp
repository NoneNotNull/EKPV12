<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/cluster/sys_cluster_server/sysClusterServer.do">
<div id="optBarDiv">
	<c:if test="${sysClusterServerForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysClusterServerForm, 'update');">
	</c:if>
	<c:if test="${sysClusterServerForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysClusterServerForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysClusterServerForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-cluster" key="table.sysClusterServer"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" required="true" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdKey"/>
		</td><td width="35%">
			<c:set var="showStatus" value="edit"/>
			<c:if test="${sysClusterServerForm.method_GET=='edit' && sysClusterServerForm.status=='2'}">
				<c:set var="showStatus" value="view"/>
			</c:if>
			<xform:text property="fdKey" style="width:85%" required="true" showStatus="${showStatus}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdUrl"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdUrl" style="width:85%" /><br>
			<bean:message bundle="sys-cluster" key="sysClusterServer.sample"/> : http://node1.company.com.cn:8080/ekp
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