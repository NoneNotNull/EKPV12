<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!-- Kanvas绘图 -->
<div class="kms_kanvas">
	<div id="demo"></div>
</div>
<div style="display:none" id="kmapsTemplateContent">
<template:include ref="default.edit" sidebar="no" >
		<template:replace name="head">
			<%@ include file="/kms/kmaps/kms_kmaps_temp_ui/kmsKmapsTemplate_edit_js.jsp"%>
			<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmaps/kms_kmaps_temp_ui/style/edit.css" />
			<script type="text/javascript">
				Com_IncludeFile("validation.js|plugin.js|validation.jsp", null, "js");
			</script>
		</template:replace>
		<template:replace name="title">
			<c:choose>
				<c:when test="${ kmsKmapsTemplateForm.method_GET == 'add' }">
					<c:out value="${ lfn:message('kms-kmaps:kmsKmapsMain.createTemps') } - ${ lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }"></c:out>	
				</c:when>
				<c:otherwise>
					<c:out value="${kmsKmapsTemplateForm.fdName} - ${ lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }"></c:out>
				</c:otherwise>
			</c:choose>
		</template:replace>
	
		<template:replace name="toolbar" >
			<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
				<c:choose>
					<c:when test="${ kmsKmapsTemplateForm.method_GET == 'add' }">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmsKmapsTemplateForm, 'save');">
						</ui:button>
					</c:when>
					<c:when test="${ kmsKmapsTemplateForm.method_GET == 'edit' }">
						<ui:button text="${lfn:message('button.submit') }" order="4" onclick="Com_Submit(document.kmsKmapsTemplateForm, 'update');">
						</ui:button>
					</c:when>
				</c:choose>
				<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.draw') }" order="4" onclick="drawTemp();">
				</ui:button>
				<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();" order="5">
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
					categoryId="${kmsKmapsTemplateForm.docCategoryId}" />
			</ui:combin>
		</template:replace>	
		<template:replace name="content"> 	
				<table style="width:100%">
					<tr>
						<td valign="top">
							<div class="lui_form_content">
								<c:set
									var="kmsKmapsTemplateForm"
									value="${kmsKmapsTemplateForm}"
									scope="request" />
								<html:form action="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do" >
							 
								<ui:tabpage expand="false">
									<html:hidden property="method_GET"/>
									<html:hidden property="docContent"/>
									
									<ui:content title="${lfn:message('kms-kmaps:kmsKmapsMain.baseInfo')}" toggle="false">
										<table class="tb_simple" width=100%>
											<tr>
												<td width="15%" class="td_normal_title">
													<bean:message  bundle="kms-kmaps" key="kmsKmapsTemplate.fdName"/>
												</td>
												<td width="85%" colspan="3"> 
													<html:hidden property="fdId"/> 
													<xform:text subject="${lfn:message('kms-kmaps:kmsKmapsTemplate.fdName')}" isLoadDataDict="false" validators="maxLength(200)" 
															property="fdName" required="true" className="inputsgl" style="width:85%;"/>
												</td>
												
											</tr>
											<tr>
												<!-- 地图分类 -->
												<td class="td_normal_title" width="15%">
													<bean:message  bundle="kms-kmaps" key="kmsKmapsMain.docCategoryId"/>
												</td>
												<td width="85%" colspan="3">
													<html:hidden property="docCategoryId" /> 
													<span name="docTemp"><bean:write name="kmsKmapsTemplateForm" property="docCategoryName" /></span>
													<c:if test="${param.method == 'add' }">
														<a href="javascript:modifyCate(true,true)" style="margin-left:15px;" class="com_btn_link">${lfn:message('kms-kmaps:kmsKmapsMain.changeTemplate') }</a>
														<span class="txtstrong">*</span>
													</c:if>
												</td>
											</tr>
											<!-- 创建者 -->
											<tr>
												<td width="10%" class="td_normal_title">
													${lfn:message('kms-kmaps:kmsKmapsMain.docCreator')}
												</td>
												<td width="40%">
													${kmsKmapsTemplateForm.docCreatorName }
												</td>
												<td width="10%" class="td_normal_title">
													${lfn:message('kms-kmaps:kmsKmapsTemplate.docCreateTime')}
												</td>
												<td width="40%">
													${kmsKmapsTemplateForm.docCreateTime }
												</td>
											</tr>
											<!-- 摘要 -->
											<td valign="top" width="15%" class="td_normal_title">
												${lfn:message('kms-kmaps:kmsKmapsTemplate.fdDescription')}
											</td>
											<td width="100%" colspan="3">
												<html:textarea property="fdDescription" style="width:85%;height:100px;" styleClass="inputmul" />
											</td>
										</table>
									</ui:content>
									<!-- 权限 -->
									<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
											<c:param name="formName" value="kmsKmapsTemplateForm" />
											<c:param name="moduleModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplate" />
									</c:import>
								</ui:tabpage>
								</html:form>
								<script language="JavaScript">
									$KMSSValidation(document.forms['kmsKmapsTemplateForm']);
								</script>
							</div>
						</td>
					</tr>
				</table>
		</template:replace>
</template:include>
</div>