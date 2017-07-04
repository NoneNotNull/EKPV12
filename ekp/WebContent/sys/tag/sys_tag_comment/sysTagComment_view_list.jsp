<%@ include file="/resource/jsp/common.jsp"%>

<table width=95%>
	<tr>
		<td id="commentContent">
			<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
			</iframe>
		</td>	
	</tr>
</table>
<script>	
Com_IncludeFile("optbar.js");
function edition_LoadIframe(){
	var iframe = document.getElementById("commentContent").getElementsByTagName("IFRAME")[0];
	if(iframe.src==""){
		iframe.src="<c:url value="/sys/tag/sys_tag_comment/sysTagComment.do?method=list&fdTagId="/>${sysTagTagsForm.fdId}";
	}
}
edition_LoadIframe();
</script>