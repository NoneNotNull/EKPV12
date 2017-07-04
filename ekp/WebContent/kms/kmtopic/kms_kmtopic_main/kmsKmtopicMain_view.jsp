<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/style/view.css" />
		<%@ include file="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_view_js.jsp"%>
		<template:super />
		<script>
			seajs.use(['theme!form']);
		</script>
		
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmsKmtopicMainForm.docSubject } - ${ lfn:message('kms-kmtopic:module.kms.kmtopic') }"></c:out>
	</template:replace>
	
	
	<template:replace name="body">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="4">
			<!-- 编辑 -->
			<c:if test="${kmsKmtopicMainForm.docStatusFirstDigit > '0' }">
				<kmss:auth
						requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=edit&fdId=${param.fdId}"
						requestMethod="GET">
					<ui:button text="${lfn:message('button.edit')}" 
						onclick="Com_OpenWindow('../../kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=edit&fdId=${param.fdId}','_self');" order="2">
					</ui:button>
				</kmss:auth>
			</c:if>
			<!-- 调整属性-->
	        <c:if test="${not empty kmsKmtopicMainForm.extendFilePath}">
	        	<kmss:auth
					requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=editProperty&fdId=${param.fdId}"
						requestMethod="GET">
					<ui:button text="${lfn:message('kms-kmtopic:kmsKmtopicMain.button.editProperty') }" order="4" onclick="editProperty();return false;"/>
				</kmss:auth>
		 	</c:if>
			<!-- 添加标签 -->
			<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=editTag&fdId=${param.fdId}" requestMethod="GET">
				<c:set var="addTag" value="false" />
			</kmss:auth>
		 	<c:if test="${addTag!='false'}">
		 		<ui:button text="${lfn:message('kms-kmtopic:kmsKmtopicMain.button.addTag') }" order="2" onclick="addTags(3);return false;"/>
		 	</c:if>
			<!-- 调整标签-->
			<kmss:auth
						requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=editTag&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('kms-kmtopic:kmsKmtopicMain.button.editTag') }" order="2" onclick="addTags(2);return false;"/>
			</kmss:auth>
			<!-- 分类转移--> 
			<c:import url="/sys/simplecategory/import/doc_cate_change_view.jsp" charEncoding="UTF-8">
				<c:param name="fdMmodelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
				<c:param name="docFkName" value="docCategory" />
				<c:param name="fdCateModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" />
				<c:param name="fdMmodelId" value="${kmsKmtopicMainForm.fdId }" />
				<c:param name="fdCategoryId" value="${kmsKmtopicMainForm.docCategoryId }" /> 
			</c:import>  
			<%-- 权限变更--%>
			<c:import url="/sys/right/import/doc_right_change_view.jsp" charEncoding="UTF-8">
				<c:param name="fdModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
				<c:param name="fdCategoryId" value="${kmsKmtopicMainForm.docCategoryId }" />
				<c:param name="fdModelId" value="${kmsKmtopicMainForm.fdId }" />
			</c:import>	
			<!-- 删除 -->
			<kmss:auth
					requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=delete&fdId=${param.fdId}"
					requestMethod="GET">
				<ui:button text="${lfn:message('kms-kmtopic:kmsKmtopicMain.button.delete')}" 
						onclick="confirmDelete();" order="5">
				</ui:button>
			</kmss:auth>
			<!-- 关闭 -->
			<ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow(); " order="6">
			</ui:button>
		</ui:toolbar>
		<div class="lui_form_path_frame" style="width:90%; min-width:980px; margin:0px auto;">
			<!-- 路径 -->
				<ui:combin ref="menu.path.simplecategory">
					<ui:varParams 
						moduleTitle="${ lfn:message('kms-kmtopic:module.kms.kmtopic') }" 
						modulePath="/kms/kmtopic/" 
						modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" 
						autoFetch="false"
						href="/kms/kmtopic/"
						categoryId="${kmsKmtopicMainForm.docCategoryId}" />
				</ui:combin>
		</div>
	
		<c:set
			var="sysDocBaseInfoForm"
			value="${kmsKmtopicMainForm}"
			scope="request" />
		<table style="width:90%; min-width:980px; margin: 0px auto;" >
			<tr>
				<td colspan="2">
					<div class="kms_kmtopic_content">
						<div class="kms_kmtopic_headBox">
							<!-- 封面 -->
							<div class="imgbox">
								<img src="${LUI_ContextPath }${imgUrl}">
							</div>
							<h2>
								${kmsKmtopicMainForm.docSubject}
								<c:if test="${isHasNewVersion=='true'}">
								     <span style="color:red">(<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.has" />
								     <a href="javascript:;" style="font-size:20px;color:red" onclick="Com_OpenWindow('kmsKmtopicMain.do?method=view&fdId=${kmsKmtopicMainForm.docOriginDocId}','_self');">
									 <bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.NewVersion" /></a>)</span>
						        </c:if>
							</h2>
							
							<!-- 摘要 -->
							<p class="desc">
								${kmsKmtopicMainForm.fdDescription}
							</p>
							<div class="kms_kmtopic_h_foot">
								<c:if test="${ fn:length(kmsKmtopicMainForm.fdCatelogList)>1|| fn:length(kmsKmtopicMainForm.fdCatelogList[0].fdCatelogContentList)>0 }">
									<label class="kms_opeGroup" onclick="selectAll()">
										<input type="checkbox">
										<span  class="lui_kmtopic_opt_select" >${ lfn:message('kms-kmtopic:kmsKmtopicMain.chooseAll') }</span>
									</label>
									<div  class="lui_kmtopic_batchdown" onclick="batchDown()">${ lfn:message('kms-kmtopic:kmsKmtopicMain.batch.downLoad') }</div>
									
								</c:if>
								
		                        <!-- 点赞 -->
		                        <div class="btn_praise" >
		                            <c:import
										url="/sys/praise/sysPraiseMain_view.jsp"
										charEncoding="UTF-8">
										<c:param name="docPraiseCount" value="${kmsKmtopicMainForm.docPraiseCount}" />
										<c:param name="fdModelId" value="${kmsKmtopicMainForm.fdId}" />
										<c:param name="fdModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
									</c:import>
		                        </div>
		                        <div style="float:right;">
		                        	<!-- 分享 -->
				                    <c:import
										url="/kms/common/kms_share/kmsShareMain_view.jsp"
										charEncoding="UTF-8">
										<c:param name="fdCategoryId" value="${kmsKmtopicMainForm.docCategoryId}" />
										<c:param name="fdModelId" value="${kmsKmtopicMainForm.fdId}" />
										<c:param name="fdModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
									</c:import>
		                        </div>
							</div>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td width="75%" valign="top">
					<div id="att_doc_attachment" style="width:100%; min-width:912px;">
					
					<!-- 摘要-->
					<c:if test="${kmsKmtopicMainForm.fdDisplayStyle == '1'}">
						<c:forEach items="${kmsKmtopicMainForm.fdCatelogList}" var="fdCatelogList" varStatus="vstatus">
							<!-- 判断当第一个目录（无目录名）没内容时，不显示该目录 -->
							<div class="kms_listWrapper" 
								<c:if test="${vstatus.first&& empty kmsKmtopicMainForm.fdCatelogList[0].fdCatelogContentList[0].kmDocSubject}">style="display: none"</c:if> >
								<div class="kms_listBox">
									<h4>
										<span class="fileTitle">${fdCatelogList.fdName}
											<span class="fileCount">(${ fn:length(fdCatelogList.fdCatelogContentList)})</span>
										</span>
										<span class="btnPage">
											<%-- 列表分页 --%>
										 	<list:paging  channel="${vstatus.index+1}">
										 		<ui:layout type="Template" >
										 			<c:import url="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_view_pagging.jsp" charEncoding="UTF-8">
													</c:import>
										 		</ui:layout>
										 	</list:paging>
									 	</span>
									 	<a onclick="slideLogContent(this)">
									 		<span class="btn_slide">${lfn:message("kms-kmtopic:kmsKmtopicMain.slideUp")}</span>
									 	</a>
									</h4>
									
									<!-- 当目录内没文件时，不进行查询，防止在页面出现“很抱歉，未找到相应的记录！”提示 -->
									<c:choose>
										<c:when test="${not empty fdCatelogList.fdCatelogContentList[0].kmDocSubject}">
											<list:listview id="listview${vstatus.index+1}" channel="${vstatus.index+1}">
												<ui:source type="AjaxJson">
													{url:'/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMainIndex.do?method=listKmtopicLog&cateLogId=${fdCatelogList.fdId }&rowsize=8'}
												</ui:source>
												<list:rowTable layout="sys.ui.listview.rowtable" 
													name="rowtable" onRowClick="" rowHref="!{rowHref}" 
													style="" target="_blank"> 
													<list:row-template ref="sys.ui.listview.rowtable">
													</list:row-template>
												</list:rowTable>
											</list:listview>
										</c:when>
										<c:otherwise>
											<div class="emptyLogContent"></div>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</c:forEach>
					</c:if>
									
					<!-- 列表 -->
					<c:if test="${kmsKmtopicMainForm.fdDisplayStyle == '3'}">
						<c:forEach items="${kmsKmtopicMainForm.fdCatelogList}" var="fdCatelogList" varStatus="vstatus">
							<!-- 第一个目录内没内容 -->
							<div class="kms_listWrapper" 
								<c:if test="${vstatus.first&& empty kmsKmtopicMainForm.fdCatelogList[0].fdCatelogContentList[0].kmDocSubject}">style="display: none"</c:if> >
								<div class="kms_listBox">
									<h4>
										<span class="fileTitle">${fdCatelogList.fdName}
											<span class="fileCount">(${ fn:length(fdCatelogList.fdCatelogContentList)})</span>
										</span>
											
										<span class="btnPage">
											<%-- 列表分页 --%>
										 	<list:paging  channel="${vstatus.index+1}">
										 		<ui:layout type="Template" >
										 			<c:import url="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_view_pagging.jsp" charEncoding="UTF-8">
													</c:import>
										 		</ui:layout>
										 	</list:paging>
									 	</span>
									 	<a onclick="slideLogContent(this)">
									 		<span class="btn_slide">${lfn:message("kms-kmtopic:kmsKmtopicMain.slideUp")}</span>
									 	</a>
									</h4>
									
									<!-- 当目录内没文件时，不进行查询，防止在页面出现“很抱歉，未找到相应的记录！”提示 -->
									<c:if test="${not empty fdCatelogList.fdCatelogContentList[0].kmDocSubject}">
										<list:listview id="listview${vstatus.index+1}" channel="${vstatus.index+1}">
												<ui:source type="AjaxJson">
													{url:'/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMainIndex.do?method=listKmtopicLog&cateLogId=${fdCatelogList.fdId }&rowsize=8'}
												</ui:source>
												
												<%-- 列表视图--%>
												<list:colTable layout="sys.ui.listview.columntable" name="columntable"
													rowHref="!{rowHref}"> 
													<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
													<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
													<list:col-html title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.docSubject')}" headerStyle="width:40%" style="text-align:left;padding:0 8px">
														{$
															<span class="com_subject">{%row['docSubject']%}</span> 
														$}
													</list:col-html>
													<list:col-auto props="docPublishTime;docCategory.fdName;docAuthor.fdName"></list:col-auto>
												</list:colTable>
										</list:listview>
									</c:if>
								</div>
							</div>
						</c:forEach>
					</c:if>	
					
					<!-- 视图 -->
					<c:if test="${kmsKmtopicMainForm.fdDisplayStyle == '2'}">
						<c:forEach items="${kmsKmtopicMainForm.fdCatelogList}" var="fdCatelogList" varStatus="vstatus">
							<!-- 第一个目录内没内容 -->
							<div class="kms_listWrapper" 
								<c:if test="${vstatus.first&& empty kmsKmtopicMainForm.fdCatelogList[0].fdCatelogContentList[0].kmDocSubject}">style="display: none"</c:if>>
								<h4>
									<span class="fileTitle">${fdCatelogList.fdName}
										<span class="fileCount">(${ fn:length(fdCatelogList.fdCatelogContentList)})</span>
									</span>
									<span class="btnPage">
										<%-- 列表分页 --%>
									 	<list:paging  channel="${vstatus.index+1}">
									 		<ui:layout type="Template" >
									 			<c:import url="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_view_pagging.jsp" charEncoding="UTF-8">
												</c:import>
									 		</ui:layout>
									 	</list:paging>
								 	</span>
								 	<a onclick="slideLogContent(this)">
								 		<span class="btn_slide">${lfn:message("kms-kmtopic:kmsKmtopicMain.slideUp")}</span>
								 	</a>
								</h4>
								<div class="kms_listBox">
									<!-- 当目录内没文件时，不进行查询，防止在页面出现“很抱歉，未找到相应的记录！”提示 -->
									<c:if test="${not empty fdCatelogList.fdCatelogContentList[0].kmDocSubject}">
										<list:listview id="listview${vstatus.index+1}" channel="${vstatus.index+1}">
											<list:gridTable name="gridtable" onGridClick="openFile('!{fdId}','!{rowHref}','!{fdContentType}');">
												<ui:source type="AjaxJson">
													{url:'/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMainIndex.do?method=listKmtopicLog&cateLogId=${fdCatelogList.fdId }&rowsize=8&dataType=pic'}
												</ui:source>
												<list:row-template ref="sys.ui.listview.gridtable" >
												</list:row-template>
											</list:gridTable>
										</list:listview>
									</c:if>
								</div>
							</div>
						</c:forEach>
					</c:if>
					</div>
							
					<ui:tabpage expand="false" id="share">
						<!-- 文档属性 -->
						<c:if test="${not empty kmsKmtopicMainForm.extendFilePath}">
							<ui:content title="${lfn:message('kms-kmtopic:kmsKmtopicMain.fdProperty') }">
								<table class="tb_simple"  width="100%" >
									<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
										<c:param name="formName" value="kmsKmtopicMainForm" />
										<c:param name="fdDocTemplateId" value="${kmsKmtopicMainForm.docCategoryId}" />
									</c:import>
								</table>
							</ui:content>
						</c:if>	
						<!-- 点评 -->
						<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp" charEncoding="UTF-8" >
							<c:param name="formName" value="kmsKmtopicMainForm" />
						</c:import>
						<!-- 阅读记录 -->
						<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
						</c:import>
						<!-- 版本 -->
						<c:import url="/sys/edition/import/sysEditionMain_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
						</c:import>
						<!-- 权限 -->
						<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
							<c:param name="moduleModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
						</c:import>
						<%--发布机制 --%>
						<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
						</c:import> 
						<!-- 收藏 -->
						<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
							<c:param name="fdSubject" value="${kmsKmtopicMainForm.docSubject}" />
							<c:param name="fdModelId" value="${kmsKmtopicMainForm.fdId}" />
							<c:param name="fdModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
						</c:import>
						<!-- 流程 -->
						<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
							<c:param name="fdKey" value="kmtopic" />
						</c:import>
					</ui:tabpage>		
				</td>
				<td width="25%" valign="top">
					<div style="padding-left:15px;">
						<div style="min-width:200px;"></div>
						<ui:accordionpanel style="min-width:200px;" toggle="false"> 
							<ui:content title="${lfn:message('kms-kmtopic:kmsKmtopicMain.docInfo') }">
								<ul class='lui_form_info'>
									<li>
										<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docCreator" />：
										<ui:person personId="${kmsKmtopicMainForm.docCreatorId}" personName="${kmsKmtopicMainForm.docCreatorName}">
										</ui:person>
									</li>
									<li>
										<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.publishTime" />：
										${ kmsKmtopicMainForm.docPublishTime }
									</li>
									<li>
										<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />：
										${ kmsKmtopicMainForm.docDeptName }
									</li>
									<li>
										${ lfn:message('kms-kmtopic:kmsKmtopicMain.status') }：
										<sunbor:enumsShow	value="${sysDocBaseInfoForm.docStatus}"	enumsType="kms_doc_status" />
									</li>
									<li>
										<bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />：
										V ${kmsKmtopicMainForm.editionForm.mainVersion}.${kmsKmtopicMainForm.editionForm.auxiVersion}
									</li>
								</ul>
								
								<div class="kms_kmtopic_tag">
	                                 <dl>
	                                     <dt>${ lfn:message('kms-kmtopic:kmsKmtopicMain.categoryInfo') }</dt>
	                                     <ul class='lui_kmtopic_cateInfo'>
	                                     	<li>
	                                     		<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docCategory"/> :
												 <a href="${LUI_ContextPath }/kms/kmtopic/?categoryId=${kmsKmtopicMainForm.docCategoryId}" target="_blank"><c:out value="${kmsKmtopicMainForm.docCategoryName}"/></a>
	                                   		</li>
	                                   		<li>
			                                     <c:if test="${not empty secondCategoriesNames[0]}">
													<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docProperties"/> :
													<c:forEach items="${secondCategoriesNames}" var="docSecondCateName" varStatus="varStatus">
														<a href="${LUI_ContextPath }/kms/kmtopic/?categoryId=${secondCategoriesIds[varStatus.index]}" target="_blank">${docSecondCateName}</a>
														<c:if test="${!varStatus.last }">;</c:if>
													</c:forEach>
												</c:if>
											</li>
										</ul>
	                                 </dl>
	                                 
                                     <!-- 知识标签 -->
									<c:set var="sysTagMainForm" value="${requestScope['kmsKmtopicMainForm'].sysTagMainForm}" />
									<c:if test="${not empty sysTagMainForm.fdTagNames}">
										<dl>
											<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
												<c:param name="formName" value="kmsKmtopicMainForm" />
												<c:param name="useTab" value="false"></c:param>
											</c:import>
										</dl>
									</c:if>	
	                             </div>
	                             
							</ui:content>
						</ui:accordionpanel>
						
						<c:import
							url="/sys/relation/import/sysRelationMain_view_new.jsp"
							charEncoding="UTF-8">
							<c:param
								name="formName"
								value="kmsKmtopicMainForm" />
							<c:param
								name="modelName"
								value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
							<c:param name="fdCategoryId" value="${kmsKmtopicMainForm.docCategoryId }" />
						</c:import>
					</div>
				</td>
			</tr>
		</table>
	</template:replace>
</template:include>
