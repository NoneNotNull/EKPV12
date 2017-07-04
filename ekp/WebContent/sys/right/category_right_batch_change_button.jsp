<%@ include file="/resource/jsp/common.jsp"%>
<script language=javascript>
	function openDialogWin()
	{
	    var result = window.showModalDialog("<c:url value="/sys/right/showmessage.jsp" />","","dialogHeight:160px; dialogWidth:300px; status:no; help:no; scroll:no");
	    if(result == "tmpdoc")
	        Com_OpenWindow('<c:url value="/sys/right/batchChangeRight.do"/>?method=categoryChangeRightBatch&fdCategoryId=${param.fdId}&type=tmpdoc&moduleModelName=${param.mainModelName}','_blank','height=400, width=550, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
	    else if(result == "tmp")
	        Com_OpenWindow('<c:url value="/sys/right/batchChangeRight.do"/>?method=categoryChangeRightBatch&fdCategoryId=${param.fdId}&type=tmp&moduleModelName=${param.mainModelName}','_blank','height=400, width=550, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1');
	}
</script>
<div
	id="changeRightBatch"
	style="display:none;"><kmss:authShow roles="ROLE_SYSCATEGORY_MAINTAINER">
	<input
		type="button"
		value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
		onclick="openDialogWin();">
</kmss:authShow></div>
<script>OptBar_AddOptBar("changeRightBatch");</script>
