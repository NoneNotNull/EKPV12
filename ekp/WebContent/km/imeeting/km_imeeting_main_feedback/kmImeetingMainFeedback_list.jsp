<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingMainFeedbackForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmImeetingMainFeedback.fdOperateType">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdOperateType"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMainFeedback.fdReason">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdReason"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMainFeedback.docCreateTime">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMainFeedback.fdFeedbackCount">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdFeedbackCount"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMainFeedback.docCreator.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMainFeedback.fdMeeting.fdId">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.fdMeeting"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMainFeedback.docAttendId.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMainFeedback.docAttendId"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingMainFeedback" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_main_feedback/kmImeetingMainFeedback.do" />?method=view&fdId=${kmImeetingMainFeedback.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingMainFeedback.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<xform:select value="${kmImeetingMainFeedback.fdOperateType}" property="fdOperateType" showStatus="view">
						<xform:enumsDataSource enumsType="km_imeeting_main_feedback_fd_operate_type" />
					</xform:select>
				</td>
				<td>
					<c:out value="${kmImeetingMainFeedback.fdReason}" />
				</td>
				<td>
					<kmss:showDate value="${kmImeetingMainFeedback.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmImeetingMainFeedback.fdFeedbackCount}" />
				</td>
				<td>
					<c:out value="${kmImeetingMainFeedback.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingMainFeedback.fdMeeting.fdId}" />
				</td>
				<td>
					<c:out value="${kmImeetingMainFeedback.docAttendId.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>