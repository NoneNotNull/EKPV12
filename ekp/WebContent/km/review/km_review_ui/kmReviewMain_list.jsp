<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:data>
	<list:data-columns var="kmReviewMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="docSubject" title="${ lfn:message('km-review:kmReviewMain.docSubject') }" style="text-align:left;min-width:200px">
		</list:data-column>
		<list:data-column headerClass="width120" property="fdNumber" title="${ lfn:message('km-review:kmReviewMain.fdNumber') }">
		</list:data-column>
		<list:data-column headerClass="width60" col="docCreator.fdName" title="${ lfn:message('km-review:kmReviewMain.docCreatorName') }" escape="false">
		  <ui:person personId="${kmReviewMain.docCreator.fdId}" personName="${kmReviewMain.docCreator.fdName}"></ui:person>
		</list:data-column>
		<list:data-column headerClass="width80" col="docCreateTime" title="${ lfn:message('km-review:kmReviewMain.docCreateTime') }">
		    <kmss:showDate value="${kmReviewMain.docCreateTime}" type="date"/>
		</list:data-column>
		<list:data-column headerClass="width40" col="docStatus" title="${ lfn:message('km-review:kmReviewMain.docStatus') }">
		            <c:if test="${kmReviewMain.docStatus=='00'}">
						${ lfn:message('km-review:status.discard')}
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='10'}">
						${ lfn:message('km-review:status.draft') } 
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='11'}">
						${ lfn:message('km-review:status.refuse')}
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='20'}">
						${ lfn:message('km-review:status.append') }
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='30'}">
						${ lfn:message('km-review:status.publish') }
					</c:if>
					<c:if test="${kmReviewMain.docStatus=='31'}">
						${ lfn:message('km-review:status.feedback') }
					</c:if>
		</list:data-column>
		<list:data-column headerClass="width100" col="nodeName" title="${ lfn:message('km-review:sysWfNode.processingNode.currentProcess') }" escape="false">
			<kmss:showWfPropertyValues  var="nodevalue" idValue="${kmReviewMain.fdId}" propertyName="nodeName" />
			    <div class="textEllipsis width100" title="${nodevalue}">
			        <c:out value="${nodevalue}"></c:out>
			    </div>
		</list:data-column>
		<list:data-column headerClass="width100" col="handlerName" title="${ lfn:message('km-review:sysWfNode.processingNode.currentProcessor') }" escape="false">
		   <kmss:showWfPropertyValues  var="handlerValue" idValue="${kmReviewMain.fdId}" propertyName="handlerName" />
			    <div class="textEllipsis width100" style="font-weight:bold;" title="${handlerValue}">
			        <c:out value="${handlerValue}"></c:out>
			    </div>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>