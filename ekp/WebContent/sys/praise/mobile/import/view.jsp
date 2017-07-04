<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<li data-dojo-type="mui/tabbar/TabBarButton"
	data-dojo-props='icon1:"muiPraiseTabButton mui mui-praise",align:"${param.align}",
		modelId:"${param.fdModelId}",subject:"${param.fdSubject}",modelName:"${param.fdModelName }"' 
	data-dojo-mixins="<%=request.getContextPath()%>/sys/praise/mobile/import/js/_PraiseTabBarButtonMixin.js">
</li>
<style>
.muiNavBarButton.mblTabBar .muiPraiseTabButton.mui.mui-focus-on{
	color:red;
}
</style>