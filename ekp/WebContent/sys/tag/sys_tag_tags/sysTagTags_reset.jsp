<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function validateEmpty() {
	var fdResetAliasId = document.getElementsByName("fdResetAliasId")[0];
	if(fdResetAliasId.value=="") {
		alert("<bean:message key="sysTagTags.resetTag.msg.aliasTag" bundle="sys-tag"/>");
		return false;
	}
	return true;
}

function dialog_aliasTag(){
	//排除当前标签
	Dialog_List(false, 'fdResetAliasId', 'fdResetAliasName', ';', Data_GetBeanNameOfFindPage('sysTagTagsService', 'fdId:fdName',null,null,'sysTagTags.fdMainTagId = \'${param.fdResetMainId}\'','sysTagTags.docCreateTime desc'),null,null,null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
}

window.onload = function(){
	dialog_aliasTag();
}

</script>

<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do">
	<div id="optBarDiv">
		<input type=button
			   value="<bean:message key="button.save"/>"
			   onclick="if(validateEmpty())Com_Submit(document.sysTagTagsForm, 'saveResetMainTag');">
		<input type="button" value="<bean:message key="button.close"/>"
			   onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-tag" key="sysTagTags.resetTag.title" /></p>
	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width=30%>
			<bean:message key="sysTagTags.resetTag.alias" bundle="sys-tag"/></td>
			<td>
			<html:hidden property="fdResetAliasId"/>
			<input type="text" name="fdResetAliasName" style="width:80%;" class="inputsgl" readonly>
			<span class="txtstrong">*</span>&nbsp;&nbsp;
			<a href="#"
				onclick="dialog_aliasTag();">
			<bean:message key="dialog.selectOther" /></a>	
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="fdRemoveMainId" value="${param.fdResetMainId}"/>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
