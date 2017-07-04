<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysTimeArea" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="fdUrl" escape="false">
			/sys/time/sys_time_area/sysTimeArea.do?method=view&fdId=${sysTimeArea.fdId}
		</list:data-column>
		<list:data-column headerStyle="width:150px" property="fdName"
			title="${ lfn:message('sys-time:sysTimeArea.fdName') }">
		</list:data-column>
		<list:data-column col="scope"
			title="${ lfn:message('sys-time:sysTimeArea.scope') }" escape="false">
			<kmss:joinListProperty value="${sysTimeArea.areaMembers}"
				properties="fdName" split=";" />
		</list:data-column>
		<list:data-column col="timeAdmin"
			title="${ lfn:message('sys-time:sysTimeArea.timeAdmin') }"
			escape="false">
			<kmss:joinListProperty value="${sysTimeArea.areaAdmins}"
				properties="fdName" split=";" />
		</list:data-column>
		<list:data-column col="docCreateTime"
			title="${ lfn:message('sys-time:sysTimeArea.docCreateTime') }">
			<kmss:showDate value="${sysTimeArea.docCreateTime}" type="date" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
