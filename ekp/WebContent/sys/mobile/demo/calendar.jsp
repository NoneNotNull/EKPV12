<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		日历样例
	</template:replace>
	<template:replace name="content">
		<link rel="stylesheet" type="text/css"
			href="<%=request.getContextPath()%>/sys/mobile/css/themes/default/calendar.css"></link>
		<div class="muiCalendarContainer">
		
			<div data-dojo-type="mui/calendar/CalendarView" id="calendar">
				<div data-dojo-type="mui/calendar/CalendarHeader"
					data-dojo-props="left:{moveTo:'group'},right:{moveTo:'all'}"></div>
				<div data-dojo-type="mui/calendar/CalendarWeek"></div>
				<div data-dojo-type="mui/calendar/CalendarContent"></div>
				<div data-dojo-type="mui/calendar/CalendarBottom"
					data-dojo-props="url:'http://www.baidu.com'">
					<div data-dojo-type="mui/calendar/CalendarListScrollableView">
						<ul data-dojo-type="mui/list/JsonStoreList"
							data-dojo-mixins="mui/list/ComplexRItemListMixin"
							data-dojo-props="url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=&orderby=docPublishTime&ordertype=down&rowsize=16&q.docStatus=30',lazy:false">
						</ul>
					</div>
				</div>
			</div>
			
			<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
				<li data-dojo-type="mui/back/BackButton"></li>
			</ul>

			<div data-dojo-type="mui/list/StoreScrollableView" id="all">
				<h1 data-dojo-type="dojox/mobile/Heading" back="返回"
					moveTo="calendar"></h1>
				<ul data-dojo-type="mui/list/JsonStoreList"
					data-dojo-mixins="mui/list/ComplexRItemListMixin"
					data-dojo-props="url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=&orderby=docPublishTime&ordertype=down&rowsize=16&q.docStatus=30',lazy:false">
				</ul>
			</div>

			<div data-dojo-type="mui/list/StoreScrollableView" id="group">
				<h1 data-dojo-type="dojox/mobile/Heading" back="返回"
					moveTo="calendar"></h1>
				<ul data-dojo-type="mui/list/JsonStoreList"
					data-dojo-mixins="mui/list/ComplexRItemListMixin"
					data-dojo-props="url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=&orderby=docPublishTime&ordertype=down&rowsize=16&q.docStatus=30',lazy:false">
				</ul>
			</div>
			
		</div>

		


	</template:replace>
</template:include>
