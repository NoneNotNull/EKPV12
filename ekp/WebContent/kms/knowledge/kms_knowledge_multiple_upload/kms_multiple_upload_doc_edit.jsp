<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadEditDocForm"%>
<%@page import="com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page import="com.landray.kmss.util.StringUtil"%>

<template:include ref="default.edit">
    <template:replace name="head">
    	 <template:replace name="head">
    	 <link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/multidoc/kms_multidoc_ui/style/edit.css" />
    	 <%@ include file="/kms/knowledge/kms_knowledge_multiple_upload/kms_multiple_upload_doc_edit_js.jsp"%>  
    	<script>
			seajs.use(['theme!form']);
		</script>
    </template:replace>
    <template:replace name="title">
	    <c:choose>
	    	<c:when test="${ param.isBatchOperate}">
				<c:out value="${ lfn:message('kms-knowledge:kmsKnowledge.multidoc.batchUpdate') }- ${ lfn:message('kms-knowledge:title.kms.multidoc') }"></c:out>
			</c:when>
			<c:otherwise>
				<c:out value="${kmsMultipleUploadEditDocForm.docSubject } - ${ lfn:message('kms-knowledge:title.kms.multidoc') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
    </template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
		   <ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.confirm') }" order="1" onclick="addDoc('${param.isBatchOperate}');"></ui:button>
		</ui:toolbar>
    </template:replace>
   <template:replace name="content"> 
     <html:form action="/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadEditDoc.do?method=saveDoc" method="post"> 
       <html:hidden property="fdId" />
       <html:hidden property="fdNewId" />
       <html:hidden property="spicAttIds" />
       <html:hidden property="spicDeleteAttIds" />
       <html:hidden property="delFormIds" />
       <html:hidden property="attId" />
       <html:hidden property="batchAttIds" />
       <html:hidden property="extendFilePath" />
       <html:hidden property="docCategoryName" />
       <html:hidden property="batchReferenceCount" />
				<div class="lui_multidoc_catelog">
					<div class="lui_multidoc_title">
						<bean:message bundle="kms-knowledge" key="table.kmsKnowledgeBaseDoc"/>
					</div>
				</div>
				
				<table class="tb_simple tb_property" width="100%">
			     <c:if test="${empty param.isBatchOperate}">
	                  <tr> 
							<td width="15%" class="td_normal_title">
								<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
							</td>
							<td width="85%" colspan="3">
							 <!-- 文档标题 -->
				                <bean:write name="kmsMultipleUploadEditDocForm" property="docSubject" />
		                	</td>
						</tr>
					</c:if>
                    <tr>
						<td class="td_normal_title" width="15%">
							<bean:message key="kmsKnowledgeCategory.fdName" bundle="kms-knowledge" />
						</td>
						<td width="35%">
							<html:hidden property="docCategoryId" /> 
							<span name="docTemp"><bean:write name="kmsMultipleUploadEditDocForm" property="docCategoryName" /></span>
						</td>
					</tr>
                    <tr>
						<!-- 作者 -->
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docAuthor" />
						</td>
						<td width="35%">
							<xform:radio property="authorType" onValueChange="changeAuthorType" value="${not empty kmsMultipleUploadEditDocForm.docAuthorId?1:2}">
								<xform:enumsDataSource enumsType="kmsKnowledgeAuthorType">
								</xform:enumsDataSource>
							</xform:radio>
						</td>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docAuthor" />
						</td>
						<td width="35%" id="innerAuthor" <c:if test="${empty kmsMultipleUploadEditDocForm.docAuthorId }">style="display: none;"</c:if> >
							<xform:address 
								required="true" 
								style="width:95%" 
								propertyId="docAuthorId" 
								propertyName="docAuthorName" 
								orgType="ORG_TYPE_PERSON"
								onValueChange="changeAuthodInfo" />
						</td>
						<td width="35%" id="outerAuthor" <c:if test="${not empty kmsMultipleUploadEditDocForm.docAuthorId }">style="display: none;"</c:if>>
							<xform:text property="outerAuthor" subject="${ lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.docAuthor')}" style="width:94%"></xform:text>
							<span class="txtstrong">*</span>
						</td>
					</tr>
					<tr>
						<!-- 所属部门 -->
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
						</td>
						<td width="35%">
						    <html:hidden property="docDeptId" />
							<xform:address required="false" validators="" subject="${ lfn:message('kms-multidoc:kmsMultidoc.form.main.docDeptId') }" style="width:95%" propertyId="docDeptId" propertyName="docDeptName" orgType='ORG_TYPE_ORGORDEPT' showStatus="edit"></xform:address>
						</td>
						<!-- 所属岗位 -->
						<td width="15%" class="td_normal_title">
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docPosts" />
						</td>
						<td width="35%">
							<xform:address required="false" style="width:95%" propertyId="docPostsIds" propertyName="docPostsNames" orgType='ORG_TYPE_POST' showStatus="edit"></xform:address>
						</td>
					</tr>
					<!-- 属性 -->
					<tr>
						<c:if test="${not empty kmsMultipleUploadEditDocForm.extendFilePath}">
							<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
								<c:param name="formName" value="kmsMultipleUploadEditDocForm" />
								<c:param name="fdDocTemplateId" value="${kmsMultipleUploadEditDocForm.docCategoryId}" />
							</c:import>
						</c:if>
					</tr>
					<!-- 摘要 -->
					<tr>
						<td width="15%" class="td_normal_title" valign="top">
							<bean:message bundle="sys-doc" key="sysDocBaseInfo.fdDescription" />
						</td>
						<td width="85%" colspan="3">
							<xform:textarea isLoadDataDict="false" property="fdDescription" validators="maxLength(1500)" style="width:98%;height:90px" className="inputmul" />
						</td>
					</tr>
					<!-- 标签 -->
					<tr>
						<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultipleUploadEditDocForm" />
							<c:param name="fdKey" value="mainDoc" /> 
							<c:param name="fdQueryCondition" value="docCategoryId" /> 
						</c:import>
					</tr>	
					<!-- 封面 -->
					<tr>
						<td width="15%" class="td_normal_title" valign="top">
							<bean:message bundle="kms-knowledge" key="kmsKnowledge.uploadCoverPic" />
						</td>
						<td width="85%" colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="spic"/>
								<c:param name="fdAttType" value="pic"/>
								<c:param name="fdShowMsg" value="true"/>
								<c:param name="fdMulti" value="false"/>
								<c:param name="fdLayoutType" value="pic"/>
								<c:param name="fdPicContentWidth" value="120"/>
								<c:param name="fdPicContentHeight" value="180"/>
								<c:param name="fdViewType" value="pic_single"/>
							</c:import>
						</td>
					</tr>
					<!-- 内容 -->
					<tr>
						<td width="15%" class="td_normal_title" style="vertical-align: top!important;">
							${ lfn:message('kms-knowledge:kmsKnowledge.batchUpdate.docContent')}
						</td>
						<td colspan="3">
							<kmss:editor property="docContent" toolbarSet="Default" height="500" width="98%"/>
						</td>
					</tr>	
		   </table>
		   <!-- 权限 -->
			<c:import url="/kms/knowledge/kms_knowledge_multiple_upload/kms_multiple_upload_right_workflow.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultipleUploadEditDocForm" /> 
				<c:param name="moduleModelName" value="${kmsMultipleUploadEditDocForm.fdModelName}" />
				<c:param name="fdKey" value="mainDoc" />
			</c:import>
     </html:form>
     <script>
	$KMSSValidation(document.forms['kmsMultipleUploadEditDocForm']);
     /*切换作者类型*/
 	function changeAuthorType(value) {
 		LUI.$('#innerAuthor').hide();
 		LUI.$('#outerAuthor').hide();
 		if (value == 1) {
 			LUI.$('#outerAuthor input').attr('validate', '').val('');
 			LUI.$('#innerAuthor input').attr('validate', 'required');
 			LUI.$('#innerAuthor').show();
 		}
 		if (value == 2) {
 			LUI.$('#innerAuthor input').attr('validate', '').val('');
 			LUI.$('#outerAuthor input').attr('validate', 'required');
 			LUI.$('#outerAuthor').show();
 			changeAuthodInfo(null);
 		}
 	}

 	/**
	*将部门和岗位修改为作者的部门和岗位
	*/
	function changeAuthodInfo(value) {
		if(value) {//内部作者
			var authorId = value[0];
			LUI.$.ajax({
				url : "<c:out value='${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=loadAuthodInfo'/>",
				type : 'post',
				dataType :'json',
				data: {fdId: authorId},
				success : function(data) {
					if (data) {
							LUI.$('input[name=docDeptId]').val(data.depId);
							LUI.$('input[name=docDeptName]').val(data.depName);
							LUI.$('input[name=docPostsIds]').val(data.postsIds);
							LUI.$('input[name=docPostsNames]').val(data.postsNames);
					} 
				},
				error : function(error) {
				}
			});
		} else {//外部作者
			LUI.$('input[name=docDeptId]').val('${kmsMultidocKnowledgeForm.docDeptId}');
			LUI.$('input[name=docDeptName]').val('${kmsMultidocKnowledgeForm.docDeptName}');
			LUI.$('input[name=docPostsIds]').val('${kmsMultidocKnowledgeForm.docPostsIds}');
			LUI.$('input[name=docPostsNames]').val('${kmsMultidocKnowledgeForm.docPostsNames}');
		}
		
	}
     </script>
   </template:replace>
 </template:include>
 <!-- 加载封面图 -->
 <%
	 KmsMultipleUploadEditDocForm uploadEditForm = (KmsMultipleUploadEditDocForm)request.getAttribute("kmsMultipleUploadEditDocForm");
	 String spicAttIds = uploadEditForm.getSpicAttIds();
	 if(StringUtil.isNotNull(spicAttIds)){
		 ISysAttMainCoreInnerService sysAttMainCoreInnerService = (ISysAttMainCoreInnerService) SpringBeanUtil
											.getBean("sysAttMainService");
		 SysAttMain sysAttMain = (SysAttMain)sysAttMainCoreInnerService.findByPrimaryKey(spicAttIds);
		 String fdFileName = sysAttMain.getFdFileName();
		 String attMainId = sysAttMain.getFdId();
		 Double fdSize = sysAttMain.getFdSize();
		 String fdFileId = sysAttMain.getFdFileId();
		 String fdContentType = sysAttMain.getFdContentType();
		 request.setAttribute("fdFileName", fdFileName);
		 request.setAttribute("attMainId", attMainId);
		 request.setAttribute("fdContentType", fdContentType);
		 request.setAttribute("fdSize", fdSize);
		 request.setAttribute("fdFileId", fdFileId);
		 request.setAttribute("isLoadPic", true);
	 }
 %>
 <script>
	 if("${isLoadPic}"){
	 	attachmentObject_spic.addDoc("${fdFileName}","${attMainId}",true,"${fdContentType}","${fdSize}","${fdFileId}");
	 }
 </script>