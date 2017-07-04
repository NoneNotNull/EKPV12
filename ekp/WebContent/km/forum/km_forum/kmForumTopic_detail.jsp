<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
		<table class="tb_normal" width="100%">
			<tr>
				<td valign="center" align="middle" width="35%"
					class="td_normal_title"><bean:message bundle="km-forum"
					key="kmForumTopic.docSubject" /></td>
				<td valign="center" align="middle" width="15%"
					class="td_normal_title"><bean:message bundle="km-forum"
					key="kmForumTopic.fdForumId" /></td>
				<td valign="center" align="middle" width="5%"
					class="td_normal_title"><bean:message bundle="km-forum"
					key="kmForumTopic.fdHitCount" /></td>
				<td valign="center" align="middle" width="5%"
					class="td_normal_title"><bean:message bundle="km-forum"
					key="kmForumTopic.fdReplyCount" /></td>
				<td valign="center" align="middle" width="15%"
					class="td_normal_title"><bean:message bundle="km-forum"
					key="kmForumTopic.docAlterTime" /></td>
				<td valign="center" align="middle" width="15%"
					class="td_normal_title"><bean:message bundle="km-forum"
					key="kmForumTopic.fdLastPosterId" /></td>
				<td valign="center" align="middle" width="8%"
					class="td_normal_title"><a href="javascript:history.go(0);"><bean:message key="button.refresh"/></a></td>
			</tr>
			<c:forEach items="${queryList}" var="kmForumTopic"
				varStatus="vstatus">
				<tr>
					<td align="left" width="35%"><a href="#"
						onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdForumId=${kmForumTopic.kmForumCategory.fdId}&fdTopicId=${kmForumTopic.fdId}')"><c:out
						value="${kmForumTopic.docSubject}" /></a></td>
					<td align="middle" width="15%"><c:out
						value="${kmForumTopic.kmForumCategory.fdName}" /></td>
					<td align="middle" width="5%"><c:out
						value="${kmForumTopic.fdHitCount}" /></td>
					<td align="middle" width="5%"><c:out
						value="${kmForumTopic.fdReplyCount}" /></td>
					<td align="middle" width="15%"><kmss:showDate
						value="${kmForumTopic.docAlterTime}" type="datetime" /></td>
					<td align="middle" width="15%"><c:if
						test="${!empty kmForumTopic.fdLastPoster.fdName}">
						<c:if test="${!empty kmForumTopic.fdLastPosterName}">
							<c:out value="${kmForumTopic.fdLastPosterName}" />
						</c:if>
						<c:if test="${empty kmForumTopic.fdLastPosterName}">
							<c:out value="${kmForumTopic.fdLastPoster.fdName}" />
						</c:if>
					</c:if> <c:if test="${empty kmForumTopic.fdLastPoster.fdName}">
												-
											</c:if></td>
					<td align="middle" width="8%"><kmss:auth
						requestURL="/km/forum/km_forum/kmForumTopic.do?method=delete&fdId=${kmForumTopic.fdId}"
						requestMethod="GET">
						<a href="#"
							onclick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumTopic.do" />?method=delete&fdId=${kmForumTopic.fdId}','_blank');">
						<bean:message key="button.delete" /> </a>
					</kmss:auth></td>
				</tr>
			</c:forEach>
		</table>