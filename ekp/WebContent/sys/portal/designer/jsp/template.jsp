<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.portal.util.TemplateUtil"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	String template = SysUiPluginUtil.getTemplateById(request.getParameter("ref").toString()).getFdDesigner();
	pageContext.setAttribute("template",template);
	pageContext.setAttribute("blockNames",TemplateUtil.analysisTemplate(template));
%>
<template:include file="${ template }" designertime="yes">
	<c:forEach items="${blockNames}" var="name">
		<template:replace name="${ name }">
			<div data-lui-mark='template:block' key='${ name }'></div>
		</template:replace>
	</c:forEach>
</template:include>