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
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibJdbcRelation.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibJdbcRelation.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcRelation"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.fdUseExplain"/>
		</td><td width="35%">
			<xform:text property="fdUseExplain" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.fdSyncType"/>
		</td><td width="35%">
			<xform:textarea property="fdSyncType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.tibJdbcMappCategory"/>
		</td><td width="35%">
			<c:out value="${tibJdbcRelationForm.tibJdbcMappCategoryName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.tibJdbcTaskManage"/>
		</td><td width="35%">
			<c:out value="${tibJdbcRelationForm.tibJdbcTaskManageName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>