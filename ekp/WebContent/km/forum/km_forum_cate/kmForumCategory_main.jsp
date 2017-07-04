<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumTopic"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumPost"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumCategory"%>
<%@ page import="java.util.Date"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<%@page import="org.springframework.web.context.request.RequestScope"%><template:include ref="default.view" sidebar="no" width="${param.type=='criteria'?'100%':'980px'}">
	<template:replace name="content"> 
	   <script type="text/javascript">
		seajs.use(['lui/dialog'], function(dialog) {
	    	LUI.ready( function() {
	    		dyniFrameSize();
			    });	

		    window.dyniFrameSize=function() {
				 try {
						// 调整高度
						var arguObj = document.getElementById("main_body");
						if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
								window.frameElement.style.height = (arguObj.offsetHeight+25) + "px";
						}
					} catch(e) {
				  }
				};
            //隐藏和显示操作       
			window.showAndHide=function(){
               var classValue = $("#showOperation").attr("class");
               if(classValue == "list_up_icon"){
            	   $('#infoDiv').slideUp(1,dyniFrameSize);
            	   $("#showOperation").attr("class","list_down_icon");
                }else{
                   $('#infoDiv').slideDown(1,dyniFrameSize);
                   $("#showOperation").attr("class","list_up_icon");
                }
		    };

		    window.openURL = function(url){
                window.parent.location.href=url;
			    };
		    //显示更多数据
		    window.showMore = function(){
               var url = window.location.href;
                   url +="&isShowAll=true";
                   window.open(url,"_self");
			    };
		  });
		</script>
		    <link href="${LUI_ContextPath}/km/forum/resource/css/forum.css" rel="stylesheet" type="text/css" />
