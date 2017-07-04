<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	function Cate_CheckNotReaderFlag(el){
		document.getElementById("Cate_AllUserId").style.display=el.checked?"none":"";
		document.getElementById("Cate_AllUserNote").style.display=el.checked?"none":"";
		el.value=el.checked;
	}
	
	function Cate_Win_Onload(){
		Cate_CheckNotReaderFlag(document.getElementById("authNotReaderFlag"));
	}

Com_AddEventListener(window, "load", Cate_Win_Onload);
	
function check(){
	var formObj = document.kmsWikiCategoryForm;
	if(formObj.fdParentId.value!="" && formObj.fdParentId.value==formObj.fdId.value){
		alert("<bean:message bundle="sys-simplecategory" key="error.illegalSelected" />");
		return false;
	}

	//var templateId = document.getElementsByName("fdTemplateId")[0];
	//if(templateId.value == "" || templateId.value == null){
		//alert("<bean:message bundle="kms-wiki" key="kmsWikiCategoryForm.templateId.error" />");
		//return false;
	//}
	return true;
}

Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = check;

Com_IncludeFile("jquery.js", null, "js");

function Cate_getParentMaintainer(){
	var url = Com_Parameter.ContextPath+"kms/wiki/kms_wiki_category/kmsWikiCategory.do?method=getParentMaintainer";
	jQuery.ajax({
		url: url,
		type: 'get',
		dataType: 'html',
		data: {
			'parentId': document.getElementsByName("fdParentId")[0].value
		},
		success: function(data, textStatus, xhr) {
			$(document.getElementById("parentMaintainerId")).text(xhr.responseText);
		},
		error: function(xhr, textStatus, errorThrown) {
			alert(errorThrown);
		}
	});
	/*  移除prototype异步提交方式--防止库冲突
	var ajax = new Ajax.Request(
		url,
		{
			method: "get",
			parameters: parameters,
			asynchronous: false,
			onComplete: function(oriRequest){Com_SetInnerText(document.getElementById("parentMaintainerId"),oriRequest.responseText);}
		}
	);
	*/
}

</script>