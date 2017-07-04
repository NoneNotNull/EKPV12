<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="org.springframework.web.context.request.RequestScope"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do">
<script type="text/javascript">
	function openTask(fdId){
		var hrefUrl="${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=view&fdId="+fdId+"&ischild=true&isAppflag="+Com_Parameter['IsAppFlag'];
		window.open(hrefUrl,"_self");
	}
</script>
<%-- banner部分--%>
<c:if test="${KMSS_PDA_ISAPP!='1'}">
<div id="div_banner" class="div_banner">
<script type="text/javascript">
		function gotoList(){	
			var hrefUrl="${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${fdTaskId}&isAppflag="+Com_Parameter['IsAppFlag'];
			location=hrefUrl;
		}
</script>
	<div class="div_return" onclick="gotoList();">
		<div>
			<bean:message bundle="third-pda" key="phone.view.back" />
		</div>
		<div></div>
	</div>
</div>
</c:if>
<c:if test="${size==0}">
<center>
<div>
  <br>
		<bean:message key="sysTaskMain.noRecord" bundle="sys-task"/><br>
  <br>
</div>
</center>
</c:if>
<c:if test="${size>0}">
<div style="padding-top: 5px;padding-bottom:8px;padding-left: 5px;font-size:14px;font-weight: bold;text-align: center;background-color:#e5e9ec;color:#2c446a">子任务(${size})</div>
<div>
<ul class='viewList'>
<c:forEach items="${childList}" var="sysTaskMain" varStatus="vstatus">
<li class='leftShort' onclick='openTask("${sysTaskMain.fdId}");'>${sysTaskMain.docSubject}

<div style='padding-bottom:3px;'>
</div>
<p class='list_summary'>
<c:out value="${sysTaskMain.docCreator.fdName}" /> &nbsp;&nbsp;&nbsp;&nbsp;<kmss:showDate value="${sysTaskMain.docCreateTime}" />
</p>
</li>
</c:forEach>
</ul>
</div>
</c:if>
</html:form>