<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
		var del = confirm("<bean:message  bundle="km-comminfo" key="kmComminfo.changeToOther"/>");
		return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmComminfoCategory.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmComminfoCategory.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-comminfo" key="table.kmComminfoCategory"/></p>
<center>
<TITLE> <bean:message  bundle="km-comminfo" key="kmComminfoCategory.view"/> </TITLE>
<table class="tb_normal" width=95%>
	<tr>
		<%-- 类别名称 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoCategory.fdName"/>
		</td>
		<td width=85% colspan="3">
			<c:out value="${kmComminfoCategoryForm.fdName}" />
		</td>
	</tr>
	<tr>
	<%-- 排序号 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.fdOrder"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoCategoryForm.fdOrder}" />
		</td>
		<%-- 可维护者 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoMain.maintainer"/>
		</td>
		<td width=35%>
			<c:out value="${kmComminfoCategoryForm.authEditorNames}" />
		</td>
	</tr>
	<tr>
		<%-- 提交者 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoCategory.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${kmComminfoCategoryForm.docCreatorName}" />
		</td>
		<%-- 提交时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-comminfo" key="kmComminfoCategory.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${kmComminfoCategoryForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>