<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumPost"%>
<%@ page import="com.landray.kmss.util.ArrayUtil"%>
<%@ page import="com.landray.kmss.km.forum.utils.ForumStringUtil"%>
<template:include ref="default.view" sidebar="no" width="980px">
    <template:replace name="head">
		<link href="${LUI_ContextPath}/km/forum/resource/css/forum_view.css" rel="stylesheet" type="text/css" />
		<script>Com_IncludeFile('ckresize.js', 'ckeditor/');</script>
        <%@ include file="./kmForumPost_view_js.jsp"%>
        <script type="text/javascript">
    	seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
	    	LUI.ready( function() {
	          initFixed();
	    	  CKResize.____ckresize____(true);
		      //定位至跳转楼层
		      var fdPostId = '${param.fdPostId}';
		      if(fdPostId !=""){
                   window.location.hash="#FID_"+fdPostId;
			   }
		     });

		     window.operationDivChange = function(fdId){
			     console.log($("#operate_"+fdId).attr("id"));
			     $("#operate_"+fdId).css("color","#343434");
		     };
		});
	   </script>
	   <%Integer hotReplyCount = Integer.parseInt(new KmForumConfig().getHotReplyCount()); 
	     request.setAttribute("hotReplyCount",hotReplyCount);
	   %>
	</template:replace>
	<%--标签页标题--%>
	<template:replace name="title">
		   <c:out value="${topic.docSubject} - ${ lfn:message('km-forum:module.km.forum') }"></c:out>
	</template:replace>
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" id="${varParams.id }">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-forum:module.km.forum') }" href="/km/forum/" target="_self">
			</ui:menu-item>
			<ui:menu-source autoFetch="false" 
					target="_self" 
					href="/km/forum/indexCriteria.jsp?categoryId=!{value}">
				<ui:source type="AjaxJson">
					{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.forum.model.KmForumCategory&categoryId=${topic.kmForumCategory.fdId}&currId=!{value}${extProps }"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>	
	<!-- 内容区域 -->
<template:replace name="content"> 
<html:form action="/km/forum/km_forum/kmForumPost.do">	 
      <!-- 快捷菜单 开始 -->
        <div class="forum_shortcut_menu" id="forum_shortcut_menu">
            <ul>
             <%--快速回复按钮--%>
             <c:if test="${topic.fdStatus == '30'}">
			    <kmss:auth
					requestURL="/km/forum/km_forum/kmForumPost.do?method=reply&fdForumId=${topic.kmForumCategory.fdId}"
					requestMethod="GET">
                    <li><a title="${ lfn:message('km-forum:KmForumPost.notify.title.quickReply') }" href="#quickReplyContent" class="menu1"></a></li>
                </kmss:auth>
             </c:if>  
             <%--快速发帖--%>
           	    <kmss:auth
					requestURL="/km/forum/km_forum/kmForumPost.do?method=add&fdForumId=${topic.kmForumCategory.fdId}"
					requestMethod="GET">
                    <li><a title="${ lfn:message('km-forum:KmForumPost.notify.title.quickPost') }" href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=add&fdForumId=${topic.kmForumCategory.fdId}" class="menu2"></a></li>
                </kmss:auth>
                <li><a title="${ lfn:message('km-forum:KmForumPost.notify.title.returnList') }" href="${LUI_ContextPath}/km/forum/indexCriteria.jsp?categoryId=${topic.kmForumCategory.fdId}" class="menu3"></a></li>
            </ul>
        </div>
        <!-- 快捷菜单 结束 -->

  <div class="forum_readPost_w" style="width: 980px">
        <div class="main_body">
            <!-- 帖子内容开始 -->
            <div class="forum_readPost_content">
                <!-- 主题显示开始 -->
                <div class="forum_subjectPost_content">
                    <!-- 标题开始 -->
                    <div class="forum_content_titleBar">
                       <div class="${topic.fdIsAnonymous ==false?'userImage':''}">
                           <div class="floor_user_info_w"> 
                        <%--发帖人头像--%>
                        <c:if test="${topic.fdIsAnonymous == false}">  
                               <img src="${LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${topic.fdPoster.fdId}" class="author_img"/>
                               <%--  <p class="level">
	                               <a href="#" onClick="Com_OpenWindow('<c:url value="/km/forum/km_forum_config/kmForumConfig.do" />?method=viewLevel','_blank');">
										<img src="${LUI_ContextPath}/resource/style/default/forum/level/${levelIcon}.gif" border="0"> 
								    </a>
						       </p> 
						       --%>
                        </c:if> 
                        <c:if test="${topic.fdIsAnonymous == true}">  <%--匿名--%>
                                <img src="${ LUI_ContextPath }/km/forum/resource/images/user_anon_img.png" class="author_img" style="padding-left: 12px;padding-top: 19px;"/>
                        </c:if>
                        <c:if test="${topic.fdIsAnonymous ==false}">  
                                    <%--用户信息匿名不显示--%>
                                    <div class="floor_user_baseInfo">
                                        <%--用户名--%>
										<p class="user">
										    <a
											href="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=${topic.fdPoster.fdId}"
											target="_blank">${topic.fdPoster.fdName}</a>
										</p>
										<ul>
                                            <%--来自--%>
                                            <li><em><bean:message bundle="km-forum" 
                                                                  key="kmForumPost.from.title" />:</em>${topic.fdPoster.fdParent.fdName}</li>
                                            <%--岗位--%>
                                            <li><em><bean:message bundle="sys-organization" 
                                                                  key="sysOrgElement.post" />:</em>${postName}</li>
                                            <%--等级--%>
                                            <li>
												<em><bean:message bundle="km-forum" 
                                                                  key="kmForumConfig.shortLevel" />:</em>${level}  </li>
                                            <%--积分--%>
                                            <li><em><bean:message bundle="km-forum"
							                                      key="kmForumScore.fdScore" />:</em>${topicPoster.posterScore.fdScore}</li>
                                            <%--主题--%>
                                            <li><em>${lfn:message('km-forum:kmForumPost.topic')}:</em>${topicPoster.posterScore.fdPostCount}</li>
                                            <%--回帖--%>
                                            <li><em>${lfn:message('km-forum:kmForum.button.reply')}:</em>${topicPoster.posterScore.fdReplyCount}</li>
                                        </ul>
                                </div>
                           </c:if>
                          </div>
                        </div>
                       
                        
	                        <h1 class="title">
	                              <%--顶图标--%>
	                              <c:if test="${topic.fdSticked==true}">
					                   <img src="${LUI_ContextPath}/km/forum/resource/images/i_top.png" border="0" title="<bean:message bundle="km-forum" key="kmForumTopic.button.stick"/>">
					              </c:if>
					              <%--精图标--%>
					              <c:if test="${topic.fdPinked==true}">
									   <img src="${LUI_ContextPath}/km/forum/resource/images/i_pink.png" border="0" title="<bean:message bundle="km-forum" key="kmForumTopic.pink.title"/>">
								  </c:if> 
								  <%--热图标--%>
								  <c:if test="${topic.fdReplyCount>=hotReplyCount}">
									   <img src="${LUI_ContextPath}/km/forum/resource/images/i_hot.png" border="0" title="<bean:message bundle="km-forum" key="kmForumTopic.hot.title"/>">
								  </c:if>
								  <%--结贴图标--%>
								  <c:if test="${topic.fdStatus=='40'}">
									   <img src="${LUI_ContextPath}/km/forum/resource/images/end.gif" border="0" title="<bean:message bundle="km-forum" key="kmForumTopic.button.conclude"/>">
								  </c:if>
								  <%--显示主话题--%>
	                                 <c:out value="${topic.docSubject}"/>
	                             <%--楼主--%>
		                        <div class="forum_floor_info">
		                            <p class="p1">
		                                <span class="floor_nL"><span class="floor_nR"><span class="floor_nC">${lfn:message('km-forum:kmForumPost.mainFloor.title') }</span></span></span></p>
		                        </div>
	                          </h1>
	                        <%--发帖人信息--%>
	                        <div class="post_basicInfo">
	                              <%--发帖人姓名--%>
	                              <c:if test="${topic.fdIsAnonymous==false}">
									<ui:person personId="${topic.fdPoster.fdId}" personName="${topic.fdPoster.fdName}"></ui:person>
								  </c:if>
								  <c:if test="${topic.fdIsAnonymous==true}">
									   <bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
								  </c:if>
								  <%--发帖时间--%>
	                              <bean:message bundle="km-forum" key="kmForumTopic.docPublishTimeAt" /> 
			                             <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${topic.docCreateTime}" />
	                                  <em>|</em> 
	                              <%--最后回复时间--%>     
	                                      ${lfn:message('km-forum:kmForumTopic.fdLastPosterId')}
			                             <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${topic.fdLastPostTime}"/>                             
	                              <%--显示查看该作者和显示全部--%>
	                              <c:if test="${topic.fdIsAnonymous==false}">
									  <em>|</em> 
								      <c:if test="${param.type!='onlyViewPoster' &&not empty topic.fdPoster}">
										  <a href="#" class="search" onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdId=${param.fdTopicId}&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${param.fdTopicId}&fdPosterId=${topic.fdPoster.fdId}&type=onlyViewPoster','_self');">
										     <bean:message bundle="km-forum" key="kmForumPost.onlyViewPoster" />
										  </a>
							          </c:if>
							          <c:if test="${param.type=='onlyViewPoster'}">
								          <a href="#" class="search" onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdId=${param.fdTopicId}&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${param.fdTopicId}','_self');">
								             <bean:message bundle="km-forum" key="kmForumPost.ViewAll" /> 
								          </a>
							          </c:if>
						          </c:if>
						          
						          <p class="p2">
	                                <a class="a_read" title="${lfn:message('km-forum:kmForumTopic.fdHitCount')}">${topic.fdHitCount}</a><em>|</em>
	                                <a class="a_comment" title="${lfn:message('km-forum:kmForumTopic.fdReplyCount')}">${topic.fdReplyCount}</a></p>
	                        </div>
                    </div>
                    <!-- 标题结束 -->
                     <%--固定标题--%>
                   	<%@ include file="./kmForumPost_view_titleBarFixed.jsp" %>
                    <!-- 帖子开始 显示主题信息-->
                    <div class="forum_post_topic_content" style="min-height: 200px;display:${showTopic == false?'none':''}">
                     <%--第一页的时候显示主题信息--%>
                          <%--主题重要信息修改--%>
                           <c:if test="${!empty topic.fdImportInfo}">
                               <div class="floor_adminTips">
	                              <span class="floor_adminTips_show"> <em>${lfn:message('km-forum:kmForumPost.adminTips')}</em>${topic.fdImportInfo}</span>
	                           </div>
	                        </c:if>
                        <%--主题痕迹--%>
                       	<c:if test="${topicPoster.fdIsAnonymous==false}">
                       	    <c:if test="${!empty topicPoster.fdAlteror}">
	                             <div class="floor_tips">
                                     <span class="floor_tips_show">
								                   ${lfn:message('km-forum:kmForumPost.toolTip.finalBy')}<span style="width: 2px"></span>
								                   <ui:person personId="${topicPoster.fdAlteror.fdId}" personName="${topicPoster.fdAlteror.fdName}"></ui:person>
								                   ${lfn:message('km-forum:kmForumPost.toolTip.yu')}
				                                   <kmss:showDate type="datetime" showTitle="true" isInterval="true" value="${topicPoster.docAlterTime}" /> 
				                                   ${lfn:message('km-forum:kmForumPost.button.edit')}                              
		                             </span>
	                           </div>
	                        </c:if>
	                        <%--兼容老数据--%>
							<c:if test="${!empty topicPoster.fdNote && empty topicPoster.fdAlteror}">
	                             <div class="floor_tips">
                                    <span class="floor_tips_show">${topicPoster.fdNote}</span>
	                           </div>
	                        </c:if>
                        </c:if>
                        <%--主题内容--%>
                        <div name="content" style="word-break:break-all">
                         <%--  ${topicPoster.docContent}--%>
                             <div id="_____rtf_____content">
                                   ${topicPoster.docContent}
                              </div>
                              <div id='_____rtf__temp_____content' style="width:80%"></div>
                                  <script type="text/javascript">
				                    var property = 'content';
									CKResize.addPropertyName(property);
							       </script>
                        	  </div>
	                        <script>
	                          document.getElementById("_____rtf__temp_____content").style.width="95%";
	                        </script>
                        <%--附件--%>
						    <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
									     charEncoding="UTF-8">
								    <c:param name="fdKey" value="attachment" />
								    <c:param name="fdAttType" value="byte" />
									<c:param name="fdModelId" value="${topicPoster.fdId }" />
									<c:param name="formBeanName" value="kmForumPost" />
									<c:param name="fdModelName"
										value="com.landray.kmss.km.forum.model.KmForumPost" />
							</c:import>
					    <%--收藏--%>
                        <div class="collect_w">
                            <span class="collectL" onclick="collectOperation('${topic.fdId}');"><span class="collectR" title="${markCount}${lfn:message('km-forum:kmForumPost.peopleCollection')}"><span class="collectC">${lfn:message('km-forum:kmForumPost.collection')}<em>${markCount}</em></span></span></span>
                        </div>
                    </div>
                    <%--签名档 由于无法从sns获取个性签名，故先移除
                    <c:if test="${post.fdIsAnonymous==false}">
					   <c:if test="${!empty post.posterScore.fdSign}">
		                   <div class="signature">
		                       <h6> <span></span> </h6>
		                       <p> ${post.posterScore.fdSign} </p>
		                   </div>
	                   </c:if>
				    </c:if>--%>
				    <%--按钮栏，主题信息按钮--%>
                    <div class="post_operate" style="display:${showTopic == false?'none':''}">
                        <div class="left">
                            <!-- 点赞 -->
		                      <c:import
									url="/km/forum/praise/sysPraiseMain_view.jsp"
									charEncoding="UTF-8">
									<c:param name="formName" value="topicPoster" />
									<c:param name="fdModelId" value="${topicPoster.fdId}" />
									<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost" />
							  </c:import>           
                            <%--回复按钮--%>
                        <c:if test="${topic.fdStatus == '30'}">
							    <kmss:auth
									requestURL="/km/forum/km_forum/kmForumPost.do?method=reply&fdForumId=${topic.kmForumCategory.fdId}"
									requestMethod="GET">
		                            <em>|</em>
		                            <a title="${lfn:message('km-forum:kmForumCategory.fdPostCount')}" href="#quickReplyContent">${lfn:message('km-forum:kmForumCategory.fdPostCount')}</a>
                                </kmss:auth>
                            <%--编辑按钮--%>
								<kmss:auth
									requestURL="/km/forum/km_forum/kmForumPost.do?method=edit&fdId=${topicPoster.fdId}"
									requestMethod="GET">
									<em>|</em>
									<a title="${lfn:message('km-forum:kmForumPost.button.edit') }" href="javascript:Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=edit&fdForumId=${topic.kmForumCategory.fdId}&fdId=${topicPoster.fdId}','_self');">
									    <bean:message bundle="km-forum" key="kmForumPost.button.edit" />
								    </a>
							    </kmss:auth>
					    </c:if>
                            <%--删除--%>
                            <c:if test="${topic.fdStatus == '30' || topic.fdStatus == '40'}">
								<kmss:auth
									requestURL="/km/forum/km_forum/kmForumTopic.do?method=delete&fdId=${topic.fdId}"
									requestMethod="GET">
									<em>|</em>
								    <a title="${lfn:message('button.delete') }" href="javascript:deleteTopicOperation('${topic.fdId}',${topic.fdReplyCount},'${LUI_ContextPath}/km/forum');">
								       <bean:message key="button.delete"/>
								    </a>
								</kmss:auth>
							</c:if>
							<%--结贴--%> 
							<c:if test="${topic.fdStatus == '30'}">
								<kmss:auth
									requestURL="/km/forum/km_forum/kmForumTopic.do?method=conclude&fdId=${topic.fdId}"
									requestMethod="GET">
									<em>|</em>
									<a title="${lfn:message('km-forum:kmForumTopic.button.conclude') }" href="javascript:buttonOperation('conclude','${topic.fdId}');">
								       <bean:message bundle="km-forum" key="kmForumTopic.button.conclude"/>
								    </a>
								</kmss:auth>
							</c:if> 
                        </div>
                        <div class="right">
                            <%--置顶和取消置顶--%>
                            　　　　　　　　<%int a=0; %>
	                        <c:if test="${topic.fdSticked==false}">
								<kmss:auth
									requestURL="/km/forum/km_forum/kmForumTopic.do?method=stick&fdId=${topic.fdId}"
									requestMethod="GET">
								    <%a++;
								     if(a!=1){
								    	 out.print("<em>|</em>");
								     }%>
									<a title="${lfn:message('km-forum:kmForumTopic.button.stick') }" href="javascript:stickOperation('stick','${topic.fdId}');">
								       <bean:message bundle="km-forum" key="kmForumTopic.button.stick"/>
								    </a>
								</kmss:auth>
							</c:if> 
						    <c:if test="${topic.fdSticked==true}">
								<kmss:auth
									requestURL="/km/forum/km_forum/kmForumTopic.do?method=undoStick&fdId=${topic.fdId}"
									requestMethod="GET">
								    <%a++;
								     if(a!=1){
								    	 out.print("<em>|</em>");
								     }%>
									<a title="${lfn:message('km-forum:kmForumTopic.button.unStick') }" href="javascript:buttonOperation('undoStick','${topic.fdId}');">
								       <bean:message bundle="km-forum" key="kmForumTopic.button.unStick"/>
								    </a>
								</kmss:auth>
							</c:if> 
					        <%--设置为精华取消精华--%>		
						 <c:if test="${topic.fdPinked==false}">
							<kmss:auth
								requestURL="/km/forum/km_forum/kmForumTopic.do?method=pink&fdId=${topic.fdId}"
								requestMethod="GET">
								   <%a++;
								     if(a!=1){
								    	 out.print("<em>|</em>");
								     }%>
								<a title="${lfn:message('km-forum:kmForumTopic.button.pink') }" href="javascript:buttonOperation('pink','${topic.fdId}');">
								    <bean:message bundle="km-forum" key="kmForumTopic.button.pink"/>
								</a>
							</kmss:auth>
						</c:if> 
					    <c:if test="${topic.fdPinked==true}">
							<kmss:auth
								requestURL="/km/forum/km_forum/kmForumTopic.do?method=undoPink&fdId=${topic.fdId}"
								requestMethod="GET">
								  <%a++;
								     if(a!=1){
								    	 out.print("<em>|</em>");
								   }%>
								<a title="${lfn:message('km-forum:kmForumTopic.button.unPink') }" href="javascript:buttonOperation('undoPink','${topic.fdId}');">
								    <bean:message bundle="km-forum" key="kmForumTopic.button.unPink"/>
								</a>
							</kmss:auth>
						</c:if>
						
						   <%--推荐--%>		
						   <kmss:auth
								requestURL="/km/forum/km_forum/kmForumTopic.do?method=introduce&fdId=${topic.fdId}"
								requestMethod="GET">
								  <%a++;
								     if(a!=1){
								    	 out.print("<em>|</em>");
								   }%>
							    <a title="${lfn:message('km-forum:kmForumTopic.introduce.button') }" href="javascript:introduceOperation('${topic.fdId}')">
								    <bean:message bundle="km-forum" key="kmForumTopic.introduce.button"/>
								</a>
						   </kmss:auth> 
                            
                           <%--转移--%>		
	                       <kmss:auth
								requestURL="/km/forum/km_forum/kmForumTopic.do?method=move&fdForumId=${topic.kmForumCategory.fdId}"
								requestMethod="GET">
								  <%a++;
								     if(a!=1){
								    	 out.print("<em>|</em>");
								   }%>
							    <a title="${lfn:message('km-forum:kmForumTopic.button.move') }" href="javascript:moveOperation('${topic.fdId}','${topic.kmForumCategory.fdId}')">
								    <bean:message bundle="km-forum" key="kmForumTopic.button.move"/>
								</a>
						  </kmss:auth>     
                        </div>
                    </div>
                    <!-- 帖子结束 -->
                </div>
                <!-- 主题显示结束 -->
                
                <!-- 评论帖子 开始 -->      
          <c:if test="${not empty queryPage}">       
                <div class="post_comment_floor">
                    <table style="table-layout: fixed;">
                    <c:forEach var="post" items="${queryPage.list}" varStatus="indx">
			            <c:set var="forumScore" value="${post.posterScore}" scope="request" />
                        <tr id="FID_${post.fdId}">
                            <%--匿名则用floor_user_none样式--%>
                            <td class="${not empty post.fdPoster?'floor_user':'floor_user_none'} one_floor split">
                                <div class="floor_user_info_w">
                                    <div class="user_img_w">
                                        <%--用户头像--%>
                                        <c:if test="${not empty post.fdPoster}"> 
                                             <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${post.fdPoster.fdId}" style="width: 60px;height: 60px"/>
                                        </c:if> 
                                        <c:if test="${empty post.fdPoster}"> 
                                             <img src="${ LUI_ContextPath }/km/forum/resource/images/user_anon_img.png" class="author_img"/>
                                        </c:if> 
                                        <%--用户等级--%>
                                      <div class="level">
								                                        <%--等级图片--%>
												<%
												  String levelIcon = null;
											      String postName = "";
											      String level ="";
												  if(((KmForumPost) pageContext
															.getAttribute("post"))
															.getFdPoster()!=null){ 
													int score = ((KmForumPost) pageContext
																			.getAttribute("post")).getPosterScore()
																			.getFdScore().intValue();
																	KmForumConfig forumConfig = new KmForumConfig();
																    level = forumConfig.getLevelByScore(score).trim();
																	levelIcon = forumConfig.getLevelIcon();
																	postName = ArrayUtil.joinProperty(
																			((KmForumPost) pageContext
																					.getAttribute("post"))
																					.getFdPoster().getFdPosts(),
																			"fdName", ",")[0];
												  }
												%>
												<%
													if (levelIcon != null && !levelIcon.equals("0")) {
												%>
													<p style="padding-bottom: 2px"><span class="post_level"><%=level%></span></p>
													<span class="post_lv">LV<%=levelIcon%><span>
												<%
													}
												%>
												<%--等级图片--%>
                                      </div>
                                    </div>
                                  <c:if test="${not empty post.fdPoster}">  
                                    <%--用户信息匿名不显示--%>
                                    <div class="floor_user_baseInfo">
                                        <%--用户名--%>
										<p class="user"><a
											href="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=${post.fdPoster.fdId}"
											target="_blank">${post.fdPoster.fdName}</a></p>
										<ul>
                                            <%--来自--%>
                                            <li><em><bean:message bundle="km-forum" 
                                                                  key="kmForumPost.from.title" />:</em>${post.fdPoster.fdParent.fdName}</li>
                                            <%--岗位--%>
                                            <li><em><bean:message bundle="sys-organization" 
                                                                  key="sysOrgElement.post" />:</em><%=postName%></li>
                                            <%--等级--%>
                                            <li>
												<em><bean:message bundle="km-forum" 
                                                                  key="kmForumConfig.shortLevel" />:</em><%=level%> </li>
                                           
                                            <%--积分--%>
                                            <li><em><bean:message bundle="km-forum"
							                                      key="kmForumScore.fdScore" />:</em>${post.posterScore.fdScore}</li>
                                            <%--主题--%>
                                            <li><em>${lfn:message('km-forum:kmForumPost.topic')}:</em>${post.posterScore.fdPostCount}</li>
                                            <%--回帖--%>
                                            <li><em>${lfn:message('km-forum:kmForum.button.reply')}:</em>${post.posterScore.fdReplyCount}</li>
                                        </ul>
                                    </div>
                                  </c:if>
                                </div>
                            </td>
                            <td class="one_floor split">
                               <p class="floor_basicInfo">
                                        <%--回帖人姓名--%>
					                    <c:if test="${post.fdIsAnonymous==false}">
											<ui:person personId="${post.posterScore.person.fdId}" personName="${post.fdPoster.fdName}"></ui:person>
										</c:if> 
									    <c:if test="${post.fdIsAnonymous==true}">
											<bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
										</c:if>
                                     <%--发帖时间--%>
                             		<bean:message bundle="km-forum" key="kmForumTopic.docPublishTimeAt" /> 
		                                 <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${post.docCreateTime}" />     
		                            <%--移动端--%>
			                        <c:if test="${not empty post.fdPdaType && post.fdPdaType!=10}">
			                           ${lfn:message('km-forum:kmForumPost.com')}
						               <bean:message  bundle="sys-mobile" key="sysMobile.pda.comefrom.${post.fdPdaType}"/>
						            </c:if>                                
		                            <%--显示查看该作者和显示全部--%>
		                            <c:if test="${post.fdIsAnonymous==false}">
									   <em>|</em> 
									 <c:if test="${param.type!='onlyViewPoster'}">
										  <a href="#" class="search" onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdId=${param.fdTopicId}&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${param.fdTopicId}&fdPosterId=${post.fdPoster.fdId}&type=onlyViewPoster','_self');">
										     <bean:message bundle="km-forum" key="kmForumPost.onlyViewPoster" />
										  </a>
							          </c:if>
							          <c:if test="${param.type=='onlyViewPoster'}">
								          <a href="#" class="search" onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdId=${param.fdTopicId}&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${param.fdTopicId}','_self');">
								             <bean:message bundle="km-forum" key="kmForumPost.ViewAll" /> 
								          </a>
							          </c:if>
							        </c:if>
                                </p>
                                <%--修改痕迹--%>
                                <c:if test="${post.fdIsAnonymous==false}">
                                  <c:if test="${!empty post.fdAlteror}">
			                          <div class="floor_tips">
		                                    <span class="floor_tips_show">
								                   ${lfn:message('km-forum:kmForumPost.toolTip.PostfinalBy')}<span style="width: 2px"></span>
								                   <ui:person personId="${post.fdAlteror.fdId}" personName="${post.fdAlteror.fdName}"></ui:person>
								                   ${lfn:message('km-forum:kmForumPost.toolTip.yu')}
				                                    <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${post.docAlterTime}" />   
				                                   ${lfn:message('km-forum:kmForumPost.button.edit')}                              
		                                    </span>
			                           </div>
			                        </c:if>
			                        <%--兼容老数据--%>
									<c:if test="${!empty post.fdNote && empty post.fdAlteror}">
                                         <div class="floor_tips">
                                            <span class="floor_tips_show">
                                              <c:out value="${post.fdNote}"/>
					                        </span>
                                         </div>
                               	    </c:if>
		                    	</c:if>
		                              <%--显示引用信息--%>
								      <c:if test="${not empty post.fdParent}">   
										       <div class="floor_quote_w">
										         <blockquote>
										           <div class="center">
				                                        <span class="floor_basicInfo_forward">${post.fdParent.fdPoster.fdName} ${lfn:message('km-forum:kmForumTopic.docPublishTimeAt')} 
			                                                     <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${post.fdParent.docCreateTime}" />
			                                                     <%--移动端
			                                                      <c:if test="${not empty post.fdParent.fdPdaType && post.fdParent.fdPdaType!=10}">
						                                        	 <bean:message  bundle="sys-mobile" key="sysMobile.pda.comefrom.${post.fdParent.fdPdaType}"/>
						                                          </c:if>
						                                         --%>
			                                                 <c:if test="${topicPoster.fdIsOnlyView != true}">
				                                                <a class="btn_forward" href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${topic.fdId}&fdPostId=${post.fdParent.fdId}&fdFloor=${post.fdParent.fdFloor}" target="_blank"></a>
				                                             </c:if>
				                                        </span>
					                                        <div class="forum_post_content" id="_____rtf_____post${post.fdId}${post.fdParent.fdId}">
					                                            <p>${post.fdParent.docContent}</p>
					                                        </div>
				                                        <div id='_____rtf__temp_____post${post.fdId}${post.fdParent.fdId}' style="width:65%"></div>
					                                        <script type="text/javascript">
					                                            var propertyParent = 'post'+'${post.fdId}${post.fdParent.fdId}';
																CKResize.addPropertyName(propertyParent);
															</script> 
													</div>
		                                          </blockquote>
		                                       </div>
	                                   </c:if> 
	                                   <%--非法引用--%>
	                                   <c:if test="${post.fdIsParentDelete ==true && empty post.fdParent}">
		                                   <div class="floor_quote_w">
		                                       <blockquote>
			                                        <div class="forum_post_content" name="content">
														<div class="locked">
														     ${lfn:message('km-forum:kmForumPost.deleteTips')}:
														     <em>${lfn:message('km-forum:kmForumPost.deleteTipsInfo')}</em>
														</div>
													</div>
											   </blockquote>
										  </div>
									   </c:if>       
	                                   <%--兼容以前的老数据--%>
	                                   <c:if test="${not empty post.fdQuoteMsg && empty post.fdParent}">
											<table width='98%' cellspacing='1' cellpadding='3' border='0'
												align='center'>
												<tr>
													<td class='quote_head'>
													<% KmForumPost post = (KmForumPost)pageContext.getAttribute("post");
													   String fdQuoteMsg = post.getFdQuoteMsg();%>
													<p><%out.write(ForumStringUtil.getNewQuote(fdQuoteMsg));%></p>
													</td>
												</tr>
											</table>
										</c:if>                                     
                                <%--显示回复信息--%>
                                <div class="forum_post_content">
                                     <div id="_____rtf_____post${post.fdId}">
                                          ${post.docContent}
                                     </div>
                                     <div id='_____rtf__temp_____post${post.fdId}' style="width:85%"></div>
                                     <script type="text/javascript">
				                          var property = 'post'+'${post.fdId}';
									      CKResize.addPropertyName(property);
							         </script> 
							            <br>
                                        <%--附件--%>
										<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
											charEncoding="UTF-8">
											<c:param name="fdKey" value="attachment" />
											<c:param name="fdAttType" value="byte" />
											<c:param name="fdModelId" value="${post.fdId}" />
											<c:param name="formBeanName" value="kmForumPost" />
											<c:param name="fdModelName"
												value="com.landray.kmss.km.forum.model.KmForumPost" />
										</c:import>
                                </div>
                                <%--签名档 先移除个性签名显示
                                <c:if test="${post.fdIsAnonymous==false}">
								   <c:if test="${!empty post.posterScore.fdSign}">
				                      <div class="signature">
				                          <h6> <span></span> </h6>
				                          <p> ${post.posterScore.fdSign}</p>
				                      </div>
                                  </c:if>
								</c:if>
								--%>
								<%--按钮栏--%>
								<div class="post_operate" style="padding-left: 0px">
                                    <div class="left">
                                      <!-- 点赞 -->
                                      <c:set var="post" value="${post}" scope="request"/>
				                      <c:import
											url="/sys/praise/sysPraiseMain_view.jsp"
											charEncoding="UTF-8">
											<c:param name="formName" value="post" />
											<c:param name="fdModelId" value="${post.fdId}" />
											<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost" />
									  </c:import>            
                                  <c:if test="${topic.fdStatus == '30'}">     
                                       	<%--回复--%>
										<kmss:auth
											requestURL="/km/forum/km_forum/kmForumPost.do?method=reply&fdForumId=${topic.kmForumCategory.fdId}"
											requestMethod="GET">
											<em>|</em>
											<a title="${lfn:message('km-forum:kmForumCategory.fdPostCount')}" href="javascript:replyOperation('${topic.kmForumCategory.fdId}','${topic.fdId}','${post.fdId}');">
											     <bean:message bundle="km-forum" key="kmForumCategory.fdPostCount" />
										    </a>
                                        </kmss:auth>
                                        <%--编辑--%>
                                        <kmss:auth
											requestURL="/km/forum/km_forum/kmForumPost.do?method=edit&fdId=${post.fdId}"
											requestMethod="GET">
											<em>|</em>
											<a title="${lfn:message('km-forum:kmForumPost.button.edit')}" href="javascript:editOperation('${topic.kmForumCategory.fdId}','${topic.fdId}','${post.fdId}');">
											      <bean:message bundle="km-forum" key="kmForumPost.button.edit" /> </a>
						 	            </kmss:auth>
						 	       </c:if>     
						 	           <kmss:auth
											requestURL="/km/forum/km_forum/kmForumPost.do?method=delete&fdId=${post.fdId}"
											requestMethod="GET">
											<em>|</em>
									    	<a title="${lfn:message('button.delete')}" href="javascript:deleteOperation('${post.fdId}');">
											     <bean:message key="button.delete" />
											</a>
									  </kmss:auth>
                                    </div>
                                </div>
                                <%--楼层显示--%>
                             <c:choose>
                                <c:when test="${post.fdFloor==2}"><span class="floor_numL floor_s"></c:when>
                                <c:when test="${post.fdFloor==3}"><span class="floor_numL floor_b"></c:when>
                                <c:when test="${post.fdFloor==4}"><span class="floor_numL floor_d"></c:when>
                                <c:otherwise><span class="floor_numL floor_o"></c:otherwise>
                             </c:choose>   
                                      <span class="floor_numR">
		                                           <c:choose>
						                                <c:when test="${post.fdFloor==2}"> <span class="floor_numC num_s"> <bean:message bundle="km-forum" key="kmForumPost.fdFloor.shafa" /></c:when>
						                                <c:when test="${post.fdFloor==3}"> <span class="floor_numC num_b"> <bean:message bundle="km-forum" key="kmForumPost.fdFloor.bandeng" /></c:when>
						                                <c:when test="${post.fdFloor==4}"> <span class="floor_numC num_d"> <bean:message bundle="km-forum" key="kmForumPost.fdFloor.diban" /></c:when>
						                                <c:otherwise>  <span class="floor_numC num_o"> <bean:message bundle="km-forum" key="kmForumPost.floor.title" arg0="${post.fdFloor-1}" /></c:otherwise>
						                            </c:choose>   
		                                      </span>
                                      </span>
                                </span>
                            </td>
                        </tr>
                      </c:forEach>
                    </table>
                    <list:paging></list:paging>	 
                </div>
         </c:if>
             <!-- 评论帖子 结束 -->
            </div>
            <!-- 帖子内容 结束 -->
            <!-- 分页信息-->
            <input type="hidden" id="currPage" name="currPage" value="${queryPage.pageno}">
			<input type="hidden" id="currRowsize" name="currRowsize" value="10">
			<input type="hidden" id="currMainId" name="currMainId" value="${param.mainId}">
		    <input type="hidden" id="totalrows" name="totalrows" value="${queryPage.totalrows}">
			<script>
		    LUI.ready(function(){
					seajs.use('lui/topic',function(topic){
						var evt = {
							    	page: {currentPage:"${queryPage.pageno}", pageSize:"${queryPage.rowsize}", totalSize:"${queryPage.totalrows}"}
					            	   }
							    topic.publish('list.changed',evt);
						        topic.subscribe('paging.changed',function(evt){
							    var  arr = evt.page;
							    var pageno=arr[0].value;
							    var rowsize=arr[1].value;
							    var type = "${param.type}";
							    var url="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${param.fdTopicId}&pageno="+pageno+"&rowsize="+rowsize+"&sortType=asc";
								if(type == "onlyViewPoster"){
									url="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${param.fdTopicId}&fdPosterId=${param.fdPosterId}&type=onlyViewPoster&pageno="+pageno+"&rowsize="+rowsize+"&sortType=asc";
								 }
							    window.location.href =url;
					         	 });
						});
				})
				</script>
		            
            <!-- 快速回帖 开始 -->
          		<c:if test="${topic.fdStatus == '30'}">
					<kmss:auth
						requestURL="/km/forum/km_forum/kmForumPost.do?method=reply&fdForumId=${topic.kmForumCategory.fdId}"
						requestMethod="GET">
			                <iframe style="margin-bottom: -4px;border-top:6px solid #e9e9e9 " id="quickReplyContent" src="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=quickReply&fdForumId=${topic.kmForumCategory.fdId}&fdTopicId=${topic.fdId}"
										width="100%" height="auto" frameborder=0 scrolling=no> 
						    </iframe>
				    </kmss:auth>
			    </c:if>
            </div>
            <!-- 快速回帖 结束 -->
        </div>
</html:form>
	</template:replace> 
</template:include>