<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@page import="com.landray.kmss.sys.task.model.SysTaskMain"%>
<html:form action="/sys/task/sys_task_main/sysTaskMain.do">
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
</c:import>
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
				<!--任务名称  -->
				<sunbor:column property="sysTaskMain.docSubject">
					<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
				</sunbor:column>
				<!-- 任务状态 -->
				<sunbor:column property="sysTaskMain.fdStatus">
					<bean:message  bundle="sys-task" key="sysTaskMain.fdStatus"/>
				</sunbor:column>
				<!-- 是否过期 -->
				<sunbor:column property="sysTaskMain.fdPastDue">
					<bean:message  bundle="sys-task" key="sysTaskMain.pastdue.yesno"/>
				</sunbor:column>
				<!-- 任务进度 -->
				<sunbor:column property="sysTaskMain.fdProgress">
					<bean:message  bundle="sys-task" key="sysTaskMain.fdProgress"/>
				</sunbor:column>
				<!-- 任务评价 -->
				<sunbor:column property="sysTaskMain.sysTaskEvaluate.sysTaskApprove.fdApprove">
					<bean:message  bundle="sys-task" key="sysTaskMain.sysTaskEvaluate"/>
				</sunbor:column>
				<!-- 指派人 -->
				<sunbor:column property="sysTaskMain.fdAppoint.fdName">
					<bean:message  bundle="sys-task" key="sysTaskMain.fdAppoint"/>
				</sunbor:column>
				<!-- 负责人 -->	
				<sunbor:column property="sysTaskMain.toSysOrgPerform.fdName">
					<bean:message  bundle="sys-task" key="sysTaskMainPerform.fdPerformId"/>
				</sunbor:column>
	
				<!-- 要求完成日期 -->	
				<sunbor:column property="sysTaskMain.fdPlanCompleteDateTime">
					<bean:message  bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime"/>
				</sunbor:column>			
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTaskMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=view&fdId=${sysTaskMain.fdId}&flag=${param.flag}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTaskMain.fdId}">
				</td>
				<td style="text-align:center">${vstatus.index+1}</td>
				<td style="text-align:center">
					<c:out value="${sysTaskMain.docSubject}" />
				</td>
				<td style="text-align:center">
					<kmss:showTaskStatus taskStatus="${sysTaskMain.fdStatus}" />
				</td>
				<td style="text-align:center">
				<sunbor:enumsShow value="${sysTaskMain.fdPastDue}" enumsType="sys_task_yesno"></sunbor:enumsShow>
				</td>
				<td style="text-align:center">
					<c:out value="${sysTaskMain.fdProgress}" />%
				</td>
				<td style="text-align:center">				
					<c:if test = "${sysTaskMain.sysTaskEvaluate == null}" >
						<!-- 待评 -->
						<bean:message key="sysTaskEvaluate.default.fdApprove" bundle="sys-task"/>
					</c:if>
					<c:if test = "${sysTaskMain.sysTaskEvaluate.sysTaskApprove.fdApprove != ''}" >
						<c:out value="${sysTaskMain.sysTaskEvaluate.sysTaskApprove.fdApprove}" />
					</c:if>
				</td>
				<td style="text-align:center">
					<c:out value="${sysTaskMain.fdAppoint.fdName}" />
				</td>
				<td style="text-align:center">
					<c:forEach items="${sysTaskMain.toSysOrgPerform}" var="performName" varStatus="vstatus_">
						<c:out value="${performName.fdName}"/>
					</c:forEach>
				</td>
				<td style="text-align:center">
					<kmss:showDate value="${sysTaskMain.fdPlanCompleteDateTime}"></kmss:showDate>
				</td>			
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>