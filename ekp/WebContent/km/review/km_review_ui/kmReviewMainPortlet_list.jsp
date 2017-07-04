<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmReviewMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" headerClass="width100" styleClass="width100" title="${ lfn:message('km-review:kmReviewMain.docSubject') }" escape="false" style="text-align:left;min-width:100px">
		 <a class="com_subject textEllipsis" title="${kmReviewMain.docSubject}" href="${LUI_ContextPath}/km/review/km_review_main/kmReviewMain.do?method=view&fdId=${kmReviewMain.fdId}" target="_blank">
		  <c:out value="${kmReviewMain.docSubject}"/>
		 </a> 
		</list:data-column>
		<list:data-column  col="docCreateTime" title="${ lfn:message('km-review:kmReviewMain.docCreateTime') }">
		    <kmss:showDate value="${kmReviewMain.docCreateTime}" type="date"/>
		</list:data-column>
		<list:data-column   col="docStatus" title="${ lfn:message('km-review:kmReviewMain.docStatus') }">
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
		<list:data-column  col="docCreator.fdName" title="${ lfn:message('km-review:kmReviewMain.docCreatorName') }" escape="false">
		  <ui:person personId="${kmReviewMain.docCreator.fdId}" personName="${kmReviewMain.docCreator.fdName}"></ui:person>
		</list:data-column>
		<list:data-column headerClass="width100" styleClass="width100" col="handlerName" title="${ lfn:message('km-review:sysWfNode.processingNode.currentProcessor') }" escape="false">
		    <kmss:showWfPropertyValues  var="handlerName" idValue="${kmReviewMain.fdId}" propertyName="handlerName" />
			    <div class="textEllipsis width100" style="font-weight: bold;" title="${handlerName}">
			        <c:out value="${handlerName}"></c:out>
			    </div>
		</list:data-column>
	</list:data-columns>
</list:data>
