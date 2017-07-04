<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/task/sys_task_evaluate/sysTaskEvaluate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&fdTaskId=${param.fdTaskId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do" />?method=add&fdTaskId=${param.fdTaskId}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTaskEvaluateForm, 'deleteall');">
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
				<sunbor:column property="sysTaskEvaluate.docCreator.fdName">
					<bean:message  bundle="sys-task" key="sysTaskEvaluate.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTaskEvaluate.docCreateTime">
					<bean:message  bundle="sys-task" key="sysTaskEvaluate.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysTaskEvaluate.sysTaskApprove.fdApprove">
					<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTaskEvaluate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do" />?method=view&fdId=${sysTaskEvaluate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTaskEvaluate.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTaskEvaluate.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTaskEvaluate.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysTaskEvaluate.sysTaskApprove.fdApprove}" />
				</td>				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>