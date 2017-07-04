<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function validateEmpty() {
	var fdMoveTargetId = document.getElementsByName("fdMoveTargetId")[0];
	if(fdMoveTargetId.value=="") {
		alert("<bean:message key="sysTagTags.moveTag.msg.cateEmpty" bundle="sys-tag"/>");
		return false;
	}
	return true;
}

function dialog_categroy(){
	Dialog_List(false, 'fdMoveTargetId', 'fdMoveTargetName', ';', 'sysTagCategoryListService',null,null,null,null,'<bean:message key="sysTagTags.fdCategoryId" bundle="sys-tag"/>');
	
}

window.onload = function(){
	dialog_categroy();
}

</script>

<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do">
	<div id="optBarDiv">
		<input type=button
			   value="<bean:message key="button.save"/>"
			   onclick="if(validateEmpty())Com_Submit(document.sysTagTagsForm, 'saveMoveTags');">
		<input type="button" value="<bean:message key="button.close"/>"
			   onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-tag" key="sysTagTags.moveTag.title" /></p>
	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width=30%>
			<bean:message key="sysTagTags.moveTag.to" bundle="sys-tag"/></td>
			<td>
			<html:hidden property="fdMoveTargetId"/>
			<input type="text" name="fdMoveTargetName" style="width:80%;" class="inputsgl" readonly>
			<span class="txtstrong">*</span>&nbsp;&nbsp;
			<a href="#"
				onclick="dialog_categroy();">
			<bean:message key="dialog.selectOther" /></a>	
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="fdMoveTagIds" value="${param.fdMoveTagIds}"/>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
