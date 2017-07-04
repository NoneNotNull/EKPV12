<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>

<template:include ref="mobile.list">
	<template:replace name="title">
		列表样例
	</template:replace>
	<template:replace name="content">
		<div id="navBar"
			data-dojo-type="mui/nav/NavBarStore" 
			data-dojo-props="
				url:'/sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do?method=data&amp;fdModelName=com.landray.kmss.km.review.model.KmReviewMain'">
		</div>
		
		<div id="scroll" 
				data-dojo-type="mui/list/NavSwapScrollableView">
			<ul 
		    	data-dojo-type="mui/list/JsonStoreList" 
		    	data-dojo-mixins="mui/list/TextItemListMixin"></ul>
		    <%-- ul data-dojo-type="dojox/mobile/EdgeToEdgeList">
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
				<li data-dojo-type="dojox/mobile/ListItem">新闻1</li>
			</ul --%>
		</div>
		
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
		  <li data-dojo-type="mui/back/BackButton"></li>
		</ul>
	</template:replace>
</template:include>
