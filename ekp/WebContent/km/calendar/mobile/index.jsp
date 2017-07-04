<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null or param.moduleName==''}">
			<bean:message bundle="km-calendar" key="module.km.calendar"/>
		</c:if>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/mobile/css/themes/default/calendar.css"></link>
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/mobile/resource/css/list.css" />
		<mui:min-file name="mui-calendar.js"/>
	</template:replace>
	<template:replace name="content">
	
		<div class="muiCalendarContainer">
			<div id="calendar" class="muiCalendarListView"
				data-dojo-type="mui/calendar/CalendarView">
				<div data-dojo-type="mui/calendar/CalendarHeader"
					data-dojo-props="left:{href:'/km/calendar/mobile/group.jsp?moduleName=${param.moduleName }'}"></div>
				<div data-dojo-type="mui/calendar/CalendarWeek"></div>
				<div data-dojo-type="mui/calendar/CalendarContent"></div>
				<div data-dojo-type="mui/calendar/CalendarBottom" data-dojo-props="url:''">
					<div class="CalendarListView" data-dojo-type="mui/calendar/CalendarListScrollableView">
						<ul data-dojo-type="mui/calendar/CalendarJsonStoreList"
							data-dojo-mixins="km/calendar/mobile/resource/js/list/CalendarItemListMixin"
							data-dojo-props="url:'/km/calendar/km_calendar_main/kmCalendarMain.do?method=data&fdStart=!{fdStart}&fdEnd=!{fdEnd}'">
						</ul>
					</div>
				</div>
			</div>
			
			<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
			  	<li data-dojo-type="mui/back/BackButton"
			  		data-dojo-props="doBack:window.doback"></li>
			   	<li data-dojo-type="mui/tabbar/TabBarButton" data-dojo-props="icon1:'mui mui-create',
			   		href:'javascript:window.create();' "></li>
			    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
			    	<div data-dojo-type="mui/back/HomeButton"></div>
			    </li>
			</ul>
			
		</div>
		
	</template:replace>
</template:include>
<script>
	require(['dojo/topic','mui/calendar/CalendarUtil'],function(topic,cutil){
		var currentDate=new Date();
		topic.subscribe('/mui/calendar/valueChange',function(widget,args){
			currentDate=args.currentDate;
		});
		//新建日程
		window.create=function(){
			var url='${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=addEvent&moduleName=${param.moduleName}',
				currentStr=cutil.formatDate(currentDate);
			if( currentStr ){
				url+='&startTime='+currentStr+'&endTime='+currentStr;
			}
			window.open(url,'_self');
		};
		//覆盖默认的后退(防止删除页面后列表页面后退到不存在的页面)
		window.doback=function(){
			location.href='${LUI_ContextPath}/';
		};
		
	});

</script>