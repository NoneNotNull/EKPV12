<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view">
	<template:replace name="title">
		<c:out value="${ lfn:message('work-cases:module.work.cases') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<script>
		function deleteDoc(delUrl){
			seajs.use(['lui/dialog'],function(dialog){
				dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
					if(isOk){
						Com_OpenWindow(delUrl,'_self');
					}	
				});
			});
		}
		</script>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			<c:if test="${workCasesMainForm.docStatus != '30' }">
				<kmss:auth requestURL="/work/cases/work_cases_main/workCasesMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('button.edit')}" 
								onclick="Com_OpenWindow('workCasesMain.do?method=edit&fdId=${param.fdId}','_self');" order="2">
					</ui:button>
				</kmss:auth>
			</c:if>
			<kmss:auth requestURL="/work/cases/work_cases_main/workCasesMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" order="4"
							onclick="deleteDoc('workCasesMain.do?method=delete&fdId=${param.fdId}');">
				</ui:button> 
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
			<!-- 收藏机制 固定格式-->
			 <c:import
				url="/sys/bookmark/import/bookmark_bar.jsp"
				charEncoding="UTF-8">
				<c:param name="fdSubject" value="${workCasesMainForm.docSubject}" />
				<c:param name="fdModelId" value="${workCasesMainForm.fdId}" />
				<c:param name="fdModelName" value="com.landray.kmss.work.cases.model.WorkCasesMain" />
			</c:import> 
			
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
			</ui:menu-item>	
			<ui:menu-item text="${ lfn:message('work-cases:module.work.cases') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="content">
		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
					<bean:write	name="workCasesMainForm" property="docSubject" />
				<%--
				<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="sys-doc" key="kmDoc.kmDocKnowledge.has" /><bean:message bundle="sys-doc" key="kmDoc.kmDocKnowledge.NewVersion" />)</span>
		        </c:if>
				--%>
			</div>
			<div class='lui_form_baseinfo'>
				<%--
				${ lfn:message('work-cases:workCasesMain.docCreator') }：
				<ui:person bean="${workCasesMain.docCreator}"></ui:person>&nbsp;
				<c:if test="${ not empty workCasesMainForm.docPublishTime }">
					<bean:write name="workCasesMainForm" property="docPublishTime" />
				</c:if>&nbsp;
				<c:if test="${workCasesMainForm.docStatus == '30'}">
				 <bean:message key="sysEvaluationMain.tab.evaluation.label" bundle="sys-evaluation"/>
					 <span data-lui-mark='sys.evaluation.fdEvaluateCount' class="com_number">
						 <c:choose>
						   <c:when test="${not empty workCasesMainForm.evaluationForm.fdEvaluateCount}">
						      ${ workCasesMainForm.evaluationForm.fdEvaluateCount }
						   </c:when>
						   <c:otherwise>(0)</c:otherwise>
						 </c:choose>
					 </span>
				</c:if>
				<bean:message key="sysReadLog.tab.readlog.label" bundle="sys-readlog"/><span data-lui-mark="sys.readlog.fdReadCount" class="com_number">(${ workCasesMainForm.readLogForm.fdReadCount })</span>
				 --%>
			</div>
		</div>
		<%-- 文档概览
		<c:if test="${ not empty workCasesMainForm.fdDescription }">
			<div class="lui_form_summary_frame">			
				<bean:write	name="workCasesMainForm" property="fdDescription" />
			</div>
		</c:if>
		--%>
		<div class="lui_form_content_frame">
			<%-- 文档内容 --%>
			<c:if test="${not empty workCasesMainForm.docContent}">
				<div style="min-height: 200px;">
					${workCasesMainForm.docContent }	
				</div>			
			</c:if>
			<%-- 其它字段 --%>
			<table class="tb_simple" width=100%>
				<!--   <tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docSubject"/>
					</td>
					<td width="35%">
						<xform:text property="docSubject" style="width:85%" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docContent"/>
					</td>
					<td width="35%">
						<xform:rtf property="docContent" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docCreateTime"/>
					</td>
					<td width="35%">
						<xform:datetime property="docCreateTime" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docPublishTime"/>
					</td>
					<td width="35%">
						<xform:datetime property="docPublishTime" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.fdWorkType"/>
					</td>
					<td width="35%">
						<xform:select property="fdWorkType">
							<xform:enumsDataSource enumsType="work_cases_main_fd_work" />
						</xform:select>
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docCreator"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.docCreatorName}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docCategory"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.docCategoryName}" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.authReaders"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.authReaderNames}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.authOtherReaders"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.authOtherReaderNames}" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.authAllReaders"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.authAllReaderNames}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.authEditors"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.authEditorNames}" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.authOtherEditors"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.authOtherEditorNames}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.authAllEditors"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.authAllEditorNames}" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.fdNotifiers"/>
					</td>
					<td width="35%">
						<c:out value="${workCasesMainForm.fdNotifierNames}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="work-cases" key="workCasesMain.docStatus"/>
					</td>
					<td width="35%">
						<xform:text property="docStatus" style="width:85%" />
					</td>
				</tr> -->
				
				<tr>
					<!-- 附件机制 -->
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="attachment"/>
						<c:param name="formBeanName" value="workCasesMainForm"/>
					</c:import>
				</tr>
			</table> 
		</div>
		<ui:tabpage expand="false">
		
		<%-- 以下代码为嵌入流程标签的代码 --%>
		<c:import url="/sys/lbpmservice/import/sysLbpmProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="workCasesMainForm" />
			<c:param name="fdKey" value="reviewMainDoc" />
		</c:import>
		<%-- 以上代码为嵌入流程标签的代码 --%>
		<%-- <kmss:showNotifyType value="${workCasesMainForm.fdNotifyType}"/> --%>
		<!--权限机制 -->
		<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="workCasesMainForm" />
			<c:param name="moduleModelName" value="com.landray.kmss.work.cases.model.WorkCasesMain" />
		</c:import>
		<!-- 阅读机制 -->
		<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="workCasesMainForm" />
		</c:import>
		<!--点评机制  -->
		<c:import url="/sys/evaluation/import/sysEvaluationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="workCasesMainForm" />
			<%-- <c:param name="isNews" value="yes| " /> --%>
			<c:param
				name="notifyOther"
				value="docAuthor" />	
			<c:param
				name="bundel"
				value="work-cases" />	
			<c:param
				name="key"
				value="workCasesMain.isNoDocAuthor" />
		</c:import>
		
			
		</ui:tabpage>
	</template:replace>
	
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${ lfn:message('work-cases:work.cases.messages') }" toggle="false">
				<c:import url="/sys/evaluation/import/sysEvaluationMain_view_star.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="workCasesMainForm" />
				</c:import>
				<ul class='lui_form_info'>
					<li><bean:message bundle="work-cases" key="workCasesMain.docCreator" />：
						<xform:address propertyId="docCreatorId"  propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view"/>
					
				<%-- 	<ui:person personId="${workCasesMainForm.docCreatorId}" personName="${workCasesMainForm.docCreatorName}"></ui:person></li>
					<li><bean:message bundle="work-cases" key="workCasesMain.docDept" />：${workCasesMainForm.docDeptName}</li> --%>
					<li><bean:message bundle="work-cases" key="workCasesMain.docStatus" />：
						<sunbor:enumsShow value="${workCasesMainForm.docStatus}" enumsType="common_status" />
					</li>
					<li><bean:message bundle="work-cases" key="workCasesMain.docCreateTime" />:${workCasesMainForm.docCreateTime } </li>				
				</ul>
			</ui:content>
		</ui:accordionpanel>
		<%---关联机制 开始----%>
			<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="workCasesMainForm" />
			</c:import>
		<%---关联机制 结束----%>
	</template:replace>
	
</template:include>