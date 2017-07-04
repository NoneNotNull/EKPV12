<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function removeTagCheckSelect() {
	var fdCategoryId = "${param.fdId}";
	if(fdCategoryId!=""){
		var url="<c:url value="sys/tag/sys_tag_category/sysTagCategory.do"/>";
		url+="?method=editRemoveTags&fdCategoryId="+fdCategoryId;
		var left = document.body.clientWidth/2;
		var top = document.body.clientHeight/2;
		Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
		return;
	}
}
</script>
<kmss:auth
	requestURL="/sys/tag/sys_tag_category/sysTagCategory.do?method=editRemoveTags"
	requestMethod="GET">
	<div
		id="removeTag"
		style="display:none;">
		<input type="button"
			   value="<bean:message key="sysTagCategory.button.removeTags" bundle="sys-tag"/>"
			   onclick="removeTagCheckSelect();">
	</div>
	<script>OptBar_AddOptBar("removeTag");</script>
</kmss:auth>

