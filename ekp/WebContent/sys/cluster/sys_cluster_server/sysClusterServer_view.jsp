<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<c:if test="${sysClusterServerForm.fdAnonymous=='false'}">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysClusterServer.do?method=edit&fdId=${param.fdId}','_self');">
	</c:if>
	<c:if test="${sysClusterServerForm.status!='2'}">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysClusterServer.do?method=delete&fdId=${param.fdId}','_self');">
	</c:if>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-cluster" key="table.sysClusterServer"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdKey"/>
		</td><td width="35%">
			<xform:text property="fdKey" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdAnonymous"/>
		</td><td width="35%">
			<xform:select property="fdAnonymous">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.status"/>
		</td><td width="35%">
			<xform:select property="status">
				<xform:enumsDataSource enumsType="sysClusterServer.status" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-cluster" key="sysClusterServer.fdUrl"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	<c:if test="${sysClusterServerForm.status=='2'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdPid"/>
			</td><td width="35%">
				<xform:text property="fdPid" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdDispatcherType"/>
			</td><td width="35%">
				<xform:select property="fdDispatcherType">
					<xform:enumsDataSource enumsType="sysClusterServer.fdDispatcherType" />
				</xform:select>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdStartTime"/>
			</td><td width="35%">
				<xform:datetime property="fdStartTime" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdRefreshTime"/>
			</td><td width="35%">
				<xform:datetime property="fdRefreshTime" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdAddress"/>
			</td><td width="35%">
				<xform:text property="fdAddress" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdPorts"/>
			</td><td width="35%">
				<xform:text property="fdPorts" />
			</td>
		</tr>
	</c:if>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>