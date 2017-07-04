<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
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
			document.getElementById('fdIds').value = values;
			var url="<c:url value="/sys/right/cchange_doc_right/cchange_doc_right.jsp"/>";
			url+="?modelName=${param.modelName}";
			url+="&authReaderNoteFlag=${param.authReaderNoteFlag}";
			window.open(url);
			return true;
		}
	}
	alert("<bean:message bundle="sys-right" key="right.change.batch.selectdocfirst" />");
	return true;
}

</script>
<div id="changeRightBatch" style="display:none;">
	<kmss:authShow roles="ROLE_SYSCATEGORY_MAINTAINER">
	<input type="button"
			value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
			onclick="changeRightCheckSelect();">
	 </kmss:authShow>
	</div>
<script>OptBar_AddOptBar("changeRightBatch");</script>
<input type='hidden' id='fdIds'>
