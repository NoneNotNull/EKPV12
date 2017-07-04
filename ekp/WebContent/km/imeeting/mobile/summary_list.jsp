<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<list:data>
	<list:data-columns var="kmImeetingSummary" list="${queryPage.list }" varIndex="status" mobile="true">
		<list:data-column property="fdId">
		</list:data-column >
	    <%-- 主题--%>	
		<list:data-column col="label" title="${ lfn:message('km-imeeting:kmImeetingMain.fdName') }" escape="false">
		         <c:out value="${kmImeetingSummary.fdName}"/>
		</list:data-column>
		<%-- 召开时间~结束时间 --%>
		<list:data-column col="created" escape="false">
			<c:if test="${not empty  kmImeetingSummary.fdHoldDate or not empty kmImeetingSummary.fdFinishDate}">
				<kmss:showDate value="${kmImeetingSummary.fdHoldDate}" type="datetime"></kmss:showDate>
			 	~
			 	<kmss:showDate value="${kmImeetingSummary.fdFinishDate}" type="datetime"></kmss:showDate>
			</c:if>
		</list:data-column>
		 <%-- 主持人头像--%>
		<list:data-column col="icon" escape="false">
			<c:if test="${not empty kmImeetingSummary.fdHost }" >
				<person:headimageUrl personId="${kmImeetingSummary.fdHost.fdId}" size="90" />
			</c:if>
			<c:if test="${empty kmImeetingSummary.fdHost }">
				<person:headimageUrl personId="" size="90" />
			</c:if>
		</list:data-column>
		 <%-- 主持人--%>
		<list:data-column col="host" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHost') }" escape="false">
			<c:if test="${not empty kmImeetingSummary.fdHost or not empty kmImeetingSummary.fdOtherHostPerson }">
				<c:if test="${not empty kmImeetingSummary.fdHost}">
					<c:out value="${kmImeetingSummary.fdHost.fdName}"/>
				</c:if>
			    <c:if test="${not empty kmImeetingSummary.fdOtherHostPerson }">
			    	<c:out value="${ kmImeetingSummary.fdOtherHostPerson }"></c:out>
			    </c:if>       
		    </c:if> 
		</list:data-column>
		 <%-- 发布时间
	 	<list:data-column col="created" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHoldDate') }">
	        <kmss:showDate value="${kmImeetingSummary.fdHoldDate}" type="datetime"></kmss:showDate>
      	</list:data-column>--%>
      	 <%-- 地点--%>
	 	<list:data-column col="place" title="${ lfn:message('km-imeeting:kmImeetingMain.fdPlace') }" escape="false">
	       <c:if test="${not empty kmImeetingSummary.fdPlace }">
	       		<c:out value="${kmImeetingSummary.fdPlace.fdName }"></c:out>
	       </c:if>
	       <c:if test="${not empty kmImeetingSummary.fdOtherPlace }">
	       		<c:out value="${kmImeetingSummary.fdOtherPlace }"></c:out>
	       </c:if>
      	</list:data-column>
		<%--链接--%>
		<list:data-column col="href" escape="false">
			/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=view&fdId=${kmImeetingSummary.fdId}
		</list:data-column>
		
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>