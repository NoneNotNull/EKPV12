<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdName" title="${lfn:message('kms-kmaps:kmsKmapsMain.templSubject') }">
		</list:data-column>
		<list:data-column property="docCategory.fdName" title="${lfn:message('kms-kmaps:kmsKmapsMain.docCategory') }">
		</list:data-column>
		<list:data-column col="docCreator" title="${lfn:message('kms-kmaps:kmsKmapsMain.docCreator') }" escape="false">
			<ui:person personId="${item.docCreator.fdId}" personName="${item.docCreator.fdName}"></ui:person>
		</list:data-column>
		<list:data-column col="docCreateTime"
			title="${lfn:message('kms-kmaps:kmsKmapsMain.docCreateTime') }">
			 <kmss:showDate value="${item.docCreateTime}" type="date" />
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>
