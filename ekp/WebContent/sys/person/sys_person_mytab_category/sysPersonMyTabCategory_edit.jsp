<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:set var="modelNamePath" scope="page">
<bean:message bundle="sys-person" key="tab.category.${sysPersonMyTabCategoryForm.fdType}.setting" />
</c:set>
<c:set var="tabLinkType" value="${sysPersonMyTabCategoryForm.fdType == 'hotlink' ? '1' : (sysPersonMyTabCategoryForm.fdType == 'shortcut' ? '2' : '') }" scope="page" />
<template:include
		ref="link.edit" 
		actionPath="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do"
		formName="sysPersonMyTabCategoryForm"
		moduleName="${lfn:message('sys-person:person.setting') }"
		modelName="${modelNamePath }"
		readOnly="${sysPersonMyTabCategoryForm.sysNavCategoryForm != null }"
		linkDialog="/sys/person/sys_person_mytab_category/sysPersonMyTabCategory.do?method=dialog&type=${tabLinkType }"
		linkType="${sysPersonMyTabCategoryForm.fdType }"
		shortName="${sysPersonMyTabCategoryForm.sysNavCategoryForm != null }">
		
		<template:replace name="title">
			<c:if test="${sysPersonMyTabCategoryForm.method_GET=='add'}">
				<kmss:message bundle="sys-person" key="tab.category.${sysPersonMyTabCategoryForm.fdType}.create" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
			<c:if test="${sysPersonMyTabCategoryForm.method_GET=='edit'}" >
				<c:out value="${sysPersonMyTabCategoryForm.fdName}" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
		</template:replace>
		
		<template:replace name="txttitle">
			<bean:message bundle="sys-person" key="tab.category.${sysPersonMyTabCategoryForm.fdType}.setting" />
		</template:replace>
		
		<template:replace name="links">
			<c:if test="${sysPersonMyTabCategoryForm.sysNavCategoryForm != null }">
				<c:if test="${sysPersonMyTabCategoryForm.sysNavCategoryForm.fdType eq 'page' }">
					<tr>
						<td class="td_normal_title">
							<kmss:message key="sys-person:sysPersonSysTabPage.content.from" />
						</td>
						<td colspan="3">
							<c:out value="${sysPersonMyTabCategoryForm.sysNavCategoryForm.fdPages[0].fdName }" />
						</td>
					</tr>
				</c:if>
				<c:if test="${sysPersonMyTabCategoryForm.sysNavCategoryForm.fdType != 'page' }">
				<c:set var="linkForm" value="${sysPersonMyTabCategoryForm.sysNavCategoryForm}" scope="request" />
				<c:import url="/sys/person/sys_person_link/include/links.jsp" charEncoding="utf-8">
					<c:param name="formName" value="linkForm" />
					<c:param name="readOnly" value="true" />
					<c:param name="linkType" value="${sysPersonMyTabCategoryForm.sysNavCategoryForm.fdType}" />
				</c:import>
				</c:if>
			</c:if>
			<c:if test="${sysPersonMyTabCategoryForm.sysNavCategoryForm == null }">
				<template:super />
				<c:if test="${sysPersonMyTabCategoryForm.fdType == 'hotlink' }">
					<tr>
						<td class="td_normal_title"><kmss:message key="sys-person:sysPersonSysTabCategory.fdCols" /></td>
						<td colspan="3">
							<xform:text property="fdCols" style="width:100px;" validators="number range(1,9999)" required="true" 
								subject="${lfn:message('sys-person:sysPersonSysTabCategory.fdCols') }" />
						</td>
					</tr>
				</c:if>
			</c:if>
		</template:replace>
		
		
		<template:replace name="base_attr">
			<c:if test="${sysPersonMyTabCategoryForm.sysNavCategoryForm != null }">
				<c:set var="base_attr" value="${sysPersonMyTabCategoryForm.sysNavCategoryForm}" scope="request" />
			</c:if>
			<template:super />
		</template:replace>
		
</template:include>
