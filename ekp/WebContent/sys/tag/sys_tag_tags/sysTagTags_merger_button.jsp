<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
function mergerTagCheckSelect() {
	//list页面选择标签合并到主标签
	if(${param.type == 'main'}){
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
				url+="?method=editMergerTag&type=${param.type}&fdMergerTagIds="+values+"&fdCategoryId=${param.fdCategoryId}";
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
	if(${param.type == 'alias'}){
		var fdMergerTargetId = "${param.fdId}";
		if(fdMergerTargetId!=""){
			var url="<c:url value="sys/tag/sys_tag_tags/sysTagTags.do"/>";
			url+="?method=editMergerTag&fdCategoryId=${param.fdCategoryId}&type=${param.type}&fdMergerTargetId="+fdMergerTargetId+"";
			var left = document.body.clientWidth/2;
			var top = document.body.clientHeight/2;
			Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+url),'500','250');
			return;
		}
	}	
}
</script>
<kmss:auth
	requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=editMergerTag&fdCategoryId=${param.fdCategoryId}"
	requestMethod="GET">
		<div
			id="mergerTag"
			style="display:none;">
			<!-- list页面合并标签 -->
			<c:if test="${param.type == 'main' }">
				<input type="button"
					   value="<bean:message key="sysTagTags.button.mergerTag" bundle="sys-tag"/>"
					   onclick="mergerTagCheckSelect();">
			</c:if>
			<c:if test="${param.type == 'alias' }">
			<input type="button"
				   value="<bean:message key="sysTagTags.button.mergerTags" bundle="sys-tag"/>"
				   onclick="mergerTagCheckSelect();">
			</c:if>
		</div>
	<script>OptBar_AddOptBar("mergerTag");</script>
</kmss:auth>

