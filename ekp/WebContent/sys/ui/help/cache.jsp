<%@page import="com.landray.kmss.web.filter.ResourceCacheFilter"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
	ResourceCacheFilter.cache = String.valueOf(System.currentTimeMillis());
%>
缓存参数已更新
