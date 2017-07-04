<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
	<div
		data-dojo-type="mui/nav/MobileCfgNavBar" 
		data-dojo-props="defaultUrl:'/km/forum/mobile/list/nav.jsp', modelName:'com.landray.kmss.km.forum.model.KmForumTopic'">
	</div>
	<div data-dojo-type="mui/header/HeaderItem" 
		data-dojo-mixins="mui/folder/Folder" 
		data-dojo-props="tmplURL:'/km/forum/mobile/list/query.jsp'">
	</div> 
</div>
<div id="scroll" data-dojo-type="mui/list/NavSwapScrollableView" class="gray">
    <ul 
    	data-dojo-type="mui/list/JsonStoreList" 
    	data-dojo-mixins="km/forum/mobile/resource/js/ForumTopicItemListMixin">
	</ul>
</div>
<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
  	<li data-dojo-type="mui/back/BackButton"></li>
 	<li data-dojo-type="km/forum/mobile/resource/js/ForumTopicCreate"></li>
    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
    	<div data-dojo-type="mui/back/HomeButton"></div>
    </li>
</ul>
