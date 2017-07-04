<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="defaultLayoutHelp" value="/sys/ui/help/panel/panel-layout-help.jsp" scope="request"/>
<template:include file="/sys/ui/help/assembly-help.jsp">
	<template:replace name="detail">
	使用样例代码：
	<textarea style="width: 100%;height: 300px;"><c:import url="panel-example.txt" charEncoding="UTF8"></c:import></textarea>		
	</template:replace>
</template:include>