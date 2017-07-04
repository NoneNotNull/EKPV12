<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<list:data>
	<list:data-columns var="kmDocKnowledge" list="${queryPage.list }" varIndex="status" mobile="true">
		<list:data-column property="fdId">
		</list:data-column >
		
	    <%-- 主题--%>	
		<list:data-column col="label" title="${ lfn:message('sysDocBaseInfo.docSubject') }" escape="false">
			<c:if test="${kmDocKnowledge.docIsIntroduced==true}"><span class="muiEssence muiProcessStatusBorder">精</span></c:if><c:out value="${kmDocKnowledge.docSubject}"/>
		</list:data-column>
		 <%-- 创建者--%>
		<list:data-column col="creator" title="${ lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }" >
		         <c:out value="${kmDocKnowledge.docCreator.fdName}"/>
		</list:data-column>
		 <%-- 创建者头像--%>
		<list:data-column col="icon" escape="false">
			    <person:headimageUrl personId="${kmDocKnowledge.docCreator.fdId}" size="90" />
		</list:data-column>
		 <%-- 发布时间--%>
	 	<list:data-column col="docPublishTime" title="${ lfn:message('km-doc:kmDocKnowledge.docPublishTime') }">
	        <kmss:showDate value="${kmDocKnowledge.docPublishTime}" type="date"></kmss:showDate>
      	</list:data-column>
		<%--链接--%>
		<list:data-column col="href" escape="false">
			/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId=${kmDocKnowledge.fdId}
		</list:data-column>
		<%--摘要--%>
		<list:data-column col="summary"  title="${ lfn:message('km-doc:kmDocKnowledge.fdDescription')}">
		       <c:out value="${kmDocKnowledge.fdDescription}"/>
		</list:data-column>
		<%--阅读数--%>
		<c:if test="${kmDocKnowledge.docStatus=='30' }">
			<list:data-column col="docReadCount"  title="${ lfn:message('km-doc:ktip.view.hits')}">
			       <c:out value="${kmDocKnowledge.docReadCount}"/>
			</list:data-column>
		</c:if>
		<list:data-column col="tagNames" title="${lfn:message('km-doc:kmDoc.kmDocKnowledge.tag') }" escape="false">		
			<c:if test="${not empty tagJson[kmDocKnowledge.fdId] }">
				<c:set var="_tags" value="${tagJson[kmDocKnowledge.fdId]}"/>
				<%
					String tags = (String)pageContext.getAttribute("_tags");
					// html过滤
					pageContext.setAttribute("_tags",StringUtil.clearHTMLTag(tags));
				%>
	       		${_tags}
	       	</c:if>
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>