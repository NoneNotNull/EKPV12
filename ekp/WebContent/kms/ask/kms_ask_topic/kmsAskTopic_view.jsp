<%@ page language="java" pageEncoding="UTF-8"%>
<head>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp"%>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<%@ include file="/kms/ask/kms_ask_topic/kmsAskTopic_view_js.jsp"%>
<%@ include file="/kms/ask/kms_ask_topic/kmsAskViewInfo_tmpl.jsp" %>
</head>

<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/kms/ask/kms_ask_topic/kmsAskTopic_view_js.jsp"%>
<template:include ref="default.view">
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
					target="_blank"
					categoryId="${kmsAskTopicForm.fdKmsAskCategoryId}" />
		</ui:combin>
	</template:replace>

	<template:replace name="content"> 
<div id="wrapper">
<div  class="box c">
<div class="content3">
	
	<%--问题信息开始--%>
	<%@ include file="/kms/ask/kms_ask_topic/kmsAskTopic_view_question.jsp"%>
	<%--问题信息结束--%>
	<%--最佳答案开始--%>
	<%@ include file="/kms/ask/kms_ask_post/kmsAskPost_view_best.jsp"%>
	<%--最佳答案结束--%>
	<%--补充、提问、回答开始--%>
	<%@ include file="/kms/ask/kms_ask_post/kmsAskPost_view_answer.jsp"%>
	<%--补充、提问、回答结束始--%>
	<%--其他答案开始--%>
	<%@ include file="/kms/ask/kms_ask_post/kmsAskPost_view_other.jsp"%>
	<%--其他答案结束---%>
	</div>
	
	<!-- end  rightbar-->
</div>
</div>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>

	</template:replace>
</template:include>