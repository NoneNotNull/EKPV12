<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/header/Header"
	data-dojo-props="height:'3.8rem'">
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/back/HrefBackMixin"
		data-dojo-props="href:'/kms/ask/mobile/index.jsp'"></div>
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-props="label:'${param.moduleName}',referListId:'_filterDataList'">
	</div>
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/simplecategory/SimpleCategoryDialogMixin"
		data-dojo-props="icon:'mui mui-ul',
			modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
			redirectURL:'/kms/ask/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&categoryId=!{curIds}'">
	</div>
</div>
<div id="scroll" data-dojo-type="mui/list/StoreScrollableView">
	<div data-dojo-type="mui/search/SearchBar"
		data-dojo-props="placeHolder:'我要搜索',modelName:'com.landray.kmss.kms.ask.model.KmsAskTopic',needPrompt:false,height:'3.8rem'">
	</div>
	<ul id="_filterDataList" data-dojo-type="mui/list/JsonStoreList"
		data-dojo-mixins="kms/ask/mobile/js/list/AskItemListMixin"
		data-dojo-props="url:'${param.queryStr}', lazy:false">
	</ul>
</div>