<html:form action="/km/forum/km_forum_cate/kmForumCategory.do" style="background:#f7f6f6">
<c:if test="${not empty kmForumCategorys}">
    <div class="forum_home_content" style="padding:${param.type=='criteria'?'0px':'22px 0px'}" id="main_body">
      <c:forEach var="forumParentCategory" items="${kmForumCategorys}" varStatus="pIndx">
        <%-- 文化生活区 开始 --%>
        <div class="lui_common_list_box">
            <%-- 主版块显示开始 --%>
            <div class="lui_common_list_4_header_left">
                <div class="lui_common_list_4_header_right">
                    <div class="lui_common_list_4_header_centre clrfix">
                        <h4>
                           <a href="javascript:openURL('${LUI_ContextPath}/km/forum/indexCriteria.jsp?categoryId=${forumParentCategory.fdId}');">
							   ${forumParentCategory.fdName}						   
						    </a>
                       </h4>
                    <c:if test="${param.type=='criteria'}">
                        <%--显示隐藏图标--%>
	                   <div class="list_up_icon" onclick="showAndHide();" id="showOperation">
	                   </div>
	                </c:if>
                    </div>
                </div>
            </div>
            <%-- 主版块显示结束 --%>
            <div class="lui_common_list_main_body" id="infoDiv">
                <div class="lui_common_list_4_content_left">
                    <div class="lui_common_list_4_content_right">
                        <div class="lui_common_list_4_content_centre">
                            <div class="forum_list_w">
                                <%--筛选器显示主版块描述信息 --%>
	                            <c:if test="${param.type=='criteria'}">
	                               <div class="quote_w">
	                                   <c:if test="${forumParentCategory.fdDescription!='' && not empty forumParentCategory.fdDescription}">
		                                    <em class="quoteL"></em>${forumParentCategory.fdDescription}
		                                    <em class="quoteR"></em>
	                                    </c:if>
	                                </div>
	                            </c:if>
                                <table>
                                  <%--筛选器显示主版块主题信息 --%>
                                  <c:if test="${param.type=='criteria'}">
	                                  <tr class="header">
	                                        <td colspan="2">
	                                            <%--今日主题回帖数 --%>
	                                            <span>${lfn:message('km-forum:kmForumPost.today')}：${topicCountToday}</span><em>|</em><span>${lfn:message('km-forum:kmForumPost.topic')}：${topicCount}</span><em>|</em><span>${lfn:message('km-forum:kmForumPost.replyCount')}：${replyCount}</span>
	                                        </td>
	                                        <td class="modlue_author">
			                                    <%--版主 --%>
	                                            <c:if test="${not empty forumParentCategory.authAllEditors }">
												     <bean:message bundle="km-forum" key="kmForumCategory.forumManagers" />:
													 <c:forEach items="${forumParentCategory.authAllEditors}" var="forumCategor" varStatus="indx">
													 <c:if test="${indx.index>0}">;</c:if>
														  <ui:person personId="${forumCategor.fdId}" personName="${forumCategor.fdName}"></ui:person>
													 </c:forEach>
												</c:if>                                     
	                                        </td>
	                                  </tr>
                                  </c:if>
                                    <%-- 子版块显示开始 --%>
                                 <c:forEach var="forumCategory" items="${forumParentCategory.fdChildren}" varStatus="indx" begin="0"  end="${param.type=='criteria' && empty param.isShowAll && rowSize>3?2:rowSize}">
	                                    <tr>
	                                        <td class="th1">
	                                            <div class="module_logo">
	                                               <a href="javascript:openURL('${LUI_ContextPath}/km/forum/indexCriteria.jsp?categoryId=${forumCategory.fdId}');">
	                                                  <img src="${LUI_ContextPath}/km/forum/resource/images/forum_list_bg.png">
	                                               </a>
	                                            </div>
	                                            <div class="module_basicInfo">
	                                                <%-- 标题--%>
	                                                <h2>
													   <a href="javascript:openURL('${LUI_ContextPath}/km/forum/indexCriteria.jsp?categoryId=${forumCategory.fdId}');">
															${forumCategory.fdName}
													   </a>
													   <%-- 子版块今日主题数--%>
													   <c:if test="${not empty sumCateTopicInfoMap[forumCategory.fdId]}">
													 	  <span class="count">${lfn:message("km-forum:kmForumPost.today")}:<em>${sumCateTopicInfoMap[forumCategory.fdId]}</em></span>
													   </c:if>
												    </h2>
												    <%-- 描述--%>
	                                                <p class="abstract">
	                                                 ${forumCategory.fdDescription}
	                                                </p>
	                                                <%-- 版主--%>
	                                                <p class="moderator">
	                                                   <c:if test="${not empty forumCategory.authAllEditors }">
		                                                    ${lfn:message("km-forum:kmForumCategory.forumManagers")}：
		                                                    <em><c:forEach items="${forumCategory.authAllEditors}" var="forumCategor" varStatus="indx">
																	<c:if test="${indx.index>0}">;</c:if>
																	<ui:person personId="${forumCategor.fdId}" personName="${forumCategor.fdName}"></ui:person>
																</c:forEach>
														   </em>
													   </c:if>  
	                                                </p>
	                                            </div>
	                                        </td>
	                                        <td class="th2">
	                                            <c:if test="${not empty forumCategory.fdTopicCount}">
										            <c:set var="fdTopicCount" value="${forumCategory.fdTopicCount}" scope="request" />
										               <%int fdTopicCount = Integer.parseInt(request.getAttribute("fdTopicCount").toString());
										                    String fdTopicCountVal = "";
										                    String local = request.getAttribute("KMSS_Parameter_Lang").toString();
										                    if(fdTopicCount>10000){ 
										                    	  if(local.equals("zh-cn")){
										                    		  fdTopicCountVal = String.valueOf(fdTopicCount/10000)+"万";
										                    	  }else if(local.equals("en-us")){
										                    		  fdTopicCountVal = String.valueOf(fdTopicCount/1000)+"THS"; 
										                    	  }
										                       }
										                    else{ fdTopicCountVal=String.valueOf(fdTopicCount); }
										                    request.setAttribute("fdTopicCountVal",fdTopicCountVal);
										                %>
										        </c:if>
										        <c:if test="${not empty forumCategory.fdPostCount}">
										        	 <c:set var="fdPostCount" scope="request" value="${forumCategory.fdPostCount - forumCategory.fdTopicCount}"></c:set>
										              <%int fdPostCount = Integer.parseInt(request.getAttribute("fdPostCount").toString());
										                         String fdPostCountVal = "";
										                         String local = request.getAttribute("KMSS_Parameter_Lang").toString();
											                     if(fdPostCount>10000){
											                    	  if(local.equals("zh-cn")){
											                    	     fdPostCountVal = String.valueOf(fdPostCount/10000)+"万";
											                    	  }else if(local.equals("en-us")){
											                    		 fdPostCountVal = String.valueOf(fdPostCount/1000)+"THS";
											                    	  }
											                         }else if(fdPostCount<0){  fdPostCountVal = "0";fdPostCount = 0;
										                             }else{  fdPostCountVal = String.valueOf(fdPostCount);
										                             }
											                     request.setAttribute("fdPostCountVal",fdPostCountVal);
													   %>
										        </c:if>
	                                            <div class="subject_reply_num" title="${lfn:message('km-forum:kmForumPost.count.post')}:${empty fdTopicCount?'0':fdTopicCount}，${lfn:message('km-forum:kmForumPost.count.reply')}:${fdPostCount>=0?fdPostCount:'0'}">
										           <%-- 发帖数--%>
													<c:if test="${empty forumCategory.fdTopicCount}">0</c:if>
										            <c:if test="${not empty forumCategory.fdTopicCount}">
										                  ${fdTopicCountVal}
										            </c:if>
													 /
													<%-- 回帖数--%>
									                <c:if test="${empty forumCategory.fdPostCount}">0</c:if>
													<c:if test="${not empty forumCategory.fdPostCount}">
													      ${fdPostCountVal}
													</c:if>
									           </div>
	                                        </td>
	                                        <td class="th3">
	                                            <div class="last_reply">
	                                              <%-- 最新帖子显示--%>
	                                                <c:if test="${forumCategory.fdTopicCount ==0 || empty forumCategory.fdTopicCount}">--</c:if>
	                                                <c:if test="${forumCategory.fdTopicCount > 0}">
	                                               	  <c:set value="${forumCategory}" var="forumCategory" scope="request"/>
	                                                  <%KmForumCategory sumCategory = (KmForumCategory)request.getAttribute("forumCategory");
		                            		    		KmForumTopic kmForumTopic = (KmForumTopic) sumCategory.getForumTopics().get(0);
		                            		    		request.setAttribute("post",kmForumTopic
		                            							.getForumPosts().get(0));
		                            		    		%>
														<c:set value="${post.docSubject}" var="docSubject" />
														<c:set value="${post.kmForumTopic.kmForumCategory.fdId}" var="fdForumId" />
														<c:set value="${post.kmForumTopic.fdId}" var="fdTopicId" />
															<%	
																KmForumPost kmForumPost = (KmForumPost) request.getAttribute("post");
																String fdValue = kmForumPost.getDocSubject();
																if(fdValue == null){
																	pageContext.setAttribute("fdValue","");
																}else{
																	pageContext.setAttribute("fdValue",fdValue);
																}
															%>
		                                                <div class="author_img">
		                                                <%-- 最新回复--%>
		                                                </div>
		                                                   <%-- 头像--%>
									                       <c:if test="${!empty post.fdPoster}">
														        <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${post.fdPoster.fdId}"/>
														   </c:if>
										                   <c:if test="${empty post.fdPoster}">
																 <img src="${ LUI_ContextPath }/km/forum/resource/images/user_anon_img.png"/>
														   </c:if>
		                                                <p class="p1">
		                                                     <%-- 标题--%>
				                                             <a href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=${fdForumId}&fdTopicId=${fdTopicId}" title="${post.kmForumTopic.docSubject}" target="_blank">
															   <span class="textEllipsis" style="width: 260px">  <c:out value="${fdValue}" /></span>
														     </a> 
		                                                 </p>
		                                                <p class="p2">
		                                                    <%--人名--%>
		                                                    by
									                       <c:if test="${!empty post.fdPoster}">
														        <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${post.fdPoster.fdId}"/>
														        <ui:person personId="${post.fdPoster.fdId}" personName="${post.fdPoster.fdName}"></ui:person>
															 </c:if>
										                     <c:if test="${empty post.fdPoster}">
																<bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
									                       </c:if>,
			                                                  <span>
			                                                        <%-- 时间--%>
			                                                        <c:if test="${!empty post.docAlterTime}">
			                                                            <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${post.docAlterTime}" />
																	</c:if>
																	<c:if test="${empty post.docAlterTime}">
			                                                            <kmss:showDate type="datetime" isInterval="true" showTitle="true" value="${post.docCreateTime}" />
																	</c:if>
	                                                         </span>
                                                         </p>
                                                     </c:if>
	                                            </div>
	                                        </td>
	                                    </tr>
                                  </c:forEach>
                                  <%-- 子版块显示结束 --%>
                                </table>
                            </div>
                        </div>
                      <%-- 加载更多数据--%>
                      <c:if test="${param.type=='criteria'&& empty param.isShowAll && rowSize>3}">
                        <div class="lui_common_loadModulesM" onclick="showMore();">
						     <span>${lfn:message('km-forum:kmForumPost.loadMoreData')}</span><a title="${lfn:message('km-forum:kmForumPost.loadMoreData')}" class="lui_common_loadPic"></a>
						</div>
				     </c:if>
                    </div>
                </div>
            </div>
        </div>
        <!-- 文化生活区 结束 -->
       </c:forEach>
    </div>
</c:if>
</html:form>
</template:replace>
</template:include>