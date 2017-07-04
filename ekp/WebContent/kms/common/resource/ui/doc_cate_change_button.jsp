<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
</script>
<script type="text/javascript">
function changeCateCheckSelect() {
	var selected=false;
	var select = document.getElementsByName("List_Selected");
	for(var i=0;i<select.length;i++) {
		if(select[i].checked){
			selected=true;
			break;
		}
	}
	if(selected) {
		selectTemplate('changeTemplate' ) ;
	}else
		alert("<bean:message key="page.noSelect"/>");
}


 
</script>
<kmss:auth
		requestURL="/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=${param.cateModelName}&categoryId=${param.categoryId}"
			requestMethod="GET">
<div
	id="docCateChg"
	style="display:none;">
	<input
			type="button"
			value="<bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/>"
			onclick="changeCateCheckSelect();">
	</div>
<script>OptBar_AddOptBar("docCateChg");</script>
</kmss:auth>

