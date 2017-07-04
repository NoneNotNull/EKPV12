<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/task/sys_task_evaluate/sysTaskEvaluate.do" onsubmit="return validateSysTaskEvaluateForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTaskEvaluateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskEvaluateForm, 'save');">
	</c:if>
</div>
<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdTaskId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docContent"/>
		</td><td width=85% colspan=3>
			<c:out value="${sysTaskEvaluateForm.sysTaskMainForm.docContent}" escapeXml="false"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdStatus"/>
		</td><td width=85% colspan=3>
			<kmss:showTaskStatus taskStatus = "${sysTaskEvaluateForm.sysTaskMainForm.fdStatus}"></kmss:showTaskStatus>
		</td>
	</tr>	
	<!-- 满意度 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
		</td><td width=85% colspan=3>
			<kmss:radioTag property="fdApproveId"  serviceBean="sysTaskApproveService" selectBlock ="sysTaskApprove.fdId,sysTaskApprove.fdApprove"></kmss:radioTag>
		</td>
	</tr>		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.docContent"/>
		</td><td width=85% colspan=3>
			<html:textarea property="docContent" style="width:100%"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTaskEvaluateForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>