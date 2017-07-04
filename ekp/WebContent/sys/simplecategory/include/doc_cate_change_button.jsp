<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
<!-- 
function changeCateCheckSelect() {
	var values="";
	var selected;
	var select = document.getElementsByName("List_Selected");
	for(var i=0;i<select.length;i++) {
		if(select[i].checked){
			values+=select[i].value;
			values+=",";
			selected=true;
		}
	}
	if(selected) {
		values = values.substring(0,values.length-1);
		    var url="<c:url value="/sys/sc/cateChg.do"/>";
		    url+="?method=cateChgEdit&cateModelName=${param.cateModelName}&modelName=${param.modelName}&categoryId=${param.categoryId}&extProps=${param.extProps}";
		    url+="&docFkName=${param.docFkName}";
			var left = document.body.clientWidth/2;
			var top = document.body.clientHeight/2;
			Com_OpenWindow(url,'_blank','left='+left+',top='+top+',height=300px, width=600px, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
		return;
	}
	alert("<bean:message key="page.noSelect"/>");
	return ;
}
// -->
</script>
<kmss:auth
		requestURL="/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=${param.cateModelName}&categoryId=${param.categoryId}&modelName=${param.modelName}"
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
