<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="rank" list="${queryPage.list }">
		<%--ID--%>
		<list:data-column property="fdId"></list:data-column>
		<%--用户--%>
		<list:data-column col="person" title="${ lfn:message('km-forum:kmForumConfig.canModifyNickname') }" style="text-align:center;"  escape="false">
			<ui:person personId="${rank.person.fdId}" personName="${rank.person.fdName}"></ui:person>
		</list:data-column>
		<c:if test="${param.type=='score' }">
			<%--积分--%>
			<list:data-column col="fdScore"  title="${ lfn:message('km-forum:kmForumScore.fdScore') }" escape="false">
				${ lfn:message('km-forum:kmForumScore.fdScore') }：<font color='green'><c:out value="${rank.fdScore}"></c:out></font>
			</list:data-column>
		</c:if>
		<c:if test="${param.type=='postCount' }">
			<%--回帖数--%>
			<list:data-column col="fdPostCount"  title="${ lfn:message('km-forum:kmForumScore.fdPostCount.portlet') }" escape="false">
				${ lfn:message('km-forum:kmForumScore.fdPostCount') }：<font color='green'><c:out value="${rank.fdPostCount}"></c:out></font>
			</list:data-column>
		</c:if>
	</list:data-columns>
</list:data>