<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do">
	 <div id="optBarDiv">
		<kmss:auth requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&fdTaskId=${param.fdTaskId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do" />?method=add&fdTaskId=${param.fdTaskId}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTaskFeedbackForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysTaskFeedback.docCreateTime">
					<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysTaskFeedback.docCreator.fdName">
					<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTaskFeedback.sysTaskMain.docSubject">
					<bean:message  bundle="sys-task" key="sysTaskFeedback.sysTaskMain.docSubject"/>
				</sunbor:column>
				<td width="450pt">
					<bean:message  bundle="sys-task" key="sysTaskFeedback.docContent"/>
				</td>
				<!--控制执行反馈权限  -->
				<kmss:auth
					requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=quoteAdd&flag=${param.flag}&fdTaskId=${param.fdTaskId}"
					requestMethod="GET">
						<td width="40pt">
							<bean:message  bundle="sys-task" key="sysTaskFeedback.operation"/>
						</td>
				</kmss:auth>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTaskFeedback" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do" />?method=view&fdId=${sysTaskFeedback.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTaskFeedback.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<kmss:showDate value="${sysTaskFeedback.docCreateTime}" />
					
				</td>
				<td>
					<c:out value="${sysTaskFeedback.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${sysTaskFeedback.sysTaskMain.docSubject}" />
				</td>
				<td>
					<span onMouseOver="mouseShowContent(this);">${sysTaskFeedback.docContent}</span>
				</td>
				<!--控制执行反馈权限  -->			
				<kmss:auth
					requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=quoteAdd&flag=${param.flag}&fdTaskId=${param.fdTaskId}"
					requestMethod="GET">
						<td>
							<a href="<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=quoteAdd&fdTaskId=${param.fdTaskId}&&fdFeedbackId=${sysTaskFeedback.fdId}"/>" target="_blank"><bean:message bundle="sys-task" key="sysTaskFeedback.operation.quote"/></a>
						</td>
				</kmss:auth>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<div id = "content" style="width:90px;height:90px"></div>
<script type="text/javascript">
 function mouseShowContent(obj){
	    //alert(event.clientX +" , "+event.clientY);
	 	//var content = obj.childNodes[0].innerHTML;
	 	//var divObj= document.getElementById("content");
	 	//divObj.style.top = event.clientY;
	 	//divObj.style.left = event.clientX;
	 	//document.getElementById("content").innerHTML = content;
  }
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>