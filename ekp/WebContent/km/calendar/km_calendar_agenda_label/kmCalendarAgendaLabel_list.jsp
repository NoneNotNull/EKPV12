<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<html:form action="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do">
	<div id="optBarDiv">
	
		<kmss:auth requestURL="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=importAgendaLabel">
			<input type="button" value="<bean:message bundle="km-calendar" key="km.calendar.tree.calendar.label.init"/>"
				onclick="Com_OpenWindow('<c:url value="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do" />?method=importAgendaLabel');">
		</kmss:auth>
		<kmss:auth requestURL="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmCalendarAgendaLabelForm, 'deleteall');">
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
				<sunbor:column property="kmCalendarAgendaLabel.fdName">
					<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarAgendaLabel.fdDiscription">
					<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.remark"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarAgendaLabel.fdModelName">
					<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="kmCalendarAgendaLabel.fdIsAvailable">
					<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.enable"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCalendarAgendaLabel" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do" />?method=view&fdId=${kmCalendarAgendaLabel.fdId}">
				<td>
					<c:if test="${!kmCalendarAgendaLabel.isAgendaLabel}">
						<input type="checkbox" name="List_Selected" value="${kmCalendarAgendaLabel.fdId}">
					</c:if>
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmCalendarAgendaLabel.fdName}" />
				</td>
				<td>
					<c:out value="${kmCalendarAgendaLabel.fdDescription}" />
				</td>
				<td>
					<c:out value="${kmCalendarAgendaLabel.fdModelName}" />
				</td>
				<td>
					<sunbor:enumsShow
					value="${kmCalendarAgendaLabel.fdIsAvailable}"
					enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>