<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function validateEmpty() {
	var fdRemoveTagIds = document.getElementsByName("fdRemoveTagIds")[0];
	if(fdRemoveTagIds.value=="") {
		alert("<bean:message key="sysTagCategory.removeTags.msg.tags" bundle="sys-tag"/>");
		return false;
	}
	return true;
}

function dialog_tag(){
	//Dialog_List(true, 'fdAddTagIds', 'fdAddTagNames', ';', Data_GetBeanNameOfFindPage('sysTagTagsService', 'fdId:fdName','1','100','sysTagTags.fdCategory is null and sysTagTags.fdStatus = 1 and sysTagTags.fdMainTagId is null','sysTagTags.docCreateTime desc'),null,null,null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
	Dialog_List(true, 'fdRemoveTagIds', 'fdRemoveTagNames', ';','sysTagTagsTreeService&type=remove&fdCategoryId=${param.fdCategoryId}',null,'sysTagTagsTreeService&type=remove&fdCategoryId=${param.fdCategoryId}&key=!{keyword}',null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
}

window.onload = function(){
	dialog_tag();
}

</script>

<html:form action="/sys/tag/sys_tag_category/sysTagCategory.do">
	<div id="optBarDiv">
		<input type=button
			   value="<bean:message key="button.save"/>"
			   onclick="if(validateEmpty())Com_Submit(document.sysTagCategoryForm, 'saveRemoveTags');">
		<input type="button" value="<bean:message key="button.close"/>"
			   onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-tag" key="sysTagCategory.removeTags.title" /></p>
	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width=30%>
			<bean:message key="sysTagCategory.removeTags.tags" bundle="sys-tag"/></td>
			<td>
			<html:hidden property="fdRemoveTagIds"/>
			<input type="text" name="fdRemoveTagNames" style="width:80%;" class="inputsgl" readonly>
			<span class="txtstrong">*</span>&nbsp;&nbsp;
			<a href="#"
				onclick="dialog_tag();">
			<bean:message key="dialog.selectOther" /></a>	
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="fdCategoryId" value="${param.fdCategoryId}"/>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
