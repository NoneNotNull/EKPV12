<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null or param.moduleName==''}">
			<c:out value="${lfn:message('sys-task:module.sys.task') }"></c:out>
		</c:if>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/task/mobile/resource/css/list.css" />
	</template:replace>
	<template:replace name="content">
		
		<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
			<div
				data-dojo-type="mui/nav/MobileCfgNavBar" 
				data-dojo-props=" defaultUrl:'/sys/task/mobile/nav.jsp',modelName:'com.landray.kmss.sys.task.model.SysTaskMain' ">
			</div>
			
			<div class="calendarButton mui mui-calendar" onclick="backToCalendar();"></div>
			
			<div
				data-dojo-type="mui/search/SearchButtonBar" 
				data-dojo-props="modelName:'com.landray.kmss.sys.task.model.SysTaskMain' ">
			</div>
		</div>
		
		<div 
			data-dojo-type="mui/list/NavSwapScrollableView">
		    <ul data-dojo-type="mui/list/JsonStoreList" 
		    	data-dojo-mixins="sys/task/mobile/resource/js/list/CalendarItemListMixin">
			</ul>
		</div>
		
			
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
		  	<li data-dojo-type="mui/back/BackButton"></li>
		  	<kmss:authShow roles="ROLE_SYSTASK_CREATE">
			   	<li data-dojo-type="mui/tabbar/TabBarButton" data-dojo-props="icon1:'mui mui-create',
				   		href:'/sys/task/sys_task_main/sysTaskMain.do?method=add'"></li>
			 </kmss:authShow>
		    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
		    	<div data-dojo-type="mui/back/HomeButton"></div>
		    </li>
		</ul>
			
		
		
	</template:replace>
</template:include>
<script>
	require(['mui/util'],function(util){
		window.backToCalendar=function(){
			location.href=util.formatUrl('/sys/task/mobile/index.jsp?moduleName=${param.moduleName}');
		};
	});

</script>