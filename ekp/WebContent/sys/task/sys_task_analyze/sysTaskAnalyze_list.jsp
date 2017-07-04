<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/task/sys_task_analyze/sysTaskAnalyze.do">
	 <div id="optBarDiv">
		<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_analyze/sysTaskAnalyze.do" />?method=add&type=${param.type}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTaskAnalyzeForm, 'deleteall');">
		</kmss:auth>
	</div>
	 
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable" >
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysTaskAnalyze.docSubject">
					<bean:message  bundle="sys-task" key="sysTaskAnalyze.docSubject"/>
				</sunbor:column>
				<sunbor:column property="sysTaskAnalyze.fdStartDate">
					<bean:message  bundle="sys-task" key="sysTaskAnalyze.startDate"/>
				</sunbor:column>
				<sunbor:column property="sysTaskAnalyze.fdEndDate">
					<bean:message  bundle="sys-task" key="sysTaskAnalyze.endDate"/>
				</sunbor:column>
				<sunbor:column property="sysTaskAnalyze.docCreator.fdName">
					<bean:message  bundle="sys-task" key="sysTaskAnalyze.docCreator"/>
				</sunbor:column>
				<sunbor:column property="sysTaskAnalyze.docCreateTime">
					<bean:message  bundle="sys-task" key="sysTaskAnalyze.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTaskAnalyze" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/task/sys_task_analyze/sysTaskAnalyze.do" />?method=view&fdId=${sysTaskAnalyze.fdId}"
				>
				<td >
					<input type="checkbox" name="List_Selected" value="${sysTaskAnalyze.fdId}">
				</td>
				<td style="text-align:center">${vstatus.index+1}</td>
				<td style="text-align:center">
					<c:out value="${sysTaskAnalyze.docSubject}" />					
				</td>
				<td style="text-align:center">
					<kmss:showDate  type="date" value="${sysTaskAnalyze.fdStartDate}"></kmss:showDate>
				</td>
				<td style="text-align:center">
					<kmss:showDate type="date" value="${sysTaskAnalyze.fdEndDate}" ></kmss:showDate>
				</td>
				<td style="text-align:center">
					<c:out value="${sysTaskAnalyze.docCreator.fdName}" />
				</td>
				<td style="text-align:center">
					<kmss:showDate value="${sysTaskAnalyze.docCreateTime}" type="date"></kmss:showDate>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>