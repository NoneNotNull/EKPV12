<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/follow/sys_follow_doc/sysFollowDoc.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/follow/sys_follow_doc/sysFollowDoc.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/follow/sys_follow_doc/sysFollowDoc.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/follow/sys_follow_doc/sysFollowDoc.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFollowDocForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysFollowDoc.docSubject">
					<bean:message bundle="sys-follow" key="sysFollowDoc.docSubject"/>
				</sunbor:column>
				<sunbor:column property="sysFollowDoc.docCreateTime">
					<bean:message bundle="sys-follow" key="sysFollowDoc.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysFollowDoc.fdModelName">
					<bean:message bundle="sys-follow" key="sysFollowDoc.fdModelName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFollowDoc" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/follow/sys_follow_doc/sysFollowDoc.do" />?method=view&fdId=${sysFollowDoc.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFollowDoc.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFollowDoc.docSubject}" />
				</td>
				<td>
					<kmss:showDate value="${sysFollowDoc.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysFollowDoc.fdModelName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>