<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function addTagCheckSelect() {
	var fdAddTargetId = "${param.fdId}";
	if(fdAddTargetId!=""){
		var url="<c:url value="sys/tag/sys_tag_category/sysTagCategory.do"/>";
		url+="?method=editAddTags&fdAddTargetId="+fdAddTargetId;
		var left = document.body.clientWidth/2;
		var top = document.body.clientHeight/2;
		Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
		return;
	}
}
</script>
<kmss:auth
	requestURL="/sys/tag/sys_tag_category/sysTagCategory.do?method=editAddTags"
	requestMethod="GET">
	<div
		id="addTag"
		style="display:none;">
		<input type="button"
			   value="<bean:message key="sysTagCategory.button.addTags" bundle="sys-tag"/>"
			   onclick="addTagCheckSelect();">
	</div>
	<script>OptBar_AddOptBar("addTag");</script>
</kmss:auth>

