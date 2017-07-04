<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/mechansm.js"/>'></script>
<script>
Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js", null, "js");
</script>
<c:set var="s_mainForm"  value="${requestScope[param.formName]}" />
<div class="com_btnBox" >
<c:if test="${sysTaskMainForm.fdStatus != '6' }">
<c:if test="${s_mainForm.fdStatus != '4' && s_mainForm.fdStatus != '3' }">
	<c:if test="${s_mainForm.fdResolveFlag != 'true' }">
		<kmss:auth
			requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}"
			requestMethod="GET">
			<input type="button" id="ChildTask" value="<bean:message key='button.sub.task' bundle='sys-task'/>" class="button_one" onclick="checkLeverNumber();" />
		</kmss:auth>
	</c:if>
</c:if>
    <kmss:auth
		requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
		requestMethod="post">
			<input type="button" id="feedback" value="<bean:message key='button.feedback' bundle='sys-task'/>" class="button_one" onclick="showDiv(1);" />
	</kmss:auth>
	<kmss:auth
		requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
		requestMethod="post">
			<input type="button" id="evaluate" value="<bean:message key='button.evaluate' bundle='sys-task'/>" class="button_one" onclick="showDiv(2);" />
	</kmss:auth>
</c:if>
</div>
<div id="div_feedback" style="display:none">
	<c:import url="/sys/task/sys_task_feedback/sysTaskFeedback_pda.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="${param.formName}" />
	</c:import>
</div>
<div id="div_evaluate" style="display:none">
	<c:import url="/sys/task/sys_task_evaluate/sysTaskEvaluate_pda.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="${param.formName}" />
	</c:import>
</div>
<script type="text/javascript">
function checkLeverNumber(){
	//debugger;
	var lever = ${currentLevel};
	if(lever == 3){
		alert('<bean:message bundle="sys-task" key="sysTaskMain.lever.number.message"/>');
		return false;
	}else{
		Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}','_self');
	}
	
}
function showDiv(val){
	 var div_feedback = document.getElementById("div_feedback");
	 var div_evaluate = document.getElementById("div_evaluate");
	if(val==1){
		div_feedback.style.display="block";
		//页面同时有两个不同的form,避免校验不通过提交不了
		document.getElementById("feedbackContent").setAttribute("validate", "required");
		document.getElementById("evalContent").setAttribute("validate", "");
		div_evaluate.style.display="none";
	}
	if(val==2){
		div_evaluate.style.display="block";	
		//页面同时有两个不同的form,避免校验不通过提交不了
		document.getElementById("evalContent").setAttribute("validate", "required");
		document.getElementById("feedbackContent").setAttribute("validate", "");
		div_feedback.style.display="none";
	}	
}
</script>