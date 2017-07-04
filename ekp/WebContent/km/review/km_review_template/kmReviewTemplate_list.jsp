<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import url="/sys/right/cchange_tmp_right/cchange_tmp_right_button.jsp" charEncoding="UTF-8">
	<c:param name="mainModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
	<c:param name="tmpModelName" value="com.landray.kmss.km.review.model.KmReviewTemplate" />
	<c:param name="templateName" value="fdTemplate" />
	<c:param name="authReaderNoteFlag" value="2" /> 
</c:import>
<html:form action="/km/review/km_review_template/kmReviewTemplate.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/km/review/km_review_template/kmReviewTemplate.do" />?method=add&parentId=${param.parentId}');">
	<kmss:auth
		requestURL="/km/review/km_review_template/kmReviewTemplate.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmReviewTemplateForm, 'deleteall');">
	</kmss:auth></div>
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>

				<sunbor:column property="kmReviewTemplate.fdName">
					<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
				</sunbor:column>
				
				<sunbor:column property="kmReviewTemplate.fdOrder">
					<bean:message bundle="km-review" key="kmReviewMain.fdOrder" />
				</sunbor:column>

				<sunbor:column property="kmReviewTemplate.docCreator">
					<bean:message bundle="km-review"
						key="kmReviewTemplate.docCreatorId" />
				</sunbor:column>


				<sunbor:column property="kmReviewTemplate.docCreateTime">
					<bean:message bundle="km-review"
						key="kmReviewTemplate.docCreateTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmReviewTemplate"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/review/km_review_template/kmReviewTemplate.do" />?method=view&fdId=${kmReviewTemplate.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${kmReviewTemplate.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmReviewTemplate.fdName}" /></td>
				<td><c:out value="${kmReviewTemplate.fdOrder}"/></td>
				<td><c:out value="${kmReviewTemplate.docCreator.fdName}" /></td>
				<td><sunbor:date value="${kmReviewTemplate.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>

<c:import url="/sys/workflow/include/sysWfTemplate_auditorBtn.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewTemplate"/>
	<c:param name="cateid" value="${param.parentId}"/>
</c:import>
<%@ include file="/resource/jsp/list_down.jsp"%>
