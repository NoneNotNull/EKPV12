<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css"
			href="${ LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/style/view.css" />
		<c:set var="attForms"
			value="${kmsWikiMainForm.attachmentForms['spic'] }" />
		<c:set var="hasPic" value="${false}" />
		<c:forEach var="sysAttMain" items="${attForms.attachments }"
			varStatus="vsStatus">
			<c:if test="${vsStatus.first }">
				<c:set var="hasPic" value="${true}" />
			</c:if>
		</c:forEach>
		<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_view_js.jsp"%>
	</template:replace>
	<%--标题 --%>
	<template:replace name="title">
		<c:out value="${kmsWikiMainForm.docSubject }" />
	</template:replace>
	<%--按钮 --%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="4">
			<c:if test="${kmsWikiMainForm.docStatus != '50'}">
				<!-- 收藏 -->
				<c:import url="/sys/bookmark/import/bookmark_bar.jsp"
					charEncoding="UTF-8">
					<c:param name="fdSubject" value="${kmsWikiMainForm.docSubject}" />
					<c:param name="fdModelId" value="${kmsWikiMainForm.fdId}" />
					<c:param name="fdModelName"
						value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
				</c:import>
				<%--编辑 --%>
				<kmss:auth
						requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=edit&fdId=${kmsWikiMainForm.fdId}"
						requestMethod="GET">
						<ui:button order="2" text="${lfn:message('button.edit') }"
							onclick="Com_OpenWindow('kmsWikiMain.do?method=edit&fdId=${kmsWikiMainForm.fdId}','_self');" />
				</kmss:auth>
				<kmss:auth
					requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=updateTag&fdId=${kmsWikiMainForm.fdId}"
					requestMethod="GET">
					<c:set var="addTag" value="false" />
					<c:set var="editTag" value="true" />
				</kmss:auth>
				<!-- 添加标签 -->
				<c:if test="${'false' != addTag}">
					<ui:button text="${lfn:message('kms-wiki:kmsWiki.addTag') }"
						onclick="addTags(3);return false;" order="3"/>
				</c:if>
				<!-- 调整标签 -->
				<c:if test="${'true' == editTag}">
					<ui:button text="${lfn:message('kms-wiki:kmsWiki.editTag') }"
						onclick="addTags(2);return false;" order="3"/>
				</c:if>
				<%--纠错 --%>
				<kmss:auth
					requestURL="/kms/wiki/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=changeErrorCorrection&fdId=${kmsWikiMainForm.fdId}&fdModelName=com.landray.kmss.kms.wiki.model.KmsWikiMain"
					requestMethod="GET">				
			   		<ui:button parentId="toolbar" text="${ lfn:message('kms-common:kmsCommonDocErrorCorrection.error') }" 
						 onclick="changeErrorCorrection();" order="3">
					</ui:button>
				</kmss:auth>
				<%-- 分类转移 --%>
				<c:import url="/sys/simplecategory/import/doc_cate_change_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdMmodelName"
						value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
					<c:param name="docFkName" value="docCategory" />
					<c:param name="fdCateModelName"
						value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
					<c:param name="fdMmodelId" value="${kmsWikiMainForm.fdId }" />
					<c:param name="fdCategoryId"
						value="${kmsWikiMainForm.docCategoryId }" />
					<c:param name="extProps" value="fdTemplateType:2;fdTemplateType:3" />
				</c:import>
				<%-- 权限变更--%>
				<c:import url="/sys/right/import/doc_right_change_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdModelName"
						value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
					<c:param name="fdCategoryId"
						value="${kmsWikiMainForm.docCategoryId }" />
					<c:param name="fdModelId" value="${kmsWikiMainForm.fdId }" />
				</c:import>
				<!-- 调整属性-->
				<c:if test="${not empty kmsWikiMainForm.extendFilePath}">
					<kmss:auth
						requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=editProperty&fdId=${kmsWikiMainForm.fdId}"
						requestMethod="GET">
						<ui:button
							text="${lfn:message('kms-wiki:kmsWiki.button.editProperty') }"
							onclick="editProperty();return false;"  order="4"/>
					</kmss:auth>
				</c:if>
			</c:if>
			<!-- 完善词条 -->
			<c:if
				test="${kmsWikiMainForm.fdLastEdition == '2' && fdHasNewVersion == 'false' && kmsWikiMainForm.docStatus == '30'}">
				<kmss:auth
					requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdId=${kmsWikiMainForm.fdId}&fdParentId=${kmsWikiMainForm.fdId}"
					requestMethod="GET">
					<ui:button
						text="${lfn:message('kms-wiki:kmswiki.addVersion.title') }"
						order="3"
						onclick="Com_OpenWindow('kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdId}','_self');" />
				</kmss:auth>
			</c:if>
			<!-- 置顶 -->
			<c:if test="${kmsWikiMainForm.fdSetTopTime==null && kmsWikiMainForm.docStatus == '30' && kmsWikiMainForm.fdLastEdition == '2'}">
				<kmss:auth
					requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=setTop&local=view&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('kms-wiki:kmsWiki.setTop')}"
						onclick="setTop();"  order="4"/>
				</kmss:auth>
			</c:if>
			<!-- 取消置顶 -->
			<c:if test="${kmsWikiMainForm.fdSetTopTime!=null}">
				<c:choose>
					<c:when test="${kmsWikiMainForm.docIsIndexTop == null}">
						<kmss:auth
							requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=cancelTop&local=view&fdId=${param.fdId}"
							requestMethod="GET">
							<ui:button text="${lfn:message('kms-wiki:kmsWiki.cancelSetTop')}"
								onclick="cancelTop();" order="4"/>
						</kmss:auth>
					</c:when>
					<c:otherwise>
						<kmss:auth
							requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=cancelTop&local=index&fdId=${param.fdId}"
							requestMethod="GET">
							<ui:button text="${lfn:message('kms-wiki:kmsWiki.cancelSetTop')}"
								onclick="cancelTop();" order="4"/>
						</kmss:auth>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${kmsWikiMainForm.fdLastEdition != '1'}">
				<c:if test="${kmsWikiMainForm.docStatus == '30'}">
					<kmss:auth
							requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=recycle&fdId=${kmsWikiMainForm.fdId}"
							requestMethod="GET">
						<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recycle') }" 
								   onclick="confirmRecycle()" order="4"/>
					</kmss:auth>
				</c:if>
				<kmss:auth
					requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=delete&fdId=${kmsWikiMainForm.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}"
						onclick="checkDelete()" order="4" />
				</kmss:auth>
			</c:if>
			<c:if test="${kmsWikiMainForm.docStatus == '50'}">
				<kmss:auth
						requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=recover&fdId=${kmsWikiMainForm.fdId}"
						requestMethod="GET">
					<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recover') }" 
								onclick="confirmRecover()" order="4"/>
				</kmss:auth>
			</c:if>
			<!--解锁词条-->
			<c:if test='${isLock }'>
				<kmss:auth
					requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=updateUnlock">
					<ui:button text="${lfn:message('kms-wiki:kmsWikiMain.unlock') }"
						onclick="unlockWiki();return false;" id="unlockWiki" order="4"/>
				</kmss:auth>
			</c:if>
			<!-- 关闭 -->
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<%--路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams
				moduleTitle="${ lfn:message('kms-wiki:moudle.name.kmsWiki') }"
				modulePath="/kms/wiki/"
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory"
				autoFetch="false" target="_blank" href="/kms/wiki/"
				categoryId="${kmsWikiMainForm.docCategoryId}" />
		</ui:combin>
	</template:replace>
	<%--内容 --%>
	<template:replace name="content">
		<div class='lui_form_title_frame'><%--词条名 --%>
		<div class="lui_form_subject"><c:out
			value="${kmsWikiMainForm.docSubject}" /> 
			<c:if test="${isHasNewVersion=='true'}">
			     <span style="color:red">(<bean:message bundle="kms-wiki" key="kmsWikiMain.title.has" />
			     <a href="javascript:;" style="font-size:18px;color:red" onclick="Com_OpenWindow('kmsWikiMain.do?method=view&fdId=${newVersionId}','_self');">
				 <bean:message bundle="kms-wiki" key="kmsWikiMain.title.NewVersion" /></a>)</span>
	        </c:if>
	        <c:if test="${kmsWikiMainForm.docStatus==50}">
			     <span style="color:red">(${lfn:message('kms-wiki:kmsWikiMain.has.deleted') })</span>
	        </c:if>
		        
			<%--词条是否被锁 --%> 
		<c:if	test='${isLock }'>
			<img alt=""
				src="${ LUI_ContextPath}/kms/wiki/resource/images/lock.gif">
		</c:if> <c:if test="${kmsWikiMainForm.docIsIntroduced==true}">
			<img src="${LUI_ContextPath}/kms/knowledge/resource/img/jing.gif"
				border=0
				title="${lfn:message('kms-knowledge:kmsKnowledge.introduced')}" />
		</c:if></div>
		<%--词条下面的基本信息 --%>
		<div class='lui_form_baseinfo'><!-- 文档作者 --> <bean:message
			bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />： <!-- 文档作者 --> <ui:person
			personId="${kmsWikiMainForm.docAuthorId}"
			personName="${kmsWikiMainForm.docAuthorName}">
		</ui:person> <!-- 外部作者 --> <span class="com_author"
			<c:if test="${not empty kmsWikiMainForm.docAuthorId }">style="display: none;"</c:if>>${kmsWikiMainForm.outerAuthor}</span>
			${publishTime }
		<!-- 点评次数 --> 
		<bean:message
			key="sysEvaluationMain.tab.evaluation.label" bundle="sys-evaluation" /><span
			data-lui-mark='sys.evaluation.fdEvaluateCount' class="com_number">${not empty kmsWikiMainForm.evaluationForm.fdEvaluateCount ? kmsWikiMainForm.evaluationForm.fdEvaluateCount : '(0)'}</span> 
		<!-- 推荐次数 --> 
		<bean:message
			key="sysIntroduceMain.tab.introduce.label" bundle="sys-introduce" /><span
			data-lui-mark="sys.introduce.fdIntroduceCount" class="com_number">(${not empty introduceCount ? introduceCount : 0})</span> 
		<!-- 阅读次数 --> 
		<bean:message
			key="sysReadLog.tab.readlog.label" bundle="sys-readlog" />
			<span data-lui-mark="sys.readlog.fdReadCount" class="com_number">(${kmsWikiMainForm.readLogForm.fdReadCount})</span>
		</div>
		</div>
		<c:if	test="${not empty kmsWikiMainForm.fdDescription}">
			<div style="height: 15px;"></div>
			<div class="lui_form_summary_frame">
				<c:out value="${kmsWikiMainForm.fdDescription}"/>
			</div>
		</c:if>
		<div id="lui-wiki-catalog" class="lui_wiki_catalog_top clearfloat">
			<div class="lui_wiki_catalog_border_top"></div>
			<div class="lui_wiki_catalog_title" style="float: left;">
				<i class="lui_wiki_catalog_title_icon"></i>
				<span class="lui_wiki_catalog_message"> <bean:message
					key="kmsWiki.catelogView" bundle="kms-wiki" /></span>
				<span style="display: inline-block;width:100%"></span>
			</div>
			<div id="wiki_catalog_content" class="clearfloat lui_wiki_catalog_content">
				
			</div>
			<div class="lui_wiki_catalog_border_bottom"></div>
		</div>
		
		<div class="lui_form_content_frame" style="text-indent: 0em;">
		
		<div id="_____rtf__temp_____${kmsWikiMainForm.fdId }"></div>
		<script>
			CKResize.addPropertyName('${kmsWikiMainForm.fdId }');
		</script>
		<div id="_____rtf_____${kmsWikiMainForm.fdId }" style="display: none;width: 100%">
			<table width="100%" style="overflow:hidden;">
				<%--内容 --%>
				<c:forEach items="${kmsWikiMainForm.fdCatelogList}"
					var="kmsWikiCatelogForm">
					<tr class="lui_wiki_tr_title">
						<%-- 目录标题 --%>
						<td class="lui_wiki_td_l"><span class="lui_wiki_catelog1">
						<c:out value="${kmsWikiCatelogForm.fdName}" /> </span></td>
						<%-- 编辑本段 --%>
						<c:if
							test="${kmsWikiMainForm.fdLastEdition == '2' && fdHasNewVersion == 'false'}">
							<td class="lui_wiki_td_r" valign="bottom">
								<kmss:auth
									requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdId}&catelogId=${kmsWikiCatelogForm.fdId}"
									requestMethod="GET">
									<span id="${kmsWikiCatelogForm.fdId}"
										class="lui_wiki_editParagraph com_subject"
										onclick="Com_OpenWindow('kmsWikiMain.do?method=addVersion&fdParentId=${kmsWikiMainForm.fdId}&catelogId=${kmsWikiCatelogForm.fdId}','_self');">
									<bean:message bundle="kms-wiki" key="kmsWiki.editParagraphView" />
									</span>
								</kmss:auth>
							</td>
	
						</c:if>
					</tr>
					<tr class="lui_wiki_catelog_content">
						<td colspan="2">
							<div>
								<div name="rtf_docContent" id="${kmsWikiCatelogForm.fdId}">
									${kmsWikiCatelogForm.docContent}
								</div>
							</div>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		
		<%--附件 --%> <c:if
			test="${not empty kmsWikiMainForm.attachmentForms['attachment'].attachments}">
			<table width="100%">
				<tr>
					<td width="15%" class="td_normal_title" valign="top"><bean:message
						bundle="kms-wiki" key="kmsWiki.attachement" /></td>
					<td width="85%" colspan="3"><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
						charEncoding="UTF-8">
						<c:param name="fdMulti" value="true" />
						<c:param name="formBeanName" value="kmsWikiMainForm" />
						<c:param name="fdKey" value="attachment" />
					</c:import></td>
				</tr>
			</table>
		</c:if></div>
		<ui:tabpage expand="false">
			<%--文档属性 --%>
			<c:if test="${not empty kmsWikiMainForm.extendFilePath}">
				<ui:content
					title="${lfn:message('kms-wiki:kmsWikiMain.docProperty') }">
					<table class="tb_simple" width="100%">
						<c:import url="/sys/property/include/sysProperty_edit.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="fdDocTemplateId"
								value="${kmsWikiMainForm.fdTemplateId}" />
						</c:import>
					</table>
				</ui:content>
			</c:if>
			<c:if
				test="${kmsWikiMainForm.docStatus == '30' && kmsWikiMainForm.docIsNewVersion == true }">
				<%--点评 --%>
				<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiEvaluationMain.jsp"%>
			</c:if>
			<c:if
				test="${kmsWikiMainForm.docStatus == '30' && kmsWikiMainForm.docIsNewVersion == true }">
				<%--推荐 --%>
				<c:import url="/sys/introduce/import/sysIntroduceMain_view.jsp"
					charEncoding="UTF-8">
					 <c:param name="fdCateModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
					<c:param name="formName" value="kmsWikiMainForm" />
					<c:param name="fdKey" value="wikiMain" />
					<c:param name="toEssence" value="true" />
					<c:param name="toNews" value="true" />
					<c:param name="docSubject" value="${kmsWikiMainForm.docSubject}" />
					<c:param name="docCreatorName"
						value="${kmsWikiMainForm.docCreatorName}" />
				</c:import>
			<%-- 纠错 --%>
			<ui:content
				title="${lfn:message('kms-common:kmsCommonDocErrorCorrection.notes') }${correctionCount}">
				<list:listview id="all_error" channel="all_error">
					<ui:source type="AjaxJson">
							{url:'/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=list&fdModelId=${param.fdId}&fdModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc&ordertype=down&rowsize=10'}
						</ui:source>
					<list:colTable layout="sys.ui.listview.columntable"
						rowHref="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=viewinfo&fdId=!{fdId}"
						style="" target="_blank" cfg-norecodeLayout="simple">
						<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
						<list:col-serial title="${ lfn:message('page.serial') }"
							headerStyle="width:5%"></list:col-serial>
						<list:col-html style="text-align:left" headerStyle="width:63%"
							title="${lfn:message('kms-common:kmsCommonDocErrorCorrection.fdCorrectionOpinions') }">
								{$ V{%row['docDescription']%} $}
						</list:col-html>
						<list:col-html headerStyle="width:10%"
							title="${lfn:message('kms-common:kmsCommonDocErrorCorrection.creatorName') }">
								{$ {%row['docCreator.fdName']%} $}
						</list:col-html>
						<list:col-html headerStyle="width:12%"
							title="${lfn:message('kms-common:kmsCommonDocErrorCorrection.correctionTime') }">
								{$ {%row['docCreateTime']%} $}
						</list:col-html>
						<kmss:auth requestURL="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=delete&fdModelName=com.landray.kmss.kms.wiki.model.KmsWikiMain&categoryId=${kmsWikiMainForm.docCategoryId}&fdId=${kmsWikiMainForm.fdId}" requestMethod="GET">
						<list:col-html headerStyle="width:10%"
							title=""> 
								{$  <a href="javascript:void(0)" onclick="delErrorCorrection( '{%row['fdId']%}' );">${lfn:message('button.delete') }</a> $}
						</list:col-html>
						</kmss:auth>
					</list:colTable>
				</list:listview>
				<div style="height: 15px;"></div>
				<list:paging layout="sys.ui.paging.simple" channel="all_error"></list:paging>
			</ui:content>
				   <%--发布机制 --%>
			<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsWikiMainForm" />
			</c:import> 
				<%--阅读信息 --%>
				<c:import url="/sys/readlog/import/sysReadLog_view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsWikiMainForm" />
				</c:import>
			</c:if>
			<%-- 版本 --%>
			<ui:content
				title="${lfn:message('sys-edition:sysEditionMain.tab.label') }">
				<div class="lui_wiki_editionCount">
				${lfn:message('kms-wiki:kmsWiki.total') } ${editionCount}
				${lfn:message('kms-wiki:kmsWiki.editionCount') }</div>
				<ui:toolbar id="toolbar1" style="float:right">
					<ui:button text="${lfn:message('kms-wiki:kmsWiki.compVersion') }"
						onclick="compareVersion()"></ui:button>
				</ui:toolbar>
				<list:listview id="listview_version" channel="new_edi">
					<ui:source type="AjaxJson">
							{url:'/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=listVersion&fdId=${param.fdId}&fdFirstId=${kmsWikiMainForm.fdFirstId}&docSubject=${kmsWikiMainForm.docSubject}&orderby=fdVersion&ordertype=down&rowsize=10'}
						</ui:source>
					<list:colTable layout="sys.ui.listview.columntable"
						rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&viewPattern=edition"
						style="" target="_blank">
						<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
						<list:col-serial title="${ lfn:message('page.serial') }"
							headerStyle="width:5%"></list:col-serial>
						<list:col-html headerStyle="width:7%"
							title="${lfn:message('kms-wiki:kmsWikiMain.fdVersion') }">
								{$ V{%row['fdVersion']%} $}
							</list:col-html>
						<list:col-html headerStyle="width:18%"
							title="${lfn:message('kms-wiki:kmsWiki.UpdateTime') }">
								{$ {%row['alterTime']%} $}
							</list:col-html>
						<list:col-html headerStyle="width:10%"
							title="${lfn:message('kms-wiki:kmsWiki.Updator') }">
								{$ {%row['docCreatorName']%} $}
							</list:col-html>
						<list:col-html headerStyle=""
							title="${lfn:message('kms-wiki:kmsWiki.UpdateReason') }">
								{$ {%row['fdReason']%} $}
							</list:col-html>
					</list:colTable>
				</list:listview>
				<div style="height: 15px;"></div>
				<list:paging layout="sys.ui.paging.simple" channel="new_edi"></list:paging>
			</ui:content>
			<%--权限 --%>
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsWikiMainForm" />
				<c:param name="moduleModelName"
					value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
			</c:import>
			<%--流程 --%>
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmsWikiMainForm" />
				<c:param name="fdKey" value="mainDoc" />
			</c:import>
		</ui:tabpage>
	</template:replace>
	<%--右边信息 --%>
	<template:replace name="nav">
			<c:if
				test="${hasPic == true}">
				<div style="width:100%;height:200px;margin-bottom: 20px;">
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formBeanName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="spic" />
							<c:param name="fdAttType" value="pic" />
							<c:param name="fdShowMsg" value="false" />
							<c:param name="fdMulti" value="false" />
							<c:param name="fdModelId" value="${param.fdId }" />
							<c:param name="fdModelName"
								value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
							<c:param name="fdLayoutType" value="pic" />
							<c:param name="fdPicContentWidth" value="98%" />
							<c:param name="fdPicContentHeight" value="200" />
							<c:param name="fdViewType" value="pic_single" />
						</c:import>
				</div>
			</c:if>
		<div style="min-width: 200px;"></div>
		<!-- 基本信息 -->
		<ui:accordionpanel toggle="false" style="min-width:200px;">
			<ui:content
				title="${lfn:message('kms-wiki:kmsWiki.rightInfo.baseInfo') }"
				toggle="false">
				<ul class="lui_wiki_baseInfo_ul">
				
					<li><bean:message bundle="kms-wiki"
						key="kmsWiki.view.thisCreator" /> : <ui:person
						personId="${kmsWikiMainForm.docCreatorId}"
						personName="${kmsWikiMainForm.docCreatorName}" /></li>
					<li>
						<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />：
						<c:out  value="${kmsWikiMainForm.docDeptName}" />
					</li>						
					<li><bean:message bundle="kms-wiki"
						key="kmsWikiMain.creatDate" /> : ${createTime}
					</li>
					<li><bean:message bundle="sys-doc"
						key="sysDocBaseInfo.docStatus" />： <sunbor:enumsShow
						value="${kmsWikiMainForm.docStatus}" enumsType="kms_doc_status" />
					</li>
					<li><bean:message bundle="kms-wiki"
						key="kmsWikiMain.fdVersion" /> : V${kmsWikiMainForm.fdVersion}</li>
					<li><bean:message bundle="kms-wiki"
						key="kmsWiki.rightInfo.addVersionTimes" /> : ${editCount}<bean:message
						bundle="kms-wiki" key="kmsWiki.rightInfo.times" /> <%--历史版本 --%> <%--
						<a href="javascript:void(0)" style="color:#56b0e4;text-decoration:underline;" onclick="viewAllVersion();">
							<bean:message bundle="kms-wiki" key="kmsWiki.rightInfo.historyVersion"/>
						</a> --%> <%-- 如果审批状态，增加与上一版本比较快捷键 --%> <c:if
						test="${not empty fdLastVersionId}">
						<a href="javascript:void(0)"
							onclick="compareLastVersion('${fdLastVersionId}')"
							style="margin-left: 5px; color: #56b0e4; text-decoration: underline;">
						<bean:message bundle="kms-wiki" key="kmsWIki.rightInfo.preVersion" />
						</a>
					</c:if></li>
					<c:if test="${not empty kmsWikiMainForm.docAlterTime}">
						<li><bean:message bundle="kms-wiki"
							key="kmsWiki.rightInfo.lastUpdateTime" /> :
						${alterTime}</li>
					</c:if>
					<c:if test="${editorSize == true}">
						<li><bean:message bundle="kms-wiki"
							key="kmsWiki.rightInfo.coEditor" /> : <c:forEach
							items="${editorList}" var="person" varStatus="varStatus">
							<ui:person personId="${person.fdId}"
								personName="${person.fdName}"></ui:person>
							<c:if test="${!varStatus.last }">；</c:if>
						</c:forEach></li>
					</c:if>
				</ul>
				<!-- 知识标签 -->
				<c:set var="sysTagMainForm"
					value="${requestScope['kmsWikiMainForm'].sysTagMainForm}" />
				<c:if test="${not empty sysTagMainForm.fdTagNames}">
					<div
						style='margin-left: -8px; margin-right: -8px; margin-bottom: 8px; border-bottom: 1px #bbb dashed; height: 8px'></div>
					<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
						<c:param name="useTab" value="false" />
					</c:import>
				</c:if>
			</ui:content>
			<!-- 分类信息 -->
			<ui:content
				title="${lfn:message('kms-wiki:kmsWiki.rightInfo.cateInfo') }"
				toggle="false">
				<ul class="lui_wiki_baseInfo_ul">
					<li><bean:message bundle="kms-wiki"
						key="kmsWiki.rightInfo.categoryHost" /> : <a
						href="javascript:void(0);"
						onclick="openCategoryIndex('${kmsWikiMainForm.docCategoryId}');">
					<c:out value="${kmsWikiMainForm.docCategoryName}" /> </a></li>
					<c:if test="${not empty categoryList[0]}">
						<li><bean:message bundle="kms-wiki"
							key="kmsWiki.rightInfo.categoryHelp" /> : <c:forEach
							items="${categoryList}" var="sccondCategory"
							varStatus="varStatus">
							<a href="javascript:void(0);"
								onclick="openCategoryIndex('${sccondCategory.fdId}');">
							${sccondCategory.fdName} </a>
							<c:if test="${!varStatus.last }">;</c:if>
						</c:forEach></li>
					</c:if>
				</ul>
			</ui:content>
		</ui:accordionpanel>

		<!-- 关联文档 -->
		<c:import
			url="/sys/relation/import/sysRelationMain_view_new.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmsWikiMainForm" />
			<c:param
				name="modelName"
				value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
			<c:param name="fdCategoryId" value="${kmsWikiMainForm.docCategoryId}" />
		</c:import>
		<!-- 下面的目录 -->
		<div class="lui_wiki_catelog_bottom" id="catelog_bottom">
			<div class="lui_wiki_catelog_barLeft"></div>
				<div class="lui_wiki_catelog_bar" style="position: relative;">
					<div style="position: absolute; top: 0px" id="wiki_catelog_side"
						class="lui_wiki_catelog_barContent">
						<ul id="catalog_ul_bottom" class="lui_wiki_catalog_ul">
							<li class="lui_catelog_bottom_first" style="margin: 0px">&nbsp</li>
						</ul>
					</div>
				</div>
			<div class="lui_wiki_catelog_btnTop" style="bottom: 32px"
				onclick="catelogScorllBtn('wiki_catelog_side', 2, this)">
				<i class="lui_wiki_catelog_trigTop"></i>
			</div>
			<div class="lui_wiki_catelog_btnDown"
				onclick="catelogScorllBtn('wiki_catelog_side', -2, this);">
				<i class="lui_wiki_catelog_trigDown"></i>
			</div>
		</div>
		<ui:button parentId="top" id="catelogBtn" onclick="showCatelog();"
			styleClass="lui_wiki_catelog_btn_c">
		</ui:button>
	</template:replace>
</template:include>
