<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumTopic"%>
<%@ page import="java.util.Date"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>

<script type="text/javascript">
Com_IncludeFile("forum_new.css", "style/"+Com_Parameter.Style+"/forum/");
Com_IncludeFile("list_page.js", "style/"+Com_Parameter.Style+"/list/");
</script>
</head>
<body>
<html:form action="/km/forum/km_forum_cate/kmForumCategory.do">

<c:if test="${empty kmForumCategorys}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
 
<c:if test="${not empty kmForumCategorys}">
	<div class="container">
		<div class="header"></div>
	    <div class="forumTitle">
	    	<table width="100%">
				<tr>
					<th width="8%"></th>
					<th width="35%" align="left" class="font_black_normal">
						<bean:message bundle="km-forum" key="kmForumTopic.fdForumId" />
					</th>
					<th width="17%" align="center" class="font_black_normal">
						<bean:message bundle="km-forum" key="kmForumTopic.docSubject" />/
						<bean:message bundle="km-forum" key="kmForumPost.button.reply" />
					</th>
					<th width="50%" align="left" class="font_black_normal">
						<bean:message bundle="km-forum" key="kmForumCategory.lastPost" />
					</th>
				</tr>
	    	</table>
	    </div>
		<c:forEach var="forumParentCategory" items="${kmForumCategorys}" varStatus="pIndx">
			<div class="forumSubject">
				<span>
					<!-- 上级板块标题 -->
					::<a title="${forumParentCategory.fdDescription}" href="#"
						onclick="Com_OpenWindow('<c:out value="${KMSS_Parameter_ContextPath}km/forum/km_forum/kmForumTopic.do?method=list&fdForumId=${forumParentCategory.fdId}"/>&s_path='+encodeURIComponent('${forumParentCategory.fdName}'),'3')">
						&nbsp;${forumParentCategory.fdName}&nbsp;</a>::
				</span><br />
				<!-- 上级板块描述 
				${forumParentCategory.fdDescription}
				-->
				<!-- 上级板块版主 -->
				<font class="font_blue">
					<c:if test="${not empty forumParentCategory.authAllEditors }">
						<bean:message bundle="km-forum" key="kmForumCategory.forumManagers" />:
						<c:forEach items="${forumParentCategory.authAllEditors}" var="forumCategor" varStatus="indx">
							<c:if test="${indx.index>0}">;</c:if>
							<c:out value="${forumCategor.fdName}" />
						</c:forEach>
					</c:if>
				</font>
			</div>
			<c:forEach var="forumCategory" items="${forumParentCategory.fdChildren}" varStatus="indx">
				<c:if test="${forumCategory.fdTopicCount>0}">
					<c:forEach items="${forumCategory.forumTopics}" var="forumTopics" varStatus="status">
						<c:if test="${isDoing != 1&&(forumTopics.fdStatus=='30' || forumTopics.fdStatus==null)}">
							<c:set var="isDoing" value="1"/>
							<c:set var="lastPostTime" value="${forumTopics.fdLastPostTime }" scope="request" />
						</c:if>
					</c:forEach>
				</c:if>
				<%
					String icon = "is_old_post";
				%>
				<c:if test="${lastPostTime != '' }">
				<%
					if (request.getAttribute("lastPostTime") != null) {
						if ((new Date()).getTime()
								- ((Date) request.getAttribute("lastPostTime"))
										.getTime() - 1 * 24 * 60 * 60 * 1000 < 0) {
							icon = "is_new_post";
						}
					}
				%>
				</c:if>
				<c:set var="lastPostTime" value="" scope="request" />
				<div class="forumList">
					<table width="100%">
						<tr>
							<td rowspan="3" width="8%" class="forumPic">
								<img src="${KMSS_Parameter_StylePath}forum/<%=icon%>.gif" />
							</td>
							<td width="35%">
								<!-- 板块标题 -->
									<font class="font_black">
									<a href="#"
										onclick="Com_OpenWindow('<c:out value="${KMSS_Parameter_ContextPath}km/forum/km_forum/kmForumTopic.do?method=list&fdForumId=${forumCategory.fdId}"/>&s_path='+encodeURIComponent('${forumCategory.fdName}'),'3')">
										${forumCategory.fdName}</a></font>
								<!-- 发帖  -->
								<kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&fdForumId=${forumCategory.fdId}" requestMethod="GET">
									<a class="font_orange" href="#"
										onclick="Com_OpenWindow('<c:out value="${KMSS_Parameter_ContextPath}km/forum/km_forum/kmForumPost.do?method=add&fdForumId=${forumCategory.fdId}" />');">
										<bean:message bundle="km-forum" key="kmForum.button.publish" />
									</a>
								</kmss:auth>
								<br />
								<!-- 板块描述 -->
								${forumCategory.fdDescription}<br/>
								<!-- 版主 -->
								<c:if test="${not empty forumCategory.authAllEditors }">
								<font class="font_blue">
									<bean:message bundle="km-forum" key="kmForumCategory.forumManagers" />: 
										<c:forEach items="${forumCategory.authAllEditors}" var="forumCategor" varStatus="indx">
											<c:if test="${indx.index>0}">;</c:if>
											<c:out value="${forumCategor.fdName}" /> 
										</c:forEach>
									</font>
								</c:if>
								
							</td>
							<td width="17%">
								<div align="center">
									<!-- 主题数 -->
									<font class="font_blue">
										<c:if test="${empty forumCategory.fdTopicCount}">0</c:if>
										<c:if test="${not empty forumCategory.fdTopicCount}">${forumCategory.fdTopicCount}</c:if>
									</font>/
									<!-- 回复数 -->
									<c:if test="${empty forumCategory.fdPostCount}">0</c:if>
									<c:if test="${not empty forumCategory.fdPostCount}">
									<c:if test="${forumCategory.fdPostCount - forumCategory.fdTopicCount>=0}">
									${forumCategory.fdPostCount - forumCategory.fdTopicCount}
									</c:if>
									<c:if test="${forumCategory.fdPostCount - forumCategory.fdTopicCount<0}">
									0
									</c:if>
									</c:if>
								</div>
							</td>
							<td width="50%">
								<!-- 最新发表 -->
								<c:if test="${empty forumCategory.fdTopicCount}">-</c:if>
								<c:if test="${forumCategory.fdTopicCount>0}">
									<c:forEach items="${forumCategory.forumTopics}" var="forumTopics" varStatus="status">
										<c:set value="${forumTopics.docSubject}" var="docSubject" />
										<c:set value="${forumTopics.kmForumCategory.fdId}" var="fdForumId" />
										<c:set value="${forumTopics.fdId}" var="fdTopicId" />
										<c:if test="${isDoing != 2 && (forumTopics.fdStatus=='30'|| forumTopics.fdStatus=='40' || forumTopics.fdStatus==null)}">
											<c:set var="isDoing" value="2"/>
											<%	
												KmForumTopic kmForumTopic = (KmForumTopic) pageContext.getAttribute("forumTopics");
												String fdValue = kmForumTopic.getDocSubject();
												if(fdValue == null)
													pageContext.setAttribute("fdValue","");
												if(fdValue!=null && fdValue.length()>28){
													String value = null;
													value = fdValue.substring(0,28)+"...";
													pageContext.setAttribute("fdValue",value);
												}else{
													pageContext.setAttribute("fdValue",fdValue);
												}
											%>
											<!-- 标题 -->
											<a href="#"
												onclick="Com_OpenWindow('<c:out value="${KMSS_Parameter_ContextPath}km/forum/km_forum/kmForumPost.do?method=view&fdForumId=${fdForumId}&fdTopicId=${fdTopicId}"/>','_blank')">
												<c:out value="${fdValue}" />
											</a>
											<br>
											<!-- 最后回复人 -->
											<c:if test="${!empty forumTopics.fdLastPosterName}">
												<c:if test="${forumTopics.fdLastPosterName eq anonymousTitle}">
													(<c:out value="${forumTopics.fdLastPosterName}" />)
												</c:if>
												<c:if test="${forumTopics.fdLastPosterName ne anonymousTitle}">
													(<a href="#"
														onclick="Com_OpenWindow('<c:out value="${KMSS_Parameter_ContextPath}km/forum/km_forum_score/kmForumScore.do?method=view&fdId=${forumTopics.fdLastPoster.fdId}"/>','_blank')">
													<c:out value="${forumTopics.fdLastPosterName}" /></a>)
												</c:if>
											</c:if>
											<c:if test="${empty forumTopics.fdLastPosterName}">
												<c:if test="${forumTopics.fdIsAnonymous == false}">
													(<a href="#"
														onclick="Com_OpenWindow('<c:out value="${KMSS_Parameter_ContextPath}km/forum/km_forum_score/kmForumScore.do?method=view&fdId=${forumTopics.fdPoster.fdId}"/>','_blank')">
													<c:out value="${forumTopics.fdPoster.fdName}" /></a>)
												</c:if>
												<c:if test="${forumTopics.fdIsAnonymous == true}">
													(<bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title"/>)
												</c:if>
											</c:if>
											<!-- 最后回复时间 -->
											<c:if test="${!empty forumTopics.fdLastPosterName}">
												<kmss:showDate value="${forumTopics.fdLastPostTime}" type="datetime"/>	
											</c:if>
											<c:if test="${empty forumTopics.fdLastPosterName}">
												<kmss:showDate value="${forumTopics.docAlterTime}" type="datetime"/>		
											</c:if>
										</c:if>
									</c:forEach>
								</c:if>
							</td>
						</tr>
					</table>
				</div>
			</c:forEach>
		</c:forEach>
		<div class="footer"></div>
	</div>
</c:if>
</html:form>
</body>
</html>