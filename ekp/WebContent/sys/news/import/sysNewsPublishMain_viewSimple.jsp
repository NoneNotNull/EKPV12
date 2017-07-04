<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%> 
<c:if test="${sysNewsPublishMainForm.fdIsShow||docForm.docStatusFirstDigit>=3}">
				<kmss:auth requestURL="${sysNewsPublishUrl}" >
					<script language="JavaScript">
						Com_IncludeFile("dialog.js");    
						function SNP_manual_publish(){ 
						 	var  url="../../../sys/news/sys_news_publish_main/sysNewsPublishMain_viewManualFrame.jsp?fdModelNameParam=${sysNewsPublishMainForm.fdModelName}&fdModelIdParam=${sysNewsPublishMainForm.fdModelId}&fdKeyParam=${sysNewsPublishMainForm.fdKey}";   
							seajs.use([ 'lui/dialog','lang!sys-news:news.tree.publishNews'], function(dialog,lang) {
								dialog.iframe(url,lang['news.tree.publishNews'],null,{width:700,height :310});
								});
						} 
					</script> 
					<ui:button parentId="toolbar" text="${lfn:message('sys-news:sysNewsPublishMain.tab.publish.label') }" 
						onclick="SNP_manual_publish();" order="3">
					</ui:button>
				</kmss:auth>
			</c:if>
			<ui:event event="show">				
			var fdModelName='${sysNewsPublishMainForm.fdModelName}';
			var fdModelId='${sysNewsPublishMainForm.fdModelId}';
			var fdKey='${sysNewsPublishMainForm.fdKey}';	  
			document.getElementById('publishRecord').src = ("<c:url value='/sys/news/sys_news_publish_main/sysNewsPublishMain_viewAllPublish.jsp?method=viewAllPublish&fdModelNameParam="+fdModelName+"&fdModelIdParam="+fdModelId+"&fdKeyParam='/>"+fdKey);
			</ui:event>
			<table width="100%">
				<tr>
					<td>
				 		<iframe id="publishRecord" width=100% height="100%" frameborder=0 scrolling=no></iframe>
					</td>
				</tr>
			</table>