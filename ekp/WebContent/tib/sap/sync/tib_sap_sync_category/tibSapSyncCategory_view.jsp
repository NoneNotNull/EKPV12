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
	<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibSapSyncCategory.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSapSyncCategory.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sap-sync" key="table.tibSapSyncCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdHierarchyId"/>
		</td><td width="35%">
			<xform:textarea property="fdHierarchyId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.fdParent"/>
		</td><td width="35%">
			<c:out value="${tibSapSyncCategoryForm.fdParentName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>