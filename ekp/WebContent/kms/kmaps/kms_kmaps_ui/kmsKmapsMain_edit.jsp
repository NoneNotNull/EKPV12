<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!-- Kanvas绘图 -->
<div class="kms_kanvas">
	<div id="demo"></div>
</div>
<div style="display:none" id="kmsKmapsContent">
<template:include ref="default.edit"  sidebar="no">
	<template:replace name="head">
		<%@ include file="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_edit_js.jsp"%>
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmaps/kms_kmaps_ui/style/edit.css" />
	</template:replace>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmsKmapsMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('kms-kmaps:kmsKmapsMain.createMaps') } - ${ lfn:message('kms-kmaps:table.kmsKmapsMain') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmsKmapsMainForm.docSubject} - ${ lfn:message('kms-kmaps:table.kmsKmapsMain') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar" >
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<c:when test="${ kmsKmapsMainForm.method_GET == 'add' }">
					<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.savedraft') }" order="2" onclick="commitMethod('save','true');">
					</ui:button>
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save','false');">
					</ui:button>
				</c:when>
				<c:when test="${ kmsKmapsMainForm.method_GET == 'edit' }">
					<c:if test="${kmsKmapsMainForm.docStatusFirstDigit=='1'}">
						<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.savedraft') }" order="4" onclick="commitMethod('update','true');">
						</ui:button>
					</c:if>
					<c:if test="${kmsKmapsMainForm.docStatusFirstDigit<'3'}">
	 					<ui:button text="${lfn:message('button.submit') }" order="4" onclick="commitMethod('update','false');">
						</ui:button>
					</c:if>
					<c:if test="${kmsKmapsMainForm.docStatusFirstDigit>='3'}">
						<ui:button text="${lfn:message('button.submit') }" order="4" onclick="commitMethod('update');">
						</ui:button>
					</c:if>			
				</c:when>
			</c:choose>
			<!-- 编辑图形 -->
			<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.draw') }" order="4" onclick="drawMap();">
			</ui:button>
			<!-- 关闭 -->
			<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();" order="5">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-kmaps:table.kmsKmapsMain') }" 
					modulePath="/kms/kmaps/" 
					modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" 
					autoFetch="false"
					target="_blank"
					categoryId="${kmsKmapsMainForm.docCategoryId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
			<table style="width:100%; ">
				<tr>
					<td valign="top">
						<div class="lui_form_content">
							<html:form action="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do" >
						 
							<ui:tabpage expand="false">
								<div>
									<%---关联机制--%>
									<c:import url="/sys/relation/import/sysRelationMain_edit_many.jsp" charEncoding="UTF-8">
										<c:param name="formName" value="kmsKmapsMainForm" />
										<c:param name="currModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
									</c:import>
									
									<html:hidden property="method_GET"/>
									<html:hidden property="docContent"/>
									<html:hidden property="docStatus" />
									<html:hidden property="fdId" />
									<html:hidden property="extendFilePath"/>
									<html:hidden property="extendDataXML"/>
									<!-- 缩略图 -->
									<html:hidden property="shotCut" /> 
								</div>
								
								<ui:content title="${lfn:message('kms-kmaps:kmsKmapsMain.baseInfo')}" toggle="false">
									
									<table class="tb_simple" width=100%>
										<tr>
											<!-- 名称 -->
											<td width="15%" class="td_normal_title">
												<bean:message bundle="kms-kmaps" key="kmsKmapsMain.docSubject" />
											</td>
											<td width="85%" colspan="3" >
												<xform:text subject="${lfn:message('kms-kmaps:kmsKmapsMain.docSubject')}" isLoadDataDict="false" validators="maxLength(200)" 
													property="docSubject" required="true" className="inputsgl" style="width:97.5%;"/>
											</td>
										</tr>
										
										<tr>
											<!-- 地图分类 -->
											<td class="td_normal_title" width="15%">
												<bean:message key="kmsKmapsMain.fdMainCate" bundle="kms-kmaps" />
											</td>
											<td width="85%" colspan="3">
												<html:hidden property="docCategoryId" /> 
												<span name="docTemp"><bean:write name="kmsKmapsMainForm" property="docCategoryName" /></span>
												<c:if test="${ kmsKmapsMainForm.method_GET == 'add' }">
													<a href="javascript:modifyCate(true,true)" style="margin-left:15px;" class="com_btn_link">${lfn:message('kms-kmaps:kmsKmapsMain.changeTemplate') }</a>
													<span class="txtstrong">*</span>
												</c:if>
											</td>
										</tr>
										<!-- 标签 -->
										<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
											<c:param name="formName" value="kmsKmapsMainForm" />
											<c:param name="fdKey" value="mainMap" /> 
											<c:param name="fdQueryCondition" value="docCategoryId;docDeptId" /> 
										</c:import>
										
										<tr>
											<!-- 内外部作者 -->
											<td width="15%" class="td_normal_title">
												<bean:message bundle="kms-kmaps" key="kmsKmapsMain.orignAuthor" />
											</td>
											<td width="35%">
												<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsKmapsMainForm.docAuthorId?1:2}">
													<xform:enumsDataSource enumsType="kmsKmapsAuthorType">
													</xform:enumsDataSource>
												</xform:radio>
											</td>
											<td width="15%" class="td_normal_title">
												<bean:message bundle="kms-kmaps" key="kmsKmapsMain.Author" />
											</td>
											
											<!-- 内部作者 -->
											<td width="35%" id="innerAuthor" <c:if test="${empty kmsKmapsMainForm.docAuthorId }">style="display: none;"</c:if> >
												<c:if test="${empty kmsKmapsMainForm.docAuthorId }">
													<xform:address  isLoadDataDict="false" style="width:94%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'  subject="${ lfn:message('kms-kmaps:kmsKmapsMain.Author')}"></xform:address>
												</c:if> 
												<c:if test="${not empty kmsKmapsMainForm.docAuthorId }">
													<xform:address required="true" isLoadDataDict="false" style="width:95%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'  subject="${ lfn:message('kms-kmaps:kmsKmapsMain.Author')}"></xform:address>
												</c:if>
											</td>
											<!-- 外部作者 -->
											<td width="35%" id="outerAuthor" <c:if test="${not empty kmsKmapsMainForm.docAuthorId }">style="display: none;"</c:if>>
												<c:if test="${not empty kmsKmapsMainForm.docAuthorId }">
													<xform:text property="outerAuthor"  style="width:93%" subject="${ lfn:message('kms-kmaps:kmsKmapsMain.Author')}"></xform:text>
													<span class="txtstrong">*</span>
												</c:if>
												<c:if test="${empty kmsKmapsMainForm.docAuthorId }">
													<xform:text property="outerAuthor"   required="true" style="width:93%" subject="${ lfn:message('kms-kmaps:kmsKmapsMain.Author')}"></xform:text>
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
												${kmsKmapsMainForm.docCreatorName }
											</td>
											<td width="10%" class="td_normal_title">
												${lfn:message('kms-kmaps:kmsKmapsTemplate.docCreateTime')}
											</td>
											<td width="40%">
												${kmsKmapsMainForm.docCreateTime }
											</td>
										</tr>
										<tr>
											<!-- 所属部门 -->
											<td width="15%" class="td_normal_title">
												<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
											</td>
											<td width="85%" colspan="3">
												<xform:address required="true" validators="" subject="${ lfn:message('kms-kmaps:kmsKmapsMain.dept') }" style="width:98%" propertyId="docDeptId" propertyName="docDeptName" orgType='ORG_TYPE_ORGORDEPT'></xform:address>
											</td>
										</tr>
										<tr>
											<!-- 摘要 -->
											<td valign="top" width="15%" class="td_normal_title">
												${lfn:message('kms-kmaps:kmsKmapsMain.docDescription')}
											</td>
											<td width="100%" colspan="3">
												<html:textarea property="fdDescription" style="width:98%;height:100px;" styleClass="inputmul" />
											</td>
										</tr>
									</table>
								</ui:content>
								<!-- 地图属性 -->
								<c:if test="${not empty kmsKmapsMainForm.extendFilePath}">
									<ui:content title="${ lfn:message('kms-kmaps:kmsKmapsMain.fdProperty') }" toggle="false">
										<table class="tb_simple tb_property" width=100%>
											<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
												<c:param name="formName" value="kmsKmapsMainForm" />
												<c:param name="fdDocTemplateId" value="${kmsKmapsMainForm.docCategoryId}" />
											</c:import>
										</table>
									</ui:content>
								</c:if>
								<!-- 权限 -->
								<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
										<c:param name="formName" value="kmsKmapsMainForm" />
										<c:param name="moduleModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
								</c:import>
								<!-- 版本 -->
								<c:import url="/sys/edition/import/sysEditionMain_edit.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmsKmapsMainForm" />
								</c:import>
								<!-- 流程 -->
								<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmsKmapsMainForm" />
									<c:param name="fdKey" value="mainMap" />
								</c:import>
								
							</ui:tabpage>
							</html:form>
							<script language="JavaScript">
								$KMSSValidation(document.forms['kmsKmapsMainForm']);
							</script>
						</div>
					</td>
				</tr>
			</table>
	</template:replace>
</template:include>
</div>