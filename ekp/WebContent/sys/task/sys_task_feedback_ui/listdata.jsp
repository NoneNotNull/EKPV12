<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskFeedback" list="${queryPage.list}" varIndex="index">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column headerStyle="width:120px;"  property="docCreator.fdName" title="${ lfn:message('sys-task:sysTaskFeedback.docCreatorId') }">
		</list:data-column>
		<list:data-column headerStyle="width:180px;" property="docCreateTime" title="${ lfn:message('sys-task:sysTaskFeedback.docCreateTime') }">
		</list:data-column>
		<list:data-column headerStyle="width:200px;"  property="sysTaskMain.docSubject" title="${ lfn:message('sys-task:sysTaskFeedback.sysTaskMain.docSubject') }">
		</list:data-column>
		<list:data-column headerStyle="width:100px;"  col="fdProgress" title="${ lfn:message('sys-task:sysTaskFeedback.fdProgress') }" escape="false">
			<style>
				.pro_barline{width: 113px;height: 7px;background: #e5e4e1;border: 1px solid #d2d1cc;text-align: left;border-radius: 4px;}
				.pro_barline .complete{height: 7px;background: #00a001;border-radius: 3px;}
				.pro_barline .uncomplete{height: 7px;background: #ff8b00;border-radius: 3px;}
			</style>
			<c:out value="${sysTaskFeedback.fdProgress}" />%
			<div class='pro_barline'>
				<c:if test="${sysTaskFeedback.fdProgress=='100' }">
					<div class='complete' style="width:${sysTaskFeedback.fdProgress}%"></div>
				</c:if>
				<c:if test="${sysTaskFeedback.fdProgress!='100' }">
					<div class='uncomplete' style="width:${sysTaskFeedback.fdProgress}%"></div>
				</c:if>
			</div>
		</list:data-column>
		<list:data-column property="docContent" title="${ lfn:message('sys-task:sysTaskFeedback.docContent') }" escape="false" >
		</list:data-column>
		<list:data-column headerStyle="width:100px;" col="operate"  escape="false" title="${ lfn:message('sys-task:sysTaskFeedback.operation')}">
			<c:if test="${fn:length(queryPage.list)>0}">
				<kmss:auth
					requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=quoteAdd&flag=${param.flag}&fdTaskId=${param.fdTaskId}"
					requestMethod="GET">
					<a style="text-decoration:underline;" onclick="quoteAdd(event,'<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=quoteAdd&fdTaskId=${param.fdTaskId}&&fdFeedbackId=${sysTaskFeedback.fdId}"/>');"  target="_blank"><bean:message bundle="sys-task" key="sysTaskFeedback.operation.quote"/></a>
					&nbsp;&nbsp;&nbsp;  
				</kmss:auth>
				<kmss:auth
					requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=delete&flag=${param.flag}&fdId=${sysTaskFeedback.fdId}"
					requestMethod="GET">
					<a style="text-decoration:underline;" onclick="del(event,'<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=delete&fdTaskId=${param.fdTaskId}&fdId=${sysTaskFeedback.fdId}"/>');"><bean:message key="button.delete"/></a>
				</kmss:auth>
			</c:if>
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>