<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function resetTagCheckSelect() {
	var fdResetMainId = "${param.fdId}";
	if(fdResetMainId!=""){
		var url="<c:url value="sys/tag/sys_tag_tags/sysTagTags.do"/>";
		url+="?method=editResetMainTag&fdResetMainId="+fdResetMainId+"&fdCategoryId=${param.fdCategoryId}";
		var left = document.body.clientWidth/2;
		var top = document.body.clientHeight/2;
		Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
		return;
	}
}
</script>
<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=editResetMainTag&fdCategoryId=${param.fdCategoryId}"
	requestMethod="GET">
	<div
		id="resetTag"
		style="display:none;">
		<input type="button"
			   value="<bean:message key="sysTagTags.button.resetTag" bundle="sys-tag"/>"
			   onclick="resetTagCheckSelect();">
	</div>
	<script>OptBar_AddOptBar("resetTag");</script>
</kmss:auth>

