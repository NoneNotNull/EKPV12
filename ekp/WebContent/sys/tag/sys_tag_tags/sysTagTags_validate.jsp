<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");
function dialog_tag(){
		Dialog_List(false, 'fdMoveTargetId', 'fdMoveTargetName', ';', 'sysTagCategoryListService',null,null,null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
}
window.onload = function(){
	dialog_tag();
}
</script>

<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do">
	<div id="optBarDiv">
		<input type=button
			   value="<bean:message key="button.save"/>"
			   onclick="Com_Submit(document.sysTagTagsForm, 'saveValidateTags');">
		<input type="button" value="<bean:message key="button.close"/>"
			   onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-tag" key="sysTagTags.validateTag.title" /></p>
	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width=30%>
				<bean:message key="sysTagTags.fdCategoryId" bundle="sys-tag"/>
			</td>
			<td>
				<html:hidden property="fdMoveTargetId"/>
				<input type="text" name="fdMoveTargetName" style="width:80%;" class="inputsgl" readonly>
				<a href="#"
					onclick="dialog_tag();">
				<bean:message key="dialog.selectOther" /></a>	
				<html:hidden property="fdMoveTagIds" value="${param.fdMoveTagIds}"/>				
			</td>
		</tr>
	</table>
</center>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
