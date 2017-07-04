<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="defaultLayoutHelp" value="/sys/ui/help/menu/layout-help.jsp" scope="request"/>
<template:include file="/sys/ui/help/assembly-help.jsp">
	<template:replace name="detail">
	
	<br>
	<br>
	使用样例代码：	
	<br>
	<br>
	<textarea style="width: 100%;height: 300px;">
<c:import url="example.txt" charEncoding="UTF8"></c:import>
	</textarea>		
	</template:replace>
</template:include>