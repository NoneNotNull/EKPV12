<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="lbpmTemlate" list="${queryPage.list }"
		varIndex="status">
		<list:data-column col="fdId">
			${lbpmTemlate[0]}
		</list:data-column>
		<list:data-column col="fdTemplateName">
			${lbpmTemlate[2]}
		</list:data-column>
		<list:data-column col="fdTemplateId">
			${lbpmTemlate[3]}
		</list:data-column>
		<!--标题-->
		<list:data-column col="fdName" 
			title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docSubject') }"
			escape="false">
			<c:if test="${empty lbpmTemlate[1] }">
				${templateNameMap[lbpmTemlate[0]]}
			</c:if>
			<c:if test="${not empty lbpmTemlate[1] }">
				${lbpmTemlate[1]}
			</c:if>
		</list:data-column>
		<!--所属模块-->
		<list:data-column headerStyle="width:8%" col="fdModelName"
				title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.order.module') }"
				escape="false">
		         ${moduleNameMap[lbpmTemlate[0]]}
		</list:data-column>
		<!--所属分类-->
		<list:data-column headerStyle="width:8%" col="docCategoryName"
				title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.templateName') }"
				escape="false">
		         ${templateNameMap[lbpmTemlate[0]]}
		</list:data-column>
		<!--版本号-->
		<list:data-column headerStyle="width:8%" col="fdVersion"
				title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.fdVersion') }"
				escape="false">
		         ${lbpmTemlate[5]}
		</list:data-column>
		<!--流程实例数-->
		<list:data-column headerStyle="width:8%" col="processCount"
				title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.processCount') }"
				escape="false">
		         ${processCountMap[lbpmTemlate[0]]}
		</list:data-column>
		<!--已结束的流程实例数-->
		<list:data-column headerStyle="width:10%" col="finishedProcessCount"
				title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.finishedProcessCount') }"
				escape="false">
		         ${finishedProcessCountMap[lbpmTemlate[0]]}
		</list:data-column>
		<!--创建时间-->
		<list:data-column headerStyle="width:130px" col="fdCreateTime"
			title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docAuthorTime') }">
			<kmss:showDate value="${lbpmTemlate[7]}" />
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>