<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysReadLogForm" value="${requestScope[param.formName]}" />
<script>
function readLog_LoadIframe(){
 var iframe5 = document.getElementById("readLogContent").getElementsByTagName("IFRAME")[0];
 iframe5.src = "<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsSysReadLog.do" />?method=view&modelId=${sysReadLogForm.readLogForm.fdModelId}&modelName=${sysReadLogForm.readLogForm.fdModelName}";
 }
</script>
<c:if test="${sysReadLogForm.readLogForm.fdIsShow=='true'}">
	<c:if test = "${sysReadLogForm.readLogForm.fdReadCount==0}">
		<tr KMS_TR_TAG="<bean:message bundle="sys-readlog" key="sysReadLog.tab.readlog.label" />" 
		   onclick="readLog_LoadIframe();" style="display:none"  id="readLogTr">
	</c:if>
	<c:if test = "${sysReadLogForm.readLogForm.fdReadCount!=0}">
	<tr KMS_TR_TAG="<bean:message bundle="sys-readlog" key="sysReadLog.tab.readlog.label" />" 
		   TAG_NUM="(${sysReadLogForm.readLogForm.fdReadCount})" SHOW_NUM="true" 
		   onclick="readLog_LoadIframe();"  style="display:none" id="readLogTr">
		<td><a name='readlog'></a>  
			<table border="0" cellspacing="0" height="100%" width="100%" cellpadding="0"   >
				<tr >
					<td id="readLogContent"   valign="top"> 
					<input type="hidden" name="_readerListDisFlag" value="false">
					<input type="hidden" name="_readlogDivDisFlag" value="false">
						<iframe src="" width="100%"  height="100%"  frameborder="0" scrolling="no">
						</iframe>
					</td> 
				</tr>
				<tr valign="top">
					<td valign="top" ><bean:message bundle="sys-readlog" key="sysReadLog.info.click" /></td>
				</tr> 
			</table>
		</td>
	</tr>
	</c:if>
</c:if>

