<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.navlink">
	<template:replace name="content">
		<c:import 
			charEncoding="UTF-8"
			url="/sys/zone/sys_zone_personInfo/sysZonePersonInfo_personData_edit_import.jsp">
			<c:param name="userId" 
				value="${param.userId}"/>
			<c:param name="method" value="${param.method}"/>
		</c:import>
	</template:replace> 
</template:include>
	   
