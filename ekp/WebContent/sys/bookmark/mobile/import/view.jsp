<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<div data-dojo-type="mui/tabbar/TabBarButton"
	data-dojo-props='icon1:"muiBookmarkTabButton mui mui-star-off",label:"${param.label}",align:"${param.align}",modelId:"${param.fdModelId}",subject:"${param.fdSubject }",modelName:"${param.fdModelName }"' 
	data-dojo-mixins="<%=request.getContextPath()%>/sys/bookmark/mobile/import/js/_BookTabBarButtonMixin.js">
</div>