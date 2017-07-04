<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<template:replace name="title">
			${ lfn:message('sys-material:module.sys.material') }
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<ui:button text="${ lfn:message('button.update') }" onclick="Com_Submit(document.sysMaterialMainForm, 'upload');"></ui:button>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>	
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
		<html:form action="/sys/material/sys_material_main/sysMaterialMain.do">
			<div class="lui_form_content_frame" style="padding-top:20px">
				<table class="tb_normal" width=100%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-material" key="sysMaterialMain.fdModelName"/>
						</td>
						<td width="35%">
							<html:hidden property="fdModelName" />
							<input name="fdModelTitle" class="inputsgl" value="" subject="${lfn:message('sys-material:sysMaterialMain.fdModelName')}" type="text" readOnly style="width:85%;ime-mode:disabled" validate="required"/>
							<a href="#" onclick="Dialog_List(false, 'fdModelName', 'fdModelTitle', null, 'sysMaterialModelListService')">
								选择
							</a>
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-material" key="sysMaterialMain.fdType"/>
						</td>
						<td width="35%">
								<xform:radio property="fdType" showStatus="edit">
									<xform:enumsDataSource enumsType="sysMaterialMain_fdType" />
								</xform:radio>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							附件
						</td>
						<td width="" colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="formBeanName" value="sysMaterialMainForm" />
								<c:param name="fdKey" value="attachment" />
								<c:param name="fdAttType" value="pic"></c:param>
							</c:import>
						</td>
					</tr>
				</table>
			</div>
		<html:hidden property="fdId" />
		<html:hidden property="method_GET" />
		</html:form>
		<script>
			Com_IncludeFile("dialog.js");
			$KMSSValidation();
		</script>
	</template:replace>
</template:include>