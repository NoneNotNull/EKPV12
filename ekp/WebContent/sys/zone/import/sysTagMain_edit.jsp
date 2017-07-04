<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("data.js|dialog.js");
	Com_IncludeFile("tag.js","${LUI_ContextPath}/sys/zone/import/js/","js",true);
</script>
<c:set var="tag_MainForm" value="${requestScope[param.formName]}"/>
<c:set var="sysTagMainForm" value="${tag_MainForm.sysTagMainForm}"/>
<c:set var="tag_modelName" value="${tag_MainForm.modelClass.name}"/>
<Script type="text/javascript">
	var tag_params = {
			"model":"edit",
			"fdQueryCondition":"${param.fdQueryCondition}",
			"tag_msg1":"<bean:message bundle='sys-tag' key='sysTagMain.message.1'/>",
			"tag_msg2":"<bean:message bundle='sys-tag' key='sysTagMain.message.2'/>",
			"tree_title":"<bean:message key='sysTagTag.tree' bundle='sys-tag'/>",
			"afterOpt" : {"fn":showTags, "ctx" : window},
			"diaEle" : "${param.dialogElement}"
			};
	if(window.tag_opt==null){
		window.tag_opt = new TagOpt('${tag_modelName}','${sysTagMainForm.fdModelId}','${param.fdKey}',
					tag_params);
	}
	Com_AddEventListener(window,'load',function(){
			window.tag_opt.onload(); 
		});

	seajs.use(["lui/jquery"], function() {
		$(function() {
			showTags();
		});
	});
	
	/**
	 * 显示个人所选标签
	 */
	function showTags(){
		var tagNames = LUI.$.trim(LUI.$("#tagNames").val());
		if(tagNames.length!=0){
			var tagNamesArray=tagNames.split(" ");
			var htmlValue="";
			for(var i=0,j=tagNamesArray.length;i<j;i++){
					htmlValue+="<dd><span>"+tagNamesArray[i]+"</span>";
					htmlValue+="</dd>";
			}
			LUI.$("#tagsDiv").html(htmlValue); 
		}
		
	}
</script>
<form name="sysZonePersonInfoForm" id="tagsForm"> 
	<input type="hidden" name="sysTagMainForm.fdId" value="${sysTagMainForm.fdId}"/> 
	<input type="hidden" name="sysTagMainForm.fdKey" value="${param.fdKey}"/>
	<input type="hidden" name="sysTagMainForm.fdModelName"/>
	<input type="hidden" name="sysTagMainForm.fdModelId" value="${tag_MainForm.fdId}"/> 
	<input type="hidden" name="sysTagMainForm.fdQueryCondition" value="${param.fdQueryCondition}"/> 
	<input type="hidden" name="sysTagMainForm.fdTagNames" id="tagNames" value="${sysTagMainForm.fdTagNames}"/>
</form>	
<input type="hidden" name="_fdTagsIds" id="_fdTagsIds" value="${sysTagMainForm.fdTagNames}"/>
<div id="tagsDiv"></div>
<input type="hidden" name="fdId" value="${sysZonePersonInfoForm.fdId}" />
<c:if test="${param.method == 'edit' }">
	<dd name="btn">
		<a class="lui_zone_append_tag" id="tag_selectItem" href="javascript:void(0)"
			title="${lfn:message('sys-zone:sysZonePerson.addTags') }">
			${lfn:message('sys-zone:sysZonePerson.addTags')}
		</a>
	</dd>
</c:if>
