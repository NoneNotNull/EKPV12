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
		<kmss:auth requestURL="/km/forum/km_forum_cate/kmForumCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmForumCategory.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/km/forum/km_forum_cate/kmForumCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmForumCategory.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="km-forum" key="kmForumCategory.fdId"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdParentId"/>
		</td><td colspan=3>
			<bean:write name="kmForumCategoryForm" property="fdParentName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdName"/>
		</td><td colspan=3>
			<bean:write name="kmForumCategoryForm" property="fdName"/>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdDescription"/>
		</td><td colspan=3>
			<kmss:showText value="${kmForumCategoryForm.fdDescription}" />
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumCategory.forumManagers"/>
		</td>
		<td colspan=3>
			<bean:write name="kmForumCategoryForm" property="fdManagerNames"/>
		</td>
	</tr>
	<tr>
		<td colspan=4><bean:message  bundle="km-forum" key="kmForumCategory.forumManager.msg"/></td>
	</tr>	

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdMainScore"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdMainScore"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdResScore"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdResScore"/>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdPinkScore"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdPinkScore"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdDisplayOrder"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdOrder"/>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docCreatorId"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="docCreatorName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docCreateTime"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="docCreateTime"/>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docAlterId"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="docAlterName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.docAlterTime"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="docAlterTime"/>
		</td>
	</tr>

</table>
</center>

<%@ include file="/resource/jsp/view_down.jsp"%>