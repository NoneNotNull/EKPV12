<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function validateEmpty() {
	var fdRemoveAliasIds = document.getElementsByName("fdRemoveAliasIds")[0];
	if(fdRemoveAliasIds.value=="") {
		alert("<bean:message key="sysTagTags.removeTag.msg.aliasTag" bundle="sys-tag"/>");
		return false;
	}
	return true;
}

function dialog_aliasTag(){
	//排除当前标签
	Dialog_List(true, 'fdRemoveAliasIds', 'fdRemoveAliasNames', ';', Data_GetBeanNameOfFindPage('sysTagTagsService', 'fdId:fdName',null,null,'sysTagTags.fdMainTagId = \'${param.fdRemoveMainId}\'','sysTagTags.docCreateTime desc'),null,null,null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
}

window.onload = function(){
	dialog_aliasTag();
}

</script>

<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do">
	<div id="optBarDiv">
		<input type=button
			   value="<bean:message key="button.save"/>"
			   onclick="if(validateEmpty())Com_Submit(document.sysTagTagsForm, 'saveRemoveAliasTags');">
		<input type="button" value="<bean:message key="button.close"/>"
			   onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-tag" key="sysTagTags.removeTag.title" /></p>
	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width=30%>
			<bean:message key="sysTagTags.removeTag.alias" bundle="sys-tag"/></td>
			<td>
			<html:hidden property="fdRemoveAliasIds"/>
			<input type="text" name="fdRemoveAliasNames" style="width:80%;" class="inputsgl" readonly>
			<span class="txtstrong">*</span>&nbsp;&nbsp;
			<a href="#"
				onclick="dialog_aliasTag();">
			<bean:message key="dialog.selectOther" /></a>	
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="fdRemoveMainId" value="${param.fdRemoveMainId}"/>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
