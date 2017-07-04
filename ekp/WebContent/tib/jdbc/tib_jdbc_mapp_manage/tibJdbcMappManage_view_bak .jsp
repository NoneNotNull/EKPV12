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
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibJdbcMappManage.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibJdbcMappManage.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcMappManage"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docSubject"/>
		</td><td width="35%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docCategory"/>
		</td><td width="35%">
			<c:out value="${tibJdbcMappManageForm.docCategoryName}" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdIsEnabled"/>
		</td><td width="35%">
			<xform:radio property="fdIsEnabled">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSource"/>
		</td><td width="35%">
			<xform:text property="fdTargetSource" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdDataSource"/>
		</td><td width="35%">
			<xform:text property="fdDataSource" style="width:85%" />
		</td>
	</tr>
	
	<tr>	
		<td width=15% class="td_normal_title" >
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdDataSourceSql"/>
		</td><td width="35%" height="45%">
			<xform:textarea property="fdDataSourceSql" style="width:100%; height:155px;"></xform:textarea>
		</td>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSourceSelectedTable"/>
		</td><td width="35%">
			<xform:text property="fdTargetSourceSelectedTable" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdMappConfigJson"/>
		</td><td width="35%">
			<xform:rtf property="fdMappConfigJson" />
		</td>
		
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>