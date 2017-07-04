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
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/mobile/resource/css/list.css" />
		<mui:min-file name="mui-imeeting.js"/>
	</template:replace>
	<template:replace name="content">
		
		<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
			<div
				data-dojo-type="mui/nav/MobileCfgNavBar" 
				data-dojo-props=" defaultUrl:'/km/imeeting/mobile/nav.jsp',modelName:'com.landray.kmss.km.imeeting.model.KmImeetingMain' ">
			</div>
			
			<div class="calendarButton mui mui-calendar" onclick="backToCalendar();"></div>
			
			<div
				data-dojo-type="mui/search/SearchButtonBar" 
				data-dojo-props="modelName:'com.landray.kmss.km.imeeting.model.KmImeetingMain' ">
			</div>
		</div>
		
		
		<div class="ImeetingScrollableView" 
			data-dojo-type="mui/list/NavSwapScrollableView">
		    <ul class="ImeetingList"
		    	data-dojo-type="mui/list/JsonStoreList" 
		    	data-dojo-mixins="km/imeeting/mobile/resource/js/list/MeetingCardItemListMixin">
			</ul>
		</div>
		
			
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
		  	<li data-dojo-type="mui/back/BackButton"></li>
		   	<li data-dojo-type="mui/tabbar/TabBarButton" data-dojo-props="icon1:'mui mui-create',
		   		href:'javascript:window.building();' "></li>
		    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
		    	<div data-dojo-type="mui/back/HomeButton"></div>
		    </li>
		</ul>
			
		
		
	</template:replace>
</template:include>
<script>
	require(['mui/util'],function(util){
		window.backToCalendar=function(){
			location.href=util.formatUrl('/km/imeeting/mobile/index.jsp');
		};
	});

</script>