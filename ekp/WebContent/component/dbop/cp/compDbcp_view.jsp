<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/component/dbop/compDbcp.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('compDbcp.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
		<kmss:auth requestURL="/component/dbop/compDbcp.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('compDbcp.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="component-dbop" key="table.compDbcp"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdName"/>
		</td><td width="85%">
			<c:out value="${compDbcpForm.fdName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdType"/>
		</td><td width="85%">
			<c:out value="${compDbcpForm.fdType}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdUrl"/>
		</td><td width="85%">
			<c:out value="${compDbcpForm.fdUrl}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdDriver"/>
		</td><td width="85%">
			<c:out value="${compDbcpForm.fdDriver}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdUsername"/>
		</td><td width="85%">
			<c:out value="${compDbcpForm.fdUsername}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdDescription"/>
		</td><td width="85%">
		<kmss:showText value="${compDbcpForm.fdDescription}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>