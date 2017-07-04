<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="tibJdbcDataSet" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--标题--%>
		<list:data-column col="docSubject" title="${ lfn:message('tib-jdbc:tibJdbcDataSet.docSubject') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibJdbcDataSet.docSubject}" /></span>
		</list:data-column>
		<list:data-column col="fdDataSource" title="${ lfn:message('tib-jdbc:tibJdbcDataSet.fdDataSource') }" escape="false" style="text-align:center;">
			<xform:select property="fdDataSource" style="float: left;" showStatus="view" value="${tibJdbcDataSet.fdDataSource}">
			 	<xform:beanDataSource serviceBean="compDbcpService"
					selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
		</list:data-column>
		<list:data-column col="docCategory" title="${ lfn:message('tib-jdbc:tibJdbcDataSet.docCategory') }" style="text-align:center" escape="false">
			<c:out value="${tibJdbcDataSet.docCategory.fdName}" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
