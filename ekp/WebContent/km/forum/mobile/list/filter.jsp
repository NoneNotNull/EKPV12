<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="_dataUrl" value="${param.queryStr}"/>
<c:set var="_cateId" value=""/>
<c:if test="${fn:contains(_dataUrl,'&q.categoryId') }">
	<c:set var="_cateId" value="${fn:substringAfter(_dataUrl,'&q.categoryId=')}"/>
	<c:set var="_cateId" value="${fn:substringBefore(_cateId,'&')}"/>
</c:if>
<c:if test="${_cateId!='' }">
	<mui:min-file name="forum.css"/>
</c:if>
<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
	<div data-dojo-type="mui/header/HeaderItem" 
		data-dojo-mixins="mui/folder/_Folder,mui/back/HrefBackMixin"
		data-dojo-props="href:'/km/forum/mobile/index.jsp'">
	</div>
	<div data-dojo-type="mui/header/HeaderItem" data-dojo-props="label:'${param.moduleName }',referListId:'_filterDataList'">
	</div>
	<div 
		data-dojo-type="mui/header/HeaderItem" 
		data-dojo-mixins="mui/folder/_Folder,mui/simplecategory/SimpleCategoryDialogMixin" 
		data-dojo-props="icon:'mui mui-ul',
			modelName:'com.landray.kmss.km.forum.model.KmForumCategory',
			redirectURL:'/km/forum/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.categoryId=!{curIds}&orderby=fdLastPostTime&ordertype=down'">
	</div> 
</div>
<div id="scroll" data-dojo-type="mui/list/StoreScrollableView" class="gray">
	<div
		data-dojo-type="mui/search/SearchBar" 
		data-dojo-props="modelName:'com.landray.kmss.km.forum.model.KmForumTopic',needPrompt:false,height:'3.8rem'">
	</div>
	<c:if test="${_cateId!='' }">
		<div 
			data-dojo-type="km/forum/mobile/resource/js/ForumCategoryBox" 
			data-dojo-props="categoryId:'${_cateId}',categoryName:'${param.moduleName}',cateListDataUrl:'${_dataUrl}'">
		</div>
	</c:if>
    <ul id="_filterDataList" 
    	data-dojo-type="mui/list/JsonStoreList" 
    	data-dojo-mixins="km/forum/mobile/resource/js/ForumTopicItemListMixin"
    	data-dojo-props="url:'${_dataUrl}', lazy:false">
	</ul>
</div>
<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
  	<li data-dojo-type="mui/back/BackButton"></li>
 		<li data-dojo-type="km/forum/mobile/resource/js/ForumTopicCreate" 
  		data-dojo-props="cateId:'${_cateId}'"></li>
    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" 
    	data-dojo-props="icon1:'mui mui-more'">
    	<div data-dojo-type="mui/back/HomeButton"></div>
    </li>
</ul>