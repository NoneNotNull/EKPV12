<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<template:include ref="default.view" sidebar="auto">
	<template:replace name="title">
		<c:out value="${kmReviewMainForm.docSubject}-${ lfn:message('km-review:table.kmReviewMain')}"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="90%">
			<c:if test="${kmReviewMainForm.method_GET=='view' }">
				<c:if test="${kmReviewMainForm.docStatus=='10' || kmReviewMainForm.docStatus=='11'|| kmReviewMainForm.docStatus=='20'}">
					<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
						<ui:button order="2" text="${ lfn:message('button.edit') }" 
							onclick="Com_OpenWindow('kmReviewMain.do?method=edit&fdId=${param.fdId}','_self');">
						</ui:button>
					</kmss:auth>
				</c:if>
				<c:if test="${kmReviewMainForm.docStatus=='30' || kmReviewMainForm.docStatus=='31'}">
					<!-- 实施反馈 -->
					<kmss:auth requestMethod="GET"
						requestURL="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=add&fdMainId=${param.fdId}&fdCreatorId=${kmReviewMainForm.docCreatorId}">
						<ui:button order="4" text="${ lfn:message('km-review:button.feedback.info') }" 
							onclick="feedback();">
						</ui:button>
					</kmss:auth>
					<c:if test="${kmReviewMainForm.fdFeedbackExecuted!='1' && kmReviewMainForm.fdFeedbackModify=='1'}">
						<kmss:auth requestURL="/km/review/km_review_main/kmReviewChangeFeedback.jsp?fdId=${param.fdId}"	requestMethod="GET">
							<!-- 指定反馈人 -->
							<ui:button order="4" text="${ lfn:message('km-review:button.feedback.people') }" 
								onclick="appointFeedback();">
							</ui:button>
						</kmss:auth>
					</c:if>
					<!-- 修改权限
					<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=editRight&fdId=${param.fdId}" requestMethod="GET">
						<ui:button order="4" text="${ lfn:message('km-review:button.modify.permission') }" 
							onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}km/review/km_review_main/kmReviewMain.do?method=editRight&fdId=${param.fdId }');">
						</ui:button>
					</kmss:auth>
				    -->
				</c:if>
			</c:if>
			<!-- 打印 -->
			<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=print&fdId=${param.fdId}" requestMethod="GET">
				<ui:button order="4" text="${ lfn:message('km-review:button.print') }" 
					onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}km/review/km_review_main/kmReviewMain.do?method=print&fdId=${param.fdId}');">
				</ui:button>
			</kmss:auth>
		    <%-- 删除 --%>
			<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button  order="4" text="${ lfn:message('button.delete') }" 
					onclick="deleteDoc('kmReviewMain.do?method=delete&fdId=${param.fdId}');">
				</ui:button>
			</kmss:auth> 
			<%-- 复制--%>
			<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=add&fdReviewId=${param.fdId}&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-review:kmReviewMain.copy') }" order="5" onclick="javascript:window.open('${LUI_ContextPath}/km/review/km_review_main/kmReviewMain.do?method=add&fdReviewId=${param.fdId}&fdTemplateId=${kmReviewMainForm.fdTemplateId}','_blank');">
				</ui:button>
			</kmss:auth>
			<ui:button text="${ lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.category">
			<ui:varParams moduleTitle="${ lfn:message('km-review:table.kmReviewMain') }"
			    modulePath="/km/review/" 
				modelName="com.landray.kmss.km.review.model.KmReviewTemplate"
			    autoFetch="false" 
			    href="/km/review/" 
				categoryId="${kmReviewMainForm.fdTemplateId}" />
		</ui:combin>
	</template:replace>	
	<template:replace name="content">
		<script type="text/javascript">
			Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js|calendar.js|dialog.js|jquery.js", null, "js");
		</script>
		<script language="JavaScript">
		seajs.use(['lui/dialog'],function(dialog){
			window.dialog = dialog;
		});
		function appointFeedback(){
			var path = "/km/review/km_review_main/kmReviewChangeFeedback.jsp?fdId=${param.fdId}"
			dialog.iframe(path,' ',null,{width:750,height:500});

		}
		function feedback(){
			var path ="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=add&fdMainId=${param.fdId}&fdCreatorId=${kmReviewMainForm.docCreatorId}";
			dialog.iframe(path,' ',null,{width:750,height:500});

		}
		</script>
		<html:form action="/km/review/km_review_main/kmReviewMain.do">							
			<p class="lui_form_subject">
				<c:if test="${empty kmReviewMainForm.docSubject}">
					<bean:message bundle="km-review" key="table.kmReviewMain" />
				</c:if>
				<c:if test="${not empty kmReviewMainForm.docSubject}">
					<c:out value="${kmReviewMainForm.docSubject}" />
				</c:if>
			</p>
			<html:hidden name="kmReviewMainForm" property="fdId" />	
			<html:hidden property="docSubject" />
			<html:hidden property="docStatus" />
			<html:hidden property="fdNumber" />
			<html:hidden property="method_GET"/>
			
			<div class="lui_form_content_frame">
				<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
					<table class="tb_normal" width=100%>
						<tr>
							<td colspan="4">${kmReviewMainForm.docContent}</td>
						</tr>
						<!-- 相关附件 -->
						<tr KMSS_RowType="documentNews">
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.attachment" />
							</td>
							<td colspan=3>
								<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
									<c:param name="fdMulti" value="true" />
									<c:param name="formBeanName" value="kmReviewMainForm" />
									<c:param name="fdKey" value="fdAttachment" />
								</c:import>
							</td>
						</tr>
					</table>
				</c:if>
				<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
					<%-- 表单 --%>
					<c:import url="/sys/xform/include/sysForm_view.jsp"	charEncoding="UTF-8">
						<c:param name="formName" value="kmReviewMainForm" />
						<c:param name="fdKey" value="reviewMainDoc" />
						<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
						<c:param name="useTab" value="false"/>
					</c:import>
				</c:if>
			</div>
			
					
			<ui:tabpage expand="false" var-navwidth="90%">
				<ui:content title="${lfn:message('km-review:kmReviewDocumentLableName.baseInfo') }">
					<table class="tb_normal" width=100%>
						<!--主题-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.docSubject" />
							</td>
							<td colspan=3>
								<c:out value="${ kmReviewMainForm.docSubject}"></c:out>
							</td>
						</tr>
						<!--关键字-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewKeyword.fdKeyword" />
							</td>
							<td colspan=3>
								<c:out value="${ kmReviewMainForm.fdKeywordNames}"></c:out>
							</td>
						</tr>
						<!--模板名称-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
							</td>
							<td colspan=3>
								<c:out value="${ kmReviewMainForm.fdTemplateName}"></c:out>
							</td>
						</tr>
						<!--申请人-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.docCreatorName" />
							</td>
							<td width=35%>
								<html:hidden name="kmReviewMainForm" property="docCreatorId" /> 
								<c:out value="${ kmReviewMainForm.docCreatorName}"></c:out>
							</td>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.fdNumber" />
							</td>
							<td width=35%>
								<c:out value="${ kmReviewMainForm.fdNumber}"></c:out>
							</td>
						</tr>
						<!--部门-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.department" />
							</td>
							<td>
								<c:out value="${ kmReviewMainForm.fdDepartmentName}"></c:out>
							</td>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.docCreateTime" />
							</td>
							<td width=35%>
								<c:out value="${ kmReviewMainForm.docCreateTime}"></c:out>
							</td>
						</tr>
						<!--状态-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.docStatus" />
							</td>
							<td>
								<c:if test="${kmReviewMainForm.docStatus=='00'}">
									<bean:message bundle="km-review" key="status.discard"/>
								</c:if>
								<c:if test="${kmReviewMainForm.docStatus=='10'}">
									<bean:message bundle="km-review" key="status.draft"/>
								</c:if>
								<c:if test="${kmReviewMainForm.docStatus=='11'}">
									<bean:message bundle="km-review" key="status.refuse"/>
								</c:if>
								<c:if test="${kmReviewMainForm.docStatus=='20'}">
									<bean:message bundle="km-review" key="status.append"/>
								</c:if>
								<c:if test="${kmReviewMainForm.docStatus=='30'}">
									<bean:message bundle="km-review" key="status.publish"/>
								</c:if>
								<c:if test="${kmReviewMainForm.docStatus=='31'}">
									<bean:message bundle="km-review" key="status.feedback" />
								</c:if>
							</td>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.docPublishTime" />
							</td>
							<td width=35%>
								<c:out value="${ kmReviewMainForm.docPublishTime}"></c:out>
							</td>
						</tr>
						<!--实施反馈人-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="table.kmReviewFeedback" />
							</td>
							<td colspan=3>
								<c:out value="${ kmReviewMainForm.fdFeedbackNames}"></c:out>
							</td>
			
						</tr>
						<%-- 所属场所 --%>
						<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
			                <c:param name="id" value="${kmReviewMainForm.authAreaId}"/>
			            </c:import> 
						<!--其他属性-->
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="table.sysCategoryProperty" />
							</td>
							<td colspan=3>
								<c:out value="${ kmReviewMainForm.docPropertyNames}"></c:out>
							</td>
						</tr>
						<xform:isExistRelationProcesses relationType="parent">
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.process.parent" />
							</td>
							<td colspan=3>
								<xform:showParentProcesse />
							</td>
						</tr>
						</xform:isExistRelationProcesses>
						<xform:isExistRelationProcesses relationType="subs">
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.process.subs" />
							</td>
							<td colspan=3>
								<xform:showSubProcesses />
							</td>
						</tr>
						</xform:isExistRelationProcesses>
					</table> 
				</ui:content>
				 <%-- 收藏 --%>
				<c:import url="/sys/bookmark/import/bookmark_bar.jsp" charEncoding="UTF-8">
					<c:param name="fdSubject" value="${kmReviewMainForm.docSubject}" />
					<c:param name="fdModelId" value="${kmReviewMainForm.fdId}" />
					<c:param name="fdModelName"	value="com.landray.kmss.km.review.model.KmReviewMain" />
				</c:import>
				
				<%-- 流程 --%>
				<c:import url="/sys/workflow/import/sysWfProcess_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewMainForm" />
					<c:param name="fdKey" value="reviewMainDoc" />
					<c:param name="showHistoryOpers" value="true" />
					<c:param name="onClickSubmitButton" value="Com_Submit(document.kmReviewMainForm, 'publishDraft');" />
					<c:param name="isExpand" value="true" />
				</c:import>
				<%-- 权限 --%>
				<c:import url="/sys/right/import/right_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewMainForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
				</c:import>
				
				<%-- 阅读记录 --%>
				<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewMainForm" />
				</c:import>
				
				 <%--传阅机制--%>
				<c:import url="/sys/circulation/import/sysCirculationMain_view.jsp"	charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewMainForm" />
				</c:import>
				
				<%-- 督办沟通 --%>
				<c:if test="${kmReviewMainForm.docStatus!='10'}">
					<kmss:ifModuleExist path = "/km/collaborate/">
						<%request.setAttribute("communicateTitle",ResourceUtil.getString("kmReviewMain.communicateTitle","km-review"));%>
							<c:import url="/km/collaborate/import/kmCollaborateMain_view.jsp" charEncoding="UTF-8">
								<c:param name="commuTitle" value="${communicateTitle}" />
								<c:param name="formName" value="kmReviewMainForm" />
							</c:import>
					</kmss:ifModuleExist>
			    </c:if>
			    
			    <%-- 反馈记录 --%>
				<c:if test="${kmReviewMainForm.docStatus=='30'||kmReviewMainForm.docStatus=='31'}">
					<ui:content title="${ lfn:message('km-review:kmReviewDocumentLableName.feedbackInfo') }">
					<kmss:auth
						requestURL="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=deleteall&fdModelId=${param.fdModelId}"
						requestMethod="GET">
					<c:set var="validateAuthfeedback" value="true" />
					</kmss:auth>
						<list:listview channel="feedbackch1">
							<ui:source type="AjaxJson">
								{"url":"/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=listdata&fdModelName=com.landray.kmss.km.review.model.KmReviewMain&fdModelId=${kmReviewMainForm.fdId}&currentVer=${sysEditionForm.mainVersion}.${sysEditionForm.auxiVersion}"}
							</ui:source>
							<list:colTable isDefault="true" layout="sys.ui.listview.listtable"  cfg-norecodeLayout="simple" 
							  rowHref="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=view&fdId=!{fdId}">
								<list:col-auto props=""></list:col-auto>
								<c:if test="${validateAuthfeedback=='true'}"> 
									<list:col-html style="width:60px;" title="">		
											{$<a href="#" onclick="deleteFeedbackInfo('{%row.fdId%}')" class="com_btn_link"><bean:message key="button.delete" /></a>$}
									</list:col-html>
								</c:if>
							</list:colTable>						
						</list:listview>
						<div style="height: 15px;"></div>
						<list:paging channel="feedbackch1" layout="sys.ui.paging.simple"></list:paging>
					</ui:content>
				</c:if>
			
				<%-- 数据迁移 --%>
				<kmss:ifModuleExist path="/tools/datatransfer/">
					<c:import url="/tools/datatransfer/import/toolsDatatransfer_old_data.jsp" charEncoding="UTF-8">
						<c:param name="fdModelId" value="${kmReviewMainForm.fdId}" />
						<c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />	
					</c:import>
				</kmss:ifModuleExist>
				
				
				<c:if test="${kmReviewMainForm.syncDataToCalendarTime=='flowSubmitAfter' || kmReviewMainForm.syncDataToCalendarTime=='flowPublishAfter'}">
				<ui:content title="${ lfn:message('sys-agenda:module.sys.agenda.syn') }" >
					<!--日程机制(表单模块) 开始-->
					<table class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" width="15%">
						 		<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
						 	</td>
						 	<td colspan="3">
						 		<xform:radio property="syncDataToCalendarTime">
					       			<xform:enumsDataSource enumsType="kmReviewMain_syncDataToCalendarTime" />
								</xform:radio>
							</td>
						</tr>
						<tr>
							<td colspan="4" style="padding: 0px;">
								 <c:import url="/sys/agenda/import/sysAgendaMain_formula_view.jsp"	charEncoding="UTF-8">
								    <c:param name="formName" value="kmReviewMainForm" />
								    <c:param name="fdKey" value="reviewMainDoc" />
								    <c:param name="fdPrefix" value="sysAgendaMain_formula_view" />
								 </c:import>
						 	</td>
						 </tr>
				    </table>
					<!--日程机制(表单模块) 结束-->
				</ui:content>
				</c:if>
				
			</ui:tabpage>
		</html:form>
		<script language="JavaScript">
			xform_validation = $KMSSValidation(document.forms['kmReviewMainForm']);
			
			seajs.use(['lui/dialog','lui/topic'],function(dialog,topic){
				window.deleteDoc = function(delUrl){
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
						if(isOk){
							Com_OpenWindow(delUrl,'_self');
						}	
					});
					return;
				};

				window.deleteFeedbackInfo = function(fdId){
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
						if(isOk){
							var loading = dialog.loading();
							var url = '<c:url value="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do" />?method=delete&fdId='+fdId;
							$.getJSON(url,function(json){
								loading.hide();
								if(json.status){
									dialog.success('<bean:message key="return.optSuccess" />');
									topic.channel('feedbackch1').publish('list.refresh');
								}else{
									dialog.failure('<bean:message key="return.optFailure" />');
								}
							});
						}	
					});
					return;
				};
			});
		</script>
	</template:replace>
	<template:replace name="nav">
		<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
		</c:import>
	</template:replace>
</template:include>