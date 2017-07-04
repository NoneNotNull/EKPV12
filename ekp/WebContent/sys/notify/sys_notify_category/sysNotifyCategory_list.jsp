<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function List_ConfirmRun(checkName){
	return List_CheckSelect(checkName);
}

</script>
<form name="sysNotifyCategoryForm" method="post" action="<c:url value="/sys/notify/sys_notify_category/sysNotifyCategory.do" />">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=mngList&owner=false">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/notify/sys_notify_category/sysNotifyCategory.do" />?method=add');">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysNotifyCategoryForm, 'deleteall');">
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
				<!--
				<sunbor:column property="sysNotifyCategory.fdNo">
					<bean:message bundle="sys-notify" key="sysNotifyCategory.fdNo"/>
				</sunbor:column>
				-->
				<sunbor:column property="sysNotifyCategory.fdName">
					<bean:message bundle="sys-notify" key="sysNotifyCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysNotifyCategory.fdOrder">
					<bean:message bundle="sys-notify" key="sysNotifyCategory.fdOrder"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysNotifyCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/notify/sys_notify_category/sysNotifyCategory.do" />?method=view&fdId=${sysNotifyCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysNotifyCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<!--
				<td nowrap>
					<c:out value="${sysNotifyCategory.fdNo}" />
				</td>
				-->
				<td nowrap>
					<c:out value="${sysNotifyCategory.fdName}" />
				</td>
				<td>
					<c:out value="${sysNotifyCategory.fdOrder}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>