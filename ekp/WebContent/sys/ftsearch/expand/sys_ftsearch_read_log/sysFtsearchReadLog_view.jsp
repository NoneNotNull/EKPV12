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
	<%--
	<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysFtsearchReadLog.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	 --%>
	<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysFtsearchReadLog.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchReadLog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdSearchWord"/>
		</td><td width="35%">
			<xform:text property="fdSearchWord" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdReadTime"/>
		</td><td width="35%">
			<xform:datetime property="fdReadTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%  >
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdDocSubject"/>
		</td><td width="85%" colspan=3>
			<xform:text property="fdDocSubject" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15% >
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdUrl"/>
		</td><td width="85%" colspan=3>
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdReaderId"/>
		</td><td width="35%">
			<xform:text property="fdReaderId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdReaderName"/>
		</td><td width="35%">
			<xform:text property="fdReaderName" style="width:85%" />
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdHitPosition"/>
		</td><td width="35%">
			<xform:text property="fdHitPosition" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdCategoryHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdCategoryHierarchyId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdModelId"/>
		</td><td width="35%">
			<xform:text property="fdModelId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdModelName"/>
		</td><td width="35%">
			<xform:text property="fdModelName" style="width:85%" />
		</td>
	</tr>

	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>