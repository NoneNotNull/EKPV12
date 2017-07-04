<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<%--样式--%>
	<template:replace name="head">
		<template:super/>
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_main.css" />
	</template:replace>
	<%--日历主体--%>
	<template:replace name="body">
		<script type="text/javascript">	
			seajs.use(['km/calendar/resource/js/calendar_group'], function(calendar) {
				//群组类
				window.groupCalendar=calendar.GroupCalendarMode;
			});
		</script>
		<ui:calendar id="calendar" showStatus="view" mode="groupCalendar" layout="km.calendar.simple" customMode="{'id':'groupCalendar','name':'群组日历','func':groupCalendar}">
			<ui:source type="AjaxJson">
				{url:'/km/calendar/km_calendar_main/kmCalendarMain.do?method=listGroupCalendar&groupId=${param.groupId}&userId=${param.userId}'}
			</ui:source>
		</ui:calendar>
	</template:replace>
</template:include>