<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibCommonLogMain" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<list:data-column col="fdPoolName" title="${ lfn:message('tib-common-log:tibCommonLogMain.fdPoolName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibCommonLogMain.fdPoolName}" /></span>
		</list:data-column>
		<list:data-column col="fdUrl" title="${ lfn:message('tib-common-log:tibCommonLogMain.fdUrl') }" escape="false" style="text-align:center;">
			<c:out value="${tibCommonLogMain.fdUrl}" />
		</list:data-column>
		<%--时间--%>
		<list:data-column col="fdStartTime" title="${ lfn:message('tib-common-log:tibCommonLogMain.fdStartTime') }" escape="false" style="text-align:center;">
			<kmss:showDate value="${tibCommonLogMain.fdStartTime}" />
		</list:data-column>
		<list:data-column col="fdEndTime" title="${ lfn:message('tib-common-log:tibCommonLogMain.fdEndTime') }" escape="false" style="text-align:center;">
			<kmss:showDate value="${tibCommonLogMain.fdEndTime}" />
		</list:data-column>
		
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
