<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null or param.moduleName==''}">
			<bean:message bundle="km-imeeting" key="module.km.imeeting"/>
		</c:if>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/mobile/css/themes/default/calendar.css"></link>
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/mobile/resource/css/list.css" />
		<mui:min-file name="mui-imeeting.js"/>
	</template:replace>
	<template:replace name="content">
	
		<div class="muiCalendarContainer">
			<div id="calendar" 
				data-dojo-type="mui/calendar/CalendarView">
				<div data-dojo-type="mui/calendar/CalendarHeader"
					data-dojo-props="right:{href:'/km/imeeting/mobile/index_list.jsp?moduleName=${param.moduleName }'}"></div>
				<div data-dojo-type="mui/calendar/CalendarWeek"></div>
				<div data-dojo-type="mui/calendar/CalendarContent"></div>
				<div data-dojo-type="mui/calendar/CalendarBottom" data-dojo-props="url:''">
					<div class="ImeetingListView" data-dojo-type="mui/calendar/CalendarListScrollableView">
						<ul data-dojo-type="mui/calendar/CalendarJsonStoreList"
							data-dojo-mixins="km/imeeting/mobile/resource/js/list/CalendarItemListMixin"
							data-dojo-props="url:'/km/imeeting/km_imeeting_calendar/kmImeetingCalendar.do?method=mycalendar&fdStart=!{fdStart}&fdEnd=!{fdEnd}'">
						</ul>
					</div>
				</div>
			</div>
			
			<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
			  	<li data-dojo-type="mui/back/BackButton"></li>
			   	<li data-dojo-type="mui/tabbar/TabBarButton" data-dojo-props="icon1:'mui mui-create',
			   		href:'javascript:window.building();' "></li>
			    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
			    	<div data-dojo-type="mui/back/HomeButton"></div>
			    </li>
			</ul>
			
		</div>
		
	</template:replace>
</template:include>
