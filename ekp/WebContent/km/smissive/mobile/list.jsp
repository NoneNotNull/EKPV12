<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<list:data>
	<list:data-columns var="kmSmissiveMain" list="${queryPage.list}" varIndex="status" mobile="true">
		<list:data-column property="fdId">
		</list:data-column >
	    <%-- 主题--%>	
		<list:data-column col="label" escape="false" title="${ lfn:message('km-smissive:kmSmissiveMain.docSubject') }">
			<c:out value="${kmSmissiveMain.docSubject}"/>
		</list:data-column>
      	<%-- 发布时间--%>
      	<list:data-column col="docPublishTime" title="${ lfn:message('km-smissive:kmSmissiveMain.docPublishTime') }">
	        <kmss:showDate value="${kmSmissiveMain.docPublishTime}" type="date"></kmss:showDate>
      	</list:data-column>
      	<list:data-column col="listIcon" escape="false">
			mui-bookOpenLogo
		</list:data-column>
		<%--链接--%>
		<list:data-column col="href" escape="false">
			/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=${kmSmissiveMain.fdId}
		</list:data-column>
		<list:data-column col="docDeptName" escape="false" title="${ lfn:message('km-smissive:kmSmissiveMain.fdMainDeptId') }">
		     <c:out value="${kmSmissiveMain.fdMainDept.fdName}"/>
		</list:data-column>
		<c:if test="${kmSmissiveMain.docStatus=='30' ||kmSmissiveMain.docStatus=='40'}">
			<list:data-column col="docReadCount" escape="false">
		       <c:out value="${kmSmissiveMain.docReadCount}" escapeXml="false"/>
			</list:data-column>
		</c:if>
		
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>