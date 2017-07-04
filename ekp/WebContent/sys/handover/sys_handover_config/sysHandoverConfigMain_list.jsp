<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysHandoverConfigMain" list="${queryPage.list }">
	    <list:data-column property="fdId">
		</list:data-column >
		<!--交接人-->
		<list:data-column headerStyle="width:25%" property="fdFromName" title="${ lfn:message('sys-handover:sysHandoverConfigMain.fdFromName') }">
		</list:data-column>
		<!--接收人-->
		<list:data-column headerStyle="width:25%" property="fdToName" title="${ lfn:message('sys-handover:sysHandoverConfigMain.fdToName') }">
		</list:data-column>
		<!--创建人-->
		<list:data-column headerStyle="width:25%" property="docCreator.fdName" title="${ lfn:message('sys-handover:sysHandoverConfigMain.docCreatorId') }">
		</list:data-column>
		<!--创建时间-->
		<list:data-column headerStyle="width:25%" property="docCreateTime" title="${ lfn:message('sys-handover:sysHandoverConfigMain.docCreateTime') }">
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>