<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.edit">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3"> 
			<ui:button text="${ lfn:message('button.update') }" onclick="Com_Submit(document.kmsCommonSensitiveForm, 'update')"></ui:button>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>	
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
		<html:form action="/kms/common/kms_common_sensitive/kmsCommonSensitive.do">
			<br>
			<p class="txttitle">
				<bean:message bundle="kms-common" key="kmsCommonSensitive.setting"/>
			</p>
			<br>		
			<div class="lui_form_content_frame">
				<table class="tb_normal" width=100%>
					<tr>
						<td class="td_normal_title">
							<bean:message bundle="kms-common" key="kmsCommonSensitive.check"/>
						</td>
					</tr>				
					<tr>
						<td>
							<xform:radio property="isCheck">
								<xform:enumsDataSource enumsType="common_yesno"  />
							</xform:radio>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title">
							<bean:message bundle="kms-common" key="kmsCommonSensitive.setting.word"/>
						</td>
					</tr>
					<tr>
						<td>
							<xform:textarea property="fdSensitiveWord" style="width:99%;height:120px;"/>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title">
							<bean:message bundle="kms-common" key="kmsCommonSensitive.multi"/>
						</td>
					</tr>					
				</table>
			</div>
		</html:form>
		<script>
			$KMSSValidation(document.forms['kmsCommonSensitiveForm']);
		</script>
	</template:replace>
</template:include>