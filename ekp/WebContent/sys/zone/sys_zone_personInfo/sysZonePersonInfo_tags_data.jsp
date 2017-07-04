<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${tagList }">
		<list:data-column col="categoryName" title="	${item.categoryName}"  escape="false">
	 				 <dt><span>${item.categoryName}</span></dt>
		</list:data-column>
		<list:data-column col="tags"  escape="false">
		 	 <c:forEach items="${item.tags}" var="tag" varStatus="vstatus">
		 	 		    <dd><a href='#' onclick='tagSearch("${tag.fdName}",true)' title='${tag.fdName}'>${tag.fdName}</a></dd>
		 	 </c:forEach>
		</list:data-column>
	</list:data-columns>
</list:data>