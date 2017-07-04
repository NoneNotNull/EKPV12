<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
	<div data-dojo-type="mui/simplecategory/SimpleCategoryHeader"
		data-dojo-props="key:'{categroy.key}',height:'3.8rem',modelName:'{categroy.modelName}'"></div>
	<div data-dojo-type="dojox/mobile/ScrollableView"
		data-dojo-mixins="mui/category/_ViewScrollResizeMixin"
		data-dojo-props="scrollBar:false,threshold:100,key:'{categroy.key}'">
		<ul data-dojo-type="km/forum/mobile/resource/js/ForumCategoryList"
			data-dojo-mixins="km/forum/mobile/resource/js/ForumCategoryItemListMixin"
			data-dojo-props="isMul:{categroy.isMul},key:'{categroy.key}',curIds:'{categroy.curIds}',curNames:'{categroy.curNames}',
				selType:{categroy.type},modelName:'{categroy.modelName}',authType:'{categroy.authType}'">
		</ul>
	</div>
