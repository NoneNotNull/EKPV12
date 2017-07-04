<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/header/Header" data-dojo-props="height:'3.8rem'">
	<div data-dojo-type="mui/header/HeaderItem" 
		data-dojo-mixins="mui/folder/_Folder,mui/back/HrefBackMixin"
		data-dojo-props="href:'/sys/news/mobile/index.jsp'">
	</div>
	<div data-dojo-type="mui/header/HeaderItem" 
		data-dojo-props="label:'${param.moduleName}',referListId:'_filterDataList'">
	</div>
	<div 
		data-dojo-type="mui/header/HeaderItem" 
		data-dojo-mixins="mui/folder/_Folder,mui/simplecategory/SimpleCategoryDialogMixin" 
		data-dojo-props="icon:'mui mui-ul',
			modelName:'com.landray.kmss.sys.news.model.SysNewsTemplate',
			redirectURL:'/sys/news/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/sys/news/sys_news_main/sysNewsMainIndex.do?method=listChildren&categoryId=!{curIds}&q.docStatus=30&orderby=fdIsTop%3BfdTopTime%3BdocAlterTime&ordertype=down'">
	</div> 
</div>
<div id="scroll" data-dojo-type="mui/list/StoreScrollableView">
	<div
		data-dojo-type="mui/search/SearchBar" 
		data-dojo-props="modelName:'com.landray.kmss.sys.news.model.SysNewsMain',needPrompt:false,height:'3.8rem'">
	</div>
    <ul id="_filterDataList"
    	data-dojo-type="mui/list/JsonStoreList" 
    	data-dojo-mixins="mui/list/ComplexRItemListMixin"
    	data-dojo-props="url:'${param.queryStr}', lazy:false">
	</ul>
</div>
