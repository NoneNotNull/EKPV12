<%@ include file="/resource/jsp/common.jsp"%>
<script>	
Com_IncludeFile("optbar.js");
function vacation_LoadIframe(){
	Doc_LoadFrame("vacationContent","<c:url value="/sys/time/sys_time_vacation/sysTimeVacation.do?method=list&sysTimeAreaId="/>${sysTimeAreaForm.fdId}");
}
</script>
<tr LKS_LabelName="<bean:message  bundle="sys-time" key="table.sysTimeVacation"/>" style="display:none">
	<td id="vacationContent" onresize="vacation_LoadIframe();">
		<iframe src="" width="100%" height="100%" frameborder="0" scrolling="no">
		</iframe>
	</td>
</tr>