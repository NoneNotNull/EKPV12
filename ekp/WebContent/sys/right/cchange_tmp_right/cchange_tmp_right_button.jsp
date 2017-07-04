<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
<!-- 
function changeRightCheckSelect(formObj, method) {
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
			document.getElementById('fdIds').value=values;
			window.open('<c:url value="/sys/right/cchange_tmp_right/cchange_tmp_right.jsp?authReaderNoteFlag=${param.authReaderNoteFlag}&tmpModelName=${param.tmpModelName}&mainModelName=${param.mainModelName}&templateName=${param.templateName}"/>');
			return;
		}
	}
	alert("<bean:message bundle="sys-right" key="right.change.batch.selecttmpfirst" />");
	return false;
}
// -->
</script>
<div
	id="changeRightBatch"
	style="display:none;"><kmss:authShow roles="ROLE_SYSCATEGORY_MAINTAINER">
	<c:if test="${not empty param.type }">
		<input
			type="button"
			value="<bean:message key="right.button.changeRight" bundle="sys-right"/>"
			onclick="changeRightCheckSelect(document.tmpBatchChangeRightForm, 'tmpChangeRightBatch');">
	</c:if>
	<c:if test="${empty param.type }">
		<input
			type="button"
			value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
			onclick="changeRightCheckSelect(document.tmpBatchChangeRightForm, 'tmpChangeRightBatch');">
	</c:if>
</kmss:authShow></div>
<input type='hidden' id='fdIds'>
<script>OptBar_AddOptBar("changeRightBatch");</script>
