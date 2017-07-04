<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibJdbcMappManage" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="docSubject" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.docSubject') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibJdbcMappManage.docSubject}" /></span>
		</list:data-column>
		<list:data-column col="fdDataSourceSql" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.fdDataSourceSql') }" escape="false" style="text-align:center;">
			<c:out value="${tibJdbcMappManage.fdDataSourceSql}" />
		</list:data-column>
		<list:data-column col="fdDataSource" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.fdDataSource') }" escape="false" style="text-align:center;">
			<c:out value="${dataSoure[tibJdbcMappManage.fdDataSource]}" />
		</list:data-column>
		<list:data-column col="fdTargetSource" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.fdTargetSource') }" escape="false" style="text-align:center;">
			<c:out value="${dataSoure[tibJdbcMappManage.fdTargetSource]}" />
		</list:data-column>
		<list:data-column col="fdTargetSourceSelectedTable" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.fdTargetSourceSelectedTable') }" escape="false" style="text-align:center;">
			<c:out value="${tibJdbcMappManage.fdTargetSourceSelectedTable}" />
		</list:data-column>
		<list:data-column col="fdIsEnabled" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.fdIsEnabled') }" escape="false" style="text-align:center;">
			<sunbor:enumsShow value="${tibJdbcMappManage.fdIsEnabled}" enumsType="common_yesno" bundle="tib-jdbc"/>
		</list:data-column>
		<list:data-column col="docCategory.fdName" title="${ lfn:message('tib-jdbc:tibJdbcMappManage.docCategory') }" escape="false" style="text-align:center;">
			<c:out value="${tibJdbcMappManage.docCategory.fdName}" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
