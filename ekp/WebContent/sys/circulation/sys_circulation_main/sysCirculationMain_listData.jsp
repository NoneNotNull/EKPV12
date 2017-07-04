<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysCirculationMain" list="${queryPage.list}" varIndex="index">
		<list:data-column style="width:35px;" col="index" title="${ lfn:message('page.serial') }">
			${index+1}
		</list:data-column>
		<list:data-column style="width:120px;" property="fdCirculationTime" title="${ lfn:message('sys-circulation:sysCirculationMain.fdCirculationTime') }">
		</list:data-column>
		<list:data-column style="width:100px;" property="fdCirculator.fdName" title="${ lfn:message('sys-circulation:sysCirculationMain.fdCirculatorId') }">
		</list:data-column> 
		<list:data-column style="width:300px;" col="sysCirculationCirculors" title="${ lfn:message('sys-circulation:table.sysCirculationCirculors') }">
			<c:forEach
					items="${sysCirculationMain.receivedCirCulators}"
					var="receivedCirCulators" 
					varStatus="vstatus">
					<c:out value="${receivedCirCulators.fdName}" />
					<c:if test="${fn:length(sysCirculationMain.receivedCirCulators)!=vstatus.count }">;</c:if>
			</c:forEach>
		</list:data-column> 
		<list:data-column property="fdRemark" title="${ lfn:message('sys-circulation:sysCirculationMain.fdRemark') }">
		</list:data-column>	
		<list:data-column property="fdId">
		</list:data-column> 
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data> 