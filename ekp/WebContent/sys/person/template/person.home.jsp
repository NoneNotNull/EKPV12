<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.ISysPersonMyNavCategoryService,
		com.landray.kmss.util.SpringBeanUtil" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include file="/sys/person/template/person.base.template.jsp" pagewidth="${ param.pagewidth }">
	<template:replace name="title">
		<portal:title/>
	</template:replace>
	<c:if test="${empty param.iframe }">
	<template:replace name="nav">
	<%@ include file="/sys/person/portal/usertitle.jsp" %>
	
	<%@ include file="/sys/person/sys_person_mynav_category/sysPersonMyNavCategory_portlet.jsp" %>
	</template:replace>
	</c:if>
</template:include>
