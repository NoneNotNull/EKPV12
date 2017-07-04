<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumPost"%>
<%@ page import="com.landray.kmss.km.forum.utils.ForumStringUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@ page import="com.sunbor.web.tag.Page"%>
	  <link rel="Stylesheet" href="../resource/css/work_comm.css" />
       <style>body{background-color: #fff}</style>
       <script type="text/javascript">
         Com_IncludeFile("jquery.js");
       </script>
       <script>
	   $(document).ready(function(){
	   var totalRows="${queryPage.totalrows}";
	  if(totalRows>0){
			doZipImg();
			doZipTable();
	  } 
	});

	function fdTime(fdTime){
		var x = fdTime.lastIndexOf(':');
		var value = fdTime.substring(0, x);
		return value;
	}

	function getObjectWidth(obj){
		var clientWidth=obj.offsetWidth;
		if(clientWidth==null || clientWidth==0)
			clientWidth=obj.clientWidth?obj.clientWidth:clientWidth;
		return clientWidth;
	}
	
	/*
	 *  编写图片处理函数,在页面加载完之后对大图片进行压缩
	 */
	 function doZipImg(){
		$("div[ref='fdContent']").find("img").each(function (){
			var width=$(this).width();
			var height=$(this).height();
			if(width>200) {
				var tempHeight = getObjectWidth(document.body)*0.8;
			  $(this).width(getObjectWidth(document.body)*0.8);
			   $(this).height(Math.round(height*tempHeight/width));
			
			}
		});
	}
	 function doZipTable(){
	 $("div[ref='fdContent']").find("table").each(function(){
			var width=$(this).width();
			var height=$(this).height();
			if(width>200){
				var tempHeight = getObjectWidth(document.body)*0.8;
				$(this).width(getObjectWidth(document.body)*0.8);
				 $(this).height(Math.round(height*tempHeight/width));
			  }		
		});
	 }

</script>
<c:if test="${queryPage.totalrows==0}">
<div id="content" style="background: #fff;">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</div>
</c:if>
<c:if test="${KMSS_PDA_ISAPP!='1'}">
	<c:choose>
	<c:when test="${sessionScope['S_CurModule']!=null}">
		<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
			<c:param name="fdNeedReturn" value="true"/>
			<c:param name="fdModuleName" value="${sessionScope['S_CurModuleName']}"/>
			<c:param name="fdModuleId" value="${sessionScope['S_CurModule']}"/>
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
				<c:param name="fdNeedHome" value="true"/>
		</c:import>
	</c:otherwise>
	</c:choose>
</c:if>
<c:if test="${queryPage.totalrows>0}">
          <div class="pages">
			<table width="100%">
				<tr>
					<td><span class="postPages"> <sunbor:page
						name="queryPage" pagenoText="pagenoText2" pageListSize="10"
						pageListSplit="">
						<sunbor:leftPaging>
							<b>&lt;<bean:message key="page.thePrev" /></b>
						</sunbor:leftPaging>
										{11}
										<sunbor:rightPaging>
							<b><bean:message key="page.theNext" />&gt;</b>
						</sunbor:rightPaging>
						<%
							if (((Page) request.getAttribute("queryPage"))
												.getTotal() > 1) {
						%>
						<%
							}
						%>
					</sunbor:page> </span></td>
				</tr>
			</table>
		  </div>
		  <p style="font-weight: bold;padding-left: 10px;padding-right: 10px;font-size:16px"><c:out value="${topic.docSubject}"/></p>
          <div class="discuss" id="con_one_1">
              <dl class="discuss_dl">
                 <c:forEach items="${queryPage.list}" var="reply" varStatus="varS">
                   <c:set var="post" value="${reply}" scope="request" />
                   <c:set var="forumScore" value="${post.posterScore}" scope="request" />
			      <dd class="clrfix">
					    <!-- 头像 -->
					     <c:if test="${post.fdFloor==1}">
					      <div class="left_first">
					       	  <c:if test="${post.fdIsAnonymous == true}">  <%--匿名--%>
                                    <img src="${KMSS_Parameter_ContextPath}/km/forum/resource/images/user_anon_img.png" border="0" width="35" height="35"/>
                      		  </c:if>
                      		  <c:if test="${post.fdIsAnonymous == false}"> 
                             	     <img src="${KMSS_Parameter_ContextPath}sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${post.fdPoster.fdId}" border="0" width="35" height="35"/>
                      		  </c:if>
		                     </div>
		                      <div class="right_first">
		                            <!--显示楼层发表于-->
		                                <div class="p1">
		                                     <span class="firstfloor">楼主</span>
		                                     <span class="author">
		                                       <c:if test="${post.fdIsAnonymous==true}">
						                         <bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
					                           </c:if> 
					                           ${post.fdPoster.fdName}
					                          </span>
					                          <span class="date">
		                                        <script>document.write(fdTime('${post.docCreateTime}')); </script>
		                                      </span>
		                               <!-- 被修改时间 -->
			                               <c:if test="${post.fdIsAnonymous==false}">
					                             <c:if test="${!empty post.fdAlteror}">
						                              <span class="work_comm_Content">
												          <p class="last_eidt"> 
												               ${lfn:message('km-forum:kmForumPost.toolTip.finalBy')}<span style="width: 2px"></span>
												               <ui:person personId="${post.fdAlteror.fdId}" personName="${post.fdAlteror.fdName}"></ui:person>
												               ${lfn:message('km-forum:kmForumPost.toolTip.yu')}
								                               <kmss:showDate type="interval" value="${post.docAlterTime}" />   
								                               ${lfn:message('km-forum:kmForumPost.button.edit')}       
								                          </p>                         
						                               </span>
							                      </c:if>
							                        <%--兼容老数据--%>
												  <c:if test="${!empty post.fdNote && empty post.fdAlteror}">
				                                      <span class="work_comm_Content">
				                                          <p class="last_eidt">  <c:out value="${post.fdNote}"/></p>
									                  </span>
			                               	      </c:if>
				                            </c:if>
		                                </div>
		                          </div>
		                          <c:if test="${topic.fdStatus == '30'}">
		                           <div style="float:right;margin-right:6px" onclick="window.open('<c:url value="/km/forum/km_forum/kmForumPost.do"/>?method=quickReply&flag=pda&fdForumId=${param.fdForumId}&fdTopicId=${topic.fdId}','_self');"><img src="${KMSS_Parameter_ContextPath}km/forum/resource/images/reply.png"/></div>
		                          </c:if>
		                           <!--显示回复楼层内容-->
		                           <div style="width:90%;display:inline-block;padding-left:10px">
			                 		     <c:if test="${not empty post.fdQuoteMsg}">	                                
	                                                  <div>
	                                                    ${post.fdQuoteMsg}
	                                                  </div>
			                             </c:if>  
		                             	<div ref="fdContent" style="word-wrap:break-word;word-break:break-all">
		                                   &nbsp; ${post.docContent}
		                                </div>
		                                 <!--显示附件-->
		                                  <p class="attach">
		                                    <c:if test="${not empty post.attachmentForms.attachment.attachments}">   
		                                        <c:set var="replyForm" value="${reply}" scope="request"/>  
										          <c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
														<c:param name="fdKey" value="attachment"/>
														<c:param name="fdAttType" value="byte"/>
														<c:param name="fdModelId" value="${post.fdId }"/>
														<c:param name="formBeanName" value="replyForm"/>
														<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost"/>
														<c:param name="msgkey" value="附件"/>
												  </c:import>
											</c:if>
										 </p>
								  </div>
					     </c:if>
					    <c:if test="${post.fdFloor!=1}">
		                   <div class="left">
		                        <c:if test="${post.fdIsAnonymous == true}">  <%--匿名--%>
                                    <img src="${KMSS_Parameter_ContextPath}/km/forum/resource/images/user_anon_img.png" border="0" width="35" height="35"/>
                      		    </c:if>
                      		    <c:if test="${post.fdIsAnonymous == false}">
								   <img src="${ KMSS_Parameter_ContextPath }sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${post.fdPoster.fdId}" border="0" width="35" height="35"/>
		                         </c:if>
		                     </div>
		                      <div class="right">
		                            <!--显示楼层发表于-->
		                                <div class="p1">
		                                     <span class="floor">${post.fdFloor-1}${lfn:message('km-forum:kmForumPost.floor')}</span>
		                                     <span class="author">
		                                       <c:if test="${post.fdIsAnonymous==true}">
						                         <bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
					                           </c:if> 
					                           ${post.fdPoster.fdName}
					                          </span>
					                          <span class="date">
		                                        <script>document.write(fdTime('${post.docCreateTime}')); </script>
		                                      </span>
		                               <!-- 被修改时间 -->
			                               <c:if test="${post.fdIsAnonymous==false}">
					                              <c:if test="${!empty post.fdAlteror}">
						                              <span class="work_comm_Content">
												          <p class="last_eidt"> 
												               ${lfn:message('km-forum:kmForumPost.toolTip.finalBy')}<span style="width: 2px"></span>
												               <ui:person personId="${post.fdAlteror.fdId}" personName="${post.fdAlteror.fdName}"></ui:person>
												               ${lfn:message('km-forum:kmForumPost.toolTip.yu')}
								                               <kmss:showDate type="interval" value="${post.docAlterTime}" />   
								                               ${lfn:message('km-forum:kmForumPost.button.edit')}       
								                          </p>                         
						                               </span>
							                      </c:if>
							                        <%--兼容老数据--%>
												  <c:if test="${!empty post.fdNote && empty post.fdAlteror}">
				                                      <span class="work_comm_Content">
				                                          <p class="last_eidt">  <c:out value="${post.fdNote}"/></p>
									                  </span>
			                               	      </c:if>
				                            </c:if>
		                                </div>
		                                 <!--显示回复楼层内容
		                 		        <c:if test="${not empty post.fdQuoteMsg}">	                                  
                                                  <div class="quoteMsg">
                                                    ${post.fdQuoteMsg}
                                                  </div>
		                                 </c:if>  
		                                 -->
		                             <div class="p2" ref="fdContent" style="word-wrap:break-word;word-break:break-all">
		                                <!--新数据--> 
		                                <c:if test="${not empty post.fdParent}">
		                                    <div class="quoteMsg">
		                                          ${lfn:message('km-forum:kmForumPost.button.quote')}                                                                      
		                                          ${post.fdParent.fdPoster.fdName}${post.fdParent.fdFloor-1}
		                                          ${lfn:message('km-forum:kmForumPost.floor')}
		                                          &nbsp
		                                          ${lfn:message('km-forum:kmForumPost.floor')}
			                                      <span style="margin-left: -3px;margin-right:-5.5px"><kmss:showDate type="datetime" value="${post.fdParent.docCreateTime}" /></span>
			                                      ${lfn:message('km-forum:kmForumPost.fdQuoteMsg.post')}
				                            </div>
											<table width='98%' cellspacing='1' cellpadding='3' border='0' align='center'>
											    <tr>
											        <td class='quote'>
											    	   <p>${post.fdParent.docContent}</p>
												    </td>
												</tr>
											</table>
											<p>${post.docContent}</p>
		                                </c:if>
		                                <!--兼容老数据-->
		                                <c:if test="${empty post.fdParent}">
			                                <!--显示回复楼层内容-->
			                 		        <c:if test="${not empty post.fdQuoteMsg}">	                                  
	                                           <div class="quoteMsg">
	                                         	    <% KmForumPost post = (KmForumPost)request.getAttribute("post");
													   String fdQuoteMsg = post.getFdQuoteMsg();%>
													<%out.write(ForumStringUtil.getNewQuote(fdQuoteMsg));%>
	                                            </div>
			                                </c:if> 
			                                ${post.docContent}
		                                </c:if>
		                             </div>
		                             							  
		                                 <!--显示附件-->
		                                  <p class="attach">
		                                    <c:if test="${not empty post.attachmentForms.attachment.attachments}">   
		                                        <c:set var="replyForm" value="${reply}" scope="request"/>  
										          <c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
														<c:param name="fdKey" value="attachment"/>
														<c:param name="fdAttType" value="byte"/>
														<c:param name="fdModelId" value="${post.fdId }"/>
														<c:param name="formBeanName" value="replyForm"/>
														<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost"/>
														<c:param name="msgkey" value="附件"/>
												  </c:import>
											</c:if>
										 </p>
										 <div class="pda">
					                         <c:if test="${not empty post.fdPdaType  && post.fdPdaType != 10}">
					                            (<bean:message  bundle="sys-mobile" key="sysMobile.pda.comefrom.${post.fdPdaType}"/>)
					                          </c:if>
					                     </div>
		                          </div>
		                          <c:if test="${topic.fdStatus == '30'}">
		                                 <div style="float:right;cursor:pointer;;margin-right:6px" onclick="window.open('<c:url value="/km/forum/km_forum/kmForumPost.do"/>?method=quote&flag=pda&fdForumId=${param.fdForumId}&postId=${post.fdId}','_self');"><img src="${KMSS_Parameter_ContextPath}km/forum/resource/images/reply.png"/></div>
		                          </c:if>
		                        </c:if>
		                    </dd>
		            </c:forEach>
		      </dl>
    </div>
    <div class="pages">
		<table width="100%">
			<tr>
				<td><span class="postPages"> <sunbor:page
					name="queryPage" pagenoText="pagenoText2" pageListSize="10"
					pageListSplit="">
					<sunbor:leftPaging>
						<b>&lt;<bean:message key="page.thePrev" /></b>
					</sunbor:leftPaging>
									{11}
									<sunbor:rightPaging>
						<b><bean:message key="page.theNext" />&gt;</b>
					</sunbor:rightPaging>
					<%
						if (((Page) request.getAttribute("queryPage"))
											.getTotal() > 1) {
					%>
					<%
						}
					%>
				</sunbor:page> </span></td>
			</tr>
		</table>
	</div>
</c:if>