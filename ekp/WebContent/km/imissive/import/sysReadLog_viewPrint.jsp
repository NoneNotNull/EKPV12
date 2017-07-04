<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%> 
<c:set var="sysReadLogForm" value="${requestScope[param.formName].readLogForm}" />
<c:if test="${sysReadLogForm.fdModelName!=null && sysReadLogForm.fdModelName!='' && sysReadLogForm.fdModelId!=null && sysReadLogForm.fdModelId!=''}"> 
<script>
$(document).ready(function(){
	var fdModelName='${sysReadLogForm.fdModelName}';
	var fdModelId='${sysReadLogForm.fdModelId}';
	document.getElementById('readLogRecord').src = ("<c:url value='/sys/readlog/sys_read_log/sysReadLog.do?method=viewReadLog&modelName="+fdModelName+"&modelId="+fdModelId+"'/>");
});
</script>
	<table width="100%">
		<tr>
			<td>
		 		<iframe id="readLogRecord" width=100% height="100%" frameborder=0 scrolling=no ></iframe>
			</td>
		</tr>
	</table>
</c:if>
