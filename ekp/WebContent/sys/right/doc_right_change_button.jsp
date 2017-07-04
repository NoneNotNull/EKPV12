<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
<!-- 
function changeRightCheckSelect() {
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
		if(selected) {
			var url="<c:url value="/sys/right/rightDocChange.do"/>";
			url+="?method=docRightEdit&modelName=${param.modelName}&categoryId=${param.categoryId}";
			url+="&authReaderNoteFlag=${param.authReaderNoteFlag}";
			//url+="&fdIds="+values;
			Com_OpenWindow(url,'_blank','height=650, width=800, toolbar=0, menubar=0, scrollbars=1, resizable=1, status=1');
			return;
		}
	}
	alert("<bean:message bundle="sys-right" key="right.change.batch.selectdocfirst" />");
	return ;
}
// -->
</script>

<kmss:auth
			requestURL="/sys/right/rightDocChange.do?method=docRightEdit&modelName=${param.modelName}&categoryId=${param.categoryId}"
			requestMethod="GET">
<div
	id="changeRightBatch"
	style="display:none;">
	<input
			type="button"
			value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
			onclick="changeRightCheckSelect();">
	</div>
<script>OptBar_AddOptBar("changeRightBatch");</script>
</kmss:auth>

