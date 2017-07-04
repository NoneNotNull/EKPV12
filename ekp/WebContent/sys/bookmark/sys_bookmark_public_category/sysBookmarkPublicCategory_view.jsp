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
	subject="${sysBookmarkPublicCategoryForm.fdName}"
	moduleKey="sys-bookmark:table.sysBookmarkPublicCategory" />

<div id="optBarDiv">
	<kmss:auth requestURL="/sys/bookmark/sys_bookmark_public_category/sysBookmarkPublicCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysBookmarkPublicCategory.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/bookmark/sys_bookmark_public_category/sysBookmarkPublicCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysBookmarkPublicCategory.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-bookmark" key="table.sysBookmarkPublicCategory"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysBookmarkPublicCategoryForm" property="fdId"/>
	<%-- 分类名称 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.fdName"/>
		</td>
		<td colspan="3">
			<c:out value="${sysBookmarkPublicCategoryForm.fdName}" />
		</td>
	</tr>
	<%-- 所属类别 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.fdParentId"/>
		</td>
		<td colspan="3">
			<c:out value="${sysBookmarkPublicCategoryForm.fdParentName}" />
		</td>
	</tr>
	<%-- 排序号 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.fdOrder"/>
		</td>
		<td colspan="3">
			<c:out value="${sysBookmarkPublicCategoryForm.fdOrder}" />
		</td>
	</tr>
	<tr>
	<%-- 创建人 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.docCreatorId"/>
		</td>
		<td width="35%">
			<c:out value="${sysBookmarkPublicCategoryForm.docCreatorName}" />
		</td>
	<%-- 创建时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.docCreateTime"/>
		</td width="35%">
		<td>
			<c:out value="${sysBookmarkPublicCategoryForm.docCreateTime}" />
		</td>
	</tr>
	<tr>
	<%-- 修改人 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.docAlterorId"/>
		</td>
		<td width="35%">
			<c:out value="${sysBookmarkPublicCategoryForm.docAlterorName}" />
		</td>
	<%-- 修改时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkPublicCategory.docAlterTime"/>
		</td>
		<td width="35%">
			<c:out value="${sysBookmarkPublicCategoryForm.docAlterTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
