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
			Com_OpenWindow(Com_Parameter.ContextPath+'sys/right/tmpBatchChangeRight.do?method=tmpChangeRightBatch&moduleModelName=${param.modelName}&fdIds='+values,'_blank','height=400, width=550, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
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
			onclick="changeRightCheckSelect();">
	</c:if>
	<c:if test="${empty param.type }">
		<input
			type="button"
			value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
			onclick="changeRightCheckSelect();">
	</c:if>
</kmss:authShow></div>
<script>OptBar_AddOptBar("changeRightBatch");</script>
