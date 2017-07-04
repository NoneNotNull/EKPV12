<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%> 
<c:set var="sysNewsPublishMainForm" value="${requestScope[param.formName].sysNewsPublishMainForm}" />
<c:set var="docForm" value="${requestScope[param.formName]}" />
<c:if test="${sysNewsPublishMainForm.fdModelName!=null && sysNewsPublishMainForm.fdModelName!='' && sysNewsPublishMainForm.fdModelId!=null && sysNewsPublishMainForm.fdModelId!=''}"> 
<script>
$(document).ready(function(){
	var fdModelName='${sysNewsPublishMainForm.fdModelName}';
	var fdModelId='${sysNewsPublishMainForm.fdModelId}';
	var fdKey='${sysNewsPublishMainForm.fdKey}';	  
	document.getElementById('publishRecord').src = ("<c:url value='/sys/news/sys_news_publish_main/sysNewsPublishMain_viewAllPublish.jsp?method=viewAllPublish&fdModelNameParam="+fdModelName+"&fdModelIdParam="+fdModelId+"&fdKeyParam='/>"+fdKey);
});
</script>
	<table width="100%">
		<tr>
			<td>
		 		<iframe id="publishRecord" width=100% height="100%" frameborder=0 scrolling=no ></iframe>
			</td>
		</tr>
	</table>
</c:if>