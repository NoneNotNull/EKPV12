<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImeetingResource" list="${list}" varIndex="status">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--序号--%>
		<list:data-column col="index">${status+1 }</list:data-column>
		<%--会议室名字--%>
		<list:data-column  property="fdName" title="${ lfn:message('km-imeeting:kmImeetingRes.fdName') }"  escape="false">
		</list:data-column>
		<%--会议室类别--%>
		<list:data-column headerStyle="width:120px;" property="docCategory.fdName" title="${ lfn:message('km-imeeting:kmImeetingRes.docCategory') }">
		</list:data-column>
		
		
		
		<%--是否可选--%>
		<c:if test="${empty conflictRes ||not empty conflictRes && fn:indexOf(conflictRes,kmImeetingResource.fdId)<0  }">
			<list:data-column col="select">1</list:data-column>
		</c:if>
		<c:if test="${not empty conflictRes && fn:indexOf(conflictRes,kmImeetingResource.fdId)>-1 }">
			<list:data-column col="select">0</list:data-column>
		</c:if>
		
	</list:data-columns>
	
</list:data>