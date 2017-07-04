<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld"
	prefix="person"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		${kmsAskTopicForm.docSubject }	
	</template:replace>
	<template:replace name="head">
		<mui:min-file name="mui-ask-view.js" />
		<mui:min-file name="mui-ask-view.css"/>
	</template:replace>
	<template:replace name="content">

		<div data-dojo-type="mui/list/StoreScrollableView" class="muiAskView"
			id="askPostList">
			<div class="muiTopicHeader">
				<div class="muiTopicHead">
					<div class="muiTopicContent">
						<div class="muiTopicHeadT">
							<span class="muiTopicHeadTitle"> <i class="mui mui-score">
									<span class="muiAskScore">${kmsAskTopicForm.fdScore }</span>
							</i> <c:out value="${kmsAskTopicForm.docSubject }"></c:out>
							</span>
						</div>
						<div class="muiTopicHeadB">
							<div class="muiTopicHeadSummary">
								<div class="muiTopicHeadCate"
									onclick="location.href='${ LUI_ContextPath}/kms/ask/mobile/index.jsp?moduleName=${kmsAskTopicForm.fdKmsAskCategoryName }&filter=1&queryStr=%2Fkms%2Fask%2Fkms_ask_index%2FkmsAskTopicIndex.do%3Fmethod%3Dindex%26categoryId%3D${kmsAskTopicForm.fdKmsAskCategoryId}'">
									<span> ${kmsAskTopicForm.fdKmsAskCategoryName } <i
										class="mui mui-Cforward"></i></span>
								</div>
								<div class="muiTopicHeadNumInfo">
									<span class="muiTopicHeadNum mui mui-eval"> <span>
											${kmsAskTopicForm.fdReplyCount }</span>
									</span> <span class="muiTopicHeadNum mui mui-eyes"> <span>
											${kmsAskTopicForm.docReadCount }</span>
									</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="muiPostItem">
					<div class="muiPostContent">
						<div class="muiPostContentT">
							<div class="muiPostHead">
								<div class="muiPostIcon">
									<img
										src="<person:headimageUrl personId="${kmsAskTopicForm.fdPosterId}" size="90" />">
								</div>

								<div class="muiPostCreate">
									<div class="muiPostCreator">
										<c:out value="${kmsAskTopicForm.fdPosterName }" />
									</div>
									<div class="muiPostCreated">
										<span><i class="mui mui-time"></i>${kmsAskTopicForm.docCreateTime }</span>
									</div>
								</div>

								<c:if test="${ kmsAskTopicForm.fdStatus==0 && isPoster==true }">
									<kmss:auth
										requestURL="/kms/ask/kms_ask_addition/kmsAskAddition.do?method=add&fdId=${param.fdId}"
										requestMethod="GET">
										<div class="muiPostReplyOpt" onclick="additionAsk(this)">
											<div class="muiTopicReplyOperation">
												<span class="l"></span><span class="f"></span><i
													class="mui mui-more"></i>
											</div>
										</div>
									</kmss:auth>

									<script>
										require(
												[ "mui/dialog/OperaTip",
														'mui/form/editor/EditorUtil' ],
												function(OperaTip, EditorUtil) {

													window.additionAsk = function(
															obj) {
														if (window.operaTip
																&& window.operaTip.isShow)
															return;
														window.operaTip = OperaTip
																.tip({
																	refNode : obj,
																	operas : [ {
																		icon : 'mui-addInfo',
																		text : '补充提问',
																		func : function() {
																			EditorUtil
																					.popup(
																							'/kms/ask/kms_ask_addition/kmsAskAddition.do?method=save&fdKmsAskTopicId=${param.fdId}',
																							{
																								name : 'docContent'
																							},
																							function(
																									data) {
																								location
																										.reload();
																							});
																		}
																	} ]
																});
														return;
													}
												});
									</script>
								</c:if>
							</div>
						</div>
						<div class="muiPostContentM">
							<div class="muiFieldRtf">${kmsAskTopicForm.docContent }</div>
							<script>
								require(
										[ 'mui/rtf/RtfResizeUtil', 'dojo/query' ],
										function(RtfResizeUtil, query) {
											new RtfResizeUtil(
													{
														containerNode : query('.muiFieldRtf')[0],
														channel : 'ask'
													});
										})
							</script>
						</div>

						<div class="muiPostContentB muiAskAddition">
							<span>补充提问：</span>
							<ul data-dojo-type="dojox/mobile/EdgeToEdgeStoreList"
								id="additionList"
								data-dojo-mixins="mui/list/_JsonStoreListMixin,kms/ask/mobile/js/view/AskAdditionItemListMixin"
								data-dojo-props="url:'/kms/ask/kms_ask_addition/kmsAskAddition.do?method=list&fdId=${param.fdId }',lazy:false">
							</ul>
						</div>
					</div>
				</div>

				<!-- 附件 -->
				<c:import url="/sys/attachment/mobile/import/view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsAskTopicForm"></c:param>
					<c:param name="fdKey" value="topic"></c:param>
				</c:import>
			</div>


			<div class="muiTopicReplyContainer">
				<ul data-dojo-type="dojox/mobile/EdgeToEdgeStoreList"
					data-dojo-mixins="mui/list/_JsonStoreListMixin,kms/ask/mobile/js/view/AskReplyItemListMixin"
					data-dojo-props="url:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=listOther&fdId=${param.fdId }',lazy:false">
				</ul>
			</div>
		</div>

		<!-- 是否有回答权限 -->
		<c:if
			test="${kmsAskTopicForm.fdStatus==0 && isReplyer==false && isPoster==false}">
			<kmss:auth
				requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=add&fdTopicId=${param.fdId}"
				requestMethod="GET">
				<c:set value="true" var="canReply"></c:set>
			</kmss:auth>
		</c:if>

		<!-- 是否有结束问题权限 -->
		<c:if test="${kmsAskTopicForm.fdStatus==0}">
			<kmss:auth
				requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=close&fdId=${param.fdId}"
				requestMethod="GET">
				<c:set value="true" var="canClose"></c:set>
			</kmss:auth>
		</c:if>

		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom"
			<c:if test="${not empty canReply || not empty canClose}">data-dojo-props='fill:"grid"'
						</c:if>>
			<li data-dojo-type="mui/back/BackButton"
				data-dojo-props="align:'left'"></li>
			<c:if test="${not empty canReply}">
				<li data-dojo-type="mui/tabbar/TabBarButton" class="muiAskReplyBtn"
					data-dojo-props='colSize:2,fdId:"${param.fdId }"'
					data-dojo-mixins="kms/ask/mobile/js/view/AskReplyButtonMixin"><span
					class="mui mui-create"></span>&nbsp;我来回答</li>
			</c:if>
			<c:if test="${not empty canClose && empty canReply}">
				<li data-dojo-type="mui/tabbar/TabBarButton" class="muiAskCloseBtn"
					data-dojo-props='colSize:2,fdId:"${param.fdId }"'
					data-dojo-mixins="kms/ask/mobile/js/view/AskCloseButtonMixin"><span
					class="mui mui-askclose"></span>&nbsp;结束问题</li>
			</c:if>
			<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
				data-dojo-props="icon1:'mui mui-more',align:'right'">
				<div data-dojo-type="mui/back/HomeButton"></div>
			</li>
		</ul>
	</template:replace>
</template:include>

