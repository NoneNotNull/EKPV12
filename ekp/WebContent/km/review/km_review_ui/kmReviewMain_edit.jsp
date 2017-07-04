<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="auto">
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmReviewMainForm.method_GET == 'add' }">
				<c:out value="${lfn:message('km-review:kmReviewMain.opt.create') } - ${ lfn:message('km-review:table.kmReviewMain') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmReviewMainForm.docSubject} - ${ lfn:message('km-review:table.kmReviewMain') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar var-navwidth="90%" id="toolbar" layout="sys.ui.toolbar.float"> 
			<c:if test="${kmReviewMainForm.method_GET=='edit' && kmReviewMainForm.docStatus=='10'}">
				<ui:button text="${ lfn:message('button.savedraft') }" order="2" 
						onclick="_updateDoc();">
				</ui:button>
			</c:if>
			<c:if test="${kmReviewMainForm.method_GET=='edit'&&(kmReviewMainForm.docStatus=='10'
						||kmReviewMainForm.docStatus=='11'||kmReviewMainForm.docStatus=='20')}">
				<ui:button text="${ lfn:message('button.submit') }" order="2"  
						onclick="_publishDraft();">
				</ui:button>
			</c:if> 
			<c:if test="${kmReviewMainForm.method_GET=='add'}">
				<ui:button text="${ lfn:message('button.savedraft') }" order="2"  
						onclick="_saveDoc();">
				</ui:button>
				<ui:button text="${ lfn:message('button.submit') }" order="2"  
						onclick="_submitDoc();">
				</ui:button>
			</c:if>
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
			</ui:button>
		</ui:toolbar>  
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.category">
			<ui:varParams 
			    moduleTitle="${ lfn:message('km-review:table.kmReviewMain') }" 
			    modulePath="/km/review/" 
				modelName="com.landray.kmss.km.review.model.KmReviewTemplate" 
				autoFetch="false"	
				target="_blank"
				categoryId="${kmReviewMainForm.fdTemplateId}" />
		</ui:combin>
	</template:replace>	
	<template:replace name="content"> 
		<c:if test="${kmReviewMainForm.method_GET=='add'}">
			<script type="text/javascript">
				Com_IncludeFile("calendar.js");
				
				window.changeDocTemp = function(modelName,url,canClose){
					if(modelName==null || modelName=='' || url==null || url=='')
						return;
			 		seajs.use(['sys/ui/js/dialog'],function(dialog) {
					 	dialog.categoryForNewFile(modelName,url,false,null,function(rtn) {
							// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
							if (!rtn)
								window.close();
						},'${param.categoryId}','_self',canClose);
				 	});
			 	};
			 	
				if('${param.fdTemplateId}'==''){
					//window.changeDocTemp('com.landray.kmss.km.review.model.KmReviewTemplate','/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{id}',true);
					window.changeDocTemp('com.landray.kmss.km.review.model.KmReviewTemplate','/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdWorkId=${param.fdWorkId}&fdPhaseId=${param.fdPhaseId}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}',true);
				}
			</script>
		</c:if>
		
		<html:form action="/km/review/km_review_main/kmReviewMain.do" >
		<html:hidden property="fdId" value="${kmReviewMainForm.fdId}"/>
		<html:hidden property="fdWorkId" />
		<html:hidden property="fdPhaseId" />
		<html:hidden property="fdModelId" />
		<html:hidden property="fdModelName" />
		<html:hidden property="docStatus" />
		<ui:tabpage expand="false" var-navwidth="90%" >
			<ui:content title="${ lfn:message('km-review:kmReviewDocumentLableName.reviewContent') }" toggle="false" >
				<table class="tb_normal" width=100%>			
					<!--主题-->
					<tr>
						<td align="right" style="border-right: 0px;" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.docSubject" /></td>
						<td style="border-left: 0px !important;">
							<c:if test="${kmReviewMainForm.titleRegulation==null || kmReviewMainForm.titleRegulation=='' }">
								<xform:text property="docSubject" style="width:97%;height:auto;" className="inputsgl"/>
							</c:if>
							<c:if test="${kmReviewMainForm.titleRegulation!=null && kmReviewMainForm.titleRegulation!='' }">
								<xform:text property="docSubject" style="width:97%;height:auto;color:#333;" className="inputsgl" showStatus="readOnly" value="${lfn:message('km-review:kmReviewMain.docSubject.info') }" />
							</c:if>
						</td> 
					</tr> 
				</table>
				<br>
				<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
					<table class="tb_normal" width=100%>
						<tr>
							<td colspan="2">
								<kmss:editor property="docContent" width="95%" needFilter="false"/>
							</td>
						</tr>
						<!-- 相关附件 -->
						<tr KMSS_RowType="documentNews">
							<td class="td_normal_title" width=15%>
								<bean:message bundle="km-review" key="kmReviewMain.attachment" />
							</td>
							<td>
								<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
									<c:param name="fdAttType" value="byte" />
									<c:param name="fdMulti" value="true" />
									<c:param name="fdImgHtmlProperty" />
									<c:param name="fdKey" value="fdAttachment" />
									<c:param name="fdModelId" value="${param.fdId }" />
									<c:param name="fdModelName"	value="com.landray.kmss.km.review.model.KmReviewMain" />
								</c:import>
							</td>
						</tr>
					</table>
				</c:if>
				<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
					<%-- 表单 --%>
					<div id="kmReviewXform">
						<c:import url="/sys/xform/include/sysForm_edit.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmReviewMainForm" />
							<c:param name="fdKey" value="reviewMainDoc" />
							<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
							<c:param name="useTab" value="false" />
						</c:import>
					</div>
				</c:if>
			</ui:content>
			<ui:content title="${ lfn:message('km-review:kmReviewTemplateLableName.baseInfo') }">
				<table class="tb_normal" width=100%>
					<!--关键字-->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewKeyword.fdKeyword" />
						</td>
						<td colspan=3>
							<xform:text property="fdKeywordNames" style="width:97%" />
						</td>
					</tr>
					<!--流程类别-->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewTemplate.fdName" />
						</td>
						<td colspan=3>
							<html:hidden property="fdTemplateId" /> 
							<c:out value="${ kmReviewMainForm.fdTemplateName}"/>
						</td>
					</tr>
					<!--申请人-->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.docCreatorName" />
						</td>
						<td width=35%>
							<c:out value="${ kmReviewMainForm.docCreatorName}"/>
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.fdNumber" />
						</td>
						<td width=35%>
							<c:if test="${kmReviewMainForm.fdNumber!=null}">
								<html:text property="fdNumber" readonly="true" style="width:95%"/>
							</c:if>
							<c:if test="${kmReviewMainForm.fdNumber==null}">
								<bean:message bundle="km-review" key="kmReviewMain.fdNumber.message" />
							</c:if>
						</td>
					</tr>
					<!--部门-->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.department" />
						</td>
						<td>
							<c:out value="${ kmReviewMainForm.fdDepartmentName}"/>
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.docCreateTime" />
						</td>
						<td width=35%>
							<c:out value="${ kmReviewMainForm.docCreateTime}"/>
							<html:hidden property="docCreateTime" />
						</td>
					</tr>
					<!--状态-->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.docStatus" />
						</td>
						<td>
							<c:if test="${kmReviewMainForm.docStatus=='00'}">
								<bean:message key="status.discard"/>
							</c:if>
							<c:if test="${kmReviewMainForm.docStatus=='10'}">
								<bean:message key="status.draft"/>
							</c:if>
							<c:if test="${kmReviewMainForm.docStatus=='11'}">
								<bean:message key="status.refuse"/>
							</c:if>
							<c:if test="${kmReviewMainForm.docStatus=='20'}">
								<bean:message key="status.examine"/>
							</c:if>
							<c:if test="${kmReviewMainForm.docStatus=='30'}">
								<bean:message key="status.publish"/>
							</c:if>
							<c:if test="${kmReviewMainForm.docStatus=='31'}">
								<bean:message key="status.feedback" bundle="km-review"/>
							</c:if>
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="kmReviewMain.docPublishTime" />
						</td>
						<td width=35%>
							<bean:write name="kmReviewMainForm" property="docPublishTime" />
						</td>
					</tr>
					<!--实施反馈人-->
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="table.kmReviewFeedback" />
						</td>
						<td colspan=3>
							<xform:dialog icon="orgelement" propertyId="fdFeedbackIds" style="width:95%" propertyName="fdFeedbackNames">
								Dialog_Address(true, 'fdFeedbackIds','fdFeedbackNames', ';',null);
							</xform:dialog>
						</td>
	
					</tr>
					<%-- 所属场所 --%>
					<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
	                     <c:param name="id" value="${kmReviewMainForm.authAreaId}"/>
	                </c:import> 
					
					<!--适用岗位-->
					<%--适用岗位不要了，modify by zhouchao--%>
					<%--<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="km-review" key="table.kmReviewPost" /></td>
						<td colspan=3><html:hidden property="fdPostIds" /> <html:textarea
							property="fdPostNames" style="width:80%" readonly="true" /> <a
							href="#"
							onclick="Dialog_Address(true, 'fdPostIds','fdPostNames', ';',ORG_TYPE_POST);"><bean:message
							key="dialog.selectOther" /></a></td>
					</tr>
					--%>
					<!--其他属性-->
					
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-review" key="table.sysCategoryProperty" />
						</td>
							
						<%-----辅类别--原来为不可选  现按照规章制度的 改为 可选或多选
						                   --modify by zhouchao 20090520--%>						
						<td colspan=3>
							<xform:dialog propertyId="docPropertyIds" propertyName="docPropertyNames" style="width:95%" >
								Dialog_property(true, 'docPropertyIds','docPropertyNames', ';', ORG_TYPE_PERSON);
							</xform:dialog>		
						</td>	
					</tr>
				</table>
			</ui:content> 
			<%--阅读机制 --%>
			<c:import url="/sys/readlog/import/sysReadLog_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
			</c:import>
			<%--流程--%>
			<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="showHistoryOpers" value="true" />
				<c:param name="isExpand" value="true" />
			</c:import>
			 <%--权限机制 --%>
			<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
			</c:import>
			<c:if test="${kmReviewMainForm.syncDataToCalendarTime=='flowSubmitAfter' || kmReviewMainForm.syncDataToCalendarTime=='flowPublishAfter'}">
			<ui:content title="${ lfn:message('sys-agenda:module.sys.agenda.syn') }">
			    <%--
				<!--提醒机制(主文档) 开始-->
				<table class="tb_normal" width=100%>
				 <c:import url="/sys/notify/import/sysNotifyRemindMain_edit.jsp" charEncoding="UTF-8">
				    <c:param name="formName" value="kmReviewMainForm" />
				    <c:param name="fdKey" value="reviewMainDoc" />
				    <c:param name="fdPrefix" value="sysNotifyRemindMain_edit" />
				 </c:import>
			    </table>
				<!--提醒机制(主文档) 结束-->
				--%>
				
				<%--
				<!--日程机制(普通模块) 开始-->
				<table class="tb_normal" width=100%>
				 <c:import url="/sys/agenda/import/sysAgendaMain_general_edit.jsp"	charEncoding="UTF-8">
				    <c:param name="formName" value="kmReviewMainForm" />
				    <c:param name="fdKey" value="reviewMainDoc" />
				    <c:param name="fdPrefix" value="sysAgendaMain_general_edit" />
				 </c:import>
			   </table>
				<!--日程机制(普通模块) 结束-->
				--%>
				<!--日程机制(表单模块) 开始-->
				<table class="tb_normal" width=100%>
					<tr>
					   <td width="15%"  class="tb_normal">
					   		<%--同步时机--%>
					       	<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
					   </td>
					   <td width="85%" colspan="3">
					       <xform:radio property="syncDataToCalendarTime" showStatus="edit">
					       		<xform:enumsDataSource enumsType="kmReviewMain_syncDataToCalendarTime" />
							</xform:radio>
					   </td>
					</tr>
					<tr>
						<td colspan="4" style="padding: 0px;">
							 <c:import url="/sys/agenda/import/sysAgendaMain_formula_edit.jsp"	charEncoding="UTF-8">
							    <c:param name="formName" value="kmReviewMainForm" />
							    <c:param name="fdKey" value="reviewMainDoc" />
							    <c:param name="fdPrefix" value="sysAgendaMain_formula_edit" />
							    <c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
							    <%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
								<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
								<c:param name="noSyncTimeValues" value="noSync" />
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
			var _reviewValdate = $KMSSValidation(document.forms['kmReviewMainForm']);
			function _saveDoc(){ 
				_reviewValdate.removeElements($('#kmReviewXform')[0],'required');
				Com_Submit(document.kmReviewMainForm, 'saveDraft');
			}
			function _submitDoc(){
				_reviewValdate.resetElementsValidate($('#kmReviewXform')[0]);
				Com_Submit(document.kmReviewMainForm, 'save');
			}
			function _updateDoc(){ 
				_reviewValdate.removeElements($('#kmReviewXform')[0],'required');
				Com_Submit(document.kmReviewMainForm, 'update');
			}
			function _publishDraft(){
				_reviewValdate.resetElementsValidate($('#kmReviewXform')[0]);
				Com_Submit(document.kmReviewMainForm, 'publishDraft');
			}
		</script>
	</template:replace>
	<template:replace name="nav">
		<%--关联机制(与原有机制有差异)--%>
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
		</c:import>
	</template:replace>
</template:include>