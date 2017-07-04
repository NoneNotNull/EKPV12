<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java"  import="com.landray.kmss.util.StringUtil" %>
<%--解析param.categoryId，当门户选择多个分类后，跳转过来的时候categoryId可能是多个的  --%>
<%
	String categoryIds = request.getParameter("categoryId");
	if(StringUtil.isNotNull(categoryIds)) {
		String [] ids = categoryIds.split("\\s*[;,]\\s*");
		if(ids.length != 1)
			categoryIds = "";
	}
	pageContext.setAttribute("categoryId" , categoryIds);
%>