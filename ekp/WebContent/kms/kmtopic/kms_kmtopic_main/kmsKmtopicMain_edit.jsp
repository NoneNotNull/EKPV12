<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/style/edit.css" />
		<%@ include file="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_edit_js.jsp"%>
	</template:replace>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmsKmtopicMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('kms-kmtopic:kmsKmtopicMain.create.title') } - ${ lfn:message('kms-kmtopic:table.kmsKmtopicMain') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmsKmtopicMainForm.docSubject} - ${ lfn:message('kms-kmtopic:table.kmsKmtopicMain') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<c:when test="${ kmsKmtopicMainForm.method_GET == 'add' }">
					<ui:button text="${lfn:message('kms-kmtopic:kmsKmtopicMain.button.savedraft') }" order="2" onclick="commitMethod('save','true');">
					</ui:button>
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save','false');">
					</ui:button>
				</c:when>
				<c:when test="${ kmsKmtopicMainForm.method_GET == 'edit' }">
					<c:if test="${kmsKmtopicMainForm.docStatusFirstDigit=='1'}">
						<ui:button text="${lfn:message('kms-kmtopic:kmsKmtopicMain.button.savedraft') }" order="4" onclick="commitMethod('update','true');">
						</ui:button>
					</c:if>
					<c:if test="${kmsKmtopicMainForm.docStatusFirstDigit<'3'}">
						<ui:button text="${lfn:message('button.submit') }" order="4" onclick="commitMethod('update','false');">
						</ui:button>
					</c:if>
					<c:if test="${kmsKmtopicMainForm.docStatusFirstDigit>='3'}">
						<ui:button text="${lfn:message('button.submit') }" order="4" onclick="Com_Submit(document.kmsKmtopicMainForm, 'update');">
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
					moduleTitle="${ lfn:message('kms-kmtopic:table.kmsKmtopicMain') }" 
					modulePath="/kms/kmtopic/" 
					modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" 
					autoFetch="false"
					target="_blank"
					categoryId="${kmsKmtopicMainForm.docCategoryId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<html:form action="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do" >
			<html:hidden property="method_GET" />
			<html:hidden property="extendFilePath"/>
			<html:hidden property="extendDataXML"/>
			<html:hidden property="docStatus" />
			<html:hidden property="fdId" />
		<ui:step id="__step" style="background-color:#f2f2f2" onSubmit="commitMethod('save','false');" var-unHide="true" var-unPre="true">
			<ui:layout type="Template">
				<c:import url="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_step_layout.jsp" charEncoding="UTF-8">
				</c:import>
			</ui:layout>
			<ui:content title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.createTopic')}" toggle="false" id="ctn1">
					<h2 class="lui_kmtopic_baseinfo_m">${ lfn:message('kms-kmtopic:kmsKmtopicMain.docInfo') }</h2>
					<div class="lui_kmtopic_baseinfo_l">
						<div class="t_info">
						<table class="tb_simple" width="100%" id="validate_ele0">
							<!-- 标题 -->
							<tr>
								<td width="15%" class="td_normal_title">
									<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docSubject" />
								</td>
								<td width="85%" colspan="3">
									<xform:text isLoadDataDict="false" validators="maxLength(200)" subject="${ lfn:message('kms-kmtopic:kmsKmtopicMain.docSubject')}"
										property="docSubject" required="true" className="inputAdd" style="width:98%;" />   
								</td>
							</tr>
							<!-- 主分类 -->
							<tr>
								<td class="td_normal_title" width="15%">
									<bean:message key="kmsKmtopicMain.fdMainCate" bundle="kms-kmtopic" />
								</td>
								<td width="85%" colspan="3">
									<html:hidden property="docCategoryId" /> 
									<span name="docTemp"><bean:write name="kmsKmtopicMainForm" property="docCategoryName" /></span>
									<c:if test="${param.method == 'add' }">
										<a href="javascript:modifyCate(true,true)" style="margin-left:15px;" class="com_btn_link">${lfn:message('kms-kmtopic:kmsKmtopicMain.changeTemplate') }</a>
										<span class="txtstrong">*</span>
									</c:if>
								</td>
							</tr>
							<!-- 辅分类 -->
							<tr>
								<td class="td_normal_title" width="10%">
									<bean:message key="kmsKmtopicMain.docProperties" bundle="kms-kmtopic" />
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
									<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.orignAuthor" />
								</td>
								<td width="35%">
									<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsKmtopicMainForm.docAuthorId?1:2}">
										<xform:enumsDataSource enumsType="kmsKmtopicAuthorType">
										</xform:enumsDataSource>
									</xform:radio>
								</td>
								<td width="15%" class="td_normal_title">
									<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.docAuthor" />
								</td>
								<!-- 内部作者 -->
								<td width="35%" id="innerAuthor" <c:if test="${empty kmsKmtopicMainForm.docAuthorId }">style="display: none;"</c:if> >
									<c:if test="${empty kmsKmtopicMainForm.docAuthorId }">
										<xform:address  isLoadDataDict="false" style="width:95%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'  subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:address>
									</c:if>
									<c:if test="${not empty kmsKmtopicMainForm.docAuthorId }">
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
								<td width="35%" id="outerAuthor" <c:if test="${not empty kmsKmtopicMainForm.docAuthorId }">style="display: none;"</c:if>>
									<c:if test="${not empty kmsKmtopicMainForm.docAuthorId }">
										<xform:text property="outerAuthor"  style="width:95%" subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:text>
									</c:if>
									<c:if test="${empty kmsKmtopicMainForm.docAuthorId }">
										<xform:text property="outerAuthor"   required="true" style="width:95%" subject="${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') }"></xform:text>
									</c:if>
								</td>
							</tr>
							<tr>
								<!-- 所属部门 -->
								<td width="15%" class="td_normal_title">
									<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
								</td>
								<td width="35%">
									<xform:address 
										required="true" 
										validators="" 
										subject="${ lfn:message('kms-kmtopic:kmsKmtopicMain.docDept') }" 
										style="width:95%" 
										propertyId="docDeptId" 
										propertyName="docDeptName" 
										orgType='ORG_TYPE_ORGORDEPT'>
									</xform:address>
								</td>
								<!-- 所属岗位 -->
								<td width="15%" class="td_normal_title">
									<bean:message bundle="kms-kmtopic" key="table.kmsKmtopicMainPost" />
								</td>
								<td width="35%">
									<xform:address required="false" style="width:95%" propertyId="docPostsIds" propertyName="docPostsNames" orgType='ORG_TYPE_POST'></xform:address>
								</td>
							</tr>
						</table>
						</div>
						<!-- 封面  -->
						<div class="lui_kmtopic_baseinfo_pic">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="tpic"/>
								<c:param name="fdAttType" value="pic"/>
								<c:param name="fdShowMsg" value="true"/>
								<c:param name="fdMulti" value="false"/>
								<c:param name="fdLayoutType" value="pic"/>
								<c:param name="fdPicContentWidth" value="95%"/>
								<c:param name="fdPicContentHeight" value="158"/>
								<c:param name="fdViewType" value="pic_single"/>
							</c:import>
						</div>
					</div>
					<h2 class="lui_kmtopic_baseinfo_m">${ lfn:message('kms-kmtopic:kmsKmtopicMain.fileInfo') }</h2>
					<div style="padding-left: 5%;">
						<div class="lui_kmtopic_attach_type">
							<ul>
								<li class="file_sys" title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.choose.fromSystem') }" onclick="selctBySys(this);"></li> 
								<kmss:ifModuleExist path="/kms/multidoc/">
									<li class="file_att" title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.uploadAtt') }" onclick="categorySelectDialog(this)"></li>
								</kmss:ifModuleExist>
								<li class="file_link" title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.link') }" onclick="editLink(1,this)"></li>
								<li style="padding-top: 20px;width: 220px;">
									<a class="catlog_btn_add" onclick="catelogIframe(1)">
										${ lfn:message('kms-kmtopic:kmsKmtopicMain.addCatalog') }
									</a>
									<span class="kmtopic_catelog_tip">${ lfn:message('kms-kmtopic:kmsKmtopicMain.catalogTip') }</span>
								</li>
							</ul>
						</div>
						
						<div class="lui_kmtopic_attch_list">
							<ul id="all_logs">
								<div ></div>
								<!-- 附件上传form数据 -->
								<span id='attForm'></span>
								<c:choose>
									<c:when test="${ fn:length(kmsKmtopicMainForm.fdCatelogList)!=0 }">
										<c:forEach items="${kmsKmtopicMainForm.fdCatelogList}" var="fdCatelog" varStatus="varStatus">
											<div id="kmtopic_log${varStatus.index}" class="lui_kmtopic_log<c:if test='${varStatus.first}'>0</c:if>">                     
												<c:choose>
													<c:when test="${varStatus.first}">
														<html:hidden property="fdCatelogList[0].fdOrder" value="0"/>
														<html:hidden property="fdCatelogList[0].fdName" value="${ lfn:message('kms-kmtopic:kmsKmtopicCatelog.default')}"/>
													</c:when>
													<c:otherwise>
														<h3 class="kmtopic_headline">
															<html:hidden property="fdCatelogList[${varStatus.index}].fdName"/>
															<html:hidden property="fdCatelogList[${varStatus.index}].fdOrder"/>
															<span>${fdCatelog.fdName}</span>
															<span class="log_edit" onclick="catelogIframe(0,this)"></span>
															<span class="logDelete" onclick="deleteCatelog(this)"></span>
															<span class="log_icon_sys" onclick="selctBySys(this)"></span>
															<span class="log_icon_attach" onclick="categorySelectDialog(this)"></span>
															<span class="log_icon_exterLink" onclick="editLink(1,this)"></span>
														</h3>
													</c:otherwise>
												</c:choose>
												<li id="kmtopic_log${varStatus.index}_defaultLi" <c:if test='${not empty fdCatelog.fdCatelogContentList[0].kmDocSubject}'>style="display:none;"</c:if>></li>
												<c:forEach items="${fdCatelog.fdCatelogContentList}" var="fdCatelogContent" varStatus="vStatus">
													<li>
														<c:choose>
															<c:when test="${fdCatelogContent.fdContentType==0}">
																<span class='icon icon_sys'></span>
															</c:when>
															<c:when test="${fdCatelogContent.fdContentType==1}">
																<span class='icon icon_att'></span>
															</c:when>
															<c:otherwise>
																<span class='icon icon_link'></span>
															</c:otherwise>
														</c:choose>
														<span class="title">${fdCatelogContent.kmDocSubject }</span>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdKmDescription"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].kmDocPublishTime"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdKmId"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdKmAuthor"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdKmCategory"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].kmDocSubject"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdKnowledgeType"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdContentType"/>
														<html:hidden property="fdCatelogList[${varStatus.index}].fdCatelogContentList[${vStatus.index}].fdKmLink"/>
														<span class="delete" onclick="deleteFile(this)"></span>
													</li>
													
												</c:forEach>
											</div>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<div id="kmtopic_log0" class="lui_kmtopic_log0">
											<html:hidden property="fdCatelogList[0].fdOrder" value="0"/>
											<html:hidden property="fdCatelogList[0].fdName" value="${lfn:message('kms-kmtopic:kmsKmtopicCatelog.default')}"/>
											<li id="kmtopic_log0_defaultLi"></li>
										</div>
									</c:otherwise>
								</c:choose>
							</ul>
						</div>
						
					</div>
				
			</ui:content>
			
			<ui:content title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.topicProperty') }" toggle="false" id="ctn2">
				<h2 class="lui_kmtopic_baseinfo_m">${ lfn:message('kms-kmtopic:kmsKmtopicMain.fdProperty') }</h2>
				<table class="tb_simple" width="100%" id="validate_ele2">
					<!-- 专辑属性 -->
					<c:if test="${not empty kmsKmtopicMainForm.extendFilePath}">
						<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
							<c:param name="fdDocTemplateId" value="${kmsKmtopicMainForm.docCategoryId}" />
						</c:import>
					</c:if>
					<!-- 标签 -->
					<tr>
						<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsKmtopicMainForm" />
							<c:param name="fdKey" value="kmtopic" /> 
							<c:param name="fdQueryCondition" value="docCategoryId;docDeptId" /> 
						</c:import>
					</tr>
					<tr>
						<td width="10%" class="td_normal_title" style="vertical-align:top!important;text-align: right;">
							${ lfn:message('kms-kmtopic:kmsKmtopicMain.description') }
						</td>
						<td colspan="3">
							<xform:textarea isLoadDataDict="false" property="fdDescription" validators="maxLength(1500)" style="width:98%;height:160px" className="inputmul" />
						</td>
					</tr>
					<tr>
						<td width="10%" class="td_normal_title">
							${ lfn:message('kms-kmtopic:kmsKmtopicMain.displayStyle') }
						</td>
						<td width="90%">
							<xform:radio property="fdDisplayStyle">
								<xform:enumsDataSource enumsType="kmsKmtopicMainFdDisplayStyle">
								</xform:enumsDataSource>
							</xform:radio>
						</td>
					</tr>
				</table>
			</ui:content>
			
			<!-- 权限及流程 -->
			<ui:content title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.rightAndFlow') }" toggle="false" id="ctn3">
				<c:import url="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_rightAndWorkflow_add.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsKmtopicMainForm" /> 
					<c:param name="moduleModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
					<c:param name="fdKey" value="kmtopic" />
				</c:import>
				<%---发布机制 开始---%>
				<h2 class="lui_kmtopic_baseinfo_m">
					${ lfn:message('kms-kmtopic:kmsKmtopicMain.publish') }
				</h2>
				<c:import
					url="/sys/news/import/sysNewsPublishMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsKmtopicMainForm" />
					<c:param name="fdKey" value="kmtopic" />	 
					<c:param name="isShow" value="true" /><%--是否显示--%>
				</c:import> 	
				<%---发布机制 结束---%>
				<!-- 版本 -->
				<div style="display:none">
					<c:import url="/sys/edition/import/sysEditionMain_edit.jsp" charEncoding="UTF-8" >
						<c:param name="formName" value="kmsKmtopicMainForm" />
					</c:import>
				</div>
			</ui:content>
			
		</ui:step>
		
		<div class="sideToolbar" id="sideToolbar">
			<dl>
				<dd class="highlight" id="logScorll1">
					<span class="top"></span>
					<a href="javascript:void(0)" style="font-size: 14px;" onclick="catelogScroll('ctn1',this)">
						${ lfn:message('kms-kmtopic:kmsKmtopicMain.docInfo')} 
					</a>
					<span class="bottom"></span>
				</dd>
				
				<dd id="logScorll2">
					<span class="top"></span>
					<a href="javascript:void(0)" style="font-size: 14px;" onclick="catelogScroll('ctn2',this)">
						${lfn:message('kms-kmtopic:kmsKmtopicMain.fdProperty') }
					</a>
					<span class="bottom"></span>
				</dd>
				
				<dd id="logScorll3">
					<span class="top"></span>
					<a href="javascript:void(0)" style="font-size: 14px;" onclick="catelogScroll('ctn3',this)">
						${ lfn:message('kms-kmtopic:kmsKmtopicMain.rightAndFlow') }
					</a>
					<span class="bottom"></span>
				</dd>
			</dl>
		</div>
		
		</html:form>
		<script language="JavaScript">
			$KMSSValidation(document.forms['kmsKmtopicMainForm']);
		</script>		
	</template:replace>
</template:include>
