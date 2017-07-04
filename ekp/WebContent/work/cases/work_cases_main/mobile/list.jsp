<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="workCasesMain" list="${queryPage.list}" varIndex="status" mobile="true">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<!-- 主题-->	
		<list:data-column col="label" title="${lfn:message('work-cases:workCasesMain.docSubject')}">
		    <c:out value="${workCasesMain.workCasesMain.docSubject}"/>
		</list:data-column>
		<list:data-column col="created" title="${lfn:message('work-cases:workCasesMain.docCreateTime')}">
	        <kmss:showDate value="${workCasesMain.workCasesMain.docCreateTime}" type="date"></kmss:showDate>
      	</list:data-column>
		<list:data-column property="docPublishTime" title="${ lfn:message('work-cases:workCasesMain.docPublishTime') }">
		</list:data-column>
		<list:data-column property="fdWorkType" title="${ lfn:message('work-cases:workCasesMain.fdWorkType') }">
		</list:data-column>
		<list:data-column col="href" escape="false">
			/work/cases/work_cases_main/workCasesMain.do?method=view&fdId=${workCasesMain.fdId}
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno}"
		pageSize="${queryPage.rowsize}" totalSize="${queryPage.totalrows}">
	</list:data-paging>
</list:data>	
