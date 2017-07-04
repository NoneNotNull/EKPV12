<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImeetingStat" list="${queryPage.list}">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="fdUrl" escape="false">
			/km/imeeting/km_imeeting_stat/kmImeetingStat.do?method=view&fdId=${kmImeetingStat.fdId}
		</list:data-column>
		<list:data-column headerStyle="width:150px" property="fdName" 
			title="${ lfn:message('km-imeeting:kmImeetingStat.fdName') }">
		</list:data-column>
		<list:data-column property="docCreator.fdName" 
			title="${ lfn:message('km-imeeting:kmImeetingStat.docCreator') }">
		</list:data-column>
		<list:data-column col="docCreateTime" title="${ lfn:message('km-imeeting:kmImeetingStat.docCreateTime') }">
		    <kmss:showDate value="${kmImeetingStat.docCreateTime}" type="date"/>
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
	
</list:data>