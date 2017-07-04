<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@ include file="/resource/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }" mobile="true">
		<list:data-column col="summary" 
			title="${lfn:message('sys-evaluation:sysEvaluationMain.fdEvaluationContent')}" escape="false">
			${item.fdEvaluationContent}
		</list:data-column>
		<list:data-column col="score" 
			title="${lfn:message('sysEvaluationMain.fdEvaluationScore')}">
			<c:out value="${item.fdEvaluationScore}"/>
		</list:data-column>
		<list:data-column col="label" title="${lfn:message('sysEvaluationMain.sysEvaluator')}">
			<c:out value="${item.fdEvaluator.fdName}"/>
		</list:data-column>
		<list:data-column col="created" title="${lfn:message('sysEvaluationMain.fdEvaluationTime')}">
			<kmss:showDate value="${item.fdEvaluationTime}" isInterval="true"></kmss:showDate>
		</list:data-column>
		<list:data-column col="icon" escape="false">
			<person:headimageUrl personId="${item.fdEvaluator.fdId}" size="90" />
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
