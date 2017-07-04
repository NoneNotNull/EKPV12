<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="lbpmAuthorize" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="fdStartTime" title="${ lfn:message('sys-lbpmext-authorize:lbpmAuthorize.fdStartTime') }"  escape="false">
			<kmss:showDate value="${lbpmAuthorize.fdStartTime}" type="datetime" />
		</list:data-column>
	
		<list:data-column col="fdEndTime" title="${ lfn:message('sys-lbpmext-authorize:lbpmAuthorize.fdEndTime') }"  escape="false">
			<c:if test="${lbpmAuthorize.fdAuthorizeType == 0 || lbpmAuthorize.fdAuthorizeType == 2}">
				<kmss:showDate value="${lbpmAuthorize.fdEndTime}" type="datetime" />
			</c:if>
			<c:if test="${lbpmAuthorize.fdAuthorizeType == 1}">
				<c:out value="${lfn:message('sys-lbpmext-authorize:lbpmAuthorize.fdEndTime.infinitive') }"/>
			</c:if>
		</list:data-column>
		
		<list:data-column property="fdAuthorizer.fdName" title="${ lfn:message('sys-lbpmext-authorize:lbpmAuthorize.fdAuthorizer') }">
		</list:data-column>
		
		<list:data-column property="fdAuthorizedPerson.fdName" title="${ lfn:message('sys-lbpmext-authorize:lbpmAuthorize.fdAuthorizedPerson') }">
		</list:data-column>
		
		<list:data-column col="fdAuthorizeType" title="${ lfn:message('sys-lbpmext-authorize:lbpmAuthorize.fdAuthorizeType') }" escape="false">
			<sunbor:enumsShow  enumsType="lbpmAuthorize_authorizeType" value="${lbpmAuthorize.fdAuthorizeType}"/>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>