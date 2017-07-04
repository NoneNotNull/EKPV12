<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmCollaborateMainReplyForm, 'deleteall');">
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
				<sunbor:column property="kmCollaborateMainReply.fdReplyType">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdReplyType"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.fdNotifyType">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdNotifyType"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.docCreateTime">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.docAlterTime">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.fdParentId">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.fdCommunicationMain.docSubject">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdCommunicationMain"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.docCreator.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMainReply.docAlteror.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateMainReply.docAlteror"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCollaborateMainReply" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do" />?method=view&fdId=${kmCollaborateMainReply.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCollaborateMainReply.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmCollaborateMainReply.fdReplyType}" />
				</td>
				<td>
					<c:out value="${kmCollaborateMainReply.fdNotifyType}" />
				</td>
				<td>
					<kmss:showDate value="${kmCollaborateMainReply.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmCollaborateMainReply.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmCollaborateMainReply.fdParentId}" />
				</td>
				<td>
					<c:out value="${kmCollaborateMainReply.fdCommunicationMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmCollaborateMainReply.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmCollaborateMainReply.docAlteror.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>