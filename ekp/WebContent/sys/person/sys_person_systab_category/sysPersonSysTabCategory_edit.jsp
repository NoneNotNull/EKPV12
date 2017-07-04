<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:set var="msg_key" value="sys-person:tab.category.${sysPersonSysTabCategoryForm.fdType}.setting" />
<template:include
		ref="link.edit" 
		actionPath="/sys/person/sys_person_systab_category/sysPersonSysTabCategory.do"
		formName="sysPersonSysTabCategoryForm"
		parentModuleName="${lfn:message('sys-portal:module.sys.portal') }"
		moduleName="${lfn:message('sys-person:home.portlet') }"
		modelName="${lfn:message(msg_key) }"
		linkType="${sysPersonSysTabCategoryForm.fdType }"
		mng="true"
		shortName="true">
		
		<template:replace name="title">
			<c:if test="${sysPersonSysTabCategoryForm.method_GET=='add'}">
				<kmss:message bundle="sys-person" key="tab.category.${sysPersonSysTabCategoryForm.fdType}.create" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
			<c:if test="${sysPersonSysTabCategoryForm.method_GET=='edit'}" >
				<c:out value="${sysPersonSysTabCategoryForm.fdName}" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
		</template:replace>
		
		<template:replace name="txttitle">
			<bean:message bundle="sys-person" key="tab.category.${sysPersonSysTabCategoryForm.fdType}.setting" />
		</template:replace>
		
		<template:replace name="mng_info">
			<c:import url="/sys/person/sys_person_link/include/mng_info.jsp" charEncoding="UTF-8" >
				<c:param name="formName" value="sysPersonSysTabCategoryForm" />
			</c:import>
		</template:replace>
		
</template:include>

