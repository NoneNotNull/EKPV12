<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImeetingAtt" list="${queryPage.list }">
		<list:data-column property="fdId">	
		</list:data-column>
		<%--议程名称--%>
		<list:data-column col="docSubject"   title="${ lfn:message('km-imeeting:kmImeetingAgenda.docSubject') }"escape="false" >
			<c:out value="${kmImeetingAtt.docSubject}"/>
		</list:data-column>
		<%--所属会议--%>
		<list:data-column col="fdMain"   title="${ lfn:message('km-imeeting:kmImeetingAgenda.fdMain') }" escape="false" >
			<c:out value="${kmImeetingAtt.fdMain.fdName}"/>
		</list:data-column>
		<%--上会材料名称--%>
		<list:data-column col="attachmentName"   title="${ lfn:message('km-imeeting:kmImeetingAgenda.attachmentName') }" escape="false">
			<span class="com_subject" ><c:out value="${kmImeetingAtt.attachmentName}"/></span>
		</list:data-column>
		<%--汇报人--%>
		<list:data-column col="docReporter.fdName"   title="${ lfn:message('km-imeeting:kmImeetingAgenda.docReporter') }" escape="false" >
			<ui:person personId="${kmImeetingAtt.docReporter.fdId}" personName="${kmImeetingAtt.docReporter.fdName}"></ui:person>
		</list:data-column>
		<%--需提交时间--%>
		<list:data-column headerStyle="width:115px" col="attachmentSubmitTime" title="${ lfn:message('km-imeeting:kmImeetingAgenda.attachmentSubmitTime') }">
		   <kmss:showDate value="${kmImeetingAtt.attachmentSubmitTime}" type="date" />
		</list:data-column>
	</list:data-columns>
</list:data>