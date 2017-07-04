<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do">
	<c:if test="${not empty queryPage.list }">
		<div id="optBarDiv">
		<kmss:auth
			requestURL="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=deleteall&fdModelId=${param.fdModelId}"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmReviewFeedbackInfoForm, 'deleteall');">
		</kmss:auth></div>
	</c:if>
	<script type="text/javascript">
		Com_AddEventListener(window,'load',function(){
			var feedBack = document.getElementById("div_feedBackContainer");
			if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
				window.frameElement.style.height = (feedBack.offsetHeight + 40)+"px";
			}
		} );
	</script>
	<center>
	<div id="div_feedBackContainer">
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
		<bean:message bundle="km-review" key="message.no.feedback"/>
	<%
	} else {
	%>
		<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
		<table id="List_ViewTable">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
					<td width="40pt"><bean:message key="page.serial" /></td>
					<sunbor:column property="fdSummary">
						<bean:message bundle="km-review" key="kmReviewFeedbackInfo.fdSummary" />
					</sunbor:column>
					<sunbor:column property="fdCreator">
						<bean:message bundle="km-review" key="kmReviewFeedbackInfo.docCreatorId" />
					</sunbor:column>
					<sunbor:column property="docCreatorTime">
						<bean:message bundle="km-review"
							key="kmReviewFeedbackInfo.docCreatorTime" />
					</sunbor:column>
				</sunbor:columnHead>
			</tr>
			<c:forEach items="${queryPage.list}" var="kmReviewFeedbackInfo"
				varStatus="vstatus">
				<tr
					kmss_href="<c:url value="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do" />?method=view&fdId=${kmReviewFeedbackInfo.fdId}">
					<td><input type="checkbox" name="List_Selected"
						value="${kmReviewFeedbackInfo.fdId}"></td>
					<td>${vstatus.index+1}</td>
					<td><c:out value="${kmReviewFeedbackInfo.fdSummary}" />
					</td>
					<td><c:out value="${kmReviewFeedbackInfo.fdCreator.fdName}" />
					</td>
					<td><sunbor:date value="${kmReviewFeedbackInfo.docCreateTime}" /></td>
				</tr>
			</c:forEach>
		</table>
		<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
	</div>
	</center>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
