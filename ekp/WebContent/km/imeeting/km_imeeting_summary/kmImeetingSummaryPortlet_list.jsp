<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImeetingSummary" list="${queryPage.list }"
	    href="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=view&fdId=!{fdId}">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="fdName" title="${ lfn:message('km-imeeting:kmImeetingSummary.fdName') }" escape="false" style="text-align:left">
		   <a class="com_subject" title="${kmMeetingSummary.docSubject}" href="${LUI_ContextPath}/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=view&fdId=${kmImeetingSummary.fdId}" target="_blank">
			   <c:out value="${kmImeetingSummary.fdName}"/>
			</a>
		</list:data-column>
		<list:data-column headerStyle="width:80px" col="docCreator.fdName" title="${ lfn:message('km-imeeting:kmImeetingSummary.docCreator') }" escape="false">
		  <ui:person personId="${kmImeetingSummary.docCreator.fdId}" personName="${kmImeetingSummary.docCreator.fdName}"></ui:person>
		</list:data-column>
		<list:data-column headerStyle="width:235px;" col="fdDate" title="${lfn:message('km-imeeting:kmImeetingMain.fdDate') }">
			<kmss:showDate value="${kmImeetingSummary.fdHoldDate}" type="datetime" /> ~ <kmss:showDate value="${kmImeetingSummary.fdFinishDate}" type="datetime" />
		</list:data-column>
		<list:data-column headerStyle="width:150px" property="fdTemplate.fdName" title="${ lfn:message('km-imeeting:kmImeetingSummary.fdTemplate') }">
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>