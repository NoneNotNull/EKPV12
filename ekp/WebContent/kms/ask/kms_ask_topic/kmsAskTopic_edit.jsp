<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<title>爱问_提问</title>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp"%> 
</head>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
			<template:replace name="toolbar">
				<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
					<ui:button text="${lfn:message('button.close') }" onclick="Com_CloseWindow();">
					</ui:button>
				</ui:toolbar>
				<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
					<ui:button text="${lfn:message('button.edit') }" onclick="">
					</ui:button>
				</ui:toolbar>
				<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
					<ui:button text="${lfn:message('kms-ask:button.changeRight') }" onclick="">
					</ui:button>
				</ui:toolbar>
				<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
					<ui:button text="${lfn:message('kms-ask:button.readCount') }" onclick="">
					</ui:button>
				</ui:toolbar>
				<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
					<ui:button text="${lfn:message('kms-ask:button.alterComment') }" onclick="">
					</ui:button>
				</ui:toolbar>
			</template:replace>
			
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
<%@ include file="/kms/ask/kms_ask_ui/kmsAskTopic_edit_script.jsp"%>
<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do" onsubmit="return validateKmsAskTopicForm(this);">
<html:hidden property="fdId"/>
					<div class="lui_ask_content_form">
							<div class="lui_ask_tiptitle">
							<h2 class="h2_6" >我要提问</h2> 
							<div class="lui_ask_clear"></div>
						</div>	
						
						<div class="m_t10">
						<div class="text_area" >
							<html:textarea property="docSubject" style="width:100%;height:150" ></html:textarea>
						</div>
						<div class="lui_ask_tips">
							<span class="leftbg"></span>
							<h3>如何提问</h3>
							<p>请简明清晰地描述您的疑问<br />如：知识管理系统业界第一是谁？</p>	
						</div>
						<div class="lui_ask_clear"></div>
						<div class="lui_ask_detail">
							<div class="title">
								<h3>问题补充（必选）</h3>
								<a href="javascript:void(0)" id="detail_href">
									<h3 id="detail_span">展开</h3>
								</a>
							</div>
							<div class="lui_ask_tiptitle">
								<span class="lui_ask_word">还可以输入<a style="font-family: Constantia, Georgia;font-size: 24px;">50</a>字</span>
							</div>
							<div class="lui_ask_clear"></div>
							
							<div class="clear"></div>
							<div id="detail-content" style="display: none;" class="m_t10">
								<kmss:editor property="docContent" height="300" width="100%" toolbarStartExpanded="false" />
							</div>
							
							
						</div>
						</div>
					</div>
				<br/>
				
				
				<div class="lui_form_content_frame">
				<table class="tb_simple" width=100%>
					<tr>
						<td
							class="td_title"
							width="5%"><bean:message
							key="kmsAskCategory.fdCategoryName"
							bundle="kms-ask" /></td>
						<td colspan="3" width="95%"><html:hidden property="fdKmsAskCategoryId" /> <bean:write
							name="kmsAskTopicForm"
							property="fdKmsAskCategoryName" />
							<a href="javascript:modifyCate(true)">${lfn:message('kms-ask:kmsAskCategory.changeCategory') }</a></td>
					</tr>
					
					<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm" />
					<c:param name="fdKey" value="mainDoc" /> 
					<c:param name="fdQueryCondition" value="fdDocTemplateId;docDeptId" /> 
					</c:import>
					
					
						<c:if test="${ hasExpert}">
						<tr>
							<td valign="top" class="td_title">
								<c:if test="${kmsAskTopicForm.fdPosterTypeListIds==null||kmsAskTopicForm.fdPosterTypeListIds==''}">
									<a href = "javascript:help_expert();" >
								</c:if>
								求助专家
								<c:if test="${kmsAskTopicForm.fdPosterTypeListIds==null||kmsAskTopicForm.fdPosterTypeListIds==''}">
									</a>
								</c:if>
							</td>
							<td id="help_expert">
								<xform:radio property="fdPosterType" value="${(kmsAskTopicForm.fdPosterType==null||kmsAskPostForm.fdPosterType=='')?'0':(kmsAskTopicForm.fdPosterType)}" onValueChange="postTypeChange">
			        				<xform:enumsDataSource enumsType="fdPosterType"></xform:enumsDataSource>		        			
			        			</xform:radio>
							</td>
						</tr>
						<tr style="display: none;" id="posterTr">
							<td valign="top" class="td_title">选择可回答者</td>
							<td id="fdPosterTypeList">
							 	<html:hidden property="fdPosterTypeListIds" />
								<html:text property="fdPosterTypeListNames" readonly="true" styleClass="i_b" style="width:55%;" />
							    <a href="#" onclick="openPosterTypeListWindow();" id="posterHref"><bean:message key="dialog.selectOther" /></a>
							    <html:checkbox property="fdIsLimit">指定专家回答</html:checkbox>
							</td>
						</tr>
						</c:if>
						<tr>
							<td  valign="top" class="td_title"><bean:message  bundle="kms-ask" key="kmsAskTopic.fdScore"/></td>
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
						
						<tr style="width: 100%">
							<td valign="top" style="width:5%;" class="td_title">上传附件</td>
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
				<br/>
				<ui:button id="lui_ask_btn" onclick="return kmsAsk_Com_Submit('save');"  target="_blank" style="" title="提交问题" >
					<ui:text>提交问题</ui:text>
				</ui:button>
	<!-- main end -->
<html:hidden property="method_GET"/>
</html:form>
</template:replace>
</template:include>
<html:javascript formName="kmsAskTopicForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>
<script>
	var Com_Parameter = {
			ContextPath:"${KMSS_Parameter_ContextPath}",
			JsFileList:new Array,
			ResPath:"${KMSS_Parameter_ResPath}"
		};
</script>
<script src="${LUI_ContextPath}/resource/js/common.js"></script>
<script src="${LUI_ContextPath}/resource/js/calendar.js"></script>
<script type="text/javascript">
	seajs.use('kms/ask/kms_ask_ui/style/edit.css');
</script>