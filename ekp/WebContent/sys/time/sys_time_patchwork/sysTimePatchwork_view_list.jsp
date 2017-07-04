<%@ include file="/resource/jsp/common.jsp"%>
<script>	
Com_IncludeFile("optbar.js|docutil.js");
function patchWork_LoadIframe(){
	Doc_LoadFrame("patchWorkContent","<c:url value="/sys/time/sys_time_patchwork/sysTimePatchwork.do?method=list&sysTimeAreaId="/>${sysTimeAreaForm.fdId}");
}
</script>
<tr LKS_LabelName="<bean:message  bundle="sys-time" key="table.sysTimePatchwork"/>" style="display:none">
	<td id="patchWorkContent" onresize="patchWork_LoadIframe();">
		<iframe src="" width="100%" height="100%" frameborder="0" scrolling="no">
		</iframe>
	</td>
</tr>