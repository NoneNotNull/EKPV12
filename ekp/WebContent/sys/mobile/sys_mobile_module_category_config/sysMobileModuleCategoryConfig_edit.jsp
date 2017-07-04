<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.edit">
	<template:replace name="title">
		模块配置
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar var-navwidth="90%" id="toolbar" layout="sys.ui.toolbar.float"> 
			<ui:button text="保存" order="2" onclick="Com_Submit(document.sysMobileModuleCategoryConfigForm, 'update');">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
		
<html:form action="/sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do" method="POST">
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
	<html:hidden property="fdModelName" value="${param.fdModelName }" />
	<script>
	Com_IncludeFile("dialog.js|doclist.js");
	</script>
	<script>
	DocList_Info.push("sys_mobile_module_category_config");
	</script>
	<table class="tb_normal" width="98%" style="margin-top: 50px;" id="sys_mobile_module_category_config">
		<tr class="tr_normal_title">
			<td width="35px;">序号</td>
			<td width="180px;">名称</td>
			<td>URL</td>
			<td width="100px;"><a href="#" onclick="DocList_AddRow();return false;">添加</a></td>
		</tr>
		<tr KMSS_IsReferRow="1" style="display:none">
			<td KMSS_IsRowIndex="1">!{index}</td>
			<td>
				<xform:text property="fdCateDetails[!{index}].fdName" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<xform:text property="fdCateDetails[!{index}].fdUrl" required="true" style="width:95%"></xform:text>
			</td>
			<td>
				<a href="#" onclick="DocList_DeleteRow();">删除</a>
				<a href="#" onclick="DocList_MoveRow(-1);">上移</a>
				<a href="#" onclick="DocList_MoveRow(1);">下移</a>
			</td>
		</tr>
		<c:forEach items="${sysMobileModuleCategoryConfigForm.fdCateDetails }" var="detail" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td>${vstatus.index+1}</td>
			<td>
				<xform:text property="fdCateDetails[${vstatus.index}].fdName" required="true" style="width:90%"></xform:text>
			</td>
			<td>
				<xform:text property="fdCateDetails[${vstatus.index}].fdUrl" required="true" style="width:95%"></xform:text>
			</td>
			<td>
				<a href="#" onclick="DocList_DeleteRow();">删除</a>
				<a href="#" onclick="DocList_MoveRow(-1);">上移</a>
				<a href="#" onclick="DocList_MoveRow(1);">下移</a>
			</td>
		</tr>
		</c:forEach>
	</table>
	<div style="text-align: center;margin: 5px auto 0 auto;">
	<img width="250" src="<c:url value='/sys/mobile/resource/images/module_cate_cfg.png'/>">
	</div>
</html:form>
	<script>
			$KMSSValidation(document.forms['sysMobileModuleCategoryConfigForm']);
	</script>
		
	</template:replace>
</template:include>
