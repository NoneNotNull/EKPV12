<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="tagNames" value="${param.tagNames}"/>
<c:if test="${not empty tagNames}">
<div class="sideBox">
	<h2 id="tagRelated">
		<span><bean:message key="sysTag.search.result.relatedDoc" bundle="sys-tag" /></span>
	</h2>
	<div>
		<iframe id="tagIframe" src=""
			frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
	</div>
</div>
<script>
function tag_LoadIframe(){
	var iframe = document.getElementById("tagIframe");
	if(iframe.getAttribute('src')==""){
		var tagName = "";
		var fdModelId = "${param.fdModelId}";
		var fdTagNames = "${tagNames}";	
		var tagNames = fdTagNames.split(" ");
		if(tagNames.length>0 && tagNames!=''){
			tagName = tagNames[0];
			var tagRelated = document.getElementById("tagRelated");
			tagRelated.innerHTML = '<span>"'+tagName+'" <bean:message key="sysTag.search.result.relatedDoc" bundle="sys-tag" /></span>';
		}
		iframe.src = "<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=search&queryType=normal' />&queryString="+encodeURIComponent(tagName)+"&iframeId=tagIframe&forward=docView&fdModelId="+fdModelId;
	}
}
tag_LoadIframe();
</script>
</c:if>