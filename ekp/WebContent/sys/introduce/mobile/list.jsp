<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld"
	prefix="person"%>
<%@ include file="/resource/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }" mobile="true">
		<list:data-column col="summary" title="">
			<c:out value="${item.fdIntroduceReason}" />
		</list:data-column>
		<list:data-column col="score" title="">
			<c:out value="${item.fdIntroduceGrade}" />
		</list:data-column>
		<list:data-column col="label" title="">
			<c:out value="${item.fdIntroducer.fdName}" />
		</list:data-column>
		<list:data-column col="created" title="">
			<kmss:showDate value="${item.fdIntroduceTime}" isInterval="true"></kmss:showDate>
		</list:data-column>
		<list:data-column col="icon" escape="false">
			<person:headimageUrl personId="${item.fdIntroducer.fdId}" size="90" />
		</list:data-column>
		<list:data-column property="introduceGoalNames" title="">
		</list:data-column>

		<list:data-column col="introduceType" title="" escape="false">
			<c:if test="${item.fdIntroduceToEssence&&(item.docStatus eq null or item.docStatus==30)}">
				精华库
				<c:if test="${item.fdIntroduceToNews}">，</c:if>
			</c:if>
			<c:if test="${item.fdIntroduceToNews}">
				新闻
			</c:if>
		</list:data-column>

		<list:data-column col="score" title="">
			<c:out value="${item.fdIntroduceGrade }"></c:out>
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
