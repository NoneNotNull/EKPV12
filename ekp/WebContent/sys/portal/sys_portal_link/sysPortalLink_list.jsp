<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/portal/sys_portal_link/sysPortalLink.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/portal/sys_portal_link/sysPortalLink.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/portal/sys_portal_link/sysPortalLink.do" />?method=add&fdType=${ param['fdType'] }');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/portal/sys_portal_link/sysPortalLink.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPortalLinkForm, 'deleteall');">
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
				<sunbor:column property="sysPortalLink.fdName">
					<bean:message bundle="sys-portal" key="sysPortalLink.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPortalLink.docCreateTime">
					<bean:message bundle="sys-portal" key="sysPortalLink.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysPortalLink.docCreator.fdName">
					<bean:message bundle="sys-portal" key="sysPortalLink.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPortalLink" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/portal/sys_portal_link/sysPortalLink.do" />?method=edit&fdId=${sysPortalLink.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPortalLink.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPortalLink.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysPortalLink.docCreateTime}" />
				</td> 
				<td>
					<c:out value="${sysPortalLink.docCreator.fdName}" />
				</td> 
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>