<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmaps/kms_kmaps_ui/style/view.css" />
		<script src="${LUI_ContextPath}/kms/common/resource/js/kms_utils.js"></script>
		<%@ include file="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_view_js.jsp"%>
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmsKmapsMainForm.docSubject } - ${ lfn:message('kms-kmaps:table.kmsKmapsMain') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<!-- 复制 -->
			<kmss:auth
				requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=edit&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.copyOrAdd')}" 
						onclick="Com_OpenWindow('kmsKmapsMain.do?method=copyadd&mapId=${param.fdId}&categoryId=${kmsKmapsMainForm.docCategoryId}','_self');" order="2">
				</ui:button>
			</kmss:auth>
			 
			 
			<!-- 编辑所有 -->
			 <c:if test="${kmsKmapsMainForm.docStatusFirstDigit > '0' }">
				<kmss:auth
					requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=edit&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.editAll')}" 
						onclick="Com_OpenWindow('kmsKmapsMain.do?method=edit&fdId=${param.fdId}&editType=editAll','_self');" order="2">
					</ui:button>
					<!-- 编辑图形 -->
					<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.draw') }"  
						onclick="Com_OpenWindow('kmsKmapsMain.do?method=edit&fdId=${param.fdId}','_self');" order="2">
					</ui:button>
				</kmss:auth> 
			</c:if>
			<!-- 保存为新模版 -->
			<kmss:auth
				requestURL="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=add"
				requestMethod="GET">
				<ui:button text="${lfn:message('kms-kmaps:kmsKmapsTemplate.save') }" order="2" onclick="saveTemplate();">
				</ui:button>
			</kmss:auth>  
			<!-- 删除 -->
			<kmss:auth
				requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=delete&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" 
						onclick="confirmDelete();">
				</ui:button>
			</kmss:auth>  
			<!-- 调整属性-->
            <c:if test="${not empty kmsKmapsMainForm.extendFilePath}">
			  <kmss:auth
					requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=editProperty&fdId=${param.fdId}"
					requestMethod="GET">
				<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.editProperty') }" onclick="editProperty();return false;"/>
		 	 </kmss:auth>
		 	</c:if>
		 	<!-- 分类转移-->   
			<kmss:auth 
				 requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=templateChange&fdId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }" onclick="changeCate();"/>
			 </kmss:auth>
			<%-- 权限变更--%>
			<c:import url="/sys/right/import/doc_right_change_view.jsp" charEncoding="UTF-8">
				<c:param name="fdModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
				<c:param name="fdCategoryId" value="${kmsKmapsMainForm.docCategoryId }" />
				<c:param name="fdModelId" value="${kmsKmapsMainForm.fdId }" />
			</c:import>	
			 <!-- 添加标签 -->
		 	<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=editTag&fdId=${param.fdId}" requestMethod="GET">
				<c:set var="addTag" value="false" />
			</kmss:auth>
		 	<c:if test="${addTag!='false'}">
		 		<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.addTag') }"  onclick="addTags(3);return false;"/>
			</c:if>
			<!-- 调整标签-->
			<kmss:auth
					requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=editTag&fdId=${param.fdId}" requestMethod="GET">
				 <ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.editTag') }" onclick="addTags(2);return false;"/>
			</kmss:auth>
			 
			<!-- 关闭 -->
			<ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow();" order="5">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<!-- 路径 -->
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-kmaps:table.kmsKmapsMain') }" 
					modulePath="/kms/kmaps/" 
					modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" 
					autoFetch="false"
					href="/kms/kmaps/"
					categoryId="${kmsKmapsMainForm.docCategoryId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<c:set
			var="kmsKmapsMainForm"
			value="${kmsKmapsMainForm}"
			scope="request" />
		<div class='lui_form_title_frame'>
			<!-- 标题 -->
			<div class='lui_form_subject' id='docSubject'>
				<bean:write	name="kmsKmapsMainForm" property="docSubject" />
				<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="kms-kmaps" key="kmsKmapsMain.has" />
				     <a href="javascript:;" style="font-size:18px;color:red" onclick="Com_OpenWindow('kmsKmapsMain.do?method=view&fdId=${kmsKmapsMainForm.docOriginDocId}','_self');">
					 <bean:message bundle="kms-kmaps" key="kmsKmapsMain.NewVersion" /></a>)</span>
		        </c:if>
			</div>
		</div>
		
		<ui:tabpage expand="false">
			<%--关联机制--%>
			<c:import
				url="/sys/relation/include/sysRelationMain_view_many.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
				<c:param name="currModelName"
					value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
			</c:import>
			
			<div id="demo1"></div>
			<ui:content title="${lfn:message('kms-kmaps:kmsKmapsMain.baseInfo')}">
				<table class="tb_normal" width=100%>
					<c:if test="${ not empty kmsKmapsMainForm.fdDescription }">
						<tr>
							<td class="td_normal_title" width=15%>
								${ lfn:message('kms-kmaps:kmsKmapsMain.docDescription')}
							</td>
							<td width="85%" colspan="3">
								<bean:write	name="kmsKmapsMainForm" property="fdDescription" />
							</td>
						</tr>
					</c:if>
					<tr>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />
						</td>
						<td width="35%" >
							<!-- 内部作者 -->
							<ui:person personId="${kmsKmapsMainForm.docAuthorId}" personName="${kmsKmapsMainForm.docAuthorName}">
							</ui:person>
							<!-- 外部作者 -->
							<span class="com_author" <c:if test="${not empty kmsKmapsMainForm.docAuthorId }">style="display: none;"</c:if>>${kmsKmapsMainForm.outerAuthor}</span>
						</td>
						<!-- 发布时间 -->
						<td class="td_normal_title" width="15%">
							${ lfn:message('kms-kmaps:kmsKmapsMain.postTime')}
						</td>
						<td width="35%">
							<bean:write name="kmsKmapsMainForm" property="docPublishTime" /> 
						</td>
					</tr>
					<tr>
						<!-- 版本 -->
						<td class="td_normal_title" width="15%">
							${ lfn:message('sys-edition:sysEditionMain.tab.label')}
						</td>
						<td width="35%">
							V ${kmsKmapsMainForm.editionForm.mainVersion}.${kmsKmapsMainForm.editionForm.auxiVersion}
						</td>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docStatus" />
						</td>
						<td width="35%">
							<sunbor:enumsShow	value="${kmsKmapsMainForm.docStatus}"	enumsType="common_status" />
						</td>
					</tr>
					<tr>
						<!-- 创建者 -->
						<td class="td_normal_title" width="15%">
							${lfn:message('kms-kmaps:kmsKmapsMain.docCreator')}
						</td>
						<td width="35%">
							<ui:person personId="${kmsKmapsMainForm.docCreatorId}" personName="${kmsKmapsMainForm.docCreatorName}">
							</ui:person>
						</td>
						<!-- 创建日期 -->
						<td class="td_normal_title" width="15%"> 
							${ lfn:message('kms-kmaps:kmsKmapsMain.docCreateTime')}
						</td>
						<td width="35%" >
							<bean:write name="kmsKmapsMainForm" property="docCreateTime" /> 
						</td>
					</tr>
					<tr>
						<!-- 最后更新者 -->
						<td class="td_normal_title" width="15%">
							${ lfn:message('kms-kmaps:kmsKmapsMain.lastAlterer')}
						</td>
						<td width="35%" >
							<ui:person personId="${kmsKmapsMainForm.docAlterorId}" personName="${kmsKmapsMainForm.docAlterorName}">
							</ui:person>
						</td>
						<!-- 最后更新时间 -->
						<td class="td_normal_title" width="15%">
							${ lfn:message('kms-kmaps:kmsKmapsCategory.docAlterTime')}
						</td>
						<td width="35%" >
							<bean:write name="kmsKmapsMainForm" property="docAlterTime" /> 
						</td>
					</tr>
					<!-- 标签 -->
					<c:set var="sysTagMainForm" value="${requestScope['kmsKmapsMainForm'].sysTagMainForm}" />
					<c:if test="${not empty sysTagMainForm.fdTagNames}">
						<tr>
							<td class="td_normal_title" width="15%">
								标签
							</td>
							<td width="85%" colspan="3" class="tag_content">
							</td>
						</tr>
					</c:if>
				</table>
			</ui:content>
			
			<!-- 地图属性 -->
			<c:if test="${not empty kmsKmapsMainForm.extendFilePath}">
				<ui:content title="<div id='eval_label_title'>${lfn:message('kms-kmaps:kmsKmapsMain.fdProperty') }</div>">
					<table class="tb_simple"  width="100%" >
						<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmapsMainForm" />
							<c:param name="fdDocTemplateId" value="${kmsKmapsMainForm.docCategoryId}" />
						</c:import>
					</table>
				</ui:content>
			</c:if>	
			<!-- 点评 -->
			<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
			</c:import>
			<!-- 推荐 -->
			<c:import url="/sys/introduce/import/sysIntroduceMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
				<c:param name="fdKey" value="mainMap" /> 
				<c:param name="toEssence" value="true" />
				<c:param name="toNews" value="true" />
				<c:param name="docSubject" value="${kmsKmapsMainForm.docSubject}" />
				<c:param name="docCreatorName" value="${kmsKmapsMainForm.docCreatorName}" />
			</c:import> 
			<!-- 阅读记录 -->
			<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
			</c:import>
			<!-- 传阅 -->
			<c:import url="/sys/circulation/import/sysCirculationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
			</c:import>
			<!-- 版本 -->
			<c:import url="/sys/edition/import/sysEditionMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
			</c:import>
			<!-- 收藏 -->
			<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
				<c:param name="fdSubject" value="${kmsKmapsMainForm.docSubject}" />
				<c:param name="fdModelId" value="${kmsKmapsMainForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
			</c:import>
			<!-- 权限 -->
			<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
			</c:import>
			<!-- 流程 -->
			<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsKmapsMainForm" />
				<c:param name="fdKey" value="mainMap" />
			</c:import>
		</ui:tabpage>
	</template:replace>
</template:include>
<div class="relationContainer">
	<span>
		<i class="lui_icon_s lui_icon_s_icon_remove"></i>
	</span>
	<div>
		<iframe id="relationIframe" scrolling="auto" style="height: 450px"/>
	</div>
</div>
