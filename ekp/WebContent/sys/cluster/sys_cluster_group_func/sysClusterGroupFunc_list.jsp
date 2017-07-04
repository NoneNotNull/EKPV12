<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
function submitForm(){
	Com_Submit(document.forms[0], 'update');
}
</script>
<form method="post" action="<c:url value="/sys/cluster/sys_cluster_group_func/sysClusterGroupFunc.do" />">

<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="submitForm();">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-cluster" key="sysClusterGroupFunc.setting"/></p>
<center>
<table class="tb_normal" style="width:800px;">
	<tr class="tr_normal_title">
		<td width="50%">
			<bean:message bundle="sys-cluster" key="sysClusterGroupFunc.fdFunc"/>
		</td>
		<td width="50%">
			<bean:message bundle="sys-cluster" key="sysClusterGroupFunc.fdGroupKey"/>
		</td>
	</tr>
<xform:config isLoadDataDict="false">
<c:forEach items="${funcList}" var="func">
	<tr>
		<td>
			<c:out value="${func.name}" />
			<xform:text property="fdFuncs" value="${func.id}" showStatus="noShow"/>
		</td>
		<td>
			<xform:checkbox property="fdGroup.${func.id}" value="${func.group}" showStatus="edit" isLoadDataDict="false">
				<xform:customizeDataSource className="com.landray.kmss.sys.cluster.interfaces.GroupDataSource" />
			</xform:checkbox>
		</td>
	</tr>
</c:forEach>
</xform:config>
</table>
</center>
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>