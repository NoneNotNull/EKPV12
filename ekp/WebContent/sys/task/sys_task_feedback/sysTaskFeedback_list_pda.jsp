<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="org.springframework.web.context.request.RequestScope"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do">
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
<c:if test="${queryPage.totalrows==0}">
<center>
<div>
  <br>
		<bean:message key="sysTaskFeedback.noRecord" bundle="sys-task"/><br>
  <br>
</div>
</center>
</c:if>
<c:if test="${queryPage.totalrows>0}">
<div style="padding-top: 5px;padding-bottom:8px;padding-left: 5px;font-size:14px;font-weight: bold;text-align: center;background-color:#e5e9ec;color:#2c446a">任务反馈(${queryPage.totalrows})</div>
<div>
<ul class='viewList'>
<c:forEach items="${queryPage.list}" var="sysTaskFeedback" varStatus="vstatus">
<li class='leftShort'>${sysTaskFeedback.docContent}<br><br>
 <c:set var="sysTaskFeedbackForm" value="${sysTaskFeedback}" scope="request"/>   
          <c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="attachment"/>							
		   <c:param name="formBeanName" value="sysTaskFeedbackForm"/>
           <c:param name="fdModelId" value="${sysTaskFeedback.fdId }"/>
		  <c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskFeedback"/>
			</c:import>
<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress"/>：<c:out value="${sysTaskFeedback.fdProgress}"/>% &nbsp;&nbsp;<bean:message  bundle="sys-task" key="sysTaskFeedback.fdCompleteTime"/>：<kmss:showDate value="${sysTaskFeedback.fdCompleteDateTime}" />
<br>
<bean:message  bundle="sys-task" key="sysTaskFeedback.sysTaskMain.docSubject"/>: <c:out value="${sysTaskFeedback.sysTaskMain.docSubject}"/>
<div style='padding-bottom:3px;'>
</div>
<p class='list_summary'>
<c:out value="${sysTaskFeedback.docCreator.fdName}" /> &nbsp;&nbsp;&nbsp;&nbsp;<kmss:showDate value="${sysTaskFeedback.docCreateTime}" />
</p>
</li>
</c:forEach>
</ul>
</div>
<div class="div_listPage">
	<sunbor:page name="queryPage" rowsizeText="rowsizeText2" pagenoText="pagenoText2" pageListSize="5" rowsizePara="8" pageListSplit="" textStyleClass="pagenav_input" >
	<table width="100%" height="22" cellspacing="0" cellpadding="0" border="0" class="pageNav_tb">
		<tr>
			<td width="2%" valign="top">&nbsp;</td>
			<td width="55%" valign="top">
				<div class="page_box">
				<sunbor:leftPaging><bean:message key="page.thePrev"/></sunbor:leftPaging>
				{11}
				<sunbor:rightPaging><bean:message key="page.theNext"/></sunbor:rightPaging>
				</div>
			</td>
			<td width="2%" valign="top">&nbsp;</td>
		</tr>
	</table>
	</sunbor:page>
</div>
</c:if>
</html:form>