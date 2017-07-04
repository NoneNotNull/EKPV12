<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/km/smissive/mobile/resource/css/smissive.css?v=1.0"></link>
	</template:replace>
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null || param.moduleName==''}">
			<c:out value="${lfn:message('km-smissive:module.km.smissive')}"></c:out>
		</c:if>
	</template:replace>
	<template:replace name="content">
		<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
			<div
				data-dojo-type="mui/nav/MobileCfgNavBar" 
				data-dojo-props="defaultUrl:'/km/smissive/mobile/nav.jsp',modelName:'com.landray.kmss.km.smissive.model.KmSmissiveMain'">
			</div>
			<div
				data-dojo-type="mui/search/SearchButtonBar" 
				data-dojo-props="modelName:'com.landray.kmss.km.smissive.model.KmSmissiveMain'">
			</div> 
		</div>
		
		<div data-dojo-type="mui/list/NavSwapScrollableView" class="gray">
		    <ul 
		    	data-dojo-type="mui/list/JsonStoreList" 
		    	data-dojo-mixins="mui/list/CardItemListMixin">
			</ul>
		</div>
		
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
		  	<li data-dojo-type="mui/back/BackButton"></li>
		  	<li data-dojo-type="mui/tabbar/TabBarButton" data-dojo-props="icon1:'mui mui-create',
		   		href:'javascript:building();' "></li>
		    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
		    	<div data-dojo-type="mui/back/HomeButton"></div>
		    </li>
		</ul>
	</template:replace>
</template:include>
