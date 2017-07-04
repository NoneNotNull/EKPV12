<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<table id="List_ViewTable">
	<tr>
		<sunbor:columnHead htmlTag="td">
			<td width="30pt"><bean:message key="page.serial" /></td>

			<td>
				<bean:message bundle="km-forum" key="kmForumTopic.docSubject" />
			</td>

			<td><bean:message bundle="km-forum" key="kmForumTopic.fdForumId" />
			</td>

			<td>
				<bean:message bundle="km-forum" key="kmForumTopic.fdPosterId" />
			</td>

			<td>
				<bean:message bundle="km-forum" key="kmForumTopic.docAlterTime" />
			</td>

		</sunbor:columnHead>
	</tr>
	<c:forEach items="${queryPage.list}" var="kmForumTopic"
		varStatus="vstatus">
		<tr
			kmss_href="<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdForumId=${kmForumTopic.kmForumCategory.fdId}&fdTopicId=${kmForumTopic.fdId}"
			kmss_target="_blank">
			<td>${vstatus.index+1}</td>
			<td width="60%" align="left"><c:out
				value="${kmForumTopic.docSubject}" /></td>
			<td width="12%"><c:out
				value="${kmForumTopic.kmForumCategory.fdName}" /></td>
			<td width="8%"><c:if test="${kmForumTopic.fdIsAnonymous==false}">
				<c:out value="${kmForumTopic.fdPoster.fdName}" />
			</c:if> <c:if test="${kmForumTopic.fdIsAnonymous==true}">
				<bean:message bundle="km-forum"
					key="kmForumTopic.fdIsAnonymous.title" />
			</c:if></td>
			<td width="15%"><kmss:showDate
				value="${kmForumTopic.docAlterTime}" type="datetime" /></td>
		</tr>
	</c:forEach>
</table>

<table border="0" width="100%">
<tr><td align="right">
<a  href="#" onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum/kmForumTopic.do?method=list&fdMyPosterId=${param.fdMyPosterId}"/>','_blank')">
				<bean:message  bundle="km-forum" key="kmForumTopic.title.more"/></a> 
</td></tr>
</table>
<script>
window.onload = function(){
	try {
		// 调整高度
		var arguObj = document.getElementsByTagName('table')[0];
		if (arguObj != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch (e) {}
}
</script>
</body>
</html>