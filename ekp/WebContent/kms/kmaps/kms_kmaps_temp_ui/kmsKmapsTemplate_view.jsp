<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmaps/kms_kmaps_ui/style/view.css" />
		<script src="${LUI_ContextPath}/kms/common/resource/js/kms_utils.js"></script>
		<%@ include file="/kms/kmaps/kms_kmaps_temp_ui/kmsKmapsTemplate_view_js.jsp"%>
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmsKmapsTemplateForm.fdName } - ${ lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			
			<!-- 编辑 -->
			<kmss:auth
				requestURL="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=edit&fdId=${kmsKmapsTemplateForm.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}" 
						onclick="Com_OpenWindow('kmsKmapsTemplate.do?method=edit&fdId=${kmsKmapsTemplateForm.fdId}','_self');" order="2">
				</ui:button>
			</kmss:auth> 
			<!-- 分类转移-->   
			<kmss:auth 
				 requestURL="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=templateChange&fdId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }" onclick="changeCate();"/>
			 </kmss:auth>
			<!-- 删除 -->
			<kmss:auth
				requestURL="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=delete&fdId=${kmsKmapsTemplateForm.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" 
						onclick="confirmDelete();">
				</ui:button>
			</kmss:auth> 
			
			<!-- 关闭 -->
			<ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow();" order="5">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<!-- 路径 -->
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }" 
					modulePath="/kms/kmaps/" 
					modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory" 
					autoFetch="false"
					href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_index.jsp"
					categoryId="${kmsKmapsTemplateForm.docCategoryId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<c:set
			var="kmsKmapsTemplateForm"
			value="${kmsKmapsTemplateForm}"
			scope="request" />
		
		<div class='lui_form_title_frame'>
			<!-- 模版标题 -->
				<div class='lui_form_subject' id='docSubject'>
					<bean:write	name="kmsKmapsTemplateForm" property="fdName" />
				</div>
		</div>
		<ui:tabpage expand="false">
			<div id="demo1"></div>
			
			<ui:content title="${lfn:message('kms-kmaps:kmsKmapsMain.baseInfo')}">
				<table class="tb_normal" width="100%">
					<tr>
						<%-- 描述 --%>
						<td class="td_normal_title" width=15%><bean:message
							bundle="kms-kmaps" key="kmsKmapsTemplate.fdDescription" /></td>
						<td width=85% colspan="3"><c:out value="${kmsKmapsTemplateForm.fdDescription}" />
						</td>
					</tr>
					<tr>
						<%--创建者、创建时间--%>
						<td class="td_normal_title" width="15%"><bean:message
							key="kmsKmapsMain.docCreatorId" bundle="kms-kmaps" /></td width="35%">
						<td> 
							<ui:person personId="${kmsKmapsTemplateForm.docCreatorId}" personName="${kmsKmapsTemplateForm.docCreatorName}">
							</ui:person></td>
						<td class="td_normal_title" width="15%"><bean:message
							key="kmsKmapsMain.docCreateTime" bundle="kms-kmaps" /></td>
						<td width="35%">${kmsKmapsTemplateForm.docCreateTime}</td>
					</tr>
					<tr>
						<%--最后编辑者、最后编辑时间--%> 
						<td class="td_normal_title" width=15%><bean:message
							bundle="kms-kmaps" key="kmsKmapsMain.docAlterorId" /></td>
						<td width=35%>
							<ui:person personId="${kmsKmapsTemplateForm.docAlterorId}" personName="${kmsKmapsTemplateForm.docAlterorName}">
							</ui:person>
						</td>
						<td class="td_normal_title" width=15%><bean:message
							bundle="kms-kmaps" key="kmsKmapsMain.docAlterTime" /></td>
						<td width=35%><c:out value="${kmsKmapsTemplateForm.docAlterTime}" />
						</td>
					</tr>
				</table>
			</ui:content>
			
			<!-- 权限 -->
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsTemplateForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplate" />
			</c:import>
			
		</ui:tabpage>
	</template:replace>
</template:include>
