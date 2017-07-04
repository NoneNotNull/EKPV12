<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/multidoc/kms_multidoc_ui/style/view.css" />
		<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_view_attscript.jsp"%>
		<script src="${LUI_ContextPath}/kms/common/resource/js/kms_utils.js"></script>
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmsMultidocKnowledgeForm.docSubject } - ${ lfn:message('kms-multidoc:table.kmdoc') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="4">
			<c:if test="${kmsMultidocKnowledgeForm.docStatus != '50' }">
			<!-- 编辑 -->
			<c:if test="${kmsMultidocKnowledgeForm.docStatusFirstDigit > '0' }">
				<kmss:auth
					requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=edit&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('button.edit')}" 
						onclick="Com_OpenWindow('../../multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=edit&fdId=${param.fdId}','_self');" order="2">
					</ui:button>
				</kmss:auth> 
			</c:if>
			<!-- 调整属性-->
            <c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
			  <kmss:auth
					requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=editProperty&fdId=${param.fdId}"
					requestMethod="GET">
				<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.button.editProperty') }" order="4" onclick="editProperty();return false;"/>
		 	 </kmss:auth>
		 	</c:if>
		 	<!-- 添加标签 -->
		 	<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=editTag&fdId=${param.fdId}" requestMethod="GET">
				<c:set var="addTag" value="false" />
			</kmss:auth>
		 	<c:if test="${addTag!='false'}">
		 		<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.button.addTag') }" order="2" onclick="addTags(3);return false;"/>
		 	</c:if>
			<!-- 调整标签-->
			<kmss:auth
					requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=editTag&fdId=${param.fdId}" requestMethod="GET">
				 <ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.button.editTag') }" order="2" onclick="addTags(2);return false;"/>
			 </kmss:auth>
			<!-- 分类转移--> 
			<c:import url="/sys/simplecategory/import/doc_cate_change_view.jsp" charEncoding="UTF-8">
				<c:param name="fdMmodelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
				<c:param name="docFkName" value="docCategory" />
				<c:param name="fdCateModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
				<c:param name="fdMmodelId" value="${kmsMultidocKnowledgeForm.fdId }" />
				<c:param name="fdCategoryId" value="${kmsMultidocKnowledgeForm.docCategoryId }" /> 
				<c:param name="extProps" value="fdTemplateType:1;fdTemplateType:3" />
			</c:import>  
			<%-- 权限变更--%>
			<c:import url="/sys/right/import/doc_right_change_view.jsp" charEncoding="UTF-8">
				<c:param name="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
				<c:param name="fdCategoryId" value="${kmsMultidocKnowledgeForm.docCategoryId }" />
				<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId }" />
			</c:import>	
			 <!-- 置顶 -->
			 <c:if test="${kmsMultidocKnowledgeForm.fdSetTopTime==null && kmsMultidocKnowledgeForm.docStatus == '30' && isHasNewVersion != true }">
			 	<kmss:auth 
					 requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=setTop&local=view&fdId=${param.fdId}" requestMethod="GET">
						<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.setTop')}" onclick="setTop();"/>
				 </kmss:auth>
			 </c:if>
				
			 <!-- 取消置顶 -->
			 <c:if test="${kmsMultidocKnowledgeForm.fdSetTopTime!=null}">
				<c:choose>
					<c:when test="${kmsMultidocKnowledgeForm.docIsIndexTop == null}">
						<kmss:auth
									requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=cancelTop&local=view&fdId=${param.fdId}"
									requestMethod="GET">
						 	<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.cancelSetTop')}" order="4" onclick="cancelTop();"/>		 
						</kmss:auth>	
					</c:when>
					<c:otherwise>
						<kmss:auth
									requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=cancelTop&local=index&fdId=${param.fdId}"
									requestMethod="GET">
							<ui:button text="${lfn:message('kms-multidoc:kmsMultidoc.cancelSetTop')}" order="4" onclick="cancelTop();"/> 
						</kmss:auth>	
					</c:otherwise>
				</c:choose>
			</c:if>
			</c:if>			
			<c:if test="${isHasNewVersion != true }">
				<!-- 删除 -->
				<c:if test="${kmsMultidocKnowledgeForm.docStatus == '30'}">
					<kmss:auth
						requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=recycle&fdId=${param.fdId}"
						requestMethod="GET">
						<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recycle')}" 
								onclick="confirmRecycle();" order="4">
						</ui:button>
					</kmss:auth>
				</c:if>
				<!-- 彻底删除 -->
				<kmss:auth
					requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=delete&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}" 
							onclick="confirmDelete();" order="4">
					</ui:button>
				</kmss:auth>
			</c:if>
			<%--恢复 --%>
			<c:if test="${kmsMultidocKnowledgeForm.docStatus == '50'}">
				<kmss:auth
					requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=recover&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recover') }"
						onclick="confirmRecover()" order="4"/>
				</kmss:auth>
			</c:if>
			<!-- 关闭 -->
			<ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow(); " order="5">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<!-- 路径 -->
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-multidoc:table.kmdoc') }" 
					modulePath="/kms/multidoc/" 
					modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
					autoFetch="false"
					href="/kms/multidoc/"
					categoryId="${kmsMultidocKnowledgeForm.docCategoryId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<c:set
			var="sysDocBaseInfoForm"
			value="${kmsMultidocKnowledgeForm}"
			scope="request" />
		<div class='lui_form_title_frame'>
			<!-- 文档标题 -->
			<div class='lui_form_subject'>
				<bean:write	name="kmsMultidocKnowledgeForm" property="docSubject" />
				<c:if test="${kmsMultidocKnowledgeForm.docIsIntroduced==true}">
		  	 		 <img src="${LUI_ContextPath}/kms/knowledge/resource/img/jing.gif" 
		  	 		      border=0 
		  	 		      title="${lfn:message('kms-knowledge:kmsKnowledge.introduced')}" />
		    	</c:if>
		    	<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.has" />
				     <a href="javascript:;" style="font-size:18px;color:red" onclick="Com_OpenWindow('kmsMultidocKnowledge.do?method=view&fdId=${kmsMultidocKnowledgeForm.docOriginDocId}','_self');">
					 <bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.NewVersion" /></a>)</span>
		        </c:if>
		        <c:if test="${sysDocBaseInfoForm.docStatus==50}">
				     <span style="color:red">(${lfn:message('kms-multidoc:kmsMultidocKnowledge.has.deleted') })</span>
		        </c:if>
			</div>
			<div class='lui_form_baseinfo'>
				<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />
				<span style="margin-right: 3px;">
					<!-- 文档作者 -->
					<ui:person personId="${kmsMultidocKnowledgeForm.docAuthorId}" personName="${kmsMultidocKnowledgeForm.docAuthorName}">
					</ui:person>
					<!-- 外部作者 -->
					<span class="com_author" <c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">style="display: none;"</c:if>>${kmsMultidocKnowledgeForm.outerAuthor}</span>
				</span>
				<span style="margin-right: 8px;">
					${publishTime }
				</span>
				<c:if test="${kmsMultidocKnowledgeForm.docStatus == 30}">
					<!-- 点评 --> 
					<bean:message key="sysEvaluationMain.tab.evaluation.label" bundle="sys-evaluation"/><span data-lui-mark='sys.evaluation.fdEvaluateCount' class="com_number">${not empty kmsMultidocKnowledgeForm.evaluationForm.fdEvaluateCount?kmsMultidocKnowledgeForm.evaluationForm.fdEvaluateCount : '(0)'}</span>
					<!-- 推荐 --> 
					<bean:message key="sysIntroduceMain.tab.introduce.label" bundle="sys-introduce"/><span data-lui-mark="sys.introduce.fdIntroduceCount" class="com_number">${not empty kmsMultidocKnowledgeForm.introduceForm.fdIntroduceCount ? kmsMultidocKnowledgeForm.introduceForm.fdIntroduceCount : '(0)'}</span>
				</c:if>
					<!-- 阅读信息 -->
					<bean:message key="sysReadLog.tab.readlog.label" bundle="sys-readlog"/><span data-lui-mark="sys.readlog.fdReadCount" class="com_number">(${kmsMultidocKnowledgeForm.readLogForm.fdReadCount})</span>
			</div>
		</div>
		
		<!-- 文档摘要 -->
		<c:if test="${ not empty kmsMultidocKnowledgeForm.fdDescription }">
			<div style="height: 15px;"></div>
			<div class="lui_form_summary_frame">			
				<bean:write	name="kmsMultidocKnowledgeForm" property="fdDescription" />
			</div>
		</c:if>
		 
		<!-- 文档内容 -->
			<div class="lui_form_content_frame" style="min-height: inherit" > 
				<c:if test="${not empty sysDocBaseInfoForm.docContent}">
					<div style="height:20px"> 
						<span class="lui_multidoc_slideUp" data-emit='doc.content'><span id="detail_span" style="color: #52a4c9;">${lfn:message('kms-multidoc:kmsMultidoc.slideUp')}</span></span>
					</div>
					<div data-on="doc.content" style="display: block;">
						<div class="lui_tabpage_float_header_text">
							${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.content') }
						</div>
						<xform:rtf property="docContent" imgReader="true" ></xform:rtf>
					</div>	
				</c:if>
				 <%-- 多媒体阅读器 --%>
		        <div id="imgInfo">
					<!-- 图片浏览器展现 -->
					<table class="lui_multidoc_showPic" id='imgBrowser'>
						<tr>
							<td colspan="3">
								<div class="lui_multidoc_showPic_container" >
									<div class="lui_multidoc_showPic_content" id='imgDiv'> 
										<div id='bigImg1' style="float:left;"> </div> 
										<div id='bigImg2' style="float:left;">​</div>
										<div id='bigImg3' style="float:left;"></div>
									</div>
									<!-- 左箭头 -->
									<div><a  class="insignia_left"onclick="left()"></a></div>
									<!-- 右剪头 -->
									<div><a  class="insignia_right" onclick="right()"></a></div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="img_small_btnl">
							<div class="img_small_btnbar" id="play_pre">
		                             &nbsp;<a href="javascript:void(0)" onclick="moveLeft()"><i  class="d_i_maintrig d_i_trigL"></i><i class="d_i_maintrig d_i_trig_coverL"></i></a></div>
		                             </td>
							<td class="small_pic_list">
								<div id='smallImg' class='picList'>
								   <ul id='picListItem'>
								   </ul>
								</div>
						    </td>
							<td class="img_small_btnr">
		                           <div class="img_small_btnbar" id="play_next">
		                               &nbsp;
		                            <a href="javascript:void(0)" onclick="moveRight()">   
		                            <i class="d_i_maintrig d_i_trigR"></i><i class="d_i_maintrig d_i_trig_coverR"></i></a>
		                            
		                            </div>
		                   	</td>
						</tr>
					</table>
					<div id="attachImg"></div>
				 </div>	
			</div>	
		
            <div id="attachFile" style="width:350px;">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="fdMulti" value="true" />
				<c:param name="formBeanName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="attachment" />
				<c:param name="drawFunction" value="Attachment_ShowList" />
				<c:param name="fdModelName" value="kmsMultidocKnowledge" />
				<c:param name="fdModelId" value="${param.fdId}" />
			</c:import>
	  	 </div>
		<div style="height: 15px;"></div>
		<ui:tabpage expand="false">
			<!-- 文档属性 -->
			<c:if test="${not empty kmsMultidocKnowledgeForm.extendFilePath}">
				<ui:content title="${lfn:message('kms-multidoc:kmsMultidocKnowledge.fdProperty') }">
					<table class="tb_simple"  width="100%" >
						<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							<c:param name="fdDocTemplateId" value="${kmsMultidocKnowledgeForm.docCategoryId}" />
						</c:import>
					</table>
				</ui:content>
			</c:if>	
			<!-- 文档附件 -->
			<c:if test="${not empty kmsMultidocKnowledgeForm.attachmentForms['attachment'].attachments}">
				<table width="100%">
					<tr>
						<td
							width="15%"
							class="td_normal_title"
							valign="top"><bean:message
							bundle="kms-multidoc"
							key="kmsMultidoc.attachement" /></td>
						<td
							width="85%"
							colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
										charEncoding="UTF-8">
									<c:param
										name="formBeanName"
										value="sysDocBaseInfoForm" />
									<c:param
										name="fdKey"
										value="attachment" />
							</c:import>
						</td>
					</tr> 
				</table>
			</c:if>
			
			<!-- 点评 -->
			<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="areaName" value="docContent" />
			</c:import>
			<!-- 推荐 -->
			<c:import url="/sys/introduce/import/sysIntroduceMain_view.jsp" charEncoding="UTF-8">
			    <c:param name="fdCateModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
				<c:param name="toEssence" value="true" />
				<c:param name="toNews" value="true" />
				<c:param name="docSubject" value="${kmsMultidocKnowledgeForm.docSubject}" />
				<c:param name="docCreatorName" value="${kmsMultidocKnowledgeForm.docCreatorName}" />
			</c:import> 
			<!-- 阅读记录 -->
			<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
			</c:import>
			<!-- 权限 -->
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
			</c:import>
			 
			<c:if test="${ kmsMultidocKnowledgeForm.docStatus != '50'}">
				<%--版本 --%>
				<c:import url="/sys/edition/import/sysEditionMain_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				</c:import>
				<%--发布机制 --%>
				<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				</c:import>
				<!-- 收藏 -->
				<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
					<c:param name="fdSubject" value="${kmsMultidocKnowledgeForm.docSubject}" />
					<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId}" />
					<c:param name="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
				</c:import>
			</c:if>
			
			<!-- 流程 -->
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
			</c:import>
		</ui:tabpage>
	</template:replace>
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;" toggle="false"> 
			<ui:content title="${lfn:message('kms-multidoc:kmsMultidocKnowledge.docInfo') }">
				<c:import url="/sys/evaluation/import/sysEvaluationMain_view_star.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsMultidocKnowledgeForm" />
				</c:import>
				<ul class='lui_form_info'>
					
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidoc.creator" />：
						<ui:person personId="${kmsMultidocKnowledgeForm.docCreatorId}" personName="${kmsMultidocKnowledgeForm.docCreatorName}">
						</ui:person>
					</li>
					<li>
						<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />：
						<c:out  value="${kmsMultidocKnowledgeForm.docDeptName}" />
					</li>
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.createTime" />：
						${createTime}
					</li>
					<li>
						<bean:message bundle="sys-doc" key="sysDocBaseInfo.docStatus" />：
						<sunbor:enumsShow	value="${sysDocBaseInfoForm.docStatus}"	enumsType="kms_doc_status" />
					</li>
					<li>
						<bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />：
						V ${kmsMultidocKnowledgeForm.editionForm.mainVersion}.${kmsMultidocKnowledgeForm.editionForm.auxiVersion}
					</li>
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.fdNumber"/>：
						<c:out value="${kmsMultidocKnowledgeForm.fdNumber}"/>
					</li>
					<c:if test="${not empty kmsMultidocKnowledgeForm.docAlterorId}">
						<li>
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.lastUpdateUser" />：
							<ui:person personId="${kmsMultidocKnowledgeForm.docAlterorId}" personName="${kmsMultidocKnowledgeForm.docAlterorName}">
							</ui:person>
						</li>
						<li>
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.lastUpdateTime" />：
							${ alterTime}
						</li>	
					</c:if>		
				</ul>
				
				<!-- 知识标签 -->
				<c:set var="sysTagMainForm" value="${requestScope['kmsMultidocKnowledgeForm'].sysTagMainForm}" />
				<c:if test="${not empty sysTagMainForm.fdTagNames}">
					<div style='margin-left:-8px;margin-right:-8px;margin-bottom:8px;border-bottom: 1px #bbb dashed;height:8px'></div>
					<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm" />
						<c:param name="useTab" value="false"></c:param>
					</c:import>
				</c:if>		
			</ui:content>
			
			<!-- 分类信息 -->
			<ui:content title="${lfn:message('kms-multidoc:kmsMultidocTemplate.lbl.templateinfo') }" toggle="false">
				<ul class="lui_multidoc_baseInfo_ul">
					<li>
						<bean:message bundle="kms-multidoc" key="kmsMultidocKnowledge.fdTemplateName"/> :
						<a href="${LUI_ContextPath }/kms/multidoc/?categoryId=${kmsMultidocKnowledgeForm.docCategoryId}" target="_blank"><c:out value="${kmsMultidocKnowledgeForm.docCategoryName}"/></a>
					</li>
					<li>
						<c:if test="${not empty secondCategoriesNames[0]}">
							<bean:message bundle="kms-multidoc" key="kmsMultidoc.kmsMultidocKnowledge.docProperties"/> :
							<c:forEach items="${secondCategoriesNames}" var="docSecondCateName" varStatus="varStatus">
								<a href="${LUI_ContextPath }/kms/multidoc/?categoryId=${secondCategoriesIds[varStatus.index]}" target="_blank">${docSecondCateName}</a>
								<c:if test="${!varStatus.last }">;</c:if>
							</c:forEach>
						</c:if>
					</li>
				</ul>
			</ui:content>
			
		</ui:accordionpanel>
			<c:import
			url="/sys/relation/import/sysRelationMain_view_new.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmsMultidocKnowledgeForm" />
			<c:param
				name="modelName"
				value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
			<c:param name="fdCategoryId" value="${kmsMultidocKnowledgeForm.docCategoryId }" />
		</c:import>
	</template:replace>
</template:include>
<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_view_script.jsp"%>