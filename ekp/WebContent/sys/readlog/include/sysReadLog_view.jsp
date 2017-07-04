<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysReadLogForm" value="${requestScope[param.formName]}" />
<c:if test="${sysReadLogForm.readLogForm.fdIsShow=='true'}">
	<script>
		function readLog_LoadIframe(){
		 	Doc_LoadFrame("readLogContent", '<c:url value="/sys/readlog/sys_read_log/sysReadLog.do" />?method=view&modelId=${sysReadLogForm.readLogForm.fdModelId}&modelName=${sysReadLogForm.readLogForm.fdModelName}');
		}
	</script>
		<tr LKS_LabelName="<bean:message bundle="sys-readlog" key="sysReadLog.tab.readlog.label" />" style="display:none" >
		<td>
			<table class="tb_normal" width="100%" ${param.styleValue}>
				<tr>
					<td id="readLogContent" onresize="readLog_LoadIframe();" valign="top">
						<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
						</iframe>
						<input type="hidden" id="_readerListDisFlag" name="_readerListDisFlag" value="false">
						<input type="hidden" id="_readlogDivDisFlag" name="_readerListDisFlag" value="false">
					</td>
				</tr>
				<tr class="td_normal">
					<td><bean:message bundle="sys-readlog" key="sysReadLog.info.click" /></td>
				</tr>
			</table>
		</td>
	</tr>
</c:if>

