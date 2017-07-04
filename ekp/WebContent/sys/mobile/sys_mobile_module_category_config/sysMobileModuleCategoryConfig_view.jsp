<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.view">
	<template:replace name="title">
		审批流程配置
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar var-navwidth="90%" id="toolbar" layout="sys.ui.toolbar.float"> 
			<ui:button text="编辑" order="2" onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do?method=edit&fdModelName=${param.fdModelName }','_self');">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">

<html:form action="/sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do">
	<table class="tb_normal" width="95%" style="margin-top: 50px;">
		<tr class="tr_normal_title">
			<td width="35px;">序号</td>
			<td>名称</td>
			<td>URL</td>
		</tr>
		<c:if test="${empty sysMobileModuleCategoryConfigForm.fdCateDetails }">
		<tr>
			<td align="center" colspan="3">还未配置数据</td>
		</tr>
		</c:if>
		<c:if test="${not empty sysMobileModuleCategoryConfigForm.fdCateDetails}">
		<c:forEach items="${sysMobileModuleCategoryConfigForm.fdCateDetails }" var="detail" varStatus="vstatus">
		<tr>
			<td>${vstatus.index+1}</td>
			<td>${detail.fdName }</td>
			<td>${detail.fdUrl }</td>
		</tr>
		</c:forEach>
		</c:if>
	</table>
	<div style="text-align: center;margin: 5px auto 0 auto;">
	<img width="250" src="<c:url value='/sys/mobile/resource/images/module_cate_cfg.png'/>">
	</div>
</html:form>

	</template:replace>
</template:include>
