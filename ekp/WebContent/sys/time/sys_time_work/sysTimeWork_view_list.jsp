<%@ include file="/resource/jsp/common.jsp"%>
<script>	
Com_IncludeFile("optbar.js");
function workTime_LoadIframe(){
	  Doc_LoadFrame("workTimeContent","<c:url value="/sys/time/sys_time_work/sysTimeWork.do?method=list&sysTimeAreaId="/>${sysTimeAreaForm.fdId}");
	}
</script>
<tr LKS_LabelName="<bean:message  bundle="sys-time" key="table.sysTimeWork"/>" style="display:none">
	<td id="workTimeContent" onresize="workTime_LoadIframe();">
		<iframe src="" width="100%" height="100%" frameborder="0" scrolling="no">
		</iframe>
	</td>
</tr>
