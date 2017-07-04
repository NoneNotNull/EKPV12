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
<div id="optBarDiv"><kmss:auth
	requestURL="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=edit&fdSynonym=${sysFtsearchSynonymForm.fdSynonymSet}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysFtsearchSynonym.do?method=edit&fdSynonym=${sysFtsearchSynonymForm.fdSynonymSet}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=deleteSynonym&synonymWord=${sysFtsearchSynonymForm.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('sysFtsearchSynonym.do?method=deleteSynonym&synonymWord=${sysFtsearchSynonymForm.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand"
	key="table.sysFtsearchSynonym" /></p>

<center>
<table class="tb_normal" width=95%>

	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.docCreatorName" />
		</td>
		<td width="35%"><xform:text property="docCreatorName"
			style="width:85%" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.fdSynonymSet" />
		</td>
		<td width="85%" colspan="3">
			<xform:textarea property="fdSynonymSet" style="width:40%" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>