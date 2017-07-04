<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="kms.learn.view" width="100%" sidebar="no">
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
	
	<%--路径 --%>
	<template:replace name="path">
	</template:replace>
	<%--内容 --%>
	<template:replace name="content" >
		<div class='lui_form_title_frame clearfloat' ><%--词条名 --%>
		<div class="lui_form_subject"><c:out
			value="${kmsWikiMainForm.docSubject}" /> 
			<c:if test="${isHasNewVersion=='true'}">
			     <span style="color:red">(<bean:message bundle="kms-wiki" key="kmsWikiMain.title.has" />
			     <a href="javascript:;" style="font-size:18px;color:red" onclick="Com_OpenWindow('kmsWikiMain.do?method=view&fdId=${newVersionId}','_self');">
				 <bean:message bundle="kms-wiki" key="kmsWikiMain.title.NewVersion" /></a>)</span>
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
		
		<%--附件 --%> <c:if test="${not empty kmsWikiMainForm.attachmentForms['attachment'].attachments}">
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
		<c:if
				test="${hasPic == true}">
				<div style="width:100%;height:200px;margin-bottom: 20px;display: none;">
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
	</template:replace>
</template:include>
