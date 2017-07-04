<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdEvaluationTime" title="${lfn:message('sysEvaluationMain.fdEvaluationTime')}">
		</list:data-column>
		<list:data-column property="fdEvaluationContent" title="${lfn:message('sys-evaluation:sysEvaluationNotes.fdEvaluationContent')}">
		</list:data-column>
		<list:data-column property="docSubject" title="${lfn:message('sys-evaluation:sysEvaluationNotes.docSubject')}">
		</list:data-column>
		<list:data-column property="fdModelId">
		</list:data-column> 
		<list:data-column property="fdEvaluator.fdId">
		</list:data-column>  
		<list:data-column property="fdEvaluator.fdName">
		</list:data-column>  
		<list:data-column col="fdReplyCount" title="${lfn:message('sys-evaluation:sysEvaluationMain.fdReplyCount')}">
			${not empty item.fdReplyCount? item.fdReplyCount: 0}
		</list:data-column>
		<list:data-column col="docPraiseCount">
			${not empty item.docPraiseCount? item.docPraiseCount: 0}
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
