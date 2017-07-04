<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>

<kmss:windowTitle
	subject="${sysBookmarkMainForm.docSubject}"
	moduleKey="sys-bookmark:table.sysBookmarkMain" />

<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysBookmarkMain.do?method=edit&fdId=${param.fdId}','_self');">
	<input type="button"
		value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('sysBookmarkMain.do?method=delete&fdId=${param.fdId}','_self');">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-bookmark" key="table.sysBookmarkMain"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysBookmarkMainForm" property="fdId"/>
	<%-- 收藏名 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docSubject"/>
		</td>
		<td>
			<c:out value="${sysBookmarkMainForm.docSubject}" />
		</td>
	</tr>
	<%-- 收藏URL --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.fdUrl"/>
		</td>
		<td>
			<c:out value="${sysBookmarkMainForm.fdUrl}" />
		</td>
	</tr>
	<%-- 收藏分类 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCategoryId"/>
		</td>
		<td colspan="3">
			<c:out value="${sysBookmarkMainForm.docCategoryName}" />
		</td>
	</tr>
	<%-- 创建时间 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCreateTime"/>
		</td>
		<td colspan="3">
			<c:out value="${sysBookmarkMainForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
