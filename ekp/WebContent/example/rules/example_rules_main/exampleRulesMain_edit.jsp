<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="title">
		<c:choose>
			<c:when test="${exampleRulesMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('operation.create') } - ${ lfn:message('example-rules:module.example.rules') }"></c:out>	
			</c:when>
			<c:otherwise>
					<c:out value="${exampleRulesMainForm.docSubject} - "/>
				<c:out value="${ lfn:message('example-rules:module.example.rules') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3"> 
			<c:choose>
				<c:when test="${ exampleRulesMainForm.method_GET == 'edit' }">
					<ui:button text="${ lfn:message('button.update') }" onclick="Com_Submit(document.exampleRulesMainForm, 'update');"></ui:button>
				</c:when>
				<c:when test="${ exampleRulesMainForm.method_GET == 'add' }">
					<ui:button text="${ lfn:message('button.save') }" onclick="Com_Submit(document.exampleRulesMainForm, 'save');"></ui:button>
					<ui:button text="${ lfn:message('button.saveadd') }" onclick="Com_Submit(document.exampleRulesMainForm, 'saveadd');"></ui:button>
				</c:when>
			</c:choose>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>	
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">			
		<ui:menu layout="sys.ui.menu.nav"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
			</ui:menu-item>	
			<ui:menu-item text="${ lfn:message('example-rules:module.example.rules') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	<template:replace name="content">
		<html:form action="/example/rules/example_rules_main/exampleRulesMain.do">
			<c:if test="${!empty exampleRulesMainForm.docSubject}">
				<p class="txttitle" style="display: none;">${exampleRulesMainForm.docSubject }</p>
			</c:if>
			<div class="lui_form_content_frame" style="padding-top:20px">
				<table class="tb_simple" width=100%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docSubject"/>
						</td>
						<td width="35%">
							<xform:text property="docSubject" style="width:85%" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docCreateTime"/>
						</td>
						<td width="35%">
							<xform:datetime property="docCreateTime" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.fdWorkType"/>
						</td>
						<td width="35%">
							<xform:radio property="fdWorkType">
								<xform:enumsDataSource enumsType="example_rules_main_fd_work_type" />
							</xform:radio>
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docPublishTime"/>
						</td>
						<td width="35%">
							<xform:datetime property="docPublishTime" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docContent"/>
						</td>
						<td width="35%">
							<xform:rtf property="docContent" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.fdNotifyType"/>
						</td>
						<td width="35%">
							<xform:text property="fdNotifyType" style="width:85%" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docStatus"/>
						</td>
						<td width="35%">
							<xform:select property="docStatus">
								<xform:enumsDataSource enumsType="example_rules_main_doc_status" />
							</xform:select>
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docCategory"/>
						</td>
						<td width="35%">
							<xform:select property="docCategoryId">
								<xform:beanDataSource serviceBean="exampleRulesCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
							</xform:select>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.docCreator"/>
						</td>
						<td width="35%">
							<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.fdNotifiers"/>
						</td>
						<td width="35%">
							<xform:address propertyId="fdNotifierIds" propertyName="fdNotifierNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.authReaders"/>
						</td>
						<td width="35%">
							<xform:address propertyId="authReaderIds" propertyName="authReaderNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.authEditors"/>
						</td>
						<td width="35%">
							<xform:address propertyId="authEditorIds" propertyName="authEditorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.authOtherReaders"/>
						</td>
						<td width="35%">
							<xform:address propertyId="authOtherReaderIds" propertyName="authOtherReaderNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.authAllReaders"/>
						</td>
						<td width="35%">
							<xform:address propertyId="authAllReaderIds" propertyName="authAllReaderNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.authOtherEditors"/>
						</td>
						<td width="35%">
							<xform:address propertyId="authOtherEditorIds" propertyName="authOtherEditorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="example-rules" key="exampleRulesMain.authAllEditors"/>
						</td>
						<td width="35%">
							<xform:address propertyId="authAllEditorIds" propertyName="authAllEditorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
						</td>
					</tr>
					<tr>
					   <td class="td_normal_title" width="15%">
					        <bean:message bundle="example-rules" key="exampleRulesMain.attachment"/>
					   </td>
					   <td colspan="3">
					        <!-- 附件机制 -->
					        <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
					        	<c:param name="formBeanName" value="exampleRulesMainForm"/>
			                    <c:param name="fdKey" value="attachment"/>
                            </c:import>
                            ${param.formBeanName }
					   </td>
					</tr>
				</table>
			</div>
			<ui:tabpage expand="false">
			</ui:tabpage>
		<html:hidden property="fdId" />
		<html:hidden property="method_GET" />
		</html:form>
		<script>
			$KMSSValidation(document.forms['exampleRulesMainForm']);
		</script>
	</template:replace>
	<%--
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${ lfn:message('sys-doc:kmDoc.kmDocKnowledge.docInfo') }" toggle="false">
				<c:import url="/sys/evaluation/import/sysEvaluationMain_view_star.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="exampleRulesMainForm" />
				</c:import>
				<ul class='lui_form_info'>
					<li><bean:message bundle="example-rules" key="exampleRulesMain.docCreator" />：
					<ui:person personId="${exampleRulesMainForm.docCreatorId}" personName="${exampleRulesMainForm.docCreatorName}"></ui:person></li>
					<li><bean:message bundle="example-rules" key="exampleRulesMain.docDept" />：${exampleRulesMainForm.docDeptName}</li>
					<li><bean:message bundle="example-rules" key="exampleRulesMain.docStatus" />：<sunbor:enumsShow value="${exampleRulesMainForm.docStatus}" enumsType="common_status" /></li>
					<li><bean:message bundle="example-rules" key="exampleRulesMain.docCreateTime" />：${exampleRulesMainForm.docCreateTime }</li>				
				</ul>
			</ui:content>
		</ui:accordionpanel>
	</template:replace>
	--%>
</template:include>