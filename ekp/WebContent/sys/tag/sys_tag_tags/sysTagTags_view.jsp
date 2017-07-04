<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
//点评信息
//window.onload = function(){
//	parent.document.getElementById('commentContent').style.height=document.body.scrollHeight+100;
//};
</script>
<c:if test="${sysTagTagsForm.fdStatus == '1'}">
<c:import
	url="/sys/tag/sys_tag_tags/sysTagTags_merger_button.jsp?fdCategoryId=${param.fdCategoryId}&fdId=${param.fdId}"
	charEncoding="UTF-8">
	<c:param
		name="type"
		value="alias" />
</c:import>
<c:import
	url="/sys/tag/sys_tag_tags/sysTagTags_remove_button.jsp?fdCategoryId=${param.fdCategoryId}"
	charEncoding="UTF-8">
</c:import>
<c:import
	url="/sys/tag/sys_tag_tags/sysTagTags_reset_button.jsp?fdCategoryId=${param.fdCategoryId}&fdId=${param.fdId}"
	charEncoding="UTF-8">
</c:import>
</c:if>
<c:if test="${sysTagTagsForm.fdStatus == '0'}">
	<c:import
		url="/sys/tag/sys_tag_tags/sysTagTags_validate_button.jsp?fdCategoryId=${param.fdCategoryId}"
		charEncoding="UTF-8">
	</c:import>
</c:if>
<div id="optBarDiv">
	<!-- 点评 -->
	<!-- 
	<kmss:auth requestURL="/sys/tag/sys_tag_comment/sysTagComment.do?method=add" requestMethod="GET">
		<input class="btnopt" type="button" value="<bean:message key="sysTagComment.button" bundle="sys-tag"/>"
			   onclick="if(Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'sys/tag/sys_tag_comment/sysTagComment.do?method=add&fdTagId=${param.fdId}'),'600','300'))location.reload();">
	</kmss:auth>
	 -->
	<c:if test="${sysTagTagsForm.fdStatus == '1'}">
		<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=saveInvalidateTag&fdCategoryId=${param.fdCategoryId}" requestMethod="GET">
			<input type="button" value="<bean:message key="sysTagTags.button.saveInvalidateTags" bundle="sys-tag"/>"
				onclick="Com_OpenWindow('sysTagTags.do?method=saveInvalidateTag&fdId=${param.fdId}&fdCategoryId=${param.fdCategoryId}','_self');">
		</kmss:auth>
	</c:if>
	<c:if test="${sysTagTagsForm.fdIsPrivate=='0' }">
		<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=updateFromPriToPub" requestMethod="GET">
			<input type="button" value="<bean:message  bundle="sys-tag" key="sysTagTags.button.updateFromPriToPub"/>"
				onclick="Com_OpenWindow('sysTagTags.do?method=updateFromPriToPub&fdId=${param.fdId}','_self');">
		</kmss:auth>
	</c:if>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagTags"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysTagTagsForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" colspan="4">
			<FONT size="5"><b><c:out value="${sysTagTagsForm.fdName}" /></b></FONT>
			&nbsp;&nbsp;
			<bean:message bundle="sys-tag" key="sysTagTags.fdAlias"/>:
			<c:out value="${sysTagTagsForm.fdAliasNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-tag" key="sysTagTags.fdCategoryId"/>
		</td><td width=35%>
			<c:out value="${sysTagTagsForm.fdCategoryName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagCategory.fdManagerId"/>
		</td><td width=35%>
			<c:out value="${sysTagTagsForm.fdCategoryManagerName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagTags.fdStatus"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysTagTagsForm.fdStatus}" enumsType="sysTagTags_fdStatus" bundle="sys-tag"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagTags.fdQuoteTimes"/>
		</td><td width=35%>
			<c:out value="${sysTagTagsForm.fdCountQuoteTimes}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-tag" key="sysTagTags.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${sysTagTagsForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagTags.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTagTagsForm.docCreateTime}" />
		</td>
	</tr>
</table>
<!-- 点评信息 -->
<!--  
<c:import url="/sys/tag/sys_tag_comment/sysTagComment_view_list.jsp" charEncoding="UTF-8"/>
-->
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>