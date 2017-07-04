<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/evaluation/sys_evaluation_notes/sysEvaluationNotesConfig.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/evaluation/sys_evaluation_notes/sysEvaluationNotesConfig.do?method=isOpenEvaluateSub" requestMethod="GET">	
		<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysEvaluationNotesConfigForm, 'update');">
	</kmss:auth>
</div>
<p class="txttitle">${ lfn:message('sys-evaluation:table.sysEvaluationNotes')}</p>
<center>
<table class="tb_normal" width=95%>
	<tr >
		<td class="tr_normal_title" style="width: 15%">
			${ lfn:message('sys-evaluation:sysEvaluationNotes.enable')}
		</td>
		<td>
			<input type="checkbox" name="fdEnable" value="1" ${sysEvaluationNotesConfigForm.fdEnable=='1'? 'checked': '' }> 
		</td>
	</tr>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
