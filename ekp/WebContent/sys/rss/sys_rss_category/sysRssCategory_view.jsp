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
		<kmss:auth requestURL="/sys/rss/sys_rss_category/sysRssCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysRssCategory.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/rss/sys_rss_category/sysRssCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysRssCategory.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-rss" key="table.sysRssCategory"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysRssCategoryForm" property="fdId"/>
	<%-- 名称 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.fdName"/>
		</td>
		<td colspan="3">
			<c:out value="${sysRssCategoryForm.fdName}" />
		</td>
	</tr>
	<%--  --%>
	<tr>
		<%-- 分类 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.fdParentId"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssCategoryForm.fdParentName}" />
		</td>
		<%-- 排序号 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.fdOrder"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssCategoryForm.fdOrder}" />
		</td>
	</tr>
	<%-- 创建人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docCreatorId"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssCategoryForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docCreateTime"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssCategoryForm.docCreateTime}" />
		</td>
	</tr>
	<%-- 修改人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docAlterorId"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssCategoryForm.docAlterorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssCategory.docAlterTime"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssCategoryForm.docAlterTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
