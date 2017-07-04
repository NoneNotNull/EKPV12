<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="workCasesMain" list="${queryPage.list}" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		
		<list:data-column property="docSubject" title="${ lfn:message('work-cases:workCasesMain.docSubject') }" style="text-align:left">
		</list:data-column>
		<list:data-column col="docStatus" title="${ lfn:message('work-cases:workCasesMain.docStatus') }">
			<sunbor:enumsShow  
				value="${workCasesMain.docStatus}" 
			  	enumsType="common_status"/>
		</list:data-column>
		<list:data-column col="docCategory.fdName" title="${ lfn:message('work-cases:workCasesMain.docCategory') }">
			<c:out value="${workCasesMain.docCategory.fdName}" />
		</list:data-column>
		<list:data-column col="fdWorkType" title="${ lfn:message('work-cases:workCasesMain.fdWorkType') }">
			<sunbor:enumsShow
				value="${workCasesMain.fdWorkType}"
				enumsType="work_cases_main_fd_work" />
		</list:data-column>
		<list:data-column col="docCreateTime" title="${ lfn:message('work-cases:workCasesMain.docCreateTime') }">
			<kmss:showDate value="${workCasesMain.docCreateTime}" type="date"/>
		</list:data-column>
		<list:data-column col="docPublishTime" title="${ lfn:message('work-cases:workCasesMain.docPublishTime') }">
			 <kmss:showDate value="${workCasesMain.docPublishTime}" type="date"/>
		</list:data-column>
		
		<list:data-column col="docCreator.fdName" title="${ lfn:message('work-cases:workCasesMain.docCreator') }">
			<c:out value="${workCasesMain.docCreator.fdName}" />
		</list:data-column>
		
	</list:data-columns>
	
	<list:data-paging page="${queryPage}" />
</list:data>