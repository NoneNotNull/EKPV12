<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<script>
			seajs.use(['theme!form']);
			
			Com_IncludeFile("ckresize.js",Com_Parameter.ContextPath
					+ "resource/ckeditor/", "js", true);
		
		</script>
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/style/view.css" />
			
			<%--词条名片头像和词条附件 --%>
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
			<style>
				.lui_wiki_description {
					font-size: 16px;
					padding: 0px 0px 5px 8px;
					font-weight: bold;
					border-bottom: 1px solid #e8e8e8;
					margin: 3px 15px 14px 10px;
				}
			</style>
	</template:replace>
	<template:replace name="body">
		<div style="padding: 5px;">
			 <c:if test="${not empty kmsWikiMainForm.fdDescription || not empty fdAttId}">
			 	<div class="lui_wiki_description" >
			 		<span>${lfn:message('kms-wiki:kmsWiki.wikiCard')}</span>
			 	</div>
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
										</c:import>
									</c:if>
									<c:if test="${hasPic==false }">
										<div  class="lui_wiki_cardPic" style="height: 200px;width:150px;">
											<img id="cardPic" src="${cardPicURL }" onload="javascript:drawImage(this,this.parentNode)">
										</div>
									</c:if>
								
							</td>
							<td valign="top" style="padding:12px 0px;text-indent:2em;">
									<c:out value="${kmsWikiMainForm.fdDescription}"/>
							</td>
						</tr>
					</table>
				</div>
			</c:if>
			<div class="lui_form_content_frame" style="text-indent:0em;">
				<div id="_____rtf__temp_____${kmsWikiMainForm.fdId }"></div>
				<script>
					CKResize.addPropertyName('${kmsWikiMainForm.fdId }');
				</script>
				<div id="_____rtf_____${kmsWikiMainForm.fdId }" style="display: none;width: 100%">
					<table width="100%">
						<%--内容 --%>
						<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm">
							<tr class="lui_wiki_tr_title">
								<%-- 目录标题 --%>
								<td class="lui_wiki_td_l">
									<span class="lui_wiki_catelog1">
										<c:out value="${kmsWikiCatelogForm.fdName}"/>
									</span>
								</td>
							</tr>
							<tr class="lui_wiki_catelog_content">
								<td>
									<div name="${kmsWikiCatelogForm.fdId }" id="${kmsWikiCatelogForm.fdId }" class="lui_wiki_catelogContent">
										${kmsWikiCatelogForm.docContent}
									</div>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
		</div>
		<script>
			seajs.use(['lui/jquery'],function($) {
				$(function() {
						if('${hasPic}'!='true'){
							CKResize.____ckresize____(true);
						}else{
							var att = attachmentObject_spic_${param.fdId };
							att.on('imgLoaded',function(evt){
								if(evt && evt.target)
									CKResize.extendImage = evt.target;
								CKResize.____ckresize____(true);
							});
						}}
				);
			});
		</script>
	</template:replace>
</template:include>