<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.task.service.ISysTaskApproveService"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
//设置满意度
function TaskEvaluate_setApprove(ApproveObj){
	if(ApproveObj.selectedIndex>0){
		var fdApproveId = document.getElementsByName("fdApproveId")[0];
		fdApproveId.value += fdApproveId.options[ApproveObj.selectedIndex].value + "\r\n";		
	}
}
function evaluate_submit(){
	 $KMSSValidation(document.forms['sysTaskEvaluateForm']);
	 Com_Submit(document.sysTaskEvaluateForm,'save');
}

</script>
<c:set var="s_fdTaskId" value="${param.fdId}" scope="request" />
     <%
	  	session.setAttribute("S_DocLink","/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId="+(String)request.getAttribute("s_fdTaskId"));
	  %>
<form method="POST" name="sysTaskEvaluateForm" action="${KMSS_Parameter_ContextPath}sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=save&flag=1&isAppflag=${param.isAppflag}">
<div style="width:100%" >
<table class="docView" width="100%">
	    <input type="hidden" name="fdId"/>
		<input type="hidden" name="fdTaskId" value="${param.fdId}" scope="request"/>
		<input type="hidden" name="docCreatorName"/>
		<input type="hidden" name="docCreateTime"/>	
	<tr>
		<td class="td_title" width=25%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
		</td><td class="td_common" width=75%>
		
		<%		
		request.setAttribute("taskApprove", ((ISysTaskApproveService)SpringBeanUtil.getBean("sysTaskApproveService")).getTaskApprove());
		%>
		
		 <select name="fdApproveId" onchange="TaskEvaluate_setApprove(this);" style="max-width: 200px;">
				<c:forEach items="${taskApprove}" var="Approve">
				<option value="<c:out value="${Approve['value']}" />">
					<c:out value="${Approve['name']}"/>
				</option>
				</c:forEach>
		 </select>
		</td>
	</tr>	
	<tr>
		<td class="td_title" width=25%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.docContent"/>
		</td><td class="td_common" width=75%>
			<input type="text" id="evalContent" name="docContent" style="width:90%" validate="required" subject='<%=ResourceUtil.getString(request,"sysTaskEvaluate.docContent","sys-task")%>'/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	</table>
	<br/>
		<center>
             <input type="button" id="btn_submit" value="<bean:message key="button.submit"/>" class="button_one"  onclick="evaluate_submit();"/>
	    </center>
</div>
</form>
<script language="JavaScript">
		$KMSSValidation(document.forms['sysTaskEvaluateForm']);
</script>