<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include 
		ref="link.edit" 
		actionPath="/sys/person/sys_person_sysnav_category/sysPersonSysNavCategory.do"
		formName="sysPersonSysNavCategoryForm"
		parentModuleName="${lfn:message('sys-portal:module.sys.portal') }"
		moduleName="${lfn:message('sys-person:home.portlet') }"
		modelName="${lfn:message('sys-person:nav.category.setting') }"
		linkType="home"
		mng="true"
		shortName="true">
		
		<template:replace name="title">
			<c:if test="${sysPersonSysNavCategoryForm.method_GET=='add'}">
				<kmss:message bundle="sys-person" key="nav.category.create" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
			<c:if test="${sysPersonSysNavCategoryForm.method_GET=='edit'}" >
				<c:out value="${sysPersonSysNavCategoryForm.fdName}" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
		</template:replace>
		
		<template:replace name="txttitle">
			<bean:message bundle="sys-person" key="nav.category.setting" />
		</template:replace>
		
		<template:replace name="mng_info">
			<c:import url="/sys/person/sys_person_link/include/mng_info.jsp" charEncoding="UTF-8" >
				<c:param name="formName" value="sysPersonSysNavCategoryForm" />
			</c:import>
		</template:replace>
</template:include>

