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
		<kmss:auth requestURL="/sys/rss/sys_rss_main/sysRssMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysRssMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/rss/sys_rss_main/sysRssMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysRssMain.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-rss" key="table.sysRssMain"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysRssMainForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docSubject"/>
		</td>
		<td colspan="3">
			<c:out value="${sysRssMainForm.docSubject}" />
		</td>
	</tr>
	<%-- RSS链接 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.fdLink"/>
		</td>
		<td colspan="3">
			<c:out value="${sysRssMainForm.fdLink}" />
		</td>
	</tr>
	<%--  --%>
	<tr>
		<%-- 分类 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docCategoryId"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssMainForm.docCategoryName}" />
		</td>
		<%-- 排序号 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.fdOrder"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssMainForm.fdOrder}" />
		</td>
	</tr>
	<%-- 创建人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docCreatorId"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssMainForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docCreateTime"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssMainForm.docCreateTime}" />
		</td>
	</tr>
	<%-- 修改人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docAlterorId"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssMainForm.docAlterorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docAlterTime"/>
		</td>
		<td width=35%>
			<c:out value="${sysRssMainForm.docAlterTime}" />
		</td>
	</tr>

</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
