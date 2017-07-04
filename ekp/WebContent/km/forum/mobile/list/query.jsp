<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/query/QueryList" data-dojo-props="topHeight:!{topHeight}">
	<div data-dojo-type="mui/query/QueryListItem" 
		data-dojo-mixins="mui/simplecategory/SimpleCategoryDialogMixin" 
		data-dojo-props="label:'${lfn:message("portlet.cate") }',icon:'mui mui-Csort',
			modelName:'com.landray.kmss.km.forum.model.KmForumCategory',
			redirectURL:'/km/forum/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.categoryId=!{curIds}&orderby=fdLastPostTime&ordertype=down'">
	</div>
	<div data-dojo-type="mui/query/QueryListItem"
		data-dojo-mixins="mui/search/SearchBarDialogMixin" 
		data-dojo-props="label:'${lfn:message("button.search") }',icon:'mui mui-Csearch', modelName:'com.landray.kmss.km.forum.model.KmForumTopic'">
	</div>
	<div data-dojo-type="mui/query/QueryListItem"
		data-dojo-mixins="mui/query/CommonQueryDialogMixin" 
		data-dojo-props="label:'${lfn:message("list.search") }',icon:'mui mui-query',
			redirectURL:'/km/forum/mobile/index.jsp?moduleName=!{text}&filter=1',
			store:[{'text':'${lfn:message("km-forum:menu.kmForum.my") }','dataURL':'/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.myTopic=create&orderby=fdLastPostTime&ordertype=down'},
			{'text':'${lfn:message("km-forum:menu.kmForum.Attend.my")}','dataURL':'/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.myTopic=attend&orderby=fdLastPostTime&ordertype=down'}
			]">
	</div>
</div>
