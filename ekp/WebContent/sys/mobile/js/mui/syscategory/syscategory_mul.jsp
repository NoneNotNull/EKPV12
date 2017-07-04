<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@include file="/sys/mobile/js/mui/syscategory/syscategory_auth.jsp" %>
<div data-dojo-type="mui/syscategory/SysCategoryHeader"
	data-dojo-props="key:'{categroy.key}',height:'3.8rem',modelName:'{categroy.modelName}'"></div>
<div id='_syscategory_mul_view_{categroy.key}'
	data-dojo-type="dojox/mobile/ScrollableView"
	data-dojo-mixins="mui/category/_ViewScrollResizeMixin"
	data-dojo-props="scrollBar:false,threshold:100,key:'{categroy.key}'">
	<ul data-dojo-type="mui/syscategory/SysCategoryList"
		data-dojo-mixins="mui/syscategory/SysCategoryItemListMixin"
		data-dojo-props="authCateIds:'${_authIds}',isMul:{categroy.isMul},key:'{categroy.key}',curIds:'{categroy.curIds}',curNames:'{categroy.curNames}',
			selType:{categroy.type},modelName:'{categroy.modelName}',getTemplate:'{categroy.getTemplate}',showType:'{categroy.showType}',authType:'{categroy.authType}'">
	</ul>
</div>
<div data-dojo-type="mui/syscategory/SysCategorySelection" 
	data-dojo-props="key:'{categroy.key}',curIds:'{categroy.curIds}',curNames:'{categroy.curNames}',modelName:'{categroy.modelName}'" fixed="bottom">
</div>
