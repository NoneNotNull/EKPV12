<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view">
	<template:replace name="head">	
		<%@ include file="/kms/ask/kms_ask_ui/kmsAskTopic_view_js.jsp"%>
		<%@ include file="/kms/ask/kms_ask_ui/kmsAskViewInfo_tmpl.jsp" %>
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/ask/kms_ask_ui/style/view.css" />
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmsAskTopicForm.docSubject }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<ui:button text="${lfn:message('button.close')}" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				modelName="com.landray.kmss.kms.ask.model.KmsAskCategory" 
				moduleTitle="${lfn:message('kms-ask:table.kms.ask') }"
				modulePath="/kms/ask/"
				autoFetch="false"
				href="/kms/ask/"
					target="_blank"
					categoryId="${kmsAskTopicForm.fdKmsAskCategoryId}" />
		</ui:combin>
	</template:replace>
	
	<div style="width:700px;">
	<template:replace name="content"> 
		<div  class="lui_ask_view_box"> 
		<div class="lui_ask_view_content">
			
			<%--问题信息开始--%>
			<%@ include file="/kms/ask/kms_ask_ui/kmsAskTopic_view_question.jsp"%>
			<%--问题信息结束--%>
			<%--最佳答案、补充、提问、回答开始--%>
			<%@ include file="/kms/ask/kms_ask_ui/kmsAskPost_view_answer.jsp"%>
			<%--最佳答案、补充、提问、回答结束--%>
		</div>
	
		 
		</div>
		<!-- end  rightbar-->
	</template:replace>
	</div>
	<template:replace name="nav">
		<div>
			 <ui:accordionpanel>
			 	<ui:content title="${ lfn:message('kms-ask:kmsAskTopic.fdTopicInfo')}" toggle="false" style="padding:0">
						<ui:dataview>
							<ui:source type="AjaxJson">
								{url:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=getMyInfo'}
							</ui:source>
							<ui:render type="Template">
								<c:import url="/kms/ask/kms_ask_ui/tmpl/kms-ask-myinfo.jsp" charEncoding="UTF-8">
								</c:import>
							</ui:render>
						</ui:dataview>
						
						<ui:dataview>
							<ui:source type="AjaxJson">
								{url:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=getUnsolvedAsk&fdId=${param.fdId}'}
							</ui:source>
							<ui:render type="Template">
								<c:import url="/kms/ask/kms_ask_ui/tmpl/kms-ask-unsolvedask.html" charEncoding="UTF-8">
								</c:import>
							</ui:render>
						</ui:dataview>
						
						<c:if test="${not empty kmsAskTopicForm.sysTagMainForm.fdTagNames}">
							<div style='border-bottom: 1px #bbb dashed;height:8px'></div>
							<table>
								<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmsAskTopicForm" />
									<c:param name="useTab" value="false"></c:param>
								</c:import>
							</table>
						</c:if>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
</template:include>
