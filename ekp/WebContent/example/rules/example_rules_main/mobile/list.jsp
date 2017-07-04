<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="exampleRulesMain" list="${queryPage.list}" varIndex="status" mobile="true">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<!-- 主题-->	
		<list:data-column col="label" title="${lfn:message('example-rules:exampleRulesMain.docSubject')}">
		    <c:out value="${exampleRulesMain.exampleRulesMain.docSubject}"/>
		</list:data-column>
		<list:data-column col="created" title="${lfn:message('example-rules:exampleRulesMain.docCreateTime')}">
	        <kmss:showDate value="${exampleRulesMain.exampleRulesMain.docCreateTime}" type="date"></kmss:showDate>
      	</list:data-column>
		<list:data-column property="fdWorkType" title="${ lfn:message('example-rules:exampleRulesMain.fdWorkType') }">
		</list:data-column>
		<list:data-column property="docPublishTime" title="${ lfn:message('example-rules:exampleRulesMain.docPublishTime') }">
		</list:data-column>
		<list:data-column property="fdNotifyType" title="${ lfn:message('example-rules:exampleRulesMain.fdNotifyType') }">
		</list:data-column>
		<list:data-column property="docStatus" title="${ lfn:message('example-rules:exampleRulesMain.docStatus') }">
		</list:data-column>
		<list:data-column col="href" escape="false">
			/example/rules/example_rules_main/exampleRulesMain.do?method=view&fdId=${exampleRulesMain.fdId}
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno}"
		pageSize="${queryPage.rowsize}" totalSize="${queryPage.totalrows}">
	</list:data-paging>
</list:data>	
