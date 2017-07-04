<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskEvaluate" list="${queryPage.list}" varIndex="index">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column headerStyle="width:120px;" property="docCreator.fdName"  title="${ lfn:message('sys-task:sysTaskEvaluate.docCreatorId') }">
		</list:data-column>
		<list:data-column headerStyle="width:180px;" property="docCreateTime"  title="${ lfn:message('sys-task:sysTaskEvaluate.docCreateTime') }">
		</list:data-column>
		<list:data-column headerStyle="width:150px;" property="sysTaskApprove.fdApprove"   title="${ lfn:message('sys-task:sysTaskEvaluate.fdApprove') }">
		</list:data-column>
		<list:data-column property="docContent" title="${ lfn:message('sys-task:sysTaskEvaluate.docContent') }" escape="false" >
		</list:data-column>
		<list:data-column headerStyle="width:100px;" col="operate"  escape="false" title="${ lfn:message('sys-task:sysTaskFeedback.operation')}">
			<kmss:auth
				 requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=deleteall" 
				requestMethod="GET">		
				<a style="text-decoration:underline;" onclick="del(event,'<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=delete&fdId=${sysTaskEvaluate.fdId}"/>');"><bean:message key="button.delete"/></a>
			</kmss:auth>
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>