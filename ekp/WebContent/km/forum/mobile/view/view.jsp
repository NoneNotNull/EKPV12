<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumTopic"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<template:include ref="mobile.view">
	<template:replace name="title">
		<c:out value="${forumTopic.docSubject}"></c:out>
	</template:replace>
	<template:replace name="head">
		<mui:min-file name="list.css"/>
		<mui:min-file name="forum.css"/>
		<mui:min-file name="mui-forum.js"/>
		<script type="text/javascript">
			require(["mui/form/editor/EditorUtil", "mui/device/device", "mui/dialog/Tip", "dojo/request",
						"dojo/topic", "dojo/dom-construct","dijit/registry"],function(EditorUtil, device, Tip, request, topic, domConstruct, registry){
					<%@ include file="/km/forum/mobile/view/checkword_script.jsp"%>
					window.replayPost = function(argu){
						var _url = '/km/forum/km_forum/kmForumPost.do?method=saveReplyQuote';
						EditorUtil.popup(_url,{name:"docContent",
							placeholder:'回帖',
							validates:[function(popup){
									var content = popup.textClaz.get("value");
									var tmpDom = domConstruct.create("div",{'innerHTML':content});
									content = tmpDom.innerText;
									if(content==null || content.trim()==""){
										Tip.fail({text:'回帖内容不能为空!'});
										return false;
									}
									return forum_wordCheck(content,"<bean:message  bundle='km-forum' key='kmForumConfig.word.warn'/>");
								}],
							data:{fdIsAnonymous:"false",
								fdPdaType:device.getClientType(),
								fdForumId:'${forumTopic.kmForumCategory.fdId}',
								fdTopicId:'${forumTopic.fdId}',
								fdParentId:(argu?argu.fdId:null),
								fdIsNotify:'${forumTopic.fdIsNotify}'
						}},function(data){
								if (data.status == 200) {
									Tip.success({
										text : '操作成功'
									});
								} else{
									Tip.fail({
										text : '操作失败'
									});
								}
								var view = registry.byId('scrollView');
								if(view.scrollTo)
									view.scrollTo({y:0});
								topic.publish("/mui/list/onReload",view);
								topic.publish("/km/forum/replaySuccess");
						});
					};
				});
		</script>
	</template:replace>
	<template:replace name="content">
		<%
			KmForumTopic topic = (KmForumTopic)request.getAttribute("forumTopic");
			pageContext.setAttribute("_docCreatetime",DateUtil.convertDateToString(topic.getDocCreateTime(),null)); 
			Integer hotReplyCount = Integer.parseInt(new KmForumConfig().getHotReplyCount()); 
	     	request.setAttribute("hotReplyCount",hotReplyCount);
	   %>
		<div id="scrollView" data-dojo-type="mui/list/StoreScrollableView">
			<div
				data-dojo-type="km/forum/mobile/resource/js/ForumTopicHead"
				data-dojo-props="label:'${forumTopic.docSubject}',
					cateName:'${forumTopic.kmForumCategory.fdName}',
					cateId:'${forumTopic.kmForumCategory.fdId}',
					count:${forumTopic.fdHitCount},
					replyCount:${forumTopic.fdReplyCount },
					created:'${_docCreatetime}',
					top:${forumTopic.fdSticked},
					hot:${forumTopic.fdReplyCount>=hotReplyCount},
					pinked:${forumTopic.fdPinked},
					closed:${forumTopic.fdStatus=='40'}">
			</div>
			 <ul
		    	data-dojo-type="mui/list/JsonStoreList" 
		    	data-dojo-mixins="km/forum/mobile/resource/js/ForumPostItemListMixin"
		    	data-dojo-props="url:'/km/forum/mobile/kmForumPost.do?method=listReplays&fdTopicId=${forumTopic.fdId}',lazy:false">
			</ul>
			<br/><br/>
			<c:if test="${forumTopic.fdStatus=='40' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
				  	<li data-dojo-type="mui/back/BackButton"></li>
				    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" 
				    	data-dojo-props="icon1:'mui mui-more',align:'right'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    	<c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
						   <c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumTopic"/>
						   <c:param name="fdModelId" value="${forumTopic.fdId}"/>
						   <c:param name="fdSubject" value="${forumTopic.docSubject}"/>
						   <c:param name="label" value="${lfn:message('km-forum:kmForumPost.collection')}"/>
					    </c:import>
				    </li>
				</ul>
			</c:if>
			<c:if test="${forumTopic.fdStatus!='40'}">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
				  	<li data-dojo-type="mui/back/BackButton"></li>
				  	<li class="muiBtnNext muiForumParseBtn" data-dojo-type="mui/tabbar/TabBarButton"
				  		data-dojo-mixins="km/forum/mobile/resource/js/ForumTopicParseMixin"
						data-dojo-props='colSize:1,modelId:"${forumTopic.forumPosts[0].fdId}",icon1:"mui mui-praise",
						count:${forumTopic.forumPosts[0].docPraiseCount},modelName:"com.landray.kmss.km.forum.model.KmForumPost"'>
						${forumTopic.forumPosts[0].docPraiseCount}
					</li>
				  	<li class="muiBtnNext" data-dojo-type="mui/tabbar/TabBarButton"
				  		data-dojo-mixins='km/forum/mobile/resource/js/ForumTopicReplayMixin'
						data-dojo-props='colSize:1, icon1:"mui mui-msg",count:${forumTopic.fdReplyCount}'>
						${forumTopic.fdReplyCount}
					</li>
				    <li data-dojo-type="mui/tabbar/TabBarButtonGroup" 
				    	data-dojo-props="icon1:'mui mui-more'">
				    	<div data-dojo-type="mui/back/HomeButton"></div>
				    	<c:import url="/sys/bookmark/mobile/import/view.jsp" charEncoding="UTF-8">
						   <c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumTopic"/>
						   <c:param name="fdModelId" value="${forumTopic.fdId}"/>
						   <c:param name="fdSubject" value="${forumTopic.docSubject}"/>
						   <c:param name="label" value="${lfn:message('km-forum:kmForumPost.collection')}"/>
					    </c:import>
				    </li>
				</ul>
			</c:if>
		</div>
	</template:replace>
</template:include>
