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
	<kmss:auth requestURL="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('pdaHomeCustomPortlet.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('pdaHomeCustomPortlet.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaHomeCustomPortlet"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:35%"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType"/>
		</td>
		<td width="35%">
			<xform:select property="fdType" showPleaseSelect="false">
				<xform:simpleDataSource value="list" textKey="pdaHomeCustomPortlet.fdType.list" bundle="third-pda"/>
				<xform:simpleDataSource value="pic" textKey="pdaHomeCustomPortlet.fdType.pic" bundle="third-pda"/>
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdModuleName"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdModuleId"showStatus="noShow"/>
			<xform:text property="fdModuleName" style="width:15%" showStatus="view"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdTemplateClass"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdTemplateClass" style="width:70%" showStatus="view"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdDataUrl"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdDataUrl" style="width:70%"/> 
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>