<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImeetingSummary" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdName" title="${ lfn:message('km-imeeting:kmImeetingSummary.fdName') }" style="text-align:left;min-width:150px;">
		</list:data-column>
		<list:data-column headerClass="width60" col="fdHost" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHost') }" escape="false">
		   <ui:person personId="${kmImeetingSummary.fdHost.fdId}" personName="${kmImeetingSummary.fdHost.fdName}"></ui:person>
		   <c:out value="${kmImeetingSummary.fdOtherHostPerson}"/>
		</list:data-column> 
		<list:data-column headerClass="width100" col="fdPlace" title="${ lfn:message('km-imeeting:kmImeetingSummary.fdPlace') }" escape="false">
		  <c:out value="${kmImeetingSummary.fdPlace.fdName}"/> <c:out value="${kmImeetingSummary.fdOtherPlace}"/>
		</list:data-column>
		<list:data-column headerStyle="width:120px;" col="fdDate" title="${lfn:message('km-imeeting:kmImeetingMain.fdDate') }" escape="false">
			<kmss:showDate value="${kmImeetingSummary.fdHoldDate}" type="datetime" /> 
			<br/>
			~ <kmss:showDate value="${kmImeetingSummary.fdFinishDate}" type="datetime" /> 
		</list:data-column>
		<list:data-column headerStyle="width:120px" col="fdHoldDate" title="${ lfn:message('km-imeeting:kmImeetingSummary.fdHoldDate') }">
		   <kmss:showDate value="${kmImeetingSummary.fdHoldDate}" type="datetime" />
		</list:data-column>
		<list:data-column headerStyle="width:120px" col="fdFinishDate" title="${ lfn:message('km-imeeting:kmImeetingSummary.fdFinishDate') }">
		   <kmss:showDate value="${kmImeetingSummary.fdFinishDate}" type="datetime" />
		</list:data-column>
		<list:data-column headerClass="width80" property="docCreator.fdName" title="${ lfn:message('km-imeeting:kmImeetingSummary.docCreator') }">
			<ui:person personId="${kmImeetingSummary.docCreator.fdId}" personName="${kmImeetingSummary.docCreator.fdName}"></ui:person>
		</list:data-column>
		<list:data-column headerClass="width120" col="docCreateTime" title="${ lfn:message('km-imeeting:kmImeetingSummary.docCreateTime') }">
			 <kmss:showDate value="${kmImeetingSummary.docCreateTime}" type="datetime" />
		</list:data-column>
		
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>