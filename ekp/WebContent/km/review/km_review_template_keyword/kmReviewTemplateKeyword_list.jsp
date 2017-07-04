<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmReviewTemplateKeywordForm, 'deleteall');">
		</kmss:auth>
	</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
	
				<sunbor:column property="kmReviewTemplateKeyword.kmReviewTemplate.fdId">
					<bean:message  bundle="km-review" key="table.kmReviewTemplate"/>.<bean:message key="kmReviewTemplate.fdId"/>
				</sunbor:column>
				<sunbor:column property="kmReviewTemplateKeyword.fdKeyword">
					<bean:message  bundle="km-review" key="kmReviewTemplateKeyword.fdKeyword"/>
				</sunbor:column>
			
			
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmReviewTemplateKeyword" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do" />?method=view&fdId=${kmReviewTemplateKeyword.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmReviewTemplateKeyword.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmReviewTemplateKeyword.kmReviewTemplate.fdId}" />
				</td>
				<td>
					<c:out value="${kmReviewTemplateKeyword.fdKeyword}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
