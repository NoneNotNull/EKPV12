<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<template:replace name="head">
		<script type="text/javascript">
			seajs.use(['theme!panel']);
		</script>
	</template:replace>
	<%-- 标题 --%>
	<template:replace name="title">
		<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
			<c:out value="${ lfn:message('kms-expert:kmsExpert.add') } - ${ lfn:message('kms-expert:title.kms.expert') }"/>	
		</c:if>
		<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
			<c:out value="${kmsExpertInfoForm.fdName } - ${ lfn:message('kms-expert:kmsExpert.edit') }"/>	
		</c:if>		
	</template:replace>
	<%-- 按钮 --%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
				<ui:button text="${lfn:message('button.update') }" onclick="Com_Submit(document.kmsExpertInfoForm,'update');">
				</ui:button>
			</c:if>
			<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
				<ui:button text="${lfn:message('button.save') }" onclick="Com_Submit(document.kmsExpertInfoForm,'save');">
				</ui:button>
				<ui:button text="${lfn:message('button.saveadd') }" onclick="Com_Submit(document.kmsExpertInfoForm,'saveadd');">
				</ui:button>						
			</c:if>
			<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<%-- 路径 --%>
	<template:replace name="path">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/edit.css">
		<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-expert:title.kms.expert') }" 
					modulePath="/kms/expert/" 
					modelName="com.landray.kmss.kms.expert.model.KmsExpertType" 
					autoFetch="false"
					target="_blank"
					categoryId="${kmsExpertInfoForm.kmsExpertTypeId}" />
		</ui:combin>
	</template:replace>
	<%-- 内容 --%>
	<template:replace name="content">		
		<html:form action="/kms/expert/kms_expert_info/kmsExpertInfo.do">
			<html:hidden property="method_GET" />
			<html:hidden property="fdId" />
			<%-- 创建时间 --%>
			<html:hidden property="fdCreateTime"/>
			<div class="lui_form_content_frame" style="padding-top:20px">
				<table width=100% class="tb_simple">
					<tr class="lui_expertInfo_table_tr" >
						<td width="76%" class="" valign="top">
							<table class="tb_simple" width=100%>
								<tr>
									<%-- 姓名 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdName" />
									</td>
									<td width="28%">
										<c:if test="${kmsExpertInfoForm.method_GET!='edit'}">
											<xform:address onValueChange="getPersonInfo" required="true" style="width:96%" isLoadDataDict="false" validators="required"
												 propertyId="fdPersonId" propertyName="fdName" orgType='ORG_TYPE_PERSON' subject="${lfn:message('kms-expert:table.kmsExpertInfo.fdName')}">
											</xform:address>
										</c:if>
										<c:if test="${kmsExpertInfoForm.method_GET=='edit'}">
											${kmsExpertInfoForm.fdName}
										</c:if>	
									</td>
									<%--公司电话 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.wordPhoneNo" />
									</td>
									<td  width="28%">
										<html:text 
											property="fdWorkPhone" 
											style="width:98%;" 
											readonly="true" 
											styleClass="inputsgl lui_expertInfo_readOnly"/>
									</td>
								</tr>
								<tr>
									<%-- IMNo --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdImNumber" />
									</td>
									<td  width="28%">
										<html:text property="fdImNumber" style="width:95%" />	
									</td>
									<%--手机号码 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.phoneNo" />
									</td>
									<td  width="28%">
										<html:text property="fdMobileNo" 
													style="width:98%" 
													readonly="true" 
													styleClass="inputsgl lui_expertInfo_readOnly"/>
									</td>								
								</tr>
								<tr>
									<%-- 性别 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.sex" />
									</td>
									<td  width="28%">
										<xform:radio property="fdSex">
											<xform:enumsDataSource enumsType="sys_org_person_sex">
											</xform:enumsDataSource>
										</xform:radio>
									</td>
									
									<%-- 电子邮件 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.Email" />
									</td>
									<td width="28%">
										<html:text property="fdEmail" 
												   style="width:98%" 
												   readonly="true" 
												   styleClass="inputsgl lui_expertInfo_readOnly"/>	
									</td>
								</tr>
								<tr>
									<%-- 部门 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.department" />
									</td>
									<td  width="28%">
										<html:text property="fdDeptName" 
												   style="width:95%"  
												   readonly="true" 
												   styleClass="inputsgl lui_expertInfo_readOnly"/>	
									</td>
									<%-- 岗位 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.position" />
									</td>
									<td width="28%">
										<html:text 
											property="fdPostNames" 
											style="width:98%"  
											readonly="true" 
											styleClass="inputsgl lui_expertInfo_readOnly"/>	
									</td>
								</tr>
								<tr>
									<td width="10%" class="td_normal_title" valign="top">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdSignature"/>
									</td>
									<td colspan="3">
										<html:textarea property="fdSignature" style="width:99%;height:80px" />
									</td>
								</tr>
							</table>
					    </td>
					    <td width="24%" valign="top">
					    	<div style="width:70%;padding-top:5px">
										<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
											<c:param name="fdKey" value="spic"/>
											<c:param name="fdAttType" value="pic"/>
											<c:param name="fdShowMsg" value="true"/>
											<c:param name="fdMulti" value="false"/>
											<c:param name="fdLayoutType" value="pic"/>
											<c:param name="fdPicContentWidth" value="100%"/>
											<c:param name="fdPicContentHeight" value="228"/>
											<c:param name="fdViewType" value="pic_single"/>
										</c:import>
							</div>
			    		</td>
			    	</tr>
					<tr>
						<td colspan="2">
							<table class="tb_simple" width=100% style="margin-top: 5px">

								<tr>
									<%-- 专家分类 --%>
									<td width="10%" class="td_normal_title">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdAreaName" />
									</td>
									<td >
										<xform:dialog 
											dialogJs="modifyCate(true)" 
											propertyId="kmsExpertTypeId" 
											propertyName="kmsExpertTypeName" 
											style="width:93%"
											required="true"
											subject="${lfn:message('kms-expert:table.kmsExpertInfo.fdAreaName')}">
										</xform:dialog>
									</td>
								</tr>
									
								<%-- 爱问领域 --%>
								<c:forEach items="${kmsExpertAreas}" var="kmsExpertArea" varStatus="vstatus">
									<c:import url="/kms/expert/kms_expert_area_ui/kmsExpertArea_add.jsp"
										charEncoding="UTF-8">
										<c:param name="areaMessage" value="${kmsExpertArea.areaMessageKey}" />
										<c:param name="treeBean" value="${kmsExpertArea.treeBean}" />
										<c:param name="index" value="${vstatus.index}" />
										<c:param name="fdModelName" value="${ kmsExpertArea.uuid}" />
										<c:param name="cateModelName" value="${ kmsExpertArea.cateModelName}" />
									</c:import>
								</c:forEach>
								<tr>
									<%-- 排序号 --%>
									<td width="10%" class="td_normal_title" >
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.order" />
									</td>
									<td >
										<xform:text property="fdOrder" style="width:92.5%" validators="number" isLoadDataDict="false"/>
									</td>
								</tr>
								<tr>
									<%-- 个人简介 --%>
									<td width="10%" class="td_normal_title" valign="top">
										<bean:message bundle="kms-expert" key="table.kmsExpertInfo.background" />
									</td>
									<td>
										<xform:textarea property="fdBackground" style="width:92.5%"/>
									</td>
								</tr>
								<tr>
									<%--详细介绍 --%>
									<td width="10%" class="td_normal_title" valign="top">
										<a href="javascript:void(0);" class="com_btn_link" id="detailsBtn">
											<bean:message bundle="kms-expert" key="table.kmsExpertInfo.fdDetails" />
										</a>
									</td>
									<td>
										<div style="display: none;" id="details">
											<kmss:editor property="fdDetails" width="93%" />
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<c:if test="${not empty kmsExpertInfoForm.extendFilePath}">
				<div class="lui_tabpage_float_header_l">
					<div class="lui_tabpage_float_header_r">
						<div class="lui_tabpage_float_header_c">
							<div class="lui_tabpage_float_header_title">
								<div class="lui_tabpage_float_header_text">
									${lfn:message('kms-expert:kmsExpert.expertInfo.property')}
								</div>
							</div>
						</div>
					</div>
				</div>
				<div style="margin: 10px 0px;">
					<table class="tb_simple tb_property" width=100% >
						<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsExpertInfoForm" />
							<c:param name="fdDocTemplateId" value="${kmsExpertInfoForm.kmsExpertTypeId}" />
						</c:import>
					</table>
				</div>
				</c:if>
			</div>
		</html:form>
		<%@ include file="/kms/expert/kms_expert_info_ui/kmsExpertInfo_edit_js.jsp"%>
		<script type="text/javascript">
			Com_IncludeFile("dialog.js|xform.js|plugin.js|validation.jsp");
			$KMSSValidation(document.forms['kmsExpertInfoForm']);
		</script>
	</template:replace>
</template:include>

