<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
Com_IncludeFile("doclist.js|dialog.js|data.js"); 
//部署html编辑器-目录
RTF_Plugins_docContent = new Array("category");

//提交
function Com_Submit_kmsWikiTemplateForm(form,method){
	Com_Submit(form,method);
}
var _loaded = false;
var hasSetHtmlToContent = false;
var htmlContent = '';
var fdIds=new Array(); 
function getHTMLtoContent() {
	var url = "";
	if (hasSetHtmlToContent) return true;
	var obj = document.getElementsByName('F_EditType');
	var type=document.getElementsByName("fdContentType")[0];
	var hasImg = false;

	hasSetHtmlToContent = true;
	return true;
}

function resetHasSetHtmlToContent() {
	if (hasSetHtmlToContent) {
		document.kmsWikiTemplateForm.fdHtmlContent.value = htmlContent;
	}
	hasSetHtmlToContent = true;
	return true;
}

</script>
	