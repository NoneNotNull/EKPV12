<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/portal/sys_portal_html/sysPortalHtml.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/portal/sys_portal_html/sysPortalHtml.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/portal/sys_portal_html/sysPortalHtml.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/portal/sys_portal_html/sysPortalHtml.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPortalHtmlForm, 'deleteall');">
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
				<sunbor:column property="sysPortalHtml.fdName">
					<bean:message bundle="sys-portal" key="sysPortalHtml.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPortalHtml.docCreateTime">
					<bean:message bundle="sys-portal" key="sysPortalHtml.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysPortalHtml.docCreator.fdName">
					<bean:message bundle="sys-portal" key="sysPortalHtml.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPortalHtml" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/portal/sys_portal_html/sysPortalHtml.do" />?method=edit&fdId=${sysPortalHtml.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPortalHtml.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPortalHtml.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysPortalHtml.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysPortalHtml.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>