<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/mobile/jsp/ajax-accept.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.edit" compatibleMode="true">
	<template:replace name="title">
		<c:if test="${empty  kmsAskTopicForm.docSubject}">
			新建问答
		</c:if>
		<c:out value="${kmsAskTopicForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="head">
		<mui:min-file name="mui-ask-edit.js" />
		<mui:min-file name="mui-ask-edit.css"/>
	</template:replace>
	<template:replace name="content">
		<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=save">
			<div data-dojo-type="mui/view/DocScrollableView"
				data-dojo-mixins="mui/form/_ValidateMixin" id="scrollView"
				class="muiAskView">
				<input type="hidden" value="${kmsAskTopicForm.fdId }" name="fdId">
				<div data-dojo-type="mui/form/Editor"
					data-dojo-mixins="kms/ask/mobile/js/edit/AskEditEditorMixin"
					data-dojo-props="name:'docContent',fdModelId:'${kmsAskTopicForm.fdId }',fdModelName:'com.landray.kmss.kms.ask.model.KmsAskTopic',placeholder:'问题补充'"></div>

				<div data-dojo-type="kms/ask/mobile/js/edit/AskScore"
					data-dojo-props="score:${fdScore }"></div>

				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom"
					data-dojo-props="fill:'grid'">
					<li data-dojo-type="mui/back/BackButton" edit="true"></li>
					<li data-dojo-type="mui/tabbar/TabBarButton"
						class="muiBtnSubmit" data-dojo-props='colSize:2'
						onclick="ask_submit()"><i class="mui mui-right"></i>提交</li>
					<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
						data-dojo-props="icon1:'mui mui-more'">
						<div data-dojo-type="mui/back/HomeButton"></div>
					</li>
				</ul>
			</div>

			<c:if test="${empty param.fdCategoryId}">
				<!--  无分类下默认弹开分类选择框 -->
				<script>
					require(
							[ 'mui/tabbar/CreateButton',
									'mui/simplecategory/SimpleCategoryMixin',
									'dojo/topic', 'mui/device/adapter' ],
							function(CreateButton, SimpleCategoryMixin, topic,
									adapter) {
								var claz = CreateButton
										.createSubclass([ SimpleCategoryMixin ]);
								var obj = new claz(
										{
											createUrl : '/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add&fdCategoryId=!{curIds}&fdPosterTypeListId=${param.fdPosterTypeListId}&fdPosterType=${param.fdPosterType}',
											modelName : 'com.landray.kmss.kms.ask.model.KmsAskCategory'
										});
								obj._selectCate();
								topic.subscribe('/mui/category/cancel',
										function(obj, evt) {
											adapter.goBack();
										});
							});
				</script>
			</c:if>

			<input name="fdKmsAskCategoryId" value="${param.fdCategoryId }"
				type="hidden">

			<!-- 向指定人提问 -->
			<c:if
				test="${not empty param.fdPosterTypeListId && not empty param.fdPosterType}">
				<input name="fdPosterType" value="${param.fdPosterType }"
					type="hidden">
				<input name="fdPosterTypeListIds"
					value="${param.fdPosterTypeListId }" type="hidden">
			</c:if>

			<script>
				require([ "mui/form/ajax-form!kmsAskTopicForm",
						"dijit/registry" ], function(form, registry) {
					window.ask_submit = function() {
						if (registry.byId('scrollView').validate())
							Com_Submit(document.forms[0], 'save');
					}
				});
			</script>
		</html:form>
	</template:replace>
</template:include>
