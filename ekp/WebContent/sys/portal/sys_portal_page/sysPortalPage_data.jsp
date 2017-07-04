<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%> 
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysPortalPage" list="${queryPage.list}">
		<list:data-column property="fdId" title="ID">
		</list:data-column>
		<list:data-column property="fdName" title="${ lfn:message('sys-portal:sysPortalPage.fdName') }">
		</list:data-column>
		<list:data-column property="fdIcon" title="${ lfn:message('sys-portal:sysPortalPage.fdIcon') }">
		</list:data-column>
		<list:data-column property="fdType">
		</list:data-column>
		<list:data-column col="fdTypeName" title="${ lfn:message('sys-portal:sysPortalPage.fdType') }">
			${lfn:message(lfn:concat('sys-portal:sys_portal_page_type_',sysPortalPage.fdType))}
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging page="${ queryPage }"></list:data-paging>
</list:data>