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
	<kmss:auth requestURL="/km/keydata/base/kmKeydataPluginShow.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmKeydataPluginShow.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/keydata/base/kmKeydataPluginShow.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmKeydataPluginShow.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-keydata-base" key="table.kmKeydataPluginShow"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<!-- 
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdType"/>
		</td><td width="35%">
			<xform:text property="fdType" style="width:85%" />
		</td>
		 -->
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdActionUrl"/>
		</td><td width="35%">
			<xform:text property="fdActionUrl" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdIsShow"/>
		</td><td width="35%">
			<xform:radio property="fdIsShow">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>