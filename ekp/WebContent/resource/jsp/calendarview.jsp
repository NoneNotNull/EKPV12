<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%
	String fdkey = (String)request.getAttribute("fdKey");
	if(fdkey==null) {
		fdkey = "calendarView";
		request.setAttribute("fdKey",fdkey);
	}	
%>
<script type="text/javascript">
<!--
	Com_IncludeFile("calendarview.js|data.js|calendar.js");
	Com_IncludeFile("calendarview.css","style/"+Com_Parameter.Style+"/calendar/");
//-->
</script>
<div id="${param.fdkey}_Top" name="${param.fdkey}_Top">
	<table id="calendar_head" border="0" cellpadding="0" cellspacing="0" width="100%">	
	 	<tr>
	 		<td id="${param.fdkey}_byDay" nowrap  class="calviewbtn" onClick="CalendarView_Info['${param.fdkey}'].goto(null,CALENDARVIEW_TYPE_DAY)" align=center ><bean:message key="calendar.byDay"/></td>
	 		<td id="${param.fdkey}_byWeek" nowrap class="calviewbtn" onClick="CalendarView_Info['${param.fdkey}'].goto(null,CALENDARVIEW_TYPE_WEEK_TWO)" align=center ><bean:message key="calendar.byWeek"/></td>
	 		<td id="${param.fdkey}_byMonth" nowrap class="calviewbtn" onClick="CalendarView_Info['${param.fdkey}'].goto(null,CALENDARVIEW_TYPE_MONTH)" align=center ><bean:message key="calendar.byMonth"/></td>	 		
			<td align="right">&nbsp;</td>
		</tr>
	</table>
	<table class="calviewmenubar">
		<tr>
			<td nowrap>
				<a id="Top_Head" href="#" onclick="CalendarView_Info['${param.fdkey}'].head();return false;"><bean:message key="page.first"/></a>&nbsp;&nbsp;
				<a id="Top_Head" href="#" onclick="CalendarView_Info['${param.fdkey}'].prev();return false;"><bean:message key="page.prev"/></a>&nbsp;&nbsp;
				<a id="Top_Head" href="#" onclick="CalendarView_Info['${param.fdkey}'].next();return false;"><bean:message key="page.next"/></a>&nbsp;&nbsp;
				<a id="Top_Head" href="#" onclick="CalendarView_Info['${param.fdkey}'].last();return false;"><bean:message key="page.last"/></a>&nbsp;&nbsp;
				<a id="Top_Head" href="#" onclick="CalendarView_Info['${param.fdkey}'].refresh();return false;"><bean:message key="button.refresh"/></a>&nbsp;&nbsp;
				<a id="Top_Change_${param.fdkey}" href="" onclick="CalendarView_Info['${param.fdkey}'].changeWeek();return false;"><bean:message key="calendar.switch"/></a>&nbsp;&nbsp;
				<a id="Top_Jump_${param.fdkey}" href="#" onclick="CalendarView_Info['${param.fdkey}'].selectDate();return false;"><bean:message key="page.changeTo"/></a>&nbsp;&nbsp;
			</td>
			<td nowrap align="right">
				<a id="Top_Choice_${param.fdkey}" href="" onclick="CalendarView_Info['${param.fdkey}'].showChioceMenu();return false;"><bean:message key="calendar.choice"/></a>&nbsp;&nbsp;
				&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<table border="0" cellpadding="0" cellspacing="0" align="center">
					<td><a href="#" onclick="CalendarView_Info['${param.fdkey}'].prev();return false;"><img src="${KMSS_Parameter_StylePath}calendar/prev.gif" border="0"></a></td>
					<td align=center id="${param.fdkey}_Title" class="calviewmenuTitle"></td>
					<td><a href="#" onclick="CalendarView_Info['${param.fdkey}'].next();return false;"><img src="${KMSS_Parameter_StylePath}calendar/next.gif" border="0"></a></td>
				</table>
			</td>
		</tr>
	</table>
</div>
	<div id="${param.fdkey}_Body" name="${param.fdkey}_Body">

	</div>
<script>
	if(CalendarMsg_Info.length==0) {
		CalendarMsg_Info["weeks"] = [<bean:message key="date.weekDayNames"/>]
		CalendarMsg_Info["months"] = [<bean:message key="calendar.shortMonthNames"/>]
		CalendarMsg_Info["dayname"] = "<kmss:message key="calendar.day.name"/>"
		CalendarMsg_Info["year"] = "<bean:message key="resource.period.type.year.name"/>"
		CalendarMsg_Info["begindate"] = "<bean:message key="calendar.begindate"/>"
		CalendarMsg_Info["enddate"] = "<bean:message key="calendar.enddate"/>"
		CalendarMsg_Info["subject"] = "<bean:message key="calendar.subject"/>"
		CalendarMsg_Info["applyDept"] = "<bean:message key="calendar.applyDept"/>"
		CalendarMsg_Info["prevWeek"] = "<kmss:message key="calendar.prevWeek"/>"
		CalendarMsg_Info["nextWeek"] = "<kmss:message key="calendar.nextWeek"/>"
		CalendarMsg_Info["thisWeek"] = "<kmss:message key="calendar.thisWeek"/>"
		CalendarMsg_Info["prevDay"] = "<kmss:message key="calendar.prevDay"/>"
		CalendarMsg_Info["nextDay"] = "<kmss:message key="calendar.nextDay"/>"
		CalendarMsg_Info["thisDay"] = "<kmss:message key="calendar.thisDay"/>"
	}
	var ${param.fdkey} = new CalendarView("${param.fdkey}","${param.fdkey}_Body");
	<c:if test="${not empty param.beanName}">
		${param.fdkey}.beanName = "${param.beanName}";
	</c:if>
	<c:if test="${not empty param.beanURL}">
		${param.fdkey}.beanURL = "${param.beanURL}";
	</c:if>	
	<c:if test="${not empty param.listType}">
		${param.fdkey}.listType = "${param.listType}";
	</c:if>	
	<c:if test="${not empty param.clickURL}">
		${param.fdkey}.clickURL = "${param.clickURL}";
	</c:if>
	<c:if test="${not empty param.startDate}">
		${param.fdkey}.startDate = "${param.startDate}";
	</c:if>
	<c:if test="${not empty param.onListTypeChange}">
		${param.fdkey}.onListTypeChange = ${param.onListTypeChange};
	</c:if>
</script>