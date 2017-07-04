<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/task/sys_task_evaluate/sysTaskEvaluate.do" onsubmit="return validateSysTaskEvaluateForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTaskEvaluateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskEvaluateForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskEvaluate"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdTaskId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
		</td>
		<td width=85% colspan=3>
			<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.docSubject}"/>				
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdAppoint"/>
		</td><td width=35%>
			<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdAppointName}"/>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMainPerform.fdPerformId"/>
		</td><td width=35%>
			<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdPerformName}"/>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdParentId"/>
		</td><td width=35%>
			<c:choose> 
				<c:when test="${sysTaskEvaluateForm.sysTaskMainForm.fdParentName != null}">
					<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdParentName}"/>	
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
				<c:when test="${not empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject && not empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceUrl}">
					<a href='<c:url value="${sysTaskEvaluateForm.sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
						<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject}" />
					</a>
				</c:when>
				<c:when test="${not empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject && empty sysTaskEvaluateForm.sysTaskMainForm.fdSourceUrl}">
					<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdSourceSubject}" />
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdPlanCompleteDate}"/>&nbsp;<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.fdPlanCompleteTime}"/>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.realCompleteDateTime"/>
		</td>
		<td width=35%>
			<c:choose> 
				<c:when test="${sysTaskEvaluateForm.fdRealFinishDateTime != null}">
					<c:out
					value="${sysTaskEvaluateForm.fdRealFinishDateTime}" />
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			</br><bean:message  bundle="sys-task" key="sysTaskMain.docContent"/><br></br>
		</td><td width=85% colspan=3>
			<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.docContent}" escapeXml="false"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdStatus"/>
		</td><td width=85% colspan=3>
			<kmss:showTaskStatus taskStatus = "${sysTaskEvaluateForm.sysTaskMainForm.fdStatus}" showText="true"></kmss:showTaskStatus>
		</td>
	</tr>	
	<!-- 满意度 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
		</td><td width=85% colspan=3>
			<kmss:radioTag property="fdApproveId"  serviceBean="sysTaskApproveService" selectBlock ="sysTaskApprove.fdId,sysTaskApprove.fdApprove" whereBlock = "sysTaskApprove.fdIsAvailable = 1" orderBy="sysTaskApprove.fdOrder asc"></kmss:radioTag>
		</td>
	</tr>		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.docContent"/>
		</td><td width=85% colspan=3>
			<html:textarea property="docContent" style="width:98%" /><span class="txtstrong">*</span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTaskEvaluateForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>