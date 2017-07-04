<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:data>
	<list:data-columns var="item" list="${notesPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdModelId">
		</list:data-column>
		<list:data-column property="fdModelName">
		</list:data-column>
		<list:data-column col="fdEvaluationTime" title="${lfn:message('sys-evaluation:sysEvaluationMain.fdEvaluationTime')}">
			<kmss:showDate isInterval="true" value="${item.fdEvaluationTime}" /> 
		</list:data-column>
		<list:data-column property="fdEvaluationContent" title="${lfn:message('sys-evaluation:sysEvaluation.evalContent')}">
		</list:data-column>
		<list:data-column col="docPraiseCount" title="${lfn:message('sys-evaluation:sysEvaluation.praise.count')}" escape="false">
			<span class="com_number">${not empty item.docPraiseCount? item.docPraiseCount: 0}</span>
		</list:data-column>
		<list:data-column col="fdReplyCount" title="${lfn:message('sys-evaluation:sysEvaluation.reply.count')}" escape="false">
			<span class="com_number">${not empty item.fdReplyCount? item.fdReplyCount: 0}</span>
		</list:data-column>
		<list:data-column col="fdEvaluatorName" title="${lfn:message('sys-evaluation:sysEvaluation.evaluation.person')}" escape="false">
			<ui:person personId="${item.fdEvaluator.fdId }" personName="${item.fdEvaluator.fdName }"></ui:person>
		</list:data-column>
		<list:data-column property="docSubject" title="${lfn:message('sys-evaluation:sysEvaluationNotes.fragment')}">
		</list:data-column>
		<list:data-column col="evalDocSubject" title="${lfn:message('sys-evaluation:sysEvaluation.evalDoc')}" escape="false">
			<span id="${item.fdId}" class="lui_eval_loading" title="${lfn:message('sys-evaluation:sysEvaluation.evalDoc')}"></span>
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${notesPage }">
	</list:data-paging>
</list:data>