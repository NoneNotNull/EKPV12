<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no"> 
		<template:replace name="head">
			<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/ask/kms_ask_ui/style/edit.css" />
			<%@ include file="/kms/ask/kms_ask_ui/kmsAskTopic_edit_script.jsp"%>
		</template:replace>
		<template:replace name="toolbar">
			<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
				<ui:button text="${lfn:message('kms-ask:kmsAskTopic.submitAsk')}" onclick="return kmsAsk_Com_Submit('save');">
				</ui:button>
				<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();">
				</ui:button>
			</ui:toolbar>
			
		</template:replace>
		<template:replace name="title">${lfn:message('kms-ask:kms.kmsAsk.ask') }</template:replace>
		<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('kms-ask:table.kmdoc') }" 
					modulePath="/kms/ask/" 
					modelName="com.landray.kmss.kms.ask.model.KmsAskCategory" 
					autoFetch="false"
					target="_blank"
					categoryId="${param.fdCategoryId }" />
			</ui:combin>
		</template:replace>	

		<template:replace name="content"> 
			<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do">
			<html:hidden property="fdId"/>
					<div class="lui_ask_content_form">
						<div class="lui_ask_titleline">
						<div class="h2_6" ><div class="lui_icon_s lui_icon_s_cue4" style="padding-right:10px;"></div>${lfn:message('kms-ask:kmsAskTopic.tip')}</div> 
						<div class="lui_ask_clear"></div>
					</div>	
					
					<div >
					<div class="text_area" > 
						<table style="width: 100%;">
							<tr>
								<td>
									<html:textarea property="docSubject" style="width:100%;height:90px" ></html:textarea>
								</td>
							</tr>
						</table>
					</div>
					
					<div class="lui_ask_clear"></div>
					<div class="lui_ask_word">${lfn:message('kms-ask:kmsAskTopic.moreWord')}<a style="font-family: Constantia, Georgia;font-size: 24px;">50</a>${lfn:message('kms-ask:kmsAskTopic.word')}</div>
					<div class="lui_ask_detail">
						<div class="title">
							<h3>${lfn:message('kms-ask:kmsAskTopic.addQuest')}</h3>
							<a href="javascript:addAsk()" id="detail_href">
								<h3 id="detail_span">${lfn:message('kms-ask:kmsAskTopic.open')}</h3>
							</a>
						</div>
						<div class="lui_ask_tiptitle">
						</div>
						<div class="lui_ask_clear"></div>
						
						<div class="clear"></div>
						<div id="detail-content" style="display: none;width:100%;">
							<kmss:editor property="docContent" height="300px" width="100%" toolbarStartExpanded="false" />
						</div>
					</div>
					
					<div style="margin-top: 10px;">
						<table class="tb_simple" width=100%>
							<tr style="width: 100%"> 
								<td valign="top" style="width:73px;" class="td_normal_title">${lfn:message('kms-ask:kmsAskTopic.upAtt')}</td>
								<td >
									<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								        <c:param name="fdKey" value="topic"/>
								        <c:param name="fdModelId" value="${param.fdId }"/>
								        <c:param name="fdModelName" value="com.landray.kmss.kms.ask.model.KmsAskTopic"/>
							        </c:import> 
								</td>
							</tr> 
						</table> 
					</div>
					</div>
				</div>
			
			
			<div class="lui_form_content_frame1">
 			<table class="tb_simple" width=100%>  
				<tr>
					<td
						class="td_normal_title"
						style="width:6%"><bean:message
						key="kmsAskCategory.fdCategoryName"
						bundle="kms-ask" /></td>
					<td colspan="3" width="95%"><html:hidden property="fdKmsAskCategoryId" /> 
					
					<span id="categoryName">
					<bean:write
						name="kmsAskTopicForm"
						property="fdKmsAskCategoryName"/>
					</span>
						<a href="javascript:modifyCate(true,true)" style="margin-left:15px;" class="com_btn_link">${lfn:message('kms-ask:kmsAskCategory.changeCategory') }</a>
						<span class="txtstrong">*</span>
					</td>
				</tr>
				
				<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsAskTopicForm" />
					<c:param name="fdKey" value="mainDoc" /> 
					<c:param name="fdQueryCondition" value="fdKmsAskCategoryId" /> 
				</c:import>
					<tr>
						<td valign="top" class="td_normal_title"> 
							${lfn:message('kms-ask:kmsAskTopic.questExpert')}
						</td>
						<td id="help_expert">
							<xform:radio  property="fdPosterType" 
										  value="${(kmsAskTopicForm.fdPosterType==null||kmsAskPostForm.fdPosterType=='')?'0':(kmsAskTopicForm.fdPosterType)}" 
										  onValueChange="postTypeChange">
								<xform:customizeDataSource className="com.landray.kmss.kms.ask.service.spring.KmsAskTopicHelpService"/>
		        			</xform:radio>
						</td>
					</tr>
					<tr style="display: none;" id="posterTr">
						<td valign="top" class="td_normal_title">${lfn:message('kms-ask:kmsAskTopic.choose.answerer')}</td>
						<td id="fdPosterTypeList">
						 	<html:hidden property="fdPosterTypeListIds" /> 
						    <xform:dialog propertyId="fdPosterTypeListIds" propertyName="fdPosterTypeListNames" style="width:80%" dialogJs="openPosterTypeListWindow()" >
							</xform:dialog>	 
							<html:checkbox property="fdIsLimit" >${lfn:message('kms-ask:kmsAskTopic.theExpert')}</html:checkbox>
						</td>
					</tr>
					<tr>
						<td  valign="top" class="td_normal_title"><bean:message  bundle="kms-ask" key="kmsAskTopic.fdScore"/></td>
						<td id="td_fdScore">
							<select name="fdScore" onchange="validateScore(this);">
								<option value="0">0</option>
								<option value="5">5</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="30">30</option>
								<option value="50">50</option>
								<option value="80">80</option>
								<option value="100">100</option>
					   	 	</select>
			   	 			<%--您目前的知识货币为：--%>
			    			<span style="color: #999999"><bean:message  bundle="kms-ask" key="kmsAskScore.currMoney.msg"/><b>${fdScore}</b></span>
			    		</td>
					</tr>
				</table>
			</div>
			<br/>
				<!-- main end -->
			<html:hidden property="method_GET"/>
			</html:form>
		</template:replace>
</template:include>
