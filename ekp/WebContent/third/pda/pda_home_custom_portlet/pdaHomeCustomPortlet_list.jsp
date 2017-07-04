<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaHomeCustomPortletForm, 'deleteall');">
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
				<sunbor:column property="pdaHomeCustomPortlet.fdName">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdName"/>
				</sunbor:column>
				
				<sunbor:column property="pdaHomeCustomPortlet.fdType">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType"/>
				</sunbor:column>
				
				<sunbor:column property="pdaHomeCustomPortlet.fdModuleName">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdModuleName"/>
				</sunbor:column>
			
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaHomeCustomPortlet" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do" />?method=view&fdId=${pdaHomeCustomPortlet.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaHomeCustomPortlet.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaHomeCustomPortlet.fdName}" />
				</td>
				<td>
					<c:if test="${pdaHomeCustomPortlet.fdType=='pic' }">
						<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType.pic"/>
					</c:if>
					<c:if test="${pdaHomeCustomPortlet.fdType=='list' }">
						<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType.list"/>
					</c:if>
				</td>
			
				<td>
					<c:out value="${pdaHomeCustomPortlet.fdModuleName}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>