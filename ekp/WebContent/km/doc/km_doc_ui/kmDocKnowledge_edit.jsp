<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<template:include ref="default.edit">
	<template:replace name="title">
	<c:choose>
		<c:when test="${ kmDocKnowledgeForm.method_GET == 'add' }">
			<c:out value="${ lfn:message('km-doc:kmDoc.create.title') } - ${ lfn:message('km-doc:module.km.doc') }"></c:out>	
		</c:when>
		<c:otherwise>
			<c:out value="${kmDocKnowledgeForm.docSubject} - ${ lfn:message('km-doc:module.km.doc') }"></c:out>
		</c:otherwise>
	</c:choose>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<c:when test="${ kmDocKnowledgeForm.method_GET == 'add' }">
					<ui:button text="${lfn:message('km-doc:kmDoc.button.savedraft') }" order="2" onclick="commitMethod('save','true');">
					</ui:button>
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save','false');">
					</ui:button>
				</c:when>
				<c:when test="${ kmDocKnowledgeForm.method_GET == 'edit' }">
					<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit=='1'}">
						<ui:button text="${lfn:message('km-doc:kmDoc.button.savedraft') }" order="2" onclick="commitMethod('update','true');">
						</ui:button>
					</c:if>
					<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit<'3'}">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update','false');">
						</ui:button>
					</c:if>
					<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit>='3'}">
						<ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmDocKnowledgeForm, 'update');">
						</ui:button>
					</c:if>			
				</c:when>
			</c:choose>
			<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
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
					target="_blank"
					categoryId="${kmDocKnowledgeForm.fdDocTemplateId}" />
			</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<script type="text/javascript">
				function commitMethod(commitType, saveDraft){
					var formObj = document.kmDocKnowledgeForm;
					var docStatus = document.getElementsByName("docStatus")[0];
					if(saveDraft=="true"){
						docStatus.value="10";
					}else{
						docStatus.value="20";
					}
					if('save'==commitType){
						Com_Submit(formObj, commitType,'fdId');
				    }else{
				    	Com_Submit(formObj, commitType); 
				    }
				}
				function confirmChgCate(modeName,url,canClose){
					seajs.use(['sys/ui/js/dialog'],	function(dialog) {
						dialog.confirm("${lfn:message('km-doc:kmDoc.changeCate.confirmMsg')}",function(flag){
						if(flag==true){
							window.changeDocCate(modeName,url,canClose);
						}},"warn");
					});
				};
				function changeDocCate(modeName,url,canClose,flag) {
					if(modeName==null || modeName=='' || url==null || url=='')
						return;
					seajs.use(['sys/ui/js/dialog'],	function(dialog) {
						dialog.simpleCategoryForNewFile(modeName,url,false,function(rtn) {
							// 门户无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
							if (!rtn && flag == "portlet")
								window.close();
						},null,null,"_self",canClose);
					});
				};
		</script>
		<c:if test="${kmDocKnowledgeForm.method_GET=='add'}">
			<script language="JavaScript">
			    var _doc_create_url='/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdWorkId=${param.fdWorkId}&fdPhaseId=${param.fdPhaseId}';
			    if('${param.fdTemplateId}'==''&&'${param.originId}'==''){
			   		changeDocCate('com.landray.kmss.km.doc.model.KmDocTemplate',_doc_create_url,true,"portlet");
			    }
			</script>
		</c:if>
		<c:set var="sysDocBaseInfoForm" value="${kmDocKnowledgeForm}" scope="request" />
		<html:form action="/km/doc/km_doc_knowledge/kmDocKnowledge.do">
		<html:hidden property="fdImportInfo" />
		<html:hidden property="fdId" />
		<html:hidden property="fdModelId" />
		<html:hidden property="fdModelName" />
		<html:hidden property="fdWorkId" />
		<html:hidden property="fdPhaseId" />
		<html:hidden property="docStatus" />
		<html:hidden property="docCreateTime"/>
		<c:if test="${empty kmDocKnowledgeForm.docSubject}">
			<p class="txttitle" style="display: none;"><bean:message bundle="km-doc" key="kmDoc.form.title" /></p>
		</c:if>
		<c:if test="${!empty kmDocKnowledgeForm.docSubject}">
			<p class="txttitle" style="display: none;">${kmDocKnowledgeForm.docSubject }</p>
		</c:if> 
		
		<div class="lui_form_content_frame" style="padding-top:20px">
			<table class="tb_simple" width=100%>
				<tr>
					<td width="15%" class="td_normal_title">
						<bean:message bundle="sys-doc" key="sysDocBaseInfo.docSubject" />
					</td>
					<td colspan="3">
						<xform:text isLoadDataDict="false" validators="maxLength(200)" 
							property="docSubject" required="true" subject="${lfn:message('sys-doc:sysDocBaseInfo.docSubject')}" className="inputsgl" style="width:97%;" />
					</td>
				</tr>
				<tr>
					<td width="15%" class="td_normal_title">
						<bean:message bundle="sys-doc" key="sysDocBaseInfo.docDept" />
					</td>
					<td width="35%">
						<xform:address isLoadDataDict="false" required="true" subject="${lfn:message('sys-doc:sysDocBaseInfo.docDept')}" style="width:95%" propertyId="docDeptId" propertyName="docDeptName" orgType='ORG_TYPE_ORGORDEPT'></xform:address>
					</td>
					<td width="15%" class="td_normal_title">
						<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />
					</td>
					<td width="35%">
						<xform:address isLoadDataDict="false"  style="width:95%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'></xform:address>	
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="15%">
						<bean:message key="kmDocKnowledge.fdTemplateName" bundle="km-doc" />
					</td>
					<td <%=ISysAuthConstant.IS_AREA_ENABLED? "width='35%'":"colspan='3'"%>>
						<html:hidden property="fdDocTemplateId" /> 
						<bean:write	name="kmDocKnowledgeForm" property="fdDocTemplateName" />
						<c:if test="${kmDocKnowledgeForm.method_GET=='add'}">
							&nbsp;&nbsp;
							<a href="javascript:confirmChgCate('com.landray.kmss.km.doc.model.KmDocTemplate',_doc_create_url,true);" class="com_btn_link">
								<bean:message key="kmDocKnowledge.changeCate" bundle="km-doc" /> 
							</a>
						</c:if>
					</td>
	               <%-- 所属场所 --%>
	               <c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field_single.jsp" charEncoding="UTF-8">
	                   <c:param name="id" value="${kmDocKnowledgeForm.authAreaId}"/>
	               </c:import>        			    		    
				</tr>
				<tr>		
					<td class="td_normal_title" width="15%">
						<bean:message bundle="km-doc" key="table.kmDocMainProperty" />
					</td>
					<td colspan="3">
						<xform:dialog style="width:98%;" propertyId="docPropertiesIds" propertyName="docPropertiesNames">
							Dialog_property(true, 'docPropertiesIds','docPropertiesNames', ';', ORG_TYPE_PERSON);
						</xform:dialog>
					</td> 
				</tr>		
				<!-- 标签机制 -->
				<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm" />
					<c:param name="fdKey" value="mainDoc" /> 
					<c:param name="fdQueryCondition" value="fdDocTemplateId;docDeptId" /> 
				</c:import>
				<!-- 内容摘要、文档内容、文档附件 -->
				<%@ include file="/sys/doc/sys_doc_base_info/sysDocBaseInfo_edit_bottom.jsp"%>
			</table>
		</div>
		<ui:tabpage expand="false">
			
			<%---发布机制---%>
			<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="fdKey" value="mainDocPublish" />	 
				<c:param name="isShow" value="true" />
			</c:import> 
			
			<%---版本机制 开始---%>
			<c:import url="/sys/edition/import/sysEditionMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
			</c:import>
			
			<%--权限机制 --%>
			<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
			</c:import>
			
			<%--流程机制 --%>
			<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
			</c:import>
		</ui:tabpage>
		</html:form>
		<script language="JavaScript">
		$KMSSValidation(document.forms['kmDocKnowledgeForm']);
		</script>
	</template:replace>
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${lfn:message('km-doc:kmDoc.kmDocKnowledge.docInfo') }" toggle="false">
				<ul class='lui_form_info'>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreator" />：
					<xform:address propertyId="docCreatorId" propertyName="docCreatorName" showLink="true" showStatus="view"></xform:address>
					<!--<ui:person personId="${kmDocKnowledgeForm.docCreatorId}" personName="${kmDocKnowledgeForm.docCreatorName}"></ui:person>-->
					</li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docStatus" />：
						<sunbor:enumsShow value="${sysDocBaseInfoForm.docStatus==null ? '10' : sysDocBaseInfoForm.docStatus}" enumsType="common_status" /></li>
					<li><bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />：${kmDocKnowledgeForm.editionForm.currentVersion}</li>
					<li><bean:message bundle="sys-doc" key="sysDocBaseInfo.docCreateTime" />：${ kmDocKnowledgeForm.docCreateTime}</li>				
				</ul>
			</ui:content>
		</ui:accordionpanel>
		<%--关联机制(与原有机制有差异)--%>
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmDocKnowledgeForm" />
		</c:import>
	</template:replace>
</template:include>