<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null || param.moduleName==''}">
			<c:out value="${lfn:message('km-review:module.km.review')}"></c:out>
		</c:if>
	</template:replace>
	<template:replace name="content">
		<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
			<div
				data-dojo-type="mui/nav/MobileCfgNavBar" 
				data-dojo-props="defaultUrl:'/km/review/mobile/nav.jsp',modelName:'com.landray.kmss.km.review.model.KmReviewMain'">
			</div>
			<div
				data-dojo-type="mui/search/SearchButtonBar" 
				data-dojo-props="modelName:'com.landray.kmss.km.review.model.KmReviewMain'">
			</div>
		</div>
		
		<div data-dojo-type="mui/list/NavSwapScrollableView">
		    <ul 
		    	data-dojo-type="mui/list/JsonStoreList" 
		    	data-dojo-mixins="mui/list/ProcessItemListMixin">
			</ul>
		</div>
		
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
		  	<li data-dojo-type="mui/back/BackButton"></li>
		  	<kmss:authShow roles="ROLE_KMREVIEW_CREATE">
		  		<li data-dojo-type="mui/tabbar/CreateButton" 
			  		data-dojo-mixins="mui/syscategory/SysCategoryMixin"
			  		data-dojo-props="createUrl:'/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{curIds}',
			  		modelName:'com.landray.kmss.km.review.model.KmReviewTemplate'"></li>
		  	</kmss:authShow>
		    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
		    	<div data-dojo-type="mui/back/HomeButton"></div>
		    </li>
		</ul>
	</template:replace>
</template:include>
