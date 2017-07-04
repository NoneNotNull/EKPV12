<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function validateTagCheckSelect() {
	//list页面选择标签生效
	if(${param.method == 'list'}){
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
				url+="?method=editValidateTag&fdMoveTagIds="+values+"&fdCategoryId=${param.fdCategoryId}";
				var left = document.body.clientWidth/2;
				var top = document.body.clientHeight/2;
				Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
				return;
			}
		}
		alert("<bean:message key="page.noSelect"/>");
		return ;
	}
	//view页面选择别名标签合并到当前标签
	if(${param.method == 'view'}){
		var fdMoveTagIds = "${param.fdId}";
		if(fdMoveTagIds!=""){
			var url="<c:url value="sys/tag/sys_tag_tags/sysTagTags.do"/>";
			url+="?method=editValidateTag&fdCategoryId=${param.fdCategoryId}&fdMoveTagIds="+fdMoveTagIds+"";
			var left = document.body.clientWidth/2;
			var top = document.body.clientHeight/2;
			Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
			return;
		}
	}	
}
</script>
<kmss:auth 
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=saveValidateTags&fdCategoryId=${param.fdCategoryId}" 
	requestMethod="GET">
		<div
			id="validateTag"
			style="display:none;">
			<input type="button"
				   value="<bean:message key="sysTagTags.button.saveValidateTags" bundle="sys-tag"/>"
				   onclick="validateTagCheckSelect();">
		</div>
	<script>OptBar_AddOptBar("validateTag");</script>
</kmss:auth>

