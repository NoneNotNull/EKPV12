<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="org.springframework.web.context.request.RequestScope"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.sys.task.util.DefaultNotify"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type='text/javascript'>
    Com_IncludeFile('kalendae.css','${KMSS_Parameter_ContextPath}third/pda/resource/style/','css',true);
    Com_IncludeFile('kalendae.js','${KMSS_Parameter_ContextPath}third/pda/resource/script/','js',true);
</script>
<%
java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd"); 
Date currentTime = new Date();//得到当前系统时间 
String fdCompleteDateTime = formatter.format(currentTime); //将日期时间格式化 
request.setAttribute("fdCompleteDateTime",fdCompleteDateTime);
request.setAttribute("defaultNotify",DefaultNotify.defaultValue);
%>
<script type="text/javascript">
function feedback_submit(){
	var pattern = /^([0-9]{1,2}|100)$/;
	if(!pattern.exec(document.getElementsByName("fdProgress")[0].value)){
    	alert('<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress.check"/>');
    	return;
	}
	var fdCompleteDate = document.getElementsByName("fdCompleteDate")[0].value;
	var fdCompleteTime = document.getElementsByName("fdCompleteTime")[0].value;
	document.getElementsByName("fdCompleteDateTime")[0].value = fdCompleteDate+" "+fdCompleteTime;	
	$KMSSValidation(document.forms['sysTaskFeedbackForm']);
	Com_Submit(document.sysTaskFeedbackForm,'save');
}
</script>

<c:set var="s_mainForm"  value="${requestScope[param.formName]}" />
<c:set var="defaultNotify"  value="${defaultNotify}" />
<c:set var="s_fdTaskId" value="${param.fdId}" scope="request" />
     <%
	  	session.setAttribute("S_DocLink","/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId="+(String)request.getAttribute("s_fdTaskId"));
	  %>
<form method="POST" name="sysTaskFeedbackForm" action="${KMSS_Parameter_ContextPath}sys/task/sys_task_feedback/sysTaskFeedback.do?method=save&flag=1&isAppflag=${param.isAppflag}">
<div  style="width:100%" >
<table class="docView" width="100%">
		<input type="hidden" name="fdfeedbackId"/>
		<input type="hidden" name="fdTaskId" value="${param.fdId}"/>	
		<input type="hidden" name="docCreatorName"/>
		<input type="hidden" name="docCreateTime"/>
		<input type="hidden" name="fdNotifyTypeList">
		<input type="hidden" name="fdNotifyWay" value="${defaultNotify}"/>
		<input type="hidden"  name="fdProgressAuto"  value="false"/>
	<tr>
		<td class="td_title" width=25%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress"/>
		</td><td  class="td_common" width=75%>
			<input type="text"  name="fdProgress" style="width:35px" value="${s_mainForm.fdProgress}"/>%
		</td>
	</tr>
	<tr>
	     <td class="td_title" width=25%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdCompleteTime"/>
		</td><td  class="td_common" width=75%> 
		    <input type="hidden"" name="fdCompleteDateTime" value=""/>
		    <input name="fdCompleteDate" onblur="__xformDispatch(this.value, this);"  id="fdStartDate" readonly class="auto-kal" value="${fdCompleteDateTime}" type="text" style="WIDTH: 100px" />
		    <select name="fdCompleteTime" onchange="__xformDispatch(this.value, this);" value="">
					<option value="00:00">00:00</option>
					<option value="00:30">00:30</option>
					<option value="01:00">01:00</option>
					<option value="01:30">01:30</option>
					<option value="02:00">02:00</option>
					<option value="02:30">02:30</option>
					<option value="03:00">03:00</option>
					<option value="03:30">03:30</option>
					<option value="04:00">04:00</option>
					<option value="04:30">04:30</option>
					<option value="05:00">05:00</option>
					<option value="05:30">05:30</option>
					<option value="06:00">06:00</option>
					<option value="06:30">06:30</option>
					<option value="07:00">07:00</option>
					<option value="07:30">07:30</option>
					<option value="08:00">08:00</option>
					<option value="08:30">08:30</option>
					<option value="09:00">09:00</option>
					<option value="09:30">09:30</option>
					<option value="10:00">10:00</option>
					<option value="10:30">10:30</option>
					<option value="11:00">11:00</option>
					<option value="11:30">11:30</option>
					<option value="12:00">12:00</option>
					<option value="12:30">12:30</option>
					<option value="13:00">13:00</option>
					<option value="13:30">13:30</option>
					<option value="14:00">14:00</option>
					<option value="14:30">14:30</option>
					<option value="15:00">15:00</option>
					<option value="15:30">15:30</option>
					<option value="16:00">16:00</option>
					<option value="16:30">16:30</option>
					<option value="17:00">17:00</option>
					<option value="17:30">17:30</option>
					<option value="18:00">18:00</option>
					<option value="18:30">18:30</option>
					<option value="19:00">19:00</option>
					<option value="19:30">19:30</option>
					<option value="20:00">20:00</option>
					<option value="20:30">20:30</option>
					<option value="21:00">21:00</option>
					<option value="21:30">21:30</option>
					<option value="22:00">22:00</option>
					<option value="22:30">22:30</option>
					<option value="23:00">23:00</option>
					<option value="23:30">23:30</option>
					<option value="23:59">23:59</option>
					</select>
		</td> 
	</tr>
	<tr>
		<td class="td_title" width=25%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.docContent"/>
		</td><td  class="td_common" width=75%>
			<input type="text" id="feedbackContent" name="docContent" style="width:90%" validate="required" subject='<%=ResourceUtil.getString(request,"sysTaskFeedback.docContent","sys-task")%>'/>
		    <span class="txtstrong">*</span>
		</td>
	</tr>
	</table>
	<br/>
		<center>
            <input type="button" id="btn_submit" value="<bean:message key="button.submit"/>" class="button_one"  onclick="feedback_submit();"/>
	    </center>
</div>
</form>
<script language="JavaScript">
	$KMSSValidation(document.forms['sysTaskFeedbackForm']);
</script>