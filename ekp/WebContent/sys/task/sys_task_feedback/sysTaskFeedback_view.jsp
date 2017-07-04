<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTaskFeedback.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTaskFeedback.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskFeedback"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysTaskFeedbackForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdAppoint"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdAppointName}"/>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMainPerform.fdPerformId"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPerformName}"/>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdParentId"/>
		</td><td width=35%>
			<c:choose> 
				<c:when test="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName != null}">
					<c:out
					value="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName}" />
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdSourceSubject"/>
		</td><td width=35%>
			<c:choose> 
				<c:when test="${not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject && not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}">
					<a href='<c:url value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
						<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject}" />
					</a>
				</c:when>
				<c:when test="${not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject && empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}">
					<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject}" />
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>		
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
		</td><td width=35%>
			<a href="../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskFeedbackForm.sysTaskMainForm.fdId}"  target="_blank"><c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docSubject}"/></a>			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteDate}"/>&nbsp;<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteTime}"/>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<br /><bean:message  bundle="sys-task" key="sysTaskMain.docContent"/><br />
		</td><td width=85% colspan=3>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docContent}" escapeXml="false"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-task" key="sysTaskMain.pastdue.yesno"/>
		</td><td width=85% colspan=3>
			<sunbor:enumsShow value="${sysTaskFeedbackForm.fdPastDue}" enumsType="sys_task_yesno"></sunbor:enumsShow>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.fdProgress}"/>%
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdCompleteTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.fdCompleteDate}"/>&nbsp;<c:out value="${sysTaskFeedbackForm.fdCompleteTime}"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<b><bean:message  bundle="sys-task" key="sysTaskFeedback.docContent"/></b>
		</td><td width=85% colspan=3>
			<br /><b><c:out value="${sysTaskFeedbackForm.docContent}" escapeXml="false" /></b><br>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.attachment"/>
		</td><td width=85% colspan=3>
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="attachment"/>
				<c:param name="formBeanName" value="sysTaskFeedbackForm"/>
			</c:import>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.docCreatorName}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.docCreateTime}"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdNotifyType"/>
		</td><td width=85% colspan=3>
			<sunbor:multiSelectCheckbox formName="sysTaskFeedbackForm"  enumsType="sysTaskFreedback_fdNotifyType" property="fdNotifyTypeList" htmlElementProperties = "disabled"></sunbor:multiSelectCheckbox>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>