<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.view">
	<template:replace name="title">
		<c:out value="${ kmDocKnowledgeForm.docSubject } - ${ lfn:message('km-doc:module.km.doc') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			 <c:if test="${kmDocKnowledgeForm.docStatusFirstDigit > '0' }">
				<kmss:auth
					requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=edit&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('button.edit')}" 
						onclick="Com_OpenWindow('kmDocKnowledge.do?method=edit&fdId=${param.fdId}','_self');" order="2">
					</ui:button>
				</kmss:auth> 
			</c:if>
			<kmss:auth
				requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=delete&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" order="4"
						onclick="deleteDoc('kmDocKnowledge.do?method=delete&fdId=${param.fdId}');">
				</ui:button>
			</kmss:auth>
			<ui:button text="${lfn:message('km-doc:kmDoc.button.copyLink')}" order="4" onclick="copyLink();">
			</ui:button>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('km-doc:module.km.doc') }" 
					modulePath="/km/doc/" 
					modelName="com.landray.kmss.km.doc.model.KmDocTemplate" 
					autoFetch="false"
					href="/km/doc/"
					categoryId="${kmDocKnowledgeForm.fdDocTemplateId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<script type="text/javascript">
			Com_IncludeFile("dialog.js|docutil.js");
			seajs.use(['lui/dialog'],function(dialog){
				window.deleteDoc = function(delUrl){
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
						if(isOk){
							Com_OpenWindow(delUrl,'_self');
						}	
					});
					return;
				};
				window.copyLink = function(){
					var fdId = '${kmDocKnowledgeForm.fdId}';
					var fdCopyUrl = "/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&topEdition=true&fdId=" + fdId;
					var result = '';
					if(window.clipboardData){
						result= window.clipboardData.setData('text', fdCopyUrl);
					}
					else
					{
						dialog.alert("<bean:message key="kmDoc.message.copyLinkError" bundle="km-doc" />");
					}
					if (result) {
						dialog.alert("<bean:message key="kmDoc.message.copyLinkSucess" bundle="km-doc" />");
					}
				}
			});
		</script>
		<c:set var="sysDocBaseInfoForm" value="${kmDocKnowledgeForm}" scope="request" />
		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
				<c:if test="${kmDocKnowledgeForm.docIsIntroduced==true}">
			  	     <img src="${LUI_ContextPath}/km/doc/resource/images/jing.gif" border=0 title="<bean:message key="kmDoc.tree.jing" bundle="km-doc"/>" />
			    </c:if>
				     <bean:write	name="kmDocKnowledgeForm" property="docSubject" />
				<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.has" />
				     <a href="javascript:;" style="font-size:18px;color:red" onclick="Com_OpenWindow('kmDocKnowledge.do?method=view&fdId=${kmDocKnowledgeForm.docOriginDocId}','_self');">
					 <bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.NewVersion" /></a>)</span>
		        </c:if>
			</div>
			<div class='lui_form_baseinfo'>
				<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />：
				<ui:person personId="${kmDocKnowledgeForm.docAuthorId}" personName="${kmDocKnowledgeForm.docAuthorName}"></ui:person>&nbsp;
				<c:if test="${ not empty kmDocKnowledgeForm.docPublishTime }">
					<bean:write name="kmDocKnowledgeForm" property="docPublishTime" />
				</c:if>&nbsp;
				<c:if test="${kmDocKnowledgeForm.docStatus == '30'}">
				 <bean:message key="sysEvaluationMain.tab.evaluation.label" bundle="sys-evaluation"/>
					 <span data-lui-mark='sys.evaluation.fdEvaluateCount' class="com_number">
						 <c:choose>
						   <c:when test="${not empty kmDocKnowledgeForm.evaluationForm.fdEvaluateCount}">
						      ${ kmDocKnowledgeForm.evaluationForm.fdEvaluateCount }
						   </c:when>
						   <c:otherwise>(0)</c:otherwise>
						 </c:choose>
					 </span>
				 <bean:message key="sysIntroduceMain.tab.introduce.label" bundle="sys-introduce"/>
					 <span data-lui-mark="sys.introduce.fdIntroduceCount" class="com_number">
						 <c:choose>
							   <c:when test="${not empty kmDocKnowledgeForm.introduceForm.fdIntroduceCount}">
							     ${ kmDocKnowledgeForm.introduceForm.fdIntroduceCount }
							   </c:when>
							   <c:otherwise>(0)</c:otherwise>
					     </c:choose>
					 </span>
				</c:if>
				<bean:message key="sysReadLog.tab.readlog.label" bundle="sys-readlog"/><span data-lui-mark="sys.readlog.fdReadCount" class="com_number">(${ kmDocKnowledgeForm.readLogForm.fdReadCount })</span>
			</div>
		</div>
		<c:if test="${ not empty kmDocKnowledgeForm.fdDescription }">
			<div class="lui_form_summary_frame">			
				<bean:write	name="kmDocKnowledgeForm" property="fdDescription" />
			</div>
		</c:if>
		<div class="lui_form_content_frame clearfloat">
			<c:if test="${not empty sysDocBaseInfoForm.docContent}">
			<div style="min-height: 200px;">
			   <xform:rtf property="docContent"></xform:rtf>
			</div>			
			</c:if>
			<c:if test="${not empty kmDocKnowledgeForm.attachmentForms['attachment'].attachments}">
			<div class="lui_form_spacing"></div> 
			<div>
				<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-doc:sysDocBaseInfo.docAttachments') }(${fn:length(kmDocKnowledgeForm.attachmentForms['attachment'].attachments)})</div>
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
					<c:param name="formBeanName" value="sysDocBaseInfoForm" />
					<c:param name="fdKey" value="attachment" />
				</c:import>
			</div> 	
			</c:if> 
		</div>
		<ui:tabpage expand="false">
			<%--收藏机制 --%>
			<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
				<c:param name="fdSubject" value="${kmDocKnowledgeForm.docSubject}" />
				<c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
			</c:import>
			
			<%--点评机制 --%>
			<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
			</c:import>
			
			<%--推荐机制 --%>
			<c:import url="/sys/introduce/import/sysIntroduceMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
				<c:param name="toEssence" value="true" />
				<c:param name="toNews" value="true" />
				<c:param name="docSubject" value="${kmDocKnowledgeForm.docSubject}" />
				<c:param name="docCreatorName" value="${kmDocKnowledgeForm.docCreatorName}" />
			</c:import> 
			
			<%--阅读机制 --%>
			<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
			</c:import>
			
			<%--发布机制 --%>
			<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
			</c:import> 
			
			<%--版本机制 --%>
			<c:import url="/sys/edition/import/sysEditionMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
			</c:import>
			
			<%--权限机制 --%>
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
			</c:import>
		
			<%--流程机制 --%>
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
			</c:import>
			
			<!-- 旧数据查询 -->
			<kmss:ifModuleExist path="/tools/datatransfer/">
				<c:import url="/tools/datatransfer/import/toolsDatatransfer_old_data.jsp" charEncoding="UTF-8">
					<c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId}" />
					<c:param name="fdModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />	
				</c:import>
			</kmss:ifModuleExist>
		</ui:tabpage>
	</template:replace>
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${lfn:message('km-doc:kmDoc.kmDocKnowledge.docInfo')}" toggle="false">
				<c:import url="/sys/evaluation/import/sysEvaluationMain_view_star.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm" />
				</c:import>
				<ul class='lui_form_info'>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreator" />：
					<ui:person personId="${kmDocKnowledgeForm.docCreatorId}" personName="${kmDocKnowledgeForm.docCreatorName}"></ui:person></li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />：<bean:write	name="sysDocBaseInfoForm" property="docDeptName" /></li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docStatus" />：<sunbor:enumsShow	value="${sysDocBaseInfoForm.docStatus}"	enumsType="common_status" /></li>
					<c:if test="${not empty kmDocKnowledgeForm.docPropertiesNames}">
					  <li><bean:message bundle="km-doc" key="table.kmDocMainProperty" />：<bean:write name="kmDocKnowledgeForm" property="docPropertiesNames" /></li>
					</c:if>
					<li><bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />：${kmDocKnowledgeForm.editionForm.mainVersion}.${kmDocKnowledgeForm.editionForm.auxiVersion}</li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreateTime" />：${ kmDocKnowledgeForm.docCreateTime }</li>				
				</ul>
			<c:if test="${not empty kmDocKnowledgeForm.sysTagMainForm.fdTagNames}">	
				<div style='margin-left:-8px;margin-right:-8px;margin-bottom:8px;border-bottom: 1px #bbb dashed;height:8px'></div>
			</c:if>	
				<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm" />
					<c:param name="useTab" value="false"></c:param>
				</c:import>
			</ui:content>
		</ui:accordionpanel>
		
		<%--关联机制 --%>
		<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmDocKnowledgeForm" />
		</c:import>
	</template:replace>
</template:include>