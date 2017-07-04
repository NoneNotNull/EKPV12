<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace  name="title">
		<bean:message  bundle="sys-ftsearch-db" key="search.ftsearch.mobile"/>
	</template:replace>
	<template:replace name="content">
		<script type="text/javascript">
			require(["dojo/topic","dojo/dom","dojo/dom-style"], function(topic , dom ,domStyle){
				try {
					topic.subscribe("/mui/list/loaded",function(evt){
						var count = 0;
						if(evt)
							count = evt.totalSize;
						var titleDiv = dom.byId("_searchTitle");
						if(count>0){
							titleDiv.innerHTML = '<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.probably"/>' +
								'<span>' + count + '</span><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.itemResult"/>';
							domStyle.set(titleDiv,{display:'block'});
						}else{
							domStyle.set(titleDiv,{display:'none'});
						}
					});
				}catch (e) {
					if(window.console)
						console.error(e);
				}
			});
		</script>
		<div
			data-dojo-type="mui/search/SearchBar" 
			data-dojo-props="modelName:'${param.modelName}',keyword:'${param.keyword}',height:'3.8rem'">
		</div>
		<c:if test="${param.keyword!=''&&param.keyword!=null}">
			<div id="scroll" data-dojo-type="mui/list/StoreScrollableView">
					<div class="muiSearchTitle" id='_searchTitle'>
						搜索中
					</div>
				    <ul 
				    	data-dojo-type="mui/list/JsonStoreList" 
				    	data-dojo-mixins="mui/list/TextItemListMixin"
						data-dojo-props="lazy:false,url:encodeURI('/sys/ftsearch/searchBuilder.do?method=search&queryString=${param.keyword}&modelName=${param.modelName}&newLUI=true&forward=mobileList')">
					</ul>
			</div>
		</c:if>
		<c:if test="${param.keyword==null || param.keyword =='' }">
			<div id="scroll" data-dojo-type="mui/view/DocScrollableView">
			</div>
		</c:if>
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
		  <li data-dojo-type="mui/back/BackButton"></li>
		   <li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:'mui mui-more'">
		    	<div data-dojo-type="mui/back/HomeButton"></div>
		    </li>
		</ul>
	</template:replace>
</template:include>
