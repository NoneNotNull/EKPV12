<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.edit">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<c:choose>
				<c:when test="${ sysClusterGroupForm.method_GET == 'add' }">
					<ui:button text="${ lfn:message('button.save') }" onclick="Com_Submit(document.sysClusterGroupForm, 'save');"></ui:button>
					<ui:button text="${ lfn:message('button.saveadd') }" onclick="Com_Submit(document.sysClusterGroupForm, 'saveadd');"></ui:button>
				</c:when>
				<c:when test="${ sysClusterGroupForm.method_GET == 'edit' }">
					<ui:button text="${ lfn:message('button.update') }" onclick="Com_Submit(document.sysClusterGroupForm, 'update');"></ui:button>
				</c:when>
			</c:choose>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>		
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	
<html:form action="/sys/cluster/sys_cluster_group/sysClusterGroup.do">

<p class="txttitle"><bean:message bundle="sys-cluster" key="table.sysClusterGroup"/></p><br>

<center>
<table class="tb_normal" width="600px">
	<tr>
		<td class="td_normal_title" width="25%">
			<bean:message bundle="sys-cluster" key="sysClusterGroup.fdName"/>
		</td><td width="75%">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-cluster" key="sysClusterGroup.fdKey"/>
		</td><td>
			<xform:text property="fdKey" style="width:85%" />
			<div class="com_help"><bean:message bundle="sys-cluster" key="sysClusterGroup.fdKey.help"/></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-cluster" key="sysClusterGroup.fdUrl"/>
		</td><td>
			<xform:text property="fdUrl" style="width:85%" />
			<div class="com_help"><bean:message bundle="sys-cluster" key="sysClusterGroup.fdUrl.help"/></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-cluster" key="sysClusterGroup.fdOrder"/>
		</td><td>
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-cluster" key="sysClusterGroup.fdMaster"/>
		</td><td>
			<xform:radio property="fdMaster">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-cluster" key="sysClusterGroup.fdLocal"/>
		</td><td>
			<xform:radio property="fdLocal">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
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

	</template:replace>
</template:include>