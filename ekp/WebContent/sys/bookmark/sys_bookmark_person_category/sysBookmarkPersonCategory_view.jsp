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
	subject="${sysBookmarkPersonCategoryForm.fdName}"
	moduleKey="sys-bookmark:table.sysBookmarkPersonCategory" />

<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysBookmarkPersonCategory.do?method=edit&fdId=${param.fdId}','_self');">
	<input type="button"
		value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('sysBookmarkPersonCategory.do?method=delete&fdId=${param.fdId}','_self');">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-bookmark" key="table.sysBookmarkPersonCategory"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysBookmarkPersonCategoryForm" property="fdId"/>
	<%-- 分类名称 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdName"/>
		</td>
		<td>
			<c:out value="${sysBookmarkPersonCategoryForm.fdName}" />
		</td>
	</tr>
	<%-- 所属类别 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdParentId"/>
		</td>
		<td>
			<c:out value="${sysBookmarkPersonCategoryForm.fdParentName}" />
		</td>
	</tr>
	<%-- 排序号 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.fdOrder"/>
		</td>
		<td>
			<c:out value="${sysBookmarkPersonCategoryForm.fdOrder}" />
		</td>
	</tr>
	<%-- 创建时间 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.docCreateTime"/>
		</td><td>
			<c:out value="${sysBookmarkPersonCategoryForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
