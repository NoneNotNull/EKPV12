<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view">
	<template:replace name="title">
		<c:out value="${ lfn:message('example-rules:module.example.rules') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<script>
			function deleteDoc(delUrl) {
				seajs.use([ 'lui/dialog' ], function(dialog) {
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',
							function(isOk) {
								if (isOk) {
									Com_OpenWindow(delUrl, '_self');
								}
							});
				});
			}
		</script>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
		<!-- 收藏机制 -->
			<c:import url="/sys/bookmark/import/bookmark_bar.jsp"
				charEncoding="UTF-8">
				<c:param name="fdSubject" value="${exampleRulesMainForm.docSubject}" />
				<c:param name="fdModelId" value="${exampleRulesMainForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.example.rules.model.ExampleRulesMain" />
			</c:import>
			<kmss:auth
				requestURL="/example/rules/example_rules_main/exampleRulesMain.do?method=edit&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('exampleRulesMain.do?method=edit&fdId=${param.fdId}','_self');"
					order="2">
				</ui:button>
			</kmss:auth>
			<kmss:auth
				requestURL="/example/rules/example_rules_main/exampleRulesMain.do?method=delete&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" order="4"
					onclick="deleteDoc('exampleRulesMain.do?method=delete&fdId=${param.fdId}');">
				</ui:button>
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}" order="5"
				onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav">
			<ui:menu-item text="${ lfn:message('home.home') }"
				icon="lui_icon_s_home">
			</ui:menu-item>
			<ui:menu-item
				text="${ lfn:message('example-rules:module.example.rules') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="content">
		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
				<bean:write name="exampleRulesMainForm" property="docSubject" />
				<%--
				<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="sys-doc" key="kmDoc.kmDocKnowledge.has" /><bean:message bundle="sys-doc" key="kmDoc.kmDocKnowledge.NewVersion" />)</span>
		        </c:if>
				--%>
			</div>
			<div class='lui_form_baseinfo'>
				<%--
				${ lfn:message('example-rules:exampleRulesMain.docCreator') }：
				<ui:person bean="${exampleRulesMain.docCreator}"></ui:person>&nbsp;
				<c:if test="${ not empty exampleRulesMainForm.docPublishTime }">
					<bean:write name="exampleRulesMainForm" property="docPublishTime" />
				</c:if>&nbsp;
				<c:if test="${exampleRulesMainForm.docStatus == '30'}">
				 <bean:message key="sysEvaluationMain.tab.evaluation.label" bundle="sys-evaluation"/>
					 <span data-lui-mark='sys.evaluation.fdEvaluateCount' class="com_number">
						 <c:choose>
						   <c:when test="${not empty exampleRulesMainForm.evaluationForm.fdEvaluateCount}">
						      ${ exampleRulesMainForm.evaluationForm.fdEvaluateCount }
						   </c:when>
						   <c:otherwise>(0)</c:otherwise>
						 </c:choose>
					 </span>
				</c:if>
				<bean:message key="sysReadLog.tab.readlog.label" bundle="sys-readlog"/><span data-lui-mark="sys.readlog.fdReadCount" class="com_number">(${ exampleRulesMainForm.readLogForm.fdReadCount })</span>
				 --%>
			</div>
		</div>
		<%-- 文档概览
		<c:if test="${ not empty exampleRulesMainForm.fdDescription }">
			<div class="lui_form_summary_frame">			
				<bean:write	name="exampleRulesMainForm" property="fdDescription" />
			</div>
		</c:if>
		--%>
		<div class="lui_form_content_frame">
			<%-- 文档内容 --%>
			<c:if test="${not empty exampleRulesMainForm.docContent}">
				<div style="min-height: 200px;">
					${exampleRulesMainForm.docContent }</div>
			</c:if>
			<%-- 其它字段 --%>
			<table class="tb_simple" width=100%>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docSubject" /></td>
					<td width="35%"><xform:text property="docSubject"
							style="width:85%" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docCreateTime" /></td>
					<td width="35%"><xform:datetime property="docCreateTime" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.fdWorkType" /></td>
					<td width="35%"><xform:radio property="fdWorkType">
							<xform:enumsDataSource
								enumsType="example_rules_main_fd_work_type" />
						</xform:radio></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docPublishTime" /></td>
					<td width="35%"><xform:datetime property="docPublishTime" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docContent" /></td>
					<td width="35%"><xform:rtf property="docContent" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.fdNotifyType" /></td>
					<td width="35%"><xform:text property="fdNotifyType"
							style="width:85%" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docStatus" /></td>
					<td width="35%"><xform:select property="docStatus">
							<xform:enumsDataSource enumsType="example_rules_main_doc_status" />
						</xform:select></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docCategory" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.docCategoryName}" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.docCreator" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.docCreatorName}" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.fdNotifiers" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.fdNotifierNames}" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.authReaders" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.authReaderNames}" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.authEditors" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.authEditorNames}" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.authOtherReaders" />
					</td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.authOtherReaderNames}" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.authAllReaders" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.authAllReaderNames}" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.authOtherEditors" />
					</td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.authOtherEditorNames}" /></td>
					<td class="td_normal_title" width=15%><bean:message
							bundle="example-rules" key="exampleRulesMain.authAllEditors" /></td>
					<td width="35%"><c:out
							value="${exampleRulesMainForm.authAllEditorNames}" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
					<bean:message
						bundle="example-rules" key="exampleRulesMain.attachment" />
					</td>
					<td width="35%">
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
                           <c:param name="fdKey" value="attachment"/>
                           <c:param name="formBeanName" value="post"/>
                    </c:import>
                    </td>	
				</tr>
				<tr>
				  <td class="td_normal_title" width="15%">
				     <bean:message bundle="example-rules" key="exampleRulesMain.attachment"/>
				  </td>
				  <td colspan="3">
				     <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
                         <c:param name="fdKey" value="attachment"/>
                         <c:param name="formBeanName" value="post"/>
                     </c:import>
                   </td>
				</tr>
			</table>
		</div>
		<ui:tabpage expand="false">
		</ui:tabpage>
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