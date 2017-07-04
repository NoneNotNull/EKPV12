<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdEvaluationTime" title="${lfn:message('kms-wiki:kmsWikiEvaluation.fdEvaluationTime')}">
		</list:data-column>
		<list:data-column property="fdEvaluationContent" title="${lfn:message('kms-wiki:kmsWikiEvaluation.fdEvaluationContent')}">
		</list:data-column>	
		<list:data-column property="docSubject" title="${lfn:message('kms-wiki:kmsWikiEvaluation.docSubject')}">
		</list:data-column>		
		<list:data-column property="fdModelId" title="${lfn:message('kms-wiki:kmsWikiEvaluation.fdModelId')}">
		</list:data-column> 
		<list:data-column property="fdEvaluator.fdId" title="点评人id">
		</list:data-column>  
		<list:data-column property="fdEvaluator.fdName" title="点评人名">
		</list:data-column>   
	</list:data-columns>

	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>