<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/query/QueryList" data-dojo-props="topHeight:!{topHeight}">
	<div data-dojo-type="mui/query/QueryListItem" 
		data-dojo-mixins="mui/simplecategory/SimpleCategoryDialogMixin" 
		data-dojo-props="label:'${lfn:message("portlet.cate") }',icon:'mui mui-Csort',
			modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
			redirectURL:'/kms/ask/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&categoryId=!{curIds}'">
	</div>
	
	<div data-dojo-type="mui/query/QueryListItem"
		data-dojo-mixins="mui/search/SearchBarDialogMixin" 
		data-dojo-props="label:'${lfn:message("button.search") }',icon:'mui mui-Csearch', modelName:'com.landray.kmss.kms.ask.model.KmsAskTopic'">
	</div>
	<div data-dojo-type="mui/query/QueryListItem"
		data-dojo-mixins="mui/query/CommonQueryDialogMixin" 
		data-dojo-props="label:'${lfn:message("list.search") }',icon:'mui mui-query',
			redirectURL:'/kms/ask/mobile/index.jsp?moduleName=!{text}&filter=1',
			store:[{'text':'${ lfn:message('kms-ask:kmsAskTopic.fdMyAsk') }','dataURL':'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&q.myknow=myask'},
			{'text':'${ lfn:message('kms-ask:kmsAskTopic.fdMyAnswer') }','dataURL':'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&q.myknow=myanswer'},
			{'text':'${ lfn:message('kms-ask:kmsAskTopic.fdAllKnow') }','dataURL':'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index'},
			{'text':'${ lfn:message('kms-ask:kmsAskTopic.fdIntroKnow') }','dataURL':'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&q.intro=introduce'}
			]">
	</div>
</div>
