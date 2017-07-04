<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function validateTagEmpty() {
	if(${param.type == 'main'}){
		var fdMergerTargetId = document.getElementsByName("fdMergerTargetId")[0];
		if(fdMergerTargetId.value=="") {
			alert("<bean:message key="sysTagTags.mergerTag.msg.mainTag" bundle="sys-tag"/>");
			return false;
		}
	}
	if(${param.type == 'alias'}){
		var fdMergerTagIds = document.getElementsByName("fdMergerTagIds")[0];
		if(fdMergerTagIds.value=="") {
			alert("<bean:message key="sysTagTags.mergerTag.msg.aliasTag" bundle="sys-tag"/>");
			return false;
		}
	}
	return true;
}
function dialog_tag(){
	//list页面选择标签合并到主标签
	if(${param.type == 'main'}){
		//排除已选标签
		var fdMergerTagIds = "${param.fdMergerTagIds}".split(",");
		var mergerTagsIds = '';
		for(var i=0;i<fdMergerTagIds.length;i++){
			if(i == fdMergerTagIds.length-1){
				mergerTagsIds += '\''+fdMergerTagIds[i]+'\'';
			}else{
				mergerTagsIds += '\''+fdMergerTagIds[i]+'\''+',';
			}
		}
		//Dialog_List(false, 'fdMergerTargetId', 'fdMergerTargetName', ';', Data_GetBeanNameOfFindPage('sysTagTagsService', 'fdId:fdName',1,100,'sysTagTags.fdMainTagId is null  and sysTagTags.fdStatus = 1 and sysTagTags.fdId not in('+mergerTagsIds+')','sysTagTags.docCreateTime desc'),null,null,null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
		Dialog_List(false, 'fdMergerTargetId', 'fdMergerTargetName', ';', 'sysTagTagsTreeService&type=merger&mergerTagsIds='+mergerTagsIds+'&fdCategoryId=${param.fdCategoryId}',null,'sysTagTagsTreeService&type=merger&mergerTagsIds='+mergerTagsIds+'&fdCategoryId=${param.fdCategoryId}&key=!{keyword}',null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
	}
	//view页面选择别名标签合并到当前标签
	if(${param.type == 'alias'}){
		var fdMergerTagIds = "${param.fdMergerTargetId}".split(",");
		var mergerTagsIds = '';
		for(var i=0;i<fdMergerTagIds.length;i++){
			if(i == fdMergerTagIds.length-1){
				mergerTagsIds += '\''+fdMergerTagIds[i]+'\'';
			}else{
				mergerTagsIds += '\''+fdMergerTagIds[i]+'\''+',';
			}
		}
		//排除当前标签
		//Dialog_List(true, 'fdMergerTagIds', 'fdMergerTagNames', ';', Data_GetBeanNameOfFindPage('sysTagTagsService', 'fdId:fdName',1,100,'sysTagTags.fdMainTagId is null  and sysTagTags.fdStatus = 1 and sysTagTags.fdId != \'${param.fdMergerTargetId}\'','sysTagTags.docCreateTime desc'),null,null,null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
		Dialog_List(true, 'fdMergerTagIds', 'fdMergerTagNames', ';', 'sysTagTagsTreeService&type=merger&mergerTagsIds='+mergerTagsIds+'&fdCategoryId=${param.fdCategoryId}',null,'sysTagTagsTreeService&type=merger&mergerTagsIds='+mergerTagsIds+'&fdCategoryId=${param.fdCategoryId}&key=!{keyword}',null,null,'<bean:message key="table.sysTagTags" bundle="sys-tag"/>');
	}
}
window.onload = function(){
	dialog_tag();
}
</script>

<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do">
	<div id="optBarDiv">
		<input type=button
			   value="<bean:message key="button.save"/>"
			   onclick="if(validateTagEmpty())Com_Submit(document.sysTagTagsForm, 'saveMergerTags');">
		<input type="button" value="<bean:message key="button.close"/>"
			   onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle"><bean:message bundle="sys-tag" key="sysTagTags.mergerTag.title" /></p>
	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<c:if test="${param.type == 'main' }">
				<td class="td_normal_title" width=30%>
					<bean:message key="sysTagTags.mergerTag.to" bundle="sys-tag"/>
				</td>
				<td>
					<html:hidden property="fdMergerTargetId"/>
					<input type="text" name="fdMergerTargetName" style="width:80%;" class="inputsgl" readonly>
					<span class="txtstrong">*</span>&nbsp;&nbsp;
					<a href="#"
						onclick="dialog_tag();">
					<bean:message key="dialog.selectOther" /></a>	
					<html:hidden property="fdMergerTagIds" value="${param.fdMergerTagIds}"/>				
				</td>
			</c:if>
			<c:if test="${param.type == 'alias' }">
				<td class="td_normal_title" width=30%>
					<bean:message key="sysTagTags.mergerTag.merger" bundle="sys-tag"/>
				</td>
				<td>
					<html:hidden property="fdMergerTagIds"/>
					<input type="text" name="fdMergerTagNames" style="width:80%;" class="inputsgl" readonly>
					<span class="txtstrong">*</span>&nbsp;&nbsp;
					<a href="#"
						onclick="dialog_tag();">
					<bean:message key="dialog.selectOther" /></a>	
					<html:hidden property="fdMergerTargetId" value="${param.fdMergerTargetId}"/>				
				</td>
			</c:if>
		</tr>
	</table>
</center>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
