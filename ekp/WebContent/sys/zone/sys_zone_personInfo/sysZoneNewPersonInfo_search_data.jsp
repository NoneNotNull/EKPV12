<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column col="fdId" title="fdId" >
	 		${item.fdId}
		</list:data-column>
		<list:data-column col="fdName" title="${ lfn:message('sys-zone:sysZonePerson.name') }" >
	 		${item.fdName}
		</list:data-column>
		<list:data-column col="fdDept" title="${ lfn:message('sys-zone:sysZonePerson.dept') }" >
		    ${item.fdDept}
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>