<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/follow/sys_follow_log/sysFollowLog.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/follow/sys_follow_log/sysFollowLog.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/follow/sys_follow_log/sysFollowLog.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/follow/sys_follow_log/sysFollowLog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFollowLogForm, 'deleteall');">
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
				<sunbor:column property="sysFollowLog.fdModelName">
					<bean:message bundle="sys-follow" key="sysFollowLog.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="sysFollowLog.fdAction">
					<bean:message bundle="sys-follow" key="sysFollowLog.fdAction"/>
				</sunbor:column>
				<sunbor:column property="sysFollowLog.docCreateTime">
					<bean:message bundle="sys-follow" key="sysFollowLog.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysFollowLog.fdModelId">
					<bean:message bundle="sys-follow" key="sysFollowLog.fdModelId"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFollowLog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/follow/sys_follow_log/sysFollowLog.do" />?method=view&fdId=${sysFollowLog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFollowLog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFollowLog.fdModelName}" />
				</td>
				<td>
					<c:out value="${sysFollowLog.fdAction}" />
				</td>
				<td>
					<kmss:showDate value="${sysFollowLog.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysFollowLog.fdModelId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>