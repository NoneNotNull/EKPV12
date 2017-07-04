<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
function confirmStop(msg){
	var del = confirm(msg);
	return del;
}
</script>
<div id="optBarDiv">
<!--设为关注任务  -->
<input type="button" value="<bean:message key="button.attention" bundle="sys-task"/>" onclick="Com_OpenWindow('sysTaskMain.do?method=updateAttention&fdId=${param.fdId}','_self');">
<!--终止任务  -->
<input type="button" value="<bean:message key="button.terminate" bundle="sys-task"/>" onclick="if(!confirmStop('您确定要终止此任务吗?'))return;Com_OpenWindow('sysTaskMain.do?method=updateStop&fdId=${param.fdId}','_self');">
<!--分解子任务-->
<c:if test="${sysTaskMainForm.fdStatus != '5' && sysTaskMainForm.fdStatus != '3' }">
<c:if test="${sysTaskMainForm.fdResolveFlag != 'true' }"> 
<kmss:auth
	requestURL="/sys/task/sys_task_feedback/sysTaskMain.do?method=addChildTask&fdParentId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.sub.task" bundle="sys-task"/>" onclick="Com_OpenWindow('sysTaskMain.do?method=addChildTask&fdParentId=${param.fdId}','_blank');">
</kmss:auth>
</c:if>
</c:if>
<!--执行反馈  -->
<c:if test="${sysTaskMainForm.fdStatus != '5' && sysTaskMainForm.fdStatus != '3' }">
<kmss:auth
	requestURL="/sys/task/sys_task_feedback\sysTaskFeedback.do?method=add&fdTaskId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.feedback" bundle="sys-task"/>" onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&fdTaskId=${param.fdId}"/>','_blank');">
</kmss:auth>
</c:if>
<!--任务评价  -->
<kmss:auth
	requestURL="/sys/task/sys_task_feedback\sysTaskFeedback.do?method=add&fdTaskId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.evaluate" bundle="sys-task"/>" onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=edit&fdTaskId=${param.fdId}"/>','_blank');">
</kmss:auth>  
<!--工作沟通  -->
<input type="button" value="<bean:message key="button.communicate" bundle="sys-task"/>"	onclick=""> 
<kmss:auth
	requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>" onclick="Com_OpenWindow('sysTaskMain.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> 
<!-- 删除 -->
<kmss:auth
	requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>" onclick="if(!confirmDelete())return;Com_OpenWindow('sysTaskMain.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> 
<!-- 关闭 -->
<input type="button" value="<bean:message key="button.close"/>"	onclick="Com_CloseWindow();"></div>
<center>
<table id="Label_Tabel" width="95%">
	<tr LKS_LabelName="<bean:message key="tag.task" bundle="sys-task"/>">
		<td>
		<table class="tb_normal" width=95%>
			<html:hidden name="sysTaskMainForm" property="fdId" />
			<tr>
				<td class="td_normal_title" width=15%><bean:message bundle="sys-task" key="sysTaskMain.docSubject"/></td>
				<td width=35%><c:out value="${sysTaskMainForm.docSubject}" />
				</td>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" /></td>
				<td width=35%><c:out
					value="${sysTaskMainForm.fdPlanCompleteDate}" />&nbsp;<c:out
					value="${sysTaskMainForm.fdPlanCompleteTime}" /></td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="sysTaskMain.fdAppoint" /></td>
				<td width=35%><c:out value="${sysTaskMainForm.fdAppointName}" />
				</td>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="table.sysTaskMainPerform" /></td>
				<td width=35%><c:out value="${sysTaskMainForm.fdPerformName}" />
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="sysTaskMain.fdParentId" /></td>
				<td width=35%>
					<c:out value="${sysTaskMainForm.fdParentName}" />
				</td>
				<td class="td_normal_title" width=15%><bean:message bundle="sys-task" key="sysTaskMain.fdSourceSubject"/></td>
				<td width=35%>
					<c:choose>
						<c:when test="${not empty sysTaskMainForm.fdSourceSubject && not empty sysTaskMainForm.fdSourceUrl}">
							<a href='<c:url value="${sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
								<c:out value="${sysTaskMainForm.fdSourceSubject}" />
							</a>
						</c:when>
						<c:when test="${not empty sysTaskMainForm.fdSourceSubject && empty sysTaskMainForm.fdSourceUrl}">
							<c:out value="${sysTaskMainForm.fdSourceSubject}" />
						</c:when>
						<c:otherwise>
							<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%><bean:message key="sysTaskMain.fdCategoryId" bundle="sys-task"/></td>
				<td width=35%><c:out value="${sysTaskMainForm.fdCategoryName}" />
				</td>
				<td class="td_normal_title" width=15%><bean:message bundle="sys-task" key="sysTaskFeedback.fdProgress"/></td>
				<td width=35%><c:out value="${sysTaskMainForm.fdProgress}" />%
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%><bean:message  bundle="sys-task" key="sysTaskMain.docCreatorId"/></td>
				<td width=35%><c:out value="${sysTaskMainForm.docCreatorName}" />
				</td>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="sysTaskMain.docCreateTime" /></td>
				<td width=35%><c:out value="${sysTaskMainForm.docCreateTime}" />
				</td>
			</tr>			
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="sysTaskMain.docContent" /></td>
				<td width=35% colspan="3"><c:out
					value="${sysTaskMainForm.docContent}" escapeXml="false" /></td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%> <bean:message bundle="sys-task" key="sysTaskMain.attachment"/></td>
				<td width=35% colspan=3><c:import
					url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="attachment" />
					<c:param name="formBeanName" value="sysTaskMainForm" />
					
				</c:import></td>
				
				<!-- td class="td_normal_title" width=15%><bean:message
					bundle="sys-task" key="sysTaskMain.fdStatus" /></td>
				<td width=35%><kmss:showTaskStatus
					taskStatus="${sysTaskMainForm.fdStatus}" /></td> -->
			</tr>
		</table>
		</td>
	</tr>
	<tr LKS_LabelName="<bean:message key="tag.task.view" bundle="sys-task"/>">
		<td>
		<table>
			<tr>
				<td></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr LKS_LabelName="<bean:message key="tag.feedback" bundle="sys-task"/>">
		<td height="500">
			<iframe width="100%" height="100%" frameborder="0" src="<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=list&fdTaskId=${param.fdId}"/>">
			</iframe>
		</td>
	</tr>
	<tr LKS_LabelName="<bean:message key="tag.evaluate" bundle="sys-task"/>">
		<td height="200">
			<iframe width="100%" height="100%" frameborder="0" src="<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=view&fdTaskId=${param.fdId}"/>">
			</iframe>
		</td>
	</tr>
	<tr LKS_LabelName="<bean:message key="tag.communicate" bundle="sys-task"/>">
		<td>
		<table>
			<tr>
				<td></td>
			</tr>
		</table>
		</td>
	</tr>
	<c:import url="/sys/readlog/include/sysReadLog_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="sysTaskMainForm" />
	</c:import>
			
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>