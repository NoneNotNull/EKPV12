<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/multidoc/kms_multidoc_ui/style/edit.css" />
	</template:replace>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmsMultidocKnowledgeForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('kms-multidoc:kmsMultidoc.create.title') } - ${ lfn:message('kms-multidoc:table.kmdoc') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmsMultidocKnowledgeForm.docSubject} - ${ lfn:message('kms-multidoc:table.kmdoc') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<c:when test="${ kmsMultidocKnowledgeForm.method_GET == 'add' }">
					<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.button.savedraft') }" order="2" onclick="commitMethod('save','true');">
					</ui:button>
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save','false');">
					</ui:button>
				</c:when>
				<c:when test="${ kmsMultidocKnowledgeForm.method_GET == 'edit' }">
					<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit=='1'}">
						<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.button.savedraft') }" order="4" onclick="commitMethod('update','true');">
						</ui:button>
					</c:if>
					<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit<'3'}">
						<ui:button text="${lfn:message('button.submit') }" order="4" onclick="commitMethod('update','false');">
						</ui:button>
					</c:if>
					<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit>='3'}">
						<ui:button text="${lfn:message('button.submit') }" order="4" onclick="Com_Submit(document.kmsMultidocKnowledgeForm, 'update');">
						</ui:button>
					</c:if>			
				</c:when>
			</c:choose>
			<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();" order="5">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-multidoc:table.kmdoc') }" 
					modulePath="/kms/multidoc/" 
					modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
					autoFetch="false"
					target="_blank"
					categoryId="${kmsMultidocKnowledgeForm.docCategoryId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_edit_script.jsp"%>
		<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" >
			<html:hidden property="fdImportInfo" />
			<html:hidden property="fdId" />
		<c:if test="${empty kmsMultidocKnowledgeForm.docSubject}">
			<p class="txttitle" style="display: none;"><bean:message bundle="kms-multidoc" key="kmsMultidoc.form.title" /></p>
		</c:if>
		<c:if test="${!empty kmsMultidocKnowledgeForm.docSubject}">
			<p class="txttitle" style="display: none;">${kmsMultidocKnowledgeForm.docSubject }</p>
		</c:if> 
		<html:hidden property="fdId" />
		<html:hidden property="fdModelId" />
		<html:hidden property="fdModelName" />
		<html:hidden property="fdWorkId" />
		<html:hidden property="docStatus" />
		<html:hidden property="fdPhaseId" />
		<html:hidden property="extendFilePath"/>
		<html:hidden property="extendDataXML"/>
		
		<html:hidden property="docCreateTime" />
		<html:hidden property="docAlterTime" />
		<html:hidden property="docSourceId"/>
		<ui:tabpage expand="false">
			<ui:content title="" toggle="false">
				<table class="tb_simple" width=100%>
					<tr>
						<td width="15%" class="td_normal_title" valign="top">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAttachments" />
						</td>
						<td width="85%" colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment" />
								<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" /> 
							</c:import>
						</td>
					</tr>
					
					<tr>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
						</td>
						<td width="85%" colspan="3">
							<xform:text isLoadDataDict="false" validators="maxLength(200)" 
								property="docSubject" required="true" className="inputsgl" style="width:97%;"/>
						</td>
					</tr>
					
					<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						<c:param name="fdKey" value="mainDoc" /> 
						<c:param name="fdQueryCondition" value="docCategoryId;docDeptId" /> 
					</c:import>
					
					<tr>
						<td class="td_normal_title" width="15%">
							<bean:message key="kmsMultidocKnowledge.fdTemplateName" bundle="kms-multidoc" />
						</td>
						<td width="35%">
							<html:hidden property="docCategoryId" /> 
							<bean:write name="kmsMultidocKnowledgeForm" property="docCategoryName" />
							<c:if test="${param.method == 'add' }">
								<a href="javascript:modifyCate(true)" style="margin-left:15px;" class="com_btn_link">${lfn:message('kms-multidoc:kmsMultidoc.changeTemplate') }</a>
								<span class="txtstrong">*</span>
							</c:if>
						</td>
							
						<td class="td_normal_title" width="15%">
							<bean:message key="kmsMultidoc.kmsMultidocKnowledge.docProperties" bundle="kms-multidoc" />
						</td>
						<td width="35%">
							<xform:dialog propertyId="docSecondCategoriesIds" propertyName="docSecondCategoriesNames" style="width:95%" >
								modifySecondCate(true);
							</xform:dialog>	
						</td>
					</tr>
					
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.fdStoretime" />
						</td>
						<td colspan="3" width="85%"><html:text property="docExpire" style="width:40%"/>
							<bean:message key="message.storetime" bundle="kms-multidoc" />
							<bean:message key="message.storetime.tip" bundle="kms-multidoc" />
						</td>
					</tr>
					
					<tr>
					
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.authorType" />
						</td>
						<td width="35%">
							<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsMultidocKnowledgeForm.docAuthorId?1:2}">
								<xform:enumsDataSource enumsType="kmsKnowledgeAuthorType">
								</xform:enumsDataSource>
							</xform:radio>
						</td>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />
						</td>
						<!-- 内部作者 -->
						<td width="35%" id="innerAuthor" <c:if test="${empty kmsMultidocKnowledgeForm.docAuthorId }">style="display: none;"</c:if> >
							<c:if test="${empty kmsMultidocKnowledgeForm.docAuthorId }">
								<xform:address  isLoadDataDict="false" style="width:95%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'  subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:address>
							</c:if>
							<c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">
								<xform:address 
									required="true" 
									isLoadDataDict="false" 
									style="width:95%" 
									propertyId="docAuthorId" 
									propertyName="docAuthorName" 
									orgType='ORG_TYPE_PERSON'  
									subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"
									onValueChange="changeAuthodInfo" />
							</c:if>
						</td>
						<!-- 外部作者 -->
						<td width="35%" id="outerAuthor" <c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">style="display: none;"</c:if>>
							<c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">
								<xform:text property="outerAuthor"  style="width:95%" subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:text>
							</c:if>
							<c:if test="${empty kmsMultidocKnowledgeForm.docAuthorId }">
								<xform:text property="outerAuthor"   required="true" style="width:95%" subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:text>
							</c:if>
						</td>
					</tr>
					
					<tr>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
						</td>
						<td width="35%">
							<xform:address required="false" validators="" style="width:95%" propertyId="docDeptId" propertyName="docDeptName" orgType='ORG_TYPE_ORGORDEPT'></xform:address>
						</td>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-multidoc" key="table.kmsMultidocMainPost" />
						</td>
						<td width="35%">
							<xform:address 
								required="false" 
								style="width:95%" 
								propertyId="docPostsIds" 
								propertyName="docPostsNames" 
								orgType='ORG_TYPE_POST'>
							</xform:address>
						</td>
					</tr>
					<!-- 摘要 -->
					<tr>
						<td width="15%" class="td_normal_title" valign="top">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.fdDescription" />
						</td>
						<td width="85%" colspan="3">
							<xform:textarea isLoadDataDict="false" property="fdDescription" validators="maxLength(1500)" style="width:98%;height:90px" className="inputmul" />
						</td>
					</tr>
					
					<!-- 封面 -->
					<tr>
						<td width="15%" class="td_normal_title" valign="top">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.uploadCoverPic" />
						</td>
						<td width="85%" colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="spic"/>
								<c:param name="fdAttType" value="pic"/>
								<c:param name="fdShowMsg" value="true"/>
								<c:param name="fdMulti" value="false"/>
								<c:param name="fdLayoutType" value="pic"/>
								<c:param name="fdPicContentWidth" value="120"/>
								<c:param name="fdPicContentHeight" value="180"/>
								<c:param name="fdViewType" value="pic_single"/>
								<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
							</c:import>
						</td>
					</tr>
				</table>
			</ui:content>
			<!-- 文档内容 -->
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.docContent') }" toggle="false">
				
				<table class="tb_simple" width=100%>
					<tr>
						
						<td width="85%" colspan="3">
							<kmss:editor property="docContent" toolbarSet="Default" height="500" width="98%"/>
						</td>
					</tr>
				</table>
			</ui:content>
			<!-- 属性 -->
			<c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
				<ui:content id="validate_ele2" title="${ lfn:message('kms-multidoc:kmsMultidoc.docProperty') }" toggle="false">
					<table class="tb_simple tb_property" width=100%>
						<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdDocTemplateId" value="${kmsMultidocKnowledgeForm.docCategoryId}" />
						</c:import>
					</table>
				</ui:content>
			</c:if>
			<!-- 权限 -->
			<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
			</c:import>
			<!-- 版本 -->
			<c:import url="/sys/edition/import/sysEditionMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
			</c:import>
			<!-- 流程 -->
			<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
			</c:import>
				<%---发布机制---%>
					<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdKey" value="mainDoc" />	 
							<c:param name="isShow" value="true" />
					</c:import> 
		</ui:tabpage>
		</html:form>
		<script language="JavaScript">
			$KMSSValidation(document.forms['kmsMultidocKnowledgeForm']);
		</script>		
	</template:replace>
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:panel toggle="false">
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.docInfo') }">
				<ul class='lui_form_info'>
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidoc.inputUser" />：
						<ui:person personId="${kmsMultidocKnowledgeForm.docCreatorId}" personName="${kmsMultidocKnowledgeForm.docCreatorName}">
						</ui:person>
					</li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docStatus" />：<sunbor:enumsShow	value="${kmsMultidocKnowledgeForm.docStatus}"	enumsType="common_status" /></li>
					<li><bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />：${ kmsMultidocKnowledgeForm.docMainVersion }.${ kmsMultidocKnowledgeForm.docAuxiVersion }</li>
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidoc.lastUpdateUser" />：
						<ui:person personId="${kmsMultidocKnowledgeForm.docAlterorId}" personName="${kmsMultidocKnowledgeForm.docAlterorName}">
						</ui:person>
					</li>
					<c:if test="${not empty alterTime }">
						<li><bean:message bundle="kms-multidoc" key="kmsMultidoc.lastUpdateTime" />：${alterTime }</li>
					</c:if>					
				</ul>
			</ui:content>
		</ui:panel>
		<%--关联机制(与原有机制有差异)--%>
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocKnowledgeForm" />
		</c:import>
		
	</template:replace>
</template:include>