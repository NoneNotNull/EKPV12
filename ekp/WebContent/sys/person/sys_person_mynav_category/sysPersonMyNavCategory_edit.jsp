<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include
		ref="link.edit" 
		actionPath="/sys/person/sys_person_mynav_category/sysPersonMyNavCategory.do"
		formName="sysPersonMyNavCategoryForm"
		moduleName="${lfn:message('sys-person:person.setting') }"
		modelName="${lfn:message('sys-person:nav.category.setting') }"
		readOnly="${sysPersonMyNavCategoryForm.sysNavCategoryForm != null }"
		linkDialog="/sys/person/sys_person_mynav_category/sysPersonMyNavCategory.do?method=dialog"
		linkType="home"
		shortName="${sysPersonMyNavCategoryForm.sysNavCategoryForm != null }">
		
		<template:replace name="title">
			<c:if test="${sysPersonMyNavCategoryForm.method_GET=='add'}">
				<kmss:message bundle="sys-person" key="nav.category.create" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
			<c:if test="${sysPersonMyNavCategoryForm.method_GET=='edit'}" >
				<c:out value="${sysPersonMyNavCategoryForm.fdName}" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
		</template:replace>
		
		<template:replace name="txttitle">
			<bean:message bundle="sys-person" key="nav.category.setting" />
		</template:replace>
		
		<template:replace name="links">
			<c:if test="${sysPersonMyNavCategoryForm.sysNavCategoryForm != null }">
				<c:set var="linkForm" value="${sysPersonMyNavCategoryForm.sysNavCategoryForm}" scope="request" />
				<c:import url="/sys/person/sys_person_link/include/links.jsp" charEncoding="utf-8">
					<c:param name="formName" value="linkForm" />
					<c:param name="readOnly" value="true" />
					<c:param name="linkType" value="home" />
				</c:import>
			</c:if>
			<c:if test="${sysPersonMyNavCategoryForm.sysNavCategoryForm == null }">
				<template:super />
			</c:if>
		</template:replace>
		
		<template:replace name="base_attr">
			<c:if test="${sysPersonMyNavCategoryForm.sysNavCategoryForm != null }">
				<c:set var="base_attr" value="${sysPersonMyNavCategoryForm.sysNavCategoryForm}" scope="request" />
			</c:if>
			<template:super />
		</template:replace>
		
</template:include>

