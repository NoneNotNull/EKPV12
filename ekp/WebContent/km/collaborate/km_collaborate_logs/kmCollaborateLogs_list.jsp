<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/collaborate/km_collaborate_logs/kmCollaborateLogs.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/collaborate/km_collaborate_logs/kmCollaborateLogs.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/collaborate/km_collaborate_logs/kmCollaborateLogs.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/collaborate/km_collaborate_logs/kmCollaborateLogs.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmCollaborateLogsForm, 'deleteall');">
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
				<sunbor:column property="kmCollaborateLogs.docCreateTime">
					<bean:message bundle="km-collaborate" key="kmCollaborateLogs.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateLogs.fdIpAddress">
					<bean:message bundle="km-collaborate" key="kmCollaborateLogs.fdIpAddress"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateLogs.operate">
					<bean:message bundle="km-collaborate" key="kmCollaborateLogs.operate"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateLogs.docAuthor.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateLogs.docAuthor"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateLogs.fdDoc.docSubject">
					<bean:message bundle="km-collaborate" key="kmCollaborateLogs.fdDoc"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCollaborateLogs" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/collaborate/km_collaborate_logs/kmCollaborateLogs.do" />?method=view&fdId=${kmCollaborateLogs.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCollaborateLogs.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<kmss:showDate value="${kmCollaborateLogs.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmCollaborateLogs.fdIpAddress}" />
				</td>
				<td>
					<c:out value="${kmCollaborateLogs.operate}" />
				</td>
				<td>
					<c:out value="${kmCollaborateLogs.docAuthor.fdName}" />
				</td>
				<td>
					<c:out value="${kmCollaborateLogs.fdDoc.docSubject}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>