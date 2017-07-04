<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTaskAnalyze" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--任务名称--%>
		<list:data-column col="docSubject" title="${ lfn:message('sys-task:sysTaskAnalyze.docSubject') }" style="text-align:left" escape="false">
			<span class="com_subject"><c:out value="${sysTaskAnalyze.docSubject}" /></span>
		</list:data-column>
		<%--开始日期--%>
		<list:data-column headerStyle="width:150px;" col="fdStartDate" title="${ lfn:message('sys-task:sysTaskAnalyze.startDate') }" style="width:150px;">
			<kmss:showDate value="${sysTaskAnalyze.fdStartDate}" type="date" />
		</list:data-column>
		<%--结束日期--%>
		<list:data-column  headerStyle="width:150px;" col="fdEndDate" title="${ lfn:message('sys-task:sysTaskAnalyze.endDate') }"style="width:150px;" >
			<kmss:showDate value="${sysTaskAnalyze.fdEndDate}" type="date" />
		</list:data-column>
		<%--最后修改人--%>
		<list:data-column  headerStyle="width:120px;" col="docCreator.fdName" title="${ lfn:message('sys-task:sysTaskAnalyze.docCreator') }" escape="false" style="width:120px;">
			<ui:person personId="${sysTaskAnalyze.docCreator.fdId}" personName="${sysTaskAnalyze.docCreator.fdName}"></ui:person>
		</list:data-column>
		<%--最后修改时间--%>
		<list:data-column  headerStyle="width:150px;" property="docCreateTime" title="${ lfn:message('sys-task:sysTaskAnalyze.docCreateTime') }" style="width:150px;">
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }" 
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>