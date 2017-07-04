<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<list:data>
	<list:data-columns var="sysTaskFeedback" list="${queryPage.list }">
		<%--ID--%> 
		<list:data-column property="fdId"></list:data-column>
		<%--任务名称--%>
		<list:data-column col="title" title="${ lfn:message('sys-task:sysTaskFeedback.docContent') }" escape="false">
			${sysTaskFeedback.docContent}
		</list:data-column>
		<list:data-column col="created" title="${ lfn:message('sys-task:sysTaskFeedback.docCreateTime') }">
			<kmss:showDate value="${sysTaskFeedback.docCreateTime}" type="datetime"></kmss:showDate>
		</list:data-column>
		<%--任务进度--%>
		<list:data-column col="progress" title="${ lfn:message('sys-task:sysTaskFeedback.fdProgress') }">
			<c:out value="${sysTaskFeedback.fdProgress }"></c:out>
		</list:data-column>
		<%--反馈人 --%>
		<list:data-column col="creator" escape="false" title="${ lfn:message('sys-task:sysTaskFeedback.docCreatorId') }" >
			<c:out value="${sysTaskFeedback.docCreator.fdName }"></c:out>
		</list:data-column>
		<%--UA --%>
		<list:data-column col="clientType"  escape="false" title="${ lfn:message('sys-task:sysTaskFeedback.clientType') }" >
			<c:out value="${sysTaskFeedback.clientType }"></c:out>
		</list:data-column>
		<%--反馈人头像  --%>
		<list:data-column col="icon" escape="false" title="${ lfn:message('sys-task:sysTaskFeedback.docCreatorId') }" >
			<person:headimageUrl personId="${sysTaskFeedback.docCreator.fdId }"/>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>