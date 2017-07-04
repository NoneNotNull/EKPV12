<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
<!-- 
function changeRightCheckSelect() {
	if(${param.type == 'doc'}){
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
				Com_OpenWindow(Com_Parameter.ContextPath+'sys/right/batchChangeRight.do?method=changeRightBatch&moduleModelName=${param.modelName}&type=${param.type}&fdIds='+values,'_blank','height=400, width=550, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
				return;
			}
		}
		alert("<bean:message bundle="sys-right" key="right.change.batch.selectdocfirst" />");
		return false;
	}else if(${param.type == 'tmpdoc'}){
		Com_OpenWindow(Com_Parameter.ContextPath+'sys/right/batchChangeRight.do?method=changeRightBatch&moduleModelName=${param.modelName}&type=${param.type}&fdId=${param.fdId}','_blank','height=400, width=550, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
	}
}
// -->
</script>
<div
	id="changeRightBatch"
	style="display:none;"><kmss:authShow roles="ROLE_SYSCATEGORY_MAINTAINER">
	<c:if test="${param.type == 'doc' }">
		<input
			type="button"
			value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
			onclick="changeRightCheckSelect();">
	</c:if>
	<c:if test="${param.type == 'tmpdoc'}">
		<input
			type="button"
			value="<bean:message key="right.button.changeRight" bundle="sys-right"/>"
			onclick="changeRightCheckSelect();">
	</c:if>
</kmss:authShow></div>
<script>OptBar_AddOptBar("changeRightBatch");</script>
