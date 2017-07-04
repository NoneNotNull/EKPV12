<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskOverrule" list="${queryPage.list}" varIndex="index">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column headerStyle="width:120px;" property="docCreator.fdName" title="${ lfn:message('sys-task:sysTaskOverrule.docCreator') }">
		</list:data-column>
		<list:data-column headerStyle="width:180px;" property="docCreateTime" title="${ lfn:message('sys-task:sysTaskOverrule.docCreateTime') }">
		</list:data-column>
		<list:data-column headerStyle="width:200px;" property="sysTaskMain.docSubject" title="${ lfn:message('sys-task:sysTaskMain.docSubject') }">
		</list:data-column>
		<list:data-column property="fdReason" title="${ lfn:message('sys-task:sysTaskOverrule.fdReason') }" escape="false">
		</list:data-column>
		<list:data-column headerStyle="width:100px;" col="operate"  escape="false" title="${ lfn:message('sys-task:sysTaskFeedback.operation')}">
			<kmss:auth 
				requestURL="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=delete&fdId=${sysTaskOverrule.fdId}" 
				requestMethod="GET">
				<a style="text-decoration:underline;" onclick="del(event,'<c:url value="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=delete&fdId=${sysTaskOverrule.fdId}"/>');"><bean:message key="button.delete"/></a>
			</kmss:auth>
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>