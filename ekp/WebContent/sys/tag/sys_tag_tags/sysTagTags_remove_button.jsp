<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function removeTagCheckSelect() {
	var fdRemoveMainId = "${param.fdId}";
	if(fdRemoveMainId!=""){
		var url="<c:url value="sys/tag/sys_tag_tags/sysTagTags.do"/>";
		url+="?method=editRemoveAliasTag&fdRemoveMainId="+fdRemoveMainId+"&fdCategoryId=${param.fdCategoryId}";
		var left = document.body.clientWidth/2;
		var top = document.body.clientHeight/2;
		Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
		return;
	}
}
</script>
<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=editRemoveAliasTag&fdCategoryId=${param.fdCategoryId}"
	requestMethod="GET">
	<div
		id="removeTag"
		style="display:none;">
		<input type="button"
			   value="<bean:message key="sysTagTags.button.removeTag" bundle="sys-tag"/>"
			   onclick="removeTagCheckSelect();">
	</div>
	<script>OptBar_AddOptBar("removeTag");</script>
</kmss:auth>

