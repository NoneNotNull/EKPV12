<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysNewsPublishMainForm" value="${requestScope[param.formName].sysNewsPublishMainForm}" />
<c:set var="docForm" value="${requestScope[param.formName]}" />
<c:if test="${sysNewsPublishMainForm.fdModelName!=null && 
sysNewsPublishMainForm.fdModelName!='' && sysNewsPublishMainForm.fdModelId!=null && sysNewsPublishMainForm.fdModelId!=''}"> 
<c:set var="sysNewsPublishUrl"
	   value="/sys/news/sys_news_publish_main/sysNewsPublishMain_viewManualFrame.jsp?fdModelNameParam=${sysNewsPublishMainForm.fdModelName}&fdModelIdParam=${sysNewsPublishMainForm.fdModelId}" />
 <%@ page import="com.landray.kmss.util.StringUtil"%>
 
<script language="JavaScript">
Com_IncludeFile("optbar.js|dialog.js");   
</script>
<script language="JavaScript">
function SNP_manual_publish(){ 
  var  url="<c:url value='/sys/news/sys_news_publish_main/sysNewsPublishMain_viewManualFrame.jsp?fdModelNameParam=${sysNewsPublishMainForm.fdModelName}&fdModelIdParam=${sysNewsPublishMainForm.fdModelId}&fdKeyParam=${sysNewsPublishMainForm.fdKey}'/>";   
  var  publish = Dialog_PopupWindow(url, 700, 310);
}
function SNP_publish_LoadIframe(){
	var fdModelName=document.getElementsByName("fdModelName")[0].value;
	var fdModelId=document.getElementsByName("fdModelId")[0].value;
	var fdKey=document.getElementsByName("fdKey")[0].value;	  
	Doc_LoadFrame("publishRecord","<c:url value='/sys/news/sys_news_publish_main/sysNewsPublishMain_viewAllPublish.jsp?' />method=viewAllPublish&fdModelNameParam="+fdModelName+"&fdModelIdParam="+fdModelId+"&fdKeyParam="+fdKey);
}
</script>
<input type="hidden" name="fdModelName" value="${sysNewsPublishMainForm.fdModelName}"/>
<input type="hidden" name="fdModelId" value="${sysNewsPublishMainForm.fdModelId}"/>
<input type="hidden" name="fdKey" value="${sysNewsPublishMainForm.fdKey}"/>

<tr LKS_LabelName='<bean:message bundle="sys-news" key="sysNewsPublishMain.tab.publish.label"/>' style="display:none">
	<td>
		<div id="publishBtn" style="display:none;"> 
		<kmss:auth requestURL="${sysNewsPublishUrl}" >
		<c:if test="${sysNewsPublishMainForm.fdIsShow||docForm.docStatusFirstDigit>=3}">
		 <input type="button" value="<bean:message key="sysNewsPublishMain.tab.publish.label" bundle="sys-news"/>" 
						onclick="SNP_manual_publish()">  
		</c:if> 
		</kmss:auth>
		</div>
		<script>OptBar_AddOptBar("publishBtn");</script>
		<table class="tb_normal" width="100%">
			<tr>
				<td id="publishRecord" onresize="SNP_publish_LoadIframe();">
			 	<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
					</iframe>
				</td>
			</tr>
		</table>
	</td> 
</tr>
</c:if>