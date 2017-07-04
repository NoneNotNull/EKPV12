<%@ include file="/resource/jsp/common.jsp"%>
<kmss:auth requestURL="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=cancelIntro&fdModelName=${param.fdModelName}">
<input type="button" value="<bean:message key="sysIntroduceMain.cancel.button" bundle="sys-introduce"/>"
	onclick="introduce_cancelIntroduce();">
<script>
	function introduce_cancelIntroduce(){
		if(!List_CheckSelect() || 
			!confirm("<bean:message key="sysIntroduceMain.cancel.confirm" bundle="sys-introduce"/>"))
			return;
		document.forms[0].action = "<c:url value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=cancelIntro&fdModelName=${param.fdModelName}" />";
		document.forms[0].submit();
	}
</script>
</kmss:auth>