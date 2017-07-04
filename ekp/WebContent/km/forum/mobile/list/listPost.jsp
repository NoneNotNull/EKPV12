<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@page import="com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumPost"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumScore"%>
<%@page import="com.landray.kmss.km.forum.service.IKmForumPostService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="java.util.List"%>
<%
	KmForumConfig forumConfig = new KmForumConfig();
	IKmForumPostService postService=(IKmForumPostService) SpringBeanUtil.getBean("kmForumPostService");
	ISysAttMainCoreInnerService sysAttMainCoreInnerService=(ISysAttMainCoreInnerService)SpringBeanUtil.getBean("sysAttMainService");
%>


<list:data>
	<list:data-columns var="post" list="${queryPage.list}" varIndex="rIndex" mobile="true">
		<%
			KmForumPost forumPost = (KmForumPost)pageContext.getAttribute("post");
			List attlist=sysAttMainCoreInnerService.findByModelKey(ModelUtil.getModelClassName(forumPost),
					forumPost.getFdId(),"attachment");
			if(attlist!=null && !attlist.isEmpty()){
				pageContext.setAttribute("hasAtt","1");
			}else{
				pageContext.setAttribute("hasAtt","0");
			}
			if (!forumPost.getFdIsAnonymous()) {
				forumPost.setPosterScore((KmForumScore) postService.findByPrimaryKey(
								forumPost.getFdPoster().getFdId(),
								KmForumScore.class, false));
			}
		%>
		<list:data-column col="rowIndex">
			<c:out value="${ rIndex }"/>
		</list:data-column>
		<list:data-column col="fdId">
			<c:out value="${post.fdId}"/>
		</list:data-column>
		<list:data-column col="icon" escape="false">
			<c:if test="${post.fdIsAnonymous == false}">
				 <person:headimageUrl personId="${kmForumPostForm.fdPosterId}"/>
      		</c:if>
      		<c:if test="${post.fdIsAnonymous == true}">
			    ${LUI_ContextPath}/km/forum/resource/images/user_anon_img.png
      		</c:if>
		</list:data-column>
		
		<list:data-column col="creator">
			<c:if test="${post.fdIsAnonymous == false}">
				 ${post.fdPoster.fdName}
      		</c:if>
      		<c:if test="${post.fdIsAnonymous == true}">
			    <bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
      		</c:if>
		</list:data-column>
		
		<c:if test="${post.fdIsAnonymous == false}">
			<list:data-column col="score">
				<c:set var="score" value="${post.posterScore.fdScore}"/>
				<%
					forumConfig.getLevelByScore( (Integer)pageContext.getAttribute("score"));
					String level = forumConfig.getLevelIcon();
				%>
				LV.<%=level%>
			</list:data-column>
			<c:if test="${forumTopic.fdIsAnonymous == false}">
				<list:data-column col="extendInfo">
					<c:if test="${post.fdPoster.fdId == forumTopic.fdPoster.fdId }">楼主	</c:if>
				</list:data-column>
			</c:if>
		</c:if>
		<list:data-column col="created">
			<kmss:showDate value="${post.docCreateTime}" isInterval="true" type="datetime">
			</kmss:showDate> 
		</list:data-column>
		
		<c:if test="${not empty post.fdPdaType && post.fdPdaType!=10}">
			<list:data-column col="from">
				   <bean:message  bundle="km-forum" key="kmForumPost.from.title"/><bean:message  bundle="sys-mobile" key="sysMobile.pda.comefrom.${post.fdPdaType}"/>
			</list:data-column>
        </c:if>
		
		<list:data-column col="floor">
			${post.fdFloor}
		</list:data-column>
		
		<c:if test="${forumTopic.fdStatus!='40' && post.fdFloor != 1}">
				<list:data-column col="optFlag">
					true
				</list:data-column>
		</c:if>
		<list:data-column col="content" escape="false">
				${post.docContent}
		</list:data-column>
		
		<c:if test="${post.fdParent!=null }">
			<list:data-column col="parentId">
				${post.fdParent.fdId}
			</list:data-column>
			<list:data-column col="parentPoster">
				<c:if test="${ post.fdParent.fdIsAnonymous == false}">
			 		${post.fdParent.fdPoster.fdName}
			 	</c:if>
			 	<c:if test="${ post.fdParent.fdIsAnonymous == true}">
			 		<bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title" />
			 	</c:if>
			</list:data-column>
			<list:data-column col="parentCreated">
				<kmss:showDate value="${post.fdParent.docCreateTime}" isInterval="true" type="datetime">
				</kmss:showDate> 
			</list:data-column>
			<list:data-column col="parentSummary" escape="false">
				<c:choose>
					<c:when test="${post.fdParent.docSummary!=null}">
						<c:out value="${post.fdParent.docSummary}"/>
					</c:when>
					<c:otherwise>
						<div class="muiFieldRtf">${post.fdParent.docContent}</div>
					</c:otherwise>
				</c:choose> 
			</list:data-column>
		</c:if>
		<c:if test="${hasAtt == '1' }">
			<list:data-column col="tmplURL" escape="false">
				/km/forum/mobile/kmForumPost.do?method=view&fdPostId=${post.fdId}
			</list:data-column>
		</c:if>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>