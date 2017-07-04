<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super />
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/style/catelog.css">
		<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_edit_catelog_js.jsp"%>  
		<script >
			Com_IncludeFile("validation.js|plugin.js|eventbus.js|xform.js", null, "js");
			seajs.use(['theme!form']);
		</script>
		<style>
			.tb_simple tbody tr td {
				padding: 8px 0px;
			}
		</style>
	</template:replace>
	<template:replace name="body">
		<div style="padding:20px;20px;">
		  	<div class="lui_form_subject">
		  		${lfn:message('kms-wiki:kmsWiki.editCatelog') }
		  	</div>
			<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do">
				<input type='hidden' name="fdId" value="${param.fdId}"/>
				<table class="tb_simple" width="100%" id="TABLE_DocList" >
						 <tr class="lui_wiki_catelogEdit_tr_head">
		                      <td width="5%" style="padding-top:5px;padding-bottom: 5px;">
		                      	<input type="checkbox" id="fdCatelogList_seclectAll" onclick="changeSelectAll(this);" /></td>
		                      <td width="6%">${lfn:message('kms-wiki:kmsWikiCatelogTemplate.fdOrder') }</td>
		                      <td width="40%">${lfn:message('kms-wiki:kmsWikiCatelogTemplate.fdName') }</td>
		                      <td>${lfn:message('kms-wiki:kmsWikiCatelogTemplate.authTmpEditors') }<span class="lui_wiki_catelog_add" title="${lfn:message('button.insert') }" style="margin-left: 100px" onclick="add_Row();"></span>
		                      	   <span class="lui_wiki_catelog_del" title="${lfn:message('button.delete') }" onclick="delete_Row();"></span>
		                      	   <span class="lui_wiki_catelog_up" title="${lfn:message('button.moveup') }" onclick="move_Row(-1);"></span>
		                      	   <span class="lui_wiki_catelog_down" title="${lfn:message('button.movedown') }" onclick="move_Row(1);"></span></td>
		                 </tr>
		                 <tr KMSS_IsReferRow="1" style="display:none;" class="lui_wiki_catelogEdit_tr"> 
							<td valign="top" >
								<input type="checkbox" name="fdCatelogList_seclect" onclick="changeSelect(this);" />
								<input type='hidden' name ='fdCatelogList[!{index}].fdId'/>
								<input type='hidden' name ='fdCatelogList[!{index}].fdOrder'/>
								<input type='hidden' name ='fdCatelogList[!{index}].docContent'/>
								<input type='hidden' name ='fdCatelogList[!{index}].fdParentId'/>
							</td>
							<td KMSS_IsRowIndex="1" valign="top"></td>
							<td valign="top">
								<input type='text' name='fdCatelogList[!{index}].fdName' style="width:98%"  class="inputsgl" />
								<!--  <input type="text"><input>-->
							</td>
							<td>
								<div class="inputselectmul" onclick="selectEditors(this);" style="width:90%;">
									<input name="fdCatelogList[!{index}].authEditorIds" value="" type="hidden">
									<div class="textarea">
									<textarea name="fdCatelogList[!{index}].authEditorNames" readonly="true"></textarea>
									</div>
									<div class="orgelement">
									</div>
								</div>
							</td>
						</tr>
				</table>
			<html:hidden property="method_GET"/>
			</html:form>
			<html:javascript formName="kmsWikiMainForm"  cdata="false"
		      dynamicJavascript="false" staticJavascript="false"/>
		</div>
	</template:replace>
</template:include>

