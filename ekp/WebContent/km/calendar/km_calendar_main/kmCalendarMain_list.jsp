<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/calendar/km_calendar_main/kmCalendarMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/calendar/km_calendar_main/kmCalendarMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/calendar/km_calendar_main/kmCalendarMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmCalendarMainForm, 'deleteall');">
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
				<sunbor:column property="kmCalendarMain.docSubject">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docContent">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docContent"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docCreateTime">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docAlterTime">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docStartTime">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docStartTime"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docFinishTime">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docFinishTime"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdIsAlldayevent">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdIsAlldayevent"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdRecurrenceStr">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdRecurrenceStr"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdIsLunar">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdIsLunar"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdAuthorityType">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdAuthorityType"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdLocation">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdLocation"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdRelationUrl">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdRelationUrl"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.fdType">
					<bean:message bundle="km-calendar" key="kmCalendarMain.fdType"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docCreator.fdName">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.docCreatorId.fdName">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docOwner"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarMain.labelId.fdId">
					<bean:message bundle="km-calendar" key="kmCalendarMain.docLabel"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCalendarMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/calendar/km_calendar_main/kmCalendarMain.do" />?method=view&fdId=${kmCalendarMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCalendarMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmCalendarMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.docContent}" />
				</td>
				<td>
					<kmss:showDate value="${kmCalendarMain.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmCalendarMain.docAlterTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmCalendarMain.docStartTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmCalendarMain.docFinishTime}" />
				</td>
				<td>
					<xform:radio value="${kmCalendarMain.fdIsAlldayevent}" property="fdIsAlldayevent" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${kmCalendarMain.fdRecurrenceStr}" />
				</td>
				<td>
					<xform:radio value="${kmCalendarMain.fdIsLunar}" property="fdIsLunar" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${kmCalendarMain.fdAuthorityType}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.fdLocation}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.fdRelationUrl}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.fdType}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.docOwner.fdName}" />
				</td>
				<td>
					<c:out value="${kmCalendarMain.docLabel.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>