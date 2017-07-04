<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="exampleRulesMain" list="${queryPage.list}" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		
		<list:data-column property="docSubject" title="${ lfn:message('example-rules:exampleRulesMain.docSubject') }">
		</list:data-column>
		<list:data-column property="docCreateTime" title="${ lfn:message('example-rules:exampleRulesMain.docCreateTime') }">
		</list:data-column>
		<list:data-column col="fdWorkType" title="${ lfn:message('example-rules:exampleRulesMain.fdWorkType') }">
			<sunbor:enumsShow
				value="${exampleRulesMain.fdWorkType}"
				enumsType="example_rules_main_fd_work_type" />
		</list:data-column>
		<list:data-column property="docPublishTime" title="${ lfn:message('example-rules:exampleRulesMain.docPublishTime') }">
		</list:data-column>
		<list:data-column property="fdNotifyType" title="${ lfn:message('example-rules:exampleRulesMain.fdNotifyType') }">
		</list:data-column>
		<list:data-column col="docStatus" title="${ lfn:message('example-rules:exampleRulesMain.docStatus') }">
			<sunbor:enumsShow
				value="${exampleRulesMain.docStatus}"
				enumsType="example_rules_main_doc_status" />
		</list:data-column>
		<list:data-column col="docCategory.fdName" title="${ lfn:message('example-rules:exampleRulesMain.docCategory') }">
			<c:out value="${exampleRulesMain.docCategory.fdName}" />
		</list:data-column>
		<list:data-column col="docCreator.fdName" title="${ lfn:message('example-rules:exampleRulesMain.docCreator') }">
			<c:out value="${exampleRulesMain.docCreator.fdName}" />
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging page="${queryPage}" />
</list:data>