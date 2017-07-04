<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/style/edit.css">
	</template:replace>
	<%-- 标题 --%>
	<template:replace name="title">
		<%-- 编辑词条 --%>
		<c:if test="${editType=='edit'}">
			<c:out value="${kmsWikiMainForm.docSubject}-${lfn:message('kms-wiki:kmsWikiMain.editor.update')}"/>
		</c:if>
		<%--完善词条 --%>
		<c:if test="${editType=='addVersion'}">
			<c:out value="${kmsWikiMainForm.docSubject}-${lfn:message('kms-wiki:kmswiki.addVersion.title')}"/>
		</c:if>
	</template:replace>
	<%-- 按钮 --%>
	<template:replace name="toolbar">
		<c:set var="catelogIdval" value="${param.catelogId}"></c:set>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<c:when test="${ editType == 'edit' }">
					<c:if test="${kmsWikiMainForm.docStatusFirstDigit>='3'}">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmsWikiMainForm, 'update');">
						</ui:button>
					</c:if>
					<c:if test="${kmsWikiMainForm.docStatusFirstDigit<'3'}">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="editStatus('20');Com_Submit(document.kmsWikiMainForm, 'update');">
						</ui:button>
					</c:if>
					<!-- 草稿、驳回可暂存 -->
					<c:if test="${kmsWikiMainForm.docStatusFirstDigit=='1'}">
						<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="editStatus('10');saveDraft('update')">
						</ui:button>
					</c:if>			
				</c:when>
				<c:when test="${ editType == 'addVersion' }">
					<!-- 完善词条时的暂存 -->
					<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="editStatus('10');saveDraft('save');">
					</ui:button>
					<!-- 完善词条时的提交 -->
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="editStatus('20');Com_Submit(document.kmsWikiMainForm, 'save');">
					</ui:button>
					<c:if test="${not empty catelogIdval}">
						<ui:button text="预览词条" onclick="preview();" id="preview" order="2"></ui:button>
					</c:if>
				</c:when>
				<c:when test="${ editType == 'add' }">	
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="submitMethod('20')">
					</ui:button>
					<!-- 暂存 -->
					<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="submitMethod('10')">
					</ui:button>
				</c:when>
			</c:choose>
			<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();">
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
					<c:if test='${empty catelogIdval}'>
					<%-- 基本信息,不折叠 --%>
						<div class="lui_form_content_frame" style="padding: 8px;">
							<table class="tb_simple" width="100%">
								<%-- 词条名称 --%>
								<tr>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="kms-wiki" key="kmsWikiMain.docSubject"/>
									</td>		
									<td colspan="3" width="85%">
										<c:if test="${ editType != 'add' }">
										<html:hidden property="docSubject"/>
										<bean:write	name="kmsWikiMainForm" property="docSubject" />
										</c:if>
										<c:if test="${ editType == 'add' }">
									 	   <xform:text property="docSubject"  className="inputsgl" style="width:97%;" /> 
										</c:if>
									</td>
								</tr>
								<%--所属分类 --%>
								<tr>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="kms-wiki" key="kmsWikiMain.fdCategoryList"/>
									</td>
									<td  width="35%">
										<html:hidden property="docCategoryId" />
										<html:hidden property="docCategoryName" />
										<bean:write	name="kmsWikiMainForm" property="docCategoryName" />
									</td>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="kms-wiki" key="kmsWiki.fdCategoryHelp"/>
									</td>
									<td   width="35%">
										<xform:dialog propertyId="docSecondCategoriesIds" propertyName="docSecondCategoriesNames"  style="width:95%" 
										dialogJs="changeDocCate_h('com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',true);" showStatus="edit">				
										</xform:dialog>
									</td>
								</tr>
								<%--所属模板 
								<tr>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="kms-wiki" key="kmsWikiMain.fdTemplate"/>
									</td>
									<td colspan="3" width="85%">
										<html:hidden property="fdTemplateId" />
										<html:hidden property="fdTemplateName" />
										<bean:write	name="kmsWikiMainForm" property="fdTemplateName" />
									</td>
								</tr>--%>
								<!-- 标签机制（知识标签） -->
								<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmsWikiMainForm" />
									<c:param name="fdKey" value="wikiMain" /> 
									<c:param name="fdQueryCondition" value="docSubject" /> 
								</c:import>
								<%-- 作者类型 文档作者 --%>
								<tr>
									<%-- 作者类型 --%>
									<td width="15%" class="td_normal_title">
										<bean:message bundle="kms-wiki" key="kmsWiki.stepAuthor" />
									</td>
									<td width="35%">
										<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsWikiMainForm.docAuthorId?1:2}">
											<xform:enumsDataSource enumsType="kmsKnowledgeAuthorType">
											</xform:enumsDataSource>
										</xform:radio>
									</td>
									<%-- 文档作者 --%>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="kms-wiki" key="kmsWikiMain.fdAutherName"/>
									</td>
									<!-- 内部作者 -->
									<td width="35%" id="innerAuthor" <c:if test="${empty kmsWikiMainForm.docAuthorId }">style="display: none;"</c:if> >
										<c:if test="${empty kmsWikiMainForm.docAuthorId }">
											<xform:address  isLoadDataDict="false" style="width:95%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'  subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:address>
										</c:if>
										<c:if test="${not empty kmsWikiMainForm.docAuthorId }">
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
									<td width="35%" id="outerAuthor" <c:if test="${not empty kmsWikiMainForm.docAuthorId }">style="display: none;"</c:if>>
										<c:if test="${not empty kmsWikiMainForm.docAuthorId }">
											<xform:text property="outerAuthor"  style="width:95%" subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:text>
										</c:if>
										<c:if test="${empty kmsWikiMainForm.docAuthorId }">
											<xform:text property="outerAuthor"   required="true" style="width:95%" subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:text>
										</c:if>
									</td>
								</tr>
								<tr>
									<!-- 所属部门 -->
									<td width="15%" class="td_normal_title">
										<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
									</td>
									<td width="35%" >
										<xform:address 
											subject="${lfn:message('sys-doc:sysDocBaseInfo.docDept')}" 
											required="false" 
											validators="" 
											style="width:95%" 
											propertyId="docDeptId" 
											propertyName="docDeptName" 
											orgType='ORG_TYPE_ORGORDEPT' 
											showStatus="edit">
										</xform:address>
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
						</div>
					
						<div style="padding: 10px;">
							<%-- 百科名片 --%>
							<div class="lui_wiki_catelog">
								<div class="lui_wiki_title">
									<bean:message bundle="kms-wiki" key="kmsWiki.wikiCard"/>
								</div>
							</div>
							<div class="lui_wiki_content">
								<table width="98%" class="tb_simple">
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
										<td width="72%">
											<xform:textarea isLoadDataDict="false" validators="maxLength(1500)" property="fdDescription" style="width:100% ;height:160px" showStatus="edit"></xform:textarea>
										</td>
									</tr>
								</table>
							</div>
						</div>
						</c:if>
						<c:if test='${not empty catelogIdval}'>
							<html:hidden property="docSubject" />
							<html:hidden property="docCategoryId" />
							<html:hidden property="docCategoryName" />
							<html:hidden property="docSecondCategoriesIds"/>
							<html:hidden property="docSecondCategoriesNames"/>
							<html:hidden property="fdTemplateId" />
							<html:hidden property="fdTemplateName" />
							<html:hidden property="docAuthorId"/>
							<html:hidden property="outerAuthor"/>
							<html:hidden property="docDeptId"/>
							<html:hidden property="docDeptName"/>
							<html:hidden property="sysTagMainForm.fdId"/> 
							<html:hidden property="sysTagMainForm.fdKey" value="wikiMain"/>
							<html:hidden property="sysTagMainForm.fdModelName"/>
							<html:hidden property="sysTagMainForm.fdModelId"/> 
							<html:hidden property="sysTagMainForm.fdQueryCondition"/> 
							<html:hidden property="sysTagMainForm.fdTagNames"/>
							<input type="hidden" name="sysTagMainForm.fdTagIds" />
							<c:set var="_display" value="none"/>
							<c:set var="cardPicURL" value="${ LUI_ContextPath}/kms/wiki/resource/images/header_r.gif" />
							<c:set var="attForms" value="${kmsWikiMainForm.attachmentForms['spic'] }" />
							<c:set var="hasPic" value="${false}"/>
							<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
								<c:if test="${vsStatus.first }">
									<c:set var="fdAttId" value="${sysAttMain.fdId }" />
									<c:set var="hasPic" value="${true}"/>
									<c:set var="cardPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
								</c:if>
							</c:forEach>
							<div class="lui_form_subject lui_wiki_edit_p" style="display:${_display }" >
								<c:out value="${kmsWikiMainForm.docSubject}"/>
							</div>
							<div  style="display:${_display }" class="lui_wiki_edit_p">
								 <c:if test="${not empty kmsWikiMainForm.fdDescription || not empty fdAttId}">
									<div class="lui_form_summary_frame">
										<table width="100%">
											<tr>
												<td width="15%" style="padding:12px;" valign="top"> 
												   <c:if test="${hasPic == true}">
														<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
															<c:param name="formBeanName" value="kmsWikiMainForm" />
															<c:param name="fdKey" value="spic" />
															<c:param name="fdAttType" value="pic" />
															<c:param name="fdShowMsg" value="false" />
															<c:param name="fdMulti" value="false"/>
															<c:param name="fdModelId" value="${param.fdId }"/>
															<c:param name="fdModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain"/>
															<c:param name="fdLayoutType" value="pic"/>
															<c:param name="fdPicContentWidth" value="150"/>
															<c:param name="fdPicContentHeight" value="200"/>
															<c:param name="fdViewType" value="pic_single"/>
															<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
														</c:import>
													</c:if>
													<c:if test="${hasPic==false }">
														<div  class="lui_wiki_cardPic" style="height: 200px;width:150px;">
															<img id="cardPic" src="${cardPicURL }" >
														</div>
													</c:if>
												</td>
												<td valign="top" style="padding:12px 0px;text-indent:2em;">
														<c:out value="${kmsWikiMainForm.fdDescription}"/>
														<html:hidden property="fdDescription"/>
												</td>
											</tr>
										</table>
									</div>
								</c:if>
							</div>
						</c:if>
						<div style="padding: 10px;">
						<div id="catelogTree">
						<%-- 段落 --%>
							<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="varStatus">
								<div class="lui_wiki_clear"></div>
								<div id="catelogChild_${kmsWikiCatelogForm.fdId}" style="display:${_display }" class="lui_wiki_edit_p">	
									<div class="lui_wiki_catelog clearfloat"  id="catelog_${kmsWikiCatelogForm.fdId}">
										<div class="lui_wiki_title">
											<c:out value="${kmsWikiCatelogForm.fdName}"/>
										</div>
										<c:if test="${editType=='addVersion'}">
											<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdParentId}&catelogId=${kmsWikiCatelogForm.fdParentId}" requestMethod="GET">
												<div class="lui_wiki_editparagraph com_subject" onclick="openEdit(this);return false;">
													<span  id="${kmsWikiCatelogForm.fdId}">
														<bean:message bundle="kms-wiki" key="kmsWiki.editParagraph"/>
													</span>
												</div>
											</kmss:auth>
										</c:if>
										<c:if test="${editType=='edit'||editType=='add'}">
											<div class="lui_wiki_editparagraph com_subject" onclick="openEdit(this);return false;">
												<span  id="${kmsWikiCatelogForm.fdId}">
													<bean:message bundle="kms-wiki" key="kmsWiki.editParagraph"/>
												</span>
											</div>
										</c:if>
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
						<%-- 文件附件 --%>
						<table class="tb_simple" width="100%" style="display:${_display }">
							<tr>
								<td width="15%" class="td_normal_title" valign="top">
									<bean:message	bundle="kms-wiki"	key="kmsWiki.attachement" /></td>
								<td
									width="85%"
									colspan="3">
									<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
										<c:param name="fdKey" value="attachment" />
										<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'180','h':'150'},{'name':'s2','w':'350','h':'350'}]}" />
									</c:import>
								</td>
							</tr> 
						</table>
						<%--修改原因 --%>
						<c:if test="${editType == 'addVersion' }">
							<div class="lui_wiki_catelog" style="border-bottom: 1px dotted #909090">
								<div class="lui_wiki_title">
									<bean:message bundle="kms-wiki" key="kmsWiki.reason"/>
								</div>
							</div>
							<div class="lui_wiki_content">
								<table width="100%"><tr><td >
							  	 <xform:textarea property="fdReason" style="width:100%" showStatus="edit" validators="required maxLength(600)" isLoadDataDict="false" subject="${lfn:message('kms-wiki:kmsWikiMain.fdReason') }"/>
								</td></tr></table>
							</div>
						</c:if>
					</div>
				<ui:tabpage expand="false">
					<%--文档属性 --%>
					<c:if test="${not empty kmsWikiMainForm.extendFilePath}">
						<ui:content id="validate_ele2" title="${lfn:message('kms-wiki:kmsWikiMain.docProperty') }">
							<table class="tb_simple" width="100%">
								<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmsWikiMainForm" />
								</c:import>
							</table>
						</ui:content>
					</c:if>
					<%--权限机制 --%>
					<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
						<c:param name="moduleModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
					</c:import>
					<%--流程机制 --%>
					<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
						<c:param name="fdKey" value="mainDoc" />
					</c:import>
					<%---发布机制---%>
					<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="mainDocPublish" />	 
							<c:param name="isShow" value="true" />
					</c:import> 
				</ui:tabpage>
				
				<html:hidden property="fdTemplateId" />
				<html:hidden property="fdId" />
				<html:hidden property="docReadCount" />
				<html:hidden property="docIntrCount" />
				<html:hidden property="fdHtmlContent" />
				<html:hidden property="fdParentId" />
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
				<html:hidden property="docSourceId" />
				
				<!-- 记录被删除的段落点评-->
				<input name="wikiEvaIds" value="" type="hidden"/>
			</html:form>
	</template:replace>
	<%--右边信息 --%>
	<template:replace name="nav">
		<%--至少200px，防止内容宽度过小导致信息便签缩小,最大也是200px --%>
		<div style="min-width:200px;"></div>
		<%-- 目录信息 --%>
		<ui:panel toggle="false">
			<ui:content title="${lfn:message('kms-wiki:kmsWiki.catelogInfo')}" >
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
		</ui:panel>
		<div style="min-height:15px;"></div>
		<%-- 编辑规范 
		<ui:panel toggle="false">
			<ui:content title="${lfn:message('kms-wiki:kmsWiki.editRule')}" >
				<div style="text-indent:2em">
					<c:out value="${kmsWikiMainForm.fdTemplateDescription}"/>
				</div>
			</ui:content>
		</ui:panel>--%>
		<div style="min-height:15px;"></div>
		<%--关联机制--%>
	
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmsWikiMainForm" />
		</c:import>
	</template:replace>
</template:include >
<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_edit_js.jsp"%>
<script type="text/javascript">
	$KMSSValidation(document.forms['kmsWikiMainForm']);
	if (Com_Parameter.event["submit"]) {
		Com_Parameter.event["submit"].unshift(submitDocContent);
	}
</script>