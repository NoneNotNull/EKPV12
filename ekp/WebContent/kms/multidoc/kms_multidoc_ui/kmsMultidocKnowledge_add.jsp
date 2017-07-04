<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/multidoc/kms_multidoc_ui/style/edit.css" />
		<%@page import="com.landray.kmss.kms.knowledge.forms.KmsKnowledgeCategoryForm"%>
		<%@page import="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory"%>
		<%@page import="com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService"%>
		<%@page import="org.springframework.context.ApplicationContext"%>
		<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
		<%@page import="com.landray.kmss.common.actions.RequestContext"%>
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
						<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.button.savedraft') }" order="2" onclick="commitMethod('update','true');">
						</ui:button>
					</c:if>
					<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit<'3'}">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update','false');">
						</ui:button>
					</c:if>
					<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit>='3'}">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmsMultidocKnowledgeForm, 'update');">
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
		<html:hidden property="extendDataXML"   />
		<ui:step id="__step" style="background-color:#f2f2f2" onSubmit="commitMethod('save','false');">
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.information')}" toggle="false">
				<table class="tb_simple" width="100%" id="validate_ele0">
					<!-- 文档附件 -->
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
					<!-- 标题 -->
					<tr>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.docSubject" />
						</td>
						<td width="85%" colspan="3">
							<xform:text isLoadDataDict="false" validators="maxLength(200)" subject="${ lfn:message('kms-multidoc:kmsMultidocKnowledge.docSubject')}"
								property="docSubject" required="true" className="inputAdd" style="width:98%;" />   
						</td>
					</tr>
					<!-- 主分类 -->
					<tr>
						<td class="td_normal_title" width="15%">
							<bean:message key="kmsMultidocKnowledge.fdMainCate" bundle="kms-multidoc" />
						</td>
						<td width="85%" colspan="3">
							<html:hidden property="docCategoryId" /> 
							<span name="docTemp"><bean:write name="kmsMultidocKnowledgeForm" property="docCategoryName" /></span>
							<c:if test="${param.method == 'add' }">
								<a href="javascript:modifyCate(true,true)" style="margin-left:15px;" class="com_btn_link">${lfn:message('kms-multidoc:kmsMultidoc.changeTemplate') }</a>
								<span class="txtstrong">*</span>
							</c:if>
						</td>
					</tr>
					<!-- 辅分类 -->
					<tr>
						<td class="td_normal_title" width="10%">
							<bean:message key="kmsMultidoc.kmsMultidocKnowledge.docProperties" bundle="kms-multidoc" />
						</td>
						<td colspan="3" width="90%">
							<xform:dialog propertyId="docSecondCategoriesIds" propertyName="docSecondCategoriesNames" style="width:98%" >
								modifySecondCate(true);
							</xform:dialog>	
						</td>
					</tr>
					
					<tr>
						<!-- 作者 -->
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.orignAuthor" />
						</td>
						<td width="35%">
							<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsMultidocKnowledgeForm.docAuthorId?1:2}">
								<xform:enumsDataSource enumsType="kmsKnowledgeAuthorType">
								</xform:enumsDataSource>
							</xform:radio>
						</td>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.Author" />
						</td>
						<td width="35%" id="innerAuthor" <c:if test="${empty kmsMultidocKnowledgeForm.docAuthorId }">style="display: none;"</c:if> >
							<xform:address 
								required="true" 
								style="width:95%" 
								propertyId="docAuthorId" 
								propertyName="docAuthorName" 
								orgType="ORG_TYPE_PERSON"
								onValueChange="changeAuthodInfo" />
						</td>
						<td width="35%" id="outerAuthor" <c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">style="display: none;"</c:if>>
							<xform:text property="outerAuthor" subject="${ lfn:message('kms-multidoc:kmsMultidoc.Author')}" style="width:94%"></xform:text>
							<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr>
						<!-- 所属部门 -->
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
						</td>
						<td width="35%">
							<xform:address 
								required="false" 
								validators="" 
								subject="${ lfn:message('kms-multidoc:kmsMultidoc.form.main.docDeptId') }" 
								style="width:95%" 
								propertyId="docDeptId" 
								propertyName="docDeptName" 
								orgType='ORG_TYPE_ORGORDEPT'>
							</xform:address>
						</td>
						<!-- 所属岗位 -->
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-multidoc" key="table.kmsMultidocMainPost" />
						</td>
						<td width="35%">
							<xform:address required="false" style="width:95%" propertyId="docPostsIds" propertyName="docPostsNames" orgType='ORG_TYPE_POST'></xform:address>
						</td>
					</tr>
				</table>
			</ui:content>
			
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.docContents') }" toggle="false">
				<%--标题 --%>
				<div class="lui_multidoc_docTitle">
					<span id="title_span">
					</span>
				</div>
				<div>
					<table class="tb_simple" width="100%" id="validate_ele1">
						<tr> 
							<td width="15%" class="lui_multidoc_cont">${lfn:message('kms-multidoc:kmsMultidocKnowledge.content')}
							</td>
							<td width="85%" colspan="3">
								<kmss:editor property="docContent" toolbarSet="Default" height="400" width="98%"/>
							</td>
						</tr>
					</table>
				</div>
			</ui:content>
			
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.docProperty')}" toggle="false">
			
				<div class="lui_multidoc_catelog">
					<div class="lui_multidoc_title">
						<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.fdContentDesc"/>
					</div>
				</div>
				
				<table class="tb_simple tb_property" width="100%">
					
					<tr>
						<!-- 封面 -->
						<td width="28%">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="spic"/>
								<c:param name="fdAttType" value="pic"/>
								<c:param name="fdShowMsg" value="true"/>
								<c:param name="fdMulti" value="false"/>
								<c:param name="fdLayoutType" value="pic"/>
								<c:param name="fdPicContentWidth" value="95%"/>
								<c:param name="fdPicContentHeight" value="158"/>
								<c:param name="fdViewType" value="pic_single"/>
								<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
							</c:import>
						</td>
						<!-- 摘要 -->
						<td width="68%" colspan="3">
							<xform:textarea isLoadDataDict="false" property="fdDescription" validators="maxLength(1500)" style="width:98%;height:160px" className="inputmul" />
						</td>
					</tr> 
				</table>
				
				<div class="lui_multidoc_catelog">
					<div class="lui_multidoc_title">
						<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.fdProperty"/>
					</div>
				</div>
				
				<table class="tb_simple" width="100%" id="validate_ele2">
					<!-- 属性 -->
					<tr>
						<c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
							<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
								<c:param name="formName" value="kmsMultidocKnowledgeForm" />
								<c:param name="fdDocTemplateId" value="${kmsMultidocKnowledgeForm.docCategoryId}" />
							</c:import>
						</c:if>
					</tr>
					<!-- 标签 -->
					<tr>
						<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdKey" value="mainDoc" /> 
							<c:param name="fdQueryCondition" value="docCategoryId;docDeptId" /> 
						</c:import>
					</tr>
					<!-- 存放期限 -->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.fdStoretime" />
						</td>
						<td colspan="3" width="85%"><html:text property="docExpire" style="width:40%"/>
							<bean:message key="message.storetime" bundle="kms-multidoc" />
							<bean:message key="message.storetime.tip" bundle="kms-multidoc" />
						</td>
					</tr>
				</table>
			</ui:content>
			
			<!-- 权限及流程 -->
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.rightAndFlow') }" toggle="false">
				<c:import url="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_rightAndWorkflow_add.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm" /> 
					<c:param name="moduleModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
					<c:param name="fdKey" value="mainDoc" />
				</c:import>
					<%---发布机制 开始---%>
			<c:import
				url="/sys/news/import/sysNewsPublishMain_edit.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />	 
				<c:param name="isShow" value="true" /><%--是否显示--%>
			</c:import> 	
			<%---发布机制 结束---%>
			</ui:content>
			
		</ui:step>
		</html:form>
		<script language="JavaScript">
			$KMSSValidation(document.forms['kmsMultidocKnowledgeForm']);
		</script>		
	</template:replace>
	<template:replace name="nav">
		<div style="min-width:200px;margin-top: 75px;"></div>
		<ui:panel toggle="false">
			<ui:content title="${ lfn:message('kms-multidoc:kmsMultidoc.docInfo') }">
				<ul class='lui_form_info'>
					<li>
						<div id="r_info" class="lui_multidoc_hideLi">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.Author" />：
							<span id="author_span" style="color: #F19703;">
							</span>
						</div>
					</li>
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidoc.creator" />： 
						<ui:person personId="${kmsMultidocKnowledgeForm.docCreatorId}" personName="${kmsMultidocKnowledgeForm.docCreatorName}">
						</ui:person>
					</li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docStatus" />：<sunbor:enumsShow	value="${kmsMultidocKnowledgeForm.docStatus}"	enumsType="common_status" /></li>
					
					<li><bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.docCreateTime" />：<kmss:showDate value="${ docCreateTime }" type="date"/></li>				
				</ul>
				<ul class='lui_form_info'>
					<li>
						<div id="r_info1" class="lui_multidoc_hideLi">
							<div style='margin-left:-8px;margin-right:-8px;margin-bottom:8px;border-bottom: 1px #bbb dashed;height:8px'></div>
							<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.fdMainCate" />：
							<span id="docTemplate_span">
							</span>
						</div>
						<div id="r_info2" class="lui_multidoc_hideLi">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.docProperties" />：
							<span id="secondaryCategories_span">
							</span>
						</div>
					</li>
				</ul>
			</ui:content>
		</ui:panel>
		
		<%--关联机制(与原有机制有差异)--%>
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocKnowledgeForm" />
		</c:import>
		
	</template:replace>
</template:include>
<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_add_js.jsp"%>