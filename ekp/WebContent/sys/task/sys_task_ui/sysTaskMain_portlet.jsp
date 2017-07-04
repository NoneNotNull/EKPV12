<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskMain" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--任务名称--%>
		<list:data-column col="docSubject" title="${ lfn:message('sys-task:sysTaskMain.docSubject') }" style="text-align:left" escape="false">
			<p title="${sysTaskMain.docSubject}">
			<a href="${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMain.fdId}" target="_blank">
				<c:choose >
					<c:when test="${fn:length(sysTaskMain.docSubject)>28}">${fn:substring(sysTaskMain.docSubject, 0,26)}...</c:when>
					<c:otherwise>${sysTaskMain.docSubject}</c:otherwise>
				</c:choose>
			</a>
			</p>
		</list:data-column>
		<%--任务状态--%>
		<list:data-column col="fdPastDue" title="${ lfn:message('sys-task:sysTaskMain.fdStatus') }" escape="false" style="width: 50px;">
			<kmss:showTaskStatus taskStatus="${sysTaskMain.fdStatus}" />
		</list:data-column>
		<%--任务进度--%>
		<list:data-column headerStyle="width:120px" col="fdProgress" title="${ lfn:message('sys-task:sysTaskMain.fdProgress') }" escape="false" style="width:120px;">
			<style>
				.pro_barline{width: 113px;height: 7px;background: #e5e4e1;border: 1px solid #d2d1cc;text-align: left;border-radius: 4px;}
				.pro_barline .complete{height: 7px;background: #00a001;border-radius: 3px;}
				.pro_barline .uncomplete{height: 7px;background: #ff8b00;border-radius: 3px;}
			</style>
			<c:out value="${sysTaskMain.fdProgress}" />%
			<div class='pro_barline'>
				<c:if test="${sysTaskMain.fdProgress=='100' }">
					<div class='complete' style="width:${sysTaskMain.fdProgress}%"></div>
				</c:if>
				<c:if test="${sysTaskMain.fdProgress!='100' }">
					<div class='uncomplete' style="width:${sysTaskMain.fdProgress}%"></div>
				</c:if>
			</div>
		</list:data-column>
		<%-- 计划完成时间--%>
		<list:data-column headerStyle="width:120px" property="fdPlanCompleteDateTime" title="${ lfn:message('sys-task:sysTaskMain.fdPlanCompleteTime') }" style="width:120px" >
		</list:data-column>
	</list:data-columns>
</list:data>