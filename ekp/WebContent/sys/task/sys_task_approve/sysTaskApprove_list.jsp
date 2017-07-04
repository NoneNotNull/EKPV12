<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/task/sys_task_approve/sysTaskApprove.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/task/sys_task_approve/sysTaskApprove.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_approve/sysTaskApprove.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/task/sys_task_approve/sysTaskApprove.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTaskApproveForm, 'deleteall');">
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
				<sunbor:column property="sysTaskApprove.fdApprove">
					<bean:message  bundle="sys-task" key="sysTaskApprove.fdApprove"/>
				</sunbor:column>
				<sunbor:column property="sysTaskApprove.fdScore">
					<bean:message  bundle="sys-task" key="sysTaskApprove.fdScore"/>
				</sunbor:column>
				<sunbor:column property="sysTaskApprove.fdIsAvailable">
					<bean:message  bundle="sys-task" key="sysTaskApprove.fdIsAvailable"/>
				</sunbor:column>				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTaskApprove" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/task/sys_task_approve/sysTaskApprove.do" />?method=view&fdId=${sysTaskApprove.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTaskApprove.fdId}">
				</td>
				<td >${vstatus.index+1}</td>
				<td >
					<c:out value="${sysTaskApprove.fdApprove}" />
				</td>				
				<td >
					<c:out value="${sysTaskApprove.fdScore}" />
				</td>
				<td >
				<sunbor:enumsShow value="${sysTaskApprove.fdIsAvailable}" enumsType="common_yesno" />
  				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>