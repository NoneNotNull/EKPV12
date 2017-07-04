<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/style/add.css">
	</template:replace>
	<%-- 标题 --%>
	<template:replace name="title">
			${lfn:message('kms-wiki:table.kmsWikiMain.subject')}-${lfn:message('kms-wiki:title.kms.wiki') }
	</template:replace>
	<%-- 按钮 --%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
				<ui:button text="${lfn:message('button.submit') }" order="2" onclick="submitMethod('20')">
				</ui:button>
				<!-- 暂存 -->
				<ui:button text="${lfn:message('button.savedraft') }" order="1" onclick="submitMethod('10')">
				</ui:button>
				<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();" order="3">
				</ui:button>
		</ui:toolbar>
	</template:replace>
	<%-- 路径 --%>
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-wiki:moudle.name.kmsWiki') }" 
					modulePath="/kms/wiki/" 
					modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
					autoFetch="false"
					target="_blank"
					categoryId="${kmsWikiMainForm.docCategoryId}" />
			</ui:combin>
	</template:replace>
	<%-- 内容 --%>
	<template:replace name="content">
			<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do">
				<ui:step  id="__step" style="background-color:#f2f2f2" onSubmit="submitMethod('20');">
					<%-- 基本信息--%>
					<ui:content title="${lfn:message('kms-wiki:kmsWiki.stepBaseInfo')}">
						<table class="tb_simple" width="100%" id="validate_ele0">
							<%-- 词条名称 --%>
							<tr>
								<td class="td_normal_title" width="15%">
									<bean:message bundle="kms-wiki" key="kmsWikiMain.docSubject"/>
								</td>		
								<td colspan="3" width="85%">
									<xform:text   
										property="docSubject"  className="inputsgl" style="width:97%;" /> 
								</td>
							</tr>
							
							<tr>
								<%--主分类分类 --%>
								<td class="td_normal_title" width="15%">
									<bean:message bundle="kms-wiki" key="kmsWiki.fdCategoryHost"/>
								</td>
								<td  width="85%" colspan="3">
									<html:hidden property="docCategoryId" /> 
									<html:hidden property="docCategoryName"/>
									<bean:write	name="kmsWikiMainForm" property="docCategoryName" />
										&nbsp;&nbsp;
										<a href="javascript:changeDocCate('com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',true, true);" class="com_btn_link">
											<bean:message key="kmsWiki.cateChange" bundle="kms-wiki" /> 
										</a>
										<span class="txtstrong">*</span>
								</td>
							</tr>
							<tr>
								<%--目录模板 --%>
								<td class="td_normal_title" width="15%">
									<bean:message bundle="kms-wiki" key="kmsWiki.fdTagetTemplate"/>
								</td>
								<td  width="85%" colspan="3">
									<xform:dialog propertyId="fdTemplateId" propertyName="fdTemplateName"  style="width:98%">
											Dialog_List(false, 'fdTemplateId', 'fdTemplateName', null, 'KmsWikiTemplateTree&type=child',callBackTemplateAction ,'KmsWikiTemplateTree&type=search&key=!{keyword}', null, null, '<bean:message  bundle="kms-wiki" key="table.kmsWikiTemplate"/>');
									</xform:dialog>
								</td>
							</tr>
							<%--辅分类 --%>
							<tr>
								<td class="td_normal_title" width="15%">
									<bean:message bundle="kms-wiki" key="kmsWiki.fdCategoryHelp"/>
								</td>
								<td  colspan="3" width="85%">
									<xform:dialog propertyId="docSecondCategoriesIds" propertyName="docSecondCategoriesNames"  style="width:98%" 
									dialogJs="changeDocCate_h('com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',true);">				
									</xform:dialog>
								</td>
							</tr>
							<%-- 作者类型 文档作者 --%>
							<tr>
								<td width="15%" class="td_normal_title">
									<bean:message bundle="kms-wiki" key="kmsWiki.stepAuthor" />
								</td>
								<td width="35%">
									<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsWikiMainForm.docAuthorId?1:2}">
										<xform:enumsDataSource enumsType="kmsKnowledgeAuthorType">
										</xform:enumsDataSource>
									</xform:radio>
								</td>
								<td class="td_normal_title" width="15%">
									<bean:message bundle="kms-wiki" key="kmsWikiMain.fdAutherName"/>
								</td>
								<td width="35%" id="innerAuthor" <c:if test="${empty kmsWikiMainForm.docAuthorId }">style="display: none;"</c:if> >
									<xform:address 
										required="true" 
										style="width:95%"
									    propertyId="docAuthorId" 
									    propertyName="docAuthorName" 
									    orgType='ORG_TYPE_PERSON' 
									    subject="${lfn:message('kms-wiki:kmsWikiMain.fdAutherName') }"
									    onValueChange="changeAuthodInfo">
									 </xform:address>
								</td>
								<td width="35%" id="outerAuthor" <c:if test="${not empty kmsWikiMainForm.docAuthorId }">style="display: none;"</c:if>>
									<xform:text 
										property="outerAuthor" 
										style="width:94%" 
										subject="${lfn:message('kms-wiki:kmsWikiMain.fdAutherName') }">
									</xform:text>
								</td> 
							</tr>
							<tr>
								<td width="15%" class="td_normal_title">
								<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
								</td>
								<td width="35%" >
									<xform:address required="false"  isLoadDataDict="false" style="width:95%" propertyId="docDeptId" propertyName="docDeptName" orgType='ORG_TYPE_ORGORDEPT' subject="${lfn:message('sys-doc:sysDocBaseInfo.docDept')}"></xform:address>
								</td>
								<!-- 所属岗位 -->
								<td width="15%" class="td_normal_title">
									<bean:message bundle="kms-wiki" key="kmsWiki.mainPost" />
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
						</table>
					</ui:content>
					<%-- 填写内容 --%>
					<ui:content title="${lfn:message('kms-wiki:kmsWiki.stepContent')}" >
						<div id="validate_ele1">
							<%--标题 --%>
							<div class="lui_wiki_docTitle">
								<span id="title_span" class="lui_form_subject">
								</span>
							</div>
							<div id="catelogTree">
							<%-- 段落 --%>
								<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="varStatus">
									<div class="lui_wiki_clear"></div>
									<div id="catelogChild_${kmsWikiCatelogForm.fdId}">	
										<div class="lui_wiki_catelog clearfloat"  id="catelog_${kmsWikiCatelogForm.fdId}">
											<div class="lui_wiki_title_c ">
												<c:out value="${kmsWikiCatelogForm.fdName}"/>
											</div>
											<div class="lui_wiki_editparagraph" onclick="openEdit(this);return false;">
												<span  id="${kmsWikiCatelogForm.fdId}">
													<bean:message bundle="kms-wiki" key="kmsWiki.editParagraph"/>
												</span>
											</div>
										</div>
										<div class="lui_wiki_content" id="editable_${kmsWikiCatelogForm.fdId}">
												<div id="replace_${kmsWikiCatelogForm.fdId}" class="lui_wiki_content_catelog">
													${kmsWikiCatelogForm.docContent}
												</div>
												<html:hidden property="fdCatelogList[${varStatus.index}].fdId" />
												<html:hidden property="fdCatelogList[${varStatus.index}].fdName" />
												<html:hidden property="fdCatelogList[${varStatus.index}].fdOrder" />
												<html:hidden property="fdCatelogList[${varStatus.index}].fdMainId"/>
												<html:hidden property="fdCatelogList[${varStatus.index}].fdParentId" />
												<html:hidden property="fdCatelogList[${varStatus.index}].docContent"/>
												<html:hidden property="fdCatelogList[${varStatus.index}].authEditorIds"/>
												<html:hidden property="fdCatelogList[${varStatus.index}].authEditorNames"/>
										</div>
								</div>
							</c:forEach>
						</div>
						<div class="lui_wiki_clear"></div>
						<%-- 文件附件 --%>
						<div class="lui_wiki_catelog" style="border-bottom: 1px dotted #909090">
							<div class="lui_wiki_title">
								<bean:message bundle="kms-wiki" key="kmsWiki.attachment"/>
							</div>
						</div>
						<div class="lui_wiki_content">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment" />
								<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
							</c:import>
						</div>
						</div>
					</ui:content>
					<%--完善知识属性 --%>
					<ui:content title="${lfn:message('kms-wiki:kmsWiki.stepPropertyEdit')}" >
					 <div id="validate_ele2">
						<%-- 百科名片 --%>
						<div class="lui_wiki_catelog">
							<div class="lui_wiki_title">
								<bean:message bundle="kms-wiki" key="kmsWiki.wikiCard"/>
							</div>
						</div>
						<div class="lui_wiki_content">
							<table width="97%" class="tb_simple">
								<tr>
									<td  width="28%" valign="top" >
										<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
											<c:param name="fdKey" value="spic"/>
											<c:param name="fdAttType" value="pic"/>
											<c:param name="fdShowMsg" value="true"/>
											<c:param name="fdMulti" value="false"/>
											<c:param name="fdModelId" value="${param.fdId }"/>
											<c:param name="fdModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain"/>
											<c:param name="fdLayoutType" value="pic"/>
											<c:param name="fdPicContentWidth" value="95%"/>
											<c:param name="fdPicContentHeight" value="158"/>
											<c:param name="fdViewType" value="pic_single"/>
											<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
										</c:import>
									</td>
									<td width="70%">
										<xform:textarea isLoadDataDict="false" validators="maxLength(1500)" property="fdDescription" style="width:100% ;height:160px" showStatus="edit"></xform:textarea>
									</td>
								</tr>
							</table>
						</div>
						<%--知识属性 --%>
						<div class="lui_wiki_catelog">
							<div class="lui_wiki_title">
								<bean:message bundle="kms-wiki" key="kmsWiki.stepProperty"/>
							</div>
						</div>
						<div class="lui_wiki_content">
								<table width="100%" class="tb_simple">
									<%--属性 --%>
									<c:if test="${not empty kmsWikiMainForm.extendFilePath}">
											<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
												<c:param name="formName" value="kmsWikiMainForm" />
											</c:import>
									</c:if>
									<!-- 标签机制（知识标签） -->
									<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
										<c:param name="formName" value="kmsWikiMainForm" />
										<c:param name="fdKey" value="wikiMain" /> 
										<c:param name="fdQueryCondition" value="docSubject" /> 
									</c:import>
								</table>
						 </div>
						</div>
					</ui:content>
					<%-- 权限及流程 --%>
					<ui:content title="${lfn:message('kms-wiki:kmsWiki.stepRightAndWorkflow')}">
						<c:import url="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_rightAndWorkflow_add.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="moduleModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
							<c:param name="fdKey" value="mainDoc" />
						</c:import>	
							<%---发布机制---%>
						<div style="display: none">
						<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="mainDocPublish" />	 
							<c:param name="isShow" value="true" />
						</c:import> 
						</div>			
					</ui:content>
				</ui:step>
				<input type="hidden" name="methodType" />
				<input type="hidden" name="fdOptionType" value="add" />
				<html:hidden property="fdTemplateId" />
				<html:hidden property="fdId" />
				<html:hidden property="fdHtmlContent" />
				<html:hidden property="fdVersion" />
				<html:hidden property="fdLastEdition" />
				<html:hidden property="fdFirstId" /> 
				<html:hidden property="docCreatorId" />
				<html:hidden property="docCreateTime" />
				<html:hidden property="docAlterorId" />
				<html:hidden property="docAlterTime" />
				
				<html:hidden property="docStatus" />
				<html:hidden property="method_GET" />
				<html:hidden property="extendFilePath" />
				<html:hidden property="extendDataXML" />
			</html:form>
	</template:replace>
	<%--右边信息 --%>
	<template:replace name="nav">
		<%--对齐左边 --%>
		<div style="min-height:74px;"></div>				
		<%--至少200px，防止内容宽度过小导致信息便签缩小,最大也是200px --%>
		<div style="min-width:200px;"></div>
		<%--基本信息 --%>
		<ui:accordionpanel channel="baseInfo_right"  toggle="false">
			<ui:content id="baseInfo_right_id" title="${lfn:message('kms-wiki:kmsWiki.rightInfo.baseInfo')}">
				<ul class="lui_wiki_catelogUl">
					<li>
						<bean:message bundle="kms-wiki" key="kmsWikiMain.docCreator"/> : 
						<ui:person personId="${kmsWikiMainForm.docCreatorId }" personName="${kmsWikiMainForm.docCreatorName }"/>
					</li>
					<li>
						<bean:message bundle="kms-wiki" key="kmsWikiMain.creatDate"/>:
						<xform:text property="docCreateTime" showStatus="view"/>
					</li>
					<li>
						<bean:message bundle="kms-wiki" key="kmsWikiMain.docStatus"/>:
						<bean:message bundle="kms-wiki" key="kmsWikiMain.fdLastEdition_0"/>
					</li>
				</ul>
			</ui:content>				
		</ui:accordionpanel>
		<div style="min-height:15px;"></div>
		<div class="lui_wiki_hideDiv" id="r_info">	
			<%-- 目录信息和编辑规范 --%>
			<ui:panel toggle="false">
				<ui:content title="${lfn:message('kms-wiki:kmsWiki.catelogInfo')}">
					<ui:tabpanel>
						<ui:layout type="Template">
							<c:import url="/kms/wiki/kms_wiki_main_ui/kms_wiki_catelog_tabpanel.tmpl" charEncoding="UTF-8"></c:import>
						</ui:layout>
						<ui:content title="${lfn:message('kms-wiki:kmsWiki.catelogInfo')}" style="border-top: 1px solid #c1c1c1;">
							<c:if test="${empty param.catelogId}">
							<%--编辑段落时不能编辑目录 --%>
								<div class="lui_wiki_catelog_edit" onclick="editCatelog()">
									<bean:message bundle="kms-wiki" key="kmsWiki.editCatelog"/>
								</div>
							</c:if>
							<ul class="lui_wiki_catelogUl" id="catelogUl">
								<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="varStatuses">
									<li class="right_selectLi">
										<a class="lui_catelog_dot" href="#catelogChild_${kmsWikiCatelogForm.fdId}">
											<c:out value="${kmsWikiCatelogForm.fdName}"/>
										</a>
										<div id="viewable_${kmsWikiCatelogForm.fdId}"></div>
									</li>
								</c:forEach>
							</ul>
						</ui:content>
					<%--<ui:content title="${lfn:message('kms-wiki:kmsWiki.editRule')}" style="border-top: 1px solid #c1c1c1;">
							<div style="text-indent:2em" id="wiki_description">
								<c:out value="${kmsWikiMainForm.fdTemplateDescription}"/>
							</div>
						</ui:content>--%>  
					</ui:tabpanel>
				</ui:content>
			</ui:panel>
			<div style="min-height:15px;"></div>
		</div>
		<%--关联机制--%>                             
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmsWikiMainForm" />
		</c:import>
	</template:replace>
</template:include >
<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_add_js.jsp"%>
