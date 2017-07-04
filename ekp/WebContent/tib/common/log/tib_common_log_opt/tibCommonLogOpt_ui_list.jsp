<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibCommonLogOpt" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<list:data-column col="fdPerson" title="${ lfn:message('tib-common-log:tibCommonLogOpt.fdPerson') }" style="text-align:center" escape="false">
			<c:out value="${tibCommonLogOpt.fdPerson}" />
		</list:data-column>
		<%--时间--%>
		<list:data-column col="fdAlertTime" title="${ lfn:message('tib-common-log:tibCommonLogOpt.fdAlertTime') }" escape="false" style="text-align:center;">
			<kmss:showDate value="${tibCommonLogOpt.fdAlertTime}" />
		</list:data-column>
		<list:data-column col="fdUrl" title="${ lfn:message('tib-common-log:tibCommonLogOpt.fdUrl') }" escape="false" style="text-align:center;">
			<c:out value="${tibCommonLogOpt.fdUrl}" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
