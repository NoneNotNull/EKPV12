<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/resource/jsp/common.jsp"%>

<template:include
		file="/sys/zone/sys_zone_navigation/sysZoneNavigation_template.jsp"
		actionPath="/sys/zone/sys_zone_navigation/sysZoneNavigation.do"
		formName="sysZoneNavigationForm"
		moduleName="${lfn:message('sys-zone:module.name') }"
		modelName="${lfn:message('sys-zone:navigation.setting') }"
		linkType="zone">
		
		<template:replace name="title">
			<c:if test="${sysZoneNavigationForm.method_GET=='add'}">
				<kmss:message bundle="sys-zone" key="navigation.create" />
				-
				<kmss:message bundle="sys-zone" key="module.name" />
			</c:if>
			<c:if test="${sysZoneNavigationForm.method_GET=='edit'}" >
				<c:out value="${sysZoneNavigationForm.fdName}" />
				-
				<kmss:message bundle="sys-zone" key="module.name" />
			</c:if>
		</template:replace>
		
		<template:replace name="txttitle">
			<bean:message bundle="sys-zone" key="navigation.setting" />
		</template:replace>
		
</template:include>

