<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function moveTagCheckSelect() {
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
			var url="<c:url value="sys/tag/sys_tag_tags/sysTagTags.do"/>";
			url+="?method=editMoveTag&fdCategoryId=${param.fdCategoryId}&fdMoveTagIds="+values;
			var left = document.body.clientWidth/2;
			var top = document.body.clientHeight/2;
			Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
			return;
		}
	}
	alert("<bean:message key="page.noSelect"/>");
	return ;
}
</script>
<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=editMoveTag&fdCategoryId=${param.fdCategoryId}"
	requestMethod="GET">
	<div
		id="moveTag"
		style="display:none;">
		<input type="button"
			   value="<bean:message key="sysTagTags.button.moveTag" bundle="sys-tag"/>"
			   onclick="moveTagCheckSelect();">
	</div>
	<script>OptBar_AddOptBar("moveTag");</script>
</kmss:auth>

