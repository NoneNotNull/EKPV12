<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<!DOCTYPE HTML>
<html class="mobile">
	<head>
		<meta name="viewport" 
			content="width=device-width<c:if test="${param.scale == 'true'}">,target-densitydpi=device-dpi</c:if><c:if test="${param.scale != 'true'}">,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no</c:if>" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta names="apple-mobile-web-app-status-bar-style" content="black-translucent" />
		<meta content="telephone=no" name="format-detection"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title><template:block name="title" /></title>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/mobile/css/themes/default/ios7.css"></link>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/mobile/css/icon/font-mui.css"></link>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/mobile/css/themes/default/common.css"></link>
		<mui:min-file name="view.css"/>
	
		<%@ include file="./dojoConfig.jsp" %>
		<script type="text/javascript" src="<%=request.getContextPath()%>/sys/mobile/js/dojo/dojo.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/sys/mobile/js/dojox/mobile.js"></script>
		<mui:min-file name="mui.js"/>
		<c:if test="${param.compatibleMode eq 'true' or param.compatibleMode eq '1'}">
			<c:import url="/sys/mobile/template/com_head.jsp"></c:import>
		</c:if>
		<template:block name="head" />
	</head>
	<body>
		<div id="pageLoading">
			<span>
				<i class="mui mui-loading mui-spin"></i>
				<div>${lfn:message('sys-mobile:mui.list.pull.loading') }</div>
			</span>
		</div>
		
		<div id="content">
			<template:block name="content" />
		</div>
		
		<script type="text/javascript">
		require(["dojo/parser", "mui/main", "mui/pageLoading", "dojo/_base/window","dojox/mobile/sniff", "dojo/domReady!"], function(parser, main, pageLoading, win , has){
			try {
				parser.parse().then(function() {
					<%--
					//win.doc.dojoClick = false;影响 andriod的 on事件，导致部分on设置事件失效
					//win.doc.dojoClick = true; 导致 iphone中 file事件的onchange事件无法触发
					 --%>
					win.doc.dojoClick = !has('ios');
					pageLoading.hide();
				});
			} catch (e) {
				alert(e);
			}
		});
		</script>
		
		 <div data-dojo-type="mui/top/Top" 
		 	data-dojo-mixins="mui/top/_TopViewMixin" 
			data-dojo-props="bottom:'${param.sideTop}'"></div>
		
	</body>
</html>
